local options = ...

if type(options) ~= "table" then
    options = {}
end

local genv = type(getgenv) == "function" and getgenv() or _G

if type(genv.SleepyMusicPlayer) == "table" and type(genv.SleepyMusicPlayer.destroy) == "function" then
    pcall(genv.SleepyMusicPlayer.destroy)
end

local clone = type(cloneref) == "function" and cloneref or function(object) return object end

local players = clone(game:GetService("Players"))
local run_service = clone(game:GetService("RunService"))
local user_input_service = clone(game:GetService("UserInputService"))
local tween_service = clone(game:GetService("TweenService"))
local http_service = clone(game:GetService("HttpService"))
local local_player = players.LocalPlayer

local ROOT = type(options.root) == "string" and options.root ~= "" and options.root or "Sleepy.gg"
local SONGS_FOLDER = ROOT .. "/Songs"
local DATA_FOLDER = ROOT .. "/data"
local DATA_FILE = DATA_FOLDER .. "/music_player.json"
local FOLDER_HINT = "workspace / " .. ROOT .. " / Songs"
local COMMUNITY_API = type(options.community_api) == "string" and options.community_api or "https://api.github.com/repos/SleepyScriptsHolderAntiSkids/storage/contents/musics"
local COMMUNITY_FOLDER = SONGS_FOLDER .. "/Community"
local COMMUNITY_FILE = DATA_FOLDER .. "/community_songs.json"
local COMMUNITY_LABEL = "Load Community Songs"
local EXTENSIONS = {mp3 = true, ogg = true, wav = true, flac = true}
local SCAN_DEPTH = 2
local SCAN_INTERVAL = 2
local LOAD_TIMEOUT = 10
local SAVE_DELAY = 1
local AUTOSAVE_INTERVAL = 5
local RESTART_AFTER = 3
local TOAST_TIME = 3
local MAX_VOLUME = 1
local WIDTH = 340
local MINI_WIDTH = 230
local BARS = 10
local BAR_MIN = 2
local BAR_MAX = 40
local REPEAT_ORDER = {"off", "all", "one"}
local REPEAT_NAMES = {off = "no repeat", all = "repeat all", one = "repeat one"}
local SPEED_ORDER = {"normal", "nightcore", "slowed"}
local SPEEDS = {normal = 1, nightcore = 1.25, slowed = 0.8}
local BROKEN_COLOR = Color3.fromRGB(255, 95, 95)
local SCAN_BLOCKED = {
    name = {note = "a song name has symbols your executor can't read", hint = "your executor can't open the Songs folder because one of your song names has symbols it doesn't support (emoji, other languages, special signs). rename that song using english letters and everything shows up again."},
    list = {note = "your executor can't list files", hint = "your executor doesn't support listing files, so songs in the Songs folder can't load. community songs still work."},
}
local DEFAULT_THEME = {
    accent = Color3.fromRGB(0, 162, 255),
    background = Color3.fromRGB(14, 14, 16),
    element = Color3.fromRGB(25, 25, 29),
    outline = Color3.fromRGB(36, 36, 37),
    text = Color3.fromRGB(245, 245, 245),
    inactive = Color3.fromRGB(72, 72, 73),
}
local THEMED = {BackgroundColor3 = true, TextColor3 = true, Color = true, ImageColor3 = true, ScrollBarImageColor3 = true, PlaceholderColor3 = true}

local touch = false

do
    local ok, preferred = pcall(function()
        return user_input_service.PreferredInput == Enum.PreferredInput.Touch
    end)

    if ok then
        touch = preferred
    else
        touch = user_input_service.TouchEnabled and not user_input_service.MouseEnabled
    end
end

local HEADER_HEIGHT = touch and 26 or 20
local SEEK_HEIGHT = touch and 24 or 14
local SLIDER_HEIGHT = touch and 22 or 16
local BUTTON_HEIGHT = touch and 28 or 24
local ROW_HEIGHT = touch and 30 or 26
local LIST_HEIGHT = touch and 132 or 172

local function try(fn, ...)
    if type(fn) ~= "function" then return false, nil end

    return pcall(fn, ...)
end

local function is_folder(path)
    local ok, result = try(isfolder, path)

    return ok and result == true
end

local function is_file(path)
    local ok, result = try(isfile, path)

    return ok and result == true
end

local function ensure_folder(path)
    if not is_folder(path) then
        try(makefolder, path)
    end
end

local function read_file(path)
    if not is_file(path) then return nil end

    local ok, result = try(readfile, path)

    return ok and type(result) == "string" and result or nil
end

local function write_file(path, data)
    try(writefile, path, data)
end

local custom_asset = getcustomasset or getsynasset

local function asset_of(path)
    local ok, result = try(custom_asset, path)

    return ok and type(result) == "string" and result ~= "" and result or nil
end

local TRANSLIT = {
    ["а"] = "a", ["б"] = "b", ["в"] = "v", ["г"] = "g", ["д"] = "d", ["е"] = "e", ["ё"] = "yo", ["ж"] = "zh", ["з"] = "z", ["и"] = "i", ["й"] = "y",
    ["к"] = "k", ["л"] = "l", ["м"] = "m", ["н"] = "n", ["о"] = "o", ["п"] = "p", ["р"] = "r", ["с"] = "s", ["т"] = "t", ["у"] = "u", ["ф"] = "f",
    ["х"] = "kh", ["ц"] = "ts", ["ч"] = "ch", ["ш"] = "sh", ["щ"] = "shch", ["ъ"] = "", ["ы"] = "y", ["ь"] = "", ["э"] = "e", ["ю"] = "yu", ["я"] = "ya",
    ["і"] = "i", ["ї"] = "yi", ["є"] = "ye", ["ґ"] = "g",
}

local function ascii_name(text)
    local ok, result = pcall(function()
        local out = {}

        for _, code in utf8.codes(text) do
            if code < 128 then
                out[#out + 1] = string.char(code)
            else
                local lower, upper = code, false

                if code >= 0x400 and code <= 0x40F then
                    lower, upper = code + 0x50, true
                elseif code >= 0x410 and code <= 0x42F then
                    lower, upper = code + 0x20, true
                elseif code == 0x490 then
                    lower, upper = 0x491, true
                end

                local latin = TRANSLIT[utf8.char(lower)]

                if latin and latin ~= "" then
                    out[#out + 1] = upper and (latin:sub(1, 1):upper() .. latin:sub(2)) or latin
                end
            end
        end

        return table.concat(out)
    end)

    if not ok or type(result) ~= "string" then
        result = (text:gsub(".", function(char)
            return char:byte() < 128 and char or ""
        end))
    end

    result = result:gsub("[^A-Za-z0-9 %-_%.%(%)%[%]&',!]", ""):gsub(" +", " "):gsub("^ +", ""):gsub("[ %.]+$", "")

    if not result:find("[A-Za-z0-9]") then
        return ""
    end

    return result
end

local function community_file_name(remote, used)
    local base, extension = remote:match("^(.*)%.([%w]+)$")

    base = ascii_name(base or remote)
    extension = (extension or "mp3"):lower()

    if base == "" then
        base = "song"
    end

    local name = base .. "." .. extension
    local index = 2

    while used[name:lower()] do
        name = string.format("%s (%d).%s", base, index, extension)
        index += 1
    end

    used[name:lower()] = true

    return name
end

local function url_encode(url)
    return (url:gsub("[^A-Za-z0-9%-%._~:/%%%?=&]", function(char)
        return string.format("%%%02X", char:byte())
    end))
end

local function http_get(url)
    local ok, body = pcall(function()
        return game:HttpGet(url)
    end)

    if ok and type(body) == "string" then
        return body
    end

    local requester = (type(request) == "function" and request) or (type(http_request) == "function" and http_request) or (type(syn) == "table" and type(syn.request) == "function" and syn.request) or nil

    if requester then
        local sent, response = pcall(requester, {Url = url, Method = "GET"})

        if sent and type(response) == "table" and type(response.Body) == "string" and (tonumber(response.StatusCode) or 200) < 400 then
            return response.Body
        end
    end

    return nil
end

ensure_folder(ROOT)
ensure_folder(SONGS_FOLDER)
ensure_folder(DATA_FOLDER)

local function default_state()
    return {volume = 50, muted = false, repeat_mode = "all", shuffle = false, bass = false, speed = "normal", last = nil, x = 0, y = 0, minimized = false, position = 0, playing = false, lengths = {}}
end

local state = default_state()

do
    local raw = read_file(DATA_FILE)
    local ok, decoded = false, nil

    if raw and raw ~= "" then
        ok, decoded = pcall(http_service.JSONDecode, http_service, raw)
    end

    if ok and type(decoded) == "table" then
        state.volume = math.clamp(tonumber(decoded.volume) or state.volume, 0, 100)
        state.muted = decoded.muted == true
        state.repeat_mode = REPEAT_NAMES[decoded.repeat_mode] and decoded.repeat_mode or state.repeat_mode
        state.shuffle = decoded.shuffle == true
        state.bass = decoded.bass == true
        state.speed = SPEEDS[decoded.speed] and decoded.speed or state.speed
        state.last = type(decoded.last) == "string" and decoded.last or nil
        state.x = tonumber(decoded.x) or 0
        state.y = tonumber(decoded.y) or 0
        state.minimized = decoded.minimized == true
        state.position = math.max(tonumber(decoded.position) or 0, 0)
        state.playing = decoded.playing == true

        if type(decoded.lengths) == "table" then
            for path, length in decoded.lengths do
                if type(path) == "string" and tonumber(length) then
                    state.lengths[path] = tonumber(length)
                end
            end
        end
    end
end

local destroyed = false
local save_pending = false

local restore = {path = state.last, position = state.position, resume = state.playing}
local capture = nil

local function write_state()
    if capture then
        pcall(capture)
    end

    local ok, encoded = pcall(http_service.JSONEncode, http_service, state)

    if ok then
        write_file(DATA_FILE, encoded)
    end
end

local function save_state()
    if save_pending or destroyed then return end

    save_pending = true

    task.delay(SAVE_DELAY, function()
        save_pending = false

        if not destroyed then
            write_state()
        end
    end)
end

local community = {busy = false, files = {}, reset_token = 0}

do
    local raw = read_file(COMMUNITY_FILE)
    local ok, decoded = false, nil

    if raw and raw ~= "" then
        ok, decoded = pcall(http_service.JSONDecode, http_service, raw)
    end

    if ok and type(decoded) == "table" and type(decoded.files) == "table" then
        for file, info in decoded.files do
            if type(file) == "string" and type(info) == "table" and type(info.remote) == "string" then
                community.files[file] = {remote = info.remote, sha = type(info.sha) == "string" and info.sha or "", size = tonumber(info.size)}
            end
        end
    end
end

local function save_community()
    local ok, encoded = pcall(http_service.JSONEncode, http_service, {files = community.files})

    if ok then
        write_file(COMMUNITY_FILE, encoded)
    end
end

local song_cache = {folder = DATA_FOLDER .. "/song_cache", unsafe = "[#%%%?" .. string.char(128) .. "-" .. string.char(255) .. "]", slash = string.char(92)}

function song_cache.name(path)
    local hash = 5381

    for index = 1, #path do
        hash = (hash * 33 + path:byte(index)) % 4294967296
    end

    return string.format("s_%08x.%s", hash, (path:match("%.([%w]+)$") or "mp3"):lower())
end

function song_cache.resolve(path)
    if not path:find(song_cache.unsafe) then
        return is_file(path) and asset_of(path) or nil, false
    end

    local ok, data = try(readfile, path)

    if not ok or type(data) ~= "string" or #data == 0 then
        return nil, true
    end

    ensure_folder(song_cache.folder)

    local copy = song_cache.folder .. "/" .. song_cache.name(path)

    write_file(copy, data)

    return is_file(copy) and asset_of(copy) or nil, false
end

function song_cache.prune(records)
    local ok, entries = try(listfiles, song_cache.folder)

    if not ok or type(entries) ~= "table" then return end

    local wanted = {}

    for _, record in records do
        if record.path:find(song_cache.unsafe) then
            wanted[song_cache.name(record.path)] = true
        end
    end

    for _, entry in entries do
        if type(entry) == "string" then
            local name = entry:gsub(song_cache.slash, "/"):match("([^/]+)$")

            if name and not wanted[name] then
                try(delfile, entry)
            end
        end
    end
end

local theme = {}
local theme_dirty = false

local function read_theme(source)
    for key, fallback in DEFAULT_THEME do
        local value = type(source) == "table" and source[key]

        theme[key] = typeof(value) == "Color3" and value or theme[key] or fallback
    end

    theme.panel = theme.background:Lerp(theme.element, 0.45)
    theme.track = theme.element:Lerp(theme.outline, 0.75)
    theme.hover = theme.element:Lerp(theme.outline, 0.55)
    theme.muted = theme.inactive:Lerp(theme.text, 0.3)
    theme.accent_hover = theme.accent:Lerp(Color3.new(1, 1, 1), 0.15)
end

read_theme(options.theme)

local painted = {}

local function new(class, properties)
    local object = Instance.new(class)

    for key, value in properties do
        if key ~= "Parent" then
            if THEMED[key] and type(value) == "string" then
                painted[#painted + 1] = {object, key, value}
                object[key] = theme[value]
            else
                object[key] = value
            end
        end
    end

    object.Parent = properties.Parent

    return object
end

local function corner(parent, radius)
    return new("UICorner", {CornerRadius = UDim.new(0, radius), Parent = parent})
end

local function outline(parent, key)
    return new("UIStroke", {Color = key or "outline", ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = parent})
end

local function enum_font(name)
    local ok, font = pcall(function()
        return Font.fromEnum(Enum.Font[name])
    end)

    return ok and font or Font.fromEnum(Enum.Font.SourceSans)
end

local function load_font(file, fallback)
    local face = ROOT .. "/fonts/" .. file

    asset_of(face .. ".ttf")

    if is_file(face .. ".font") then
        local id = asset_of(face .. ".font")

        if id then
            local ok, font = pcall(Font.new, id, Enum.FontWeight.Regular, Enum.FontStyle.Normal)

            if ok and font then return font end
        end
    end

    return enum_font(fallback)
end

local FONT = typeof(options.font) == "Font" and options.font or load_font("SemiBold", "BuilderSansMedium")
local FONT_LIGHT = typeof(options.font_light) == "Font" and options.font_light or load_font("Medium", "BuilderSans")
local FONT_ICON = enum_font("BuilderSansBold")

local gui = Instance.new("ScreenGui")

gui.Name = "\0"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 2147483645

do
    local targets = {}

    if typeof(options.parent) == "Instance" then
        targets[#targets + 1] = options.parent
    end

    if type(gethui) == "function" then
        local ok, hidden = pcall(gethui)

        if ok and typeof(hidden) == "Instance" then
            targets[#targets + 1] = hidden
        end
    end

    local core_ok, core = pcall(function()
        return clone(game:GetService("CoreGui"))
    end)

    if core_ok and typeof(core) == "Instance" then
        targets[#targets + 1] = core
    end

    local mounted = false

    for _, target in targets do
        if pcall(function() gui.Parent = target end) and gui.Parent == target then
            mounted = true

            break
        end
    end

    if not mounted then
        pcall(function()
            gui.Parent = local_player:WaitForChild("PlayerGui")
        end)
    end
end

local sound = Instance.new("Sound")

sound.Name = "\0"
sound.Volume = 0
sound.Looped = false
sound.Parent = gui

local ui = {}

ui.bass_effect = new("EqualizerSoundEffect", {LowGain = 8, MidGain = -1, HighGain = 0, Priority = 2, Enabled = false, Parent = sound})
ui.reverb_effect = new("ReverbSoundEffect", {DecayTime = 1.8, Density = 1, Diffusion = 1, DryLevel = -1, WetLevel = -9, Priority = 1, Enabled = false, Parent = sound})

local layout_order = 0

local function next_order()
    layout_order += 1

    return layout_order
end

ui.window = new("Frame", {Name = "\0", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, state.x, 0.5, state.y), Size = UDim2.fromOffset(WIDTH, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = "background", BorderSizePixel = 0, Active = true, Visible = false, Parent = gui})

corner(ui.window, 10)
outline(ui.window)

ui.window_scale = new("UIScale", {Parent = ui.window})

ui.window_padding = new("UIPadding", {PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 12), PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12), Parent = ui.window})
new("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), Parent = ui.window})

ui.header = new("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, HEADER_HEIGHT), LayoutOrder = next_order(), Parent = ui.window})
ui.drag_zone = new("TextButton", {AutoButtonColor = false, BackgroundTransparency = 1, Text = "", Size = UDim2.fromScale(1, 1), ZIndex = 1, Parent = ui.header})
ui.live_dot = new("Frame", {BackgroundColor3 = "accent", BackgroundTransparency = 0.7, BorderSizePixel = 0, AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 1, 0.5, 0), Size = UDim2.fromOffset(6, 6), ZIndex = 2, Parent = ui.header})

corner(ui.live_dot, 3)

ui.title = new("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 0), Size = UDim2.new(1, -(HEADER_HEIGHT * 2 + 144), 1, 0), FontFace = FONT, Text = "Music Player", TextColor3 = "text", TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 2, Parent = ui.header})

ui.count_label = new("TextLabel", {BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -(HEADER_HEIGHT * 2 + 14), 0, 0), Size = UDim2.new(0, 110, 1, 0), FontFace = FONT_LIGHT, Text = "", TextColor3 = "muted", TextSize = 13, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 2, Parent = ui.header})
ui.close_button = new("TextButton", {AutoButtonColor = false, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.fromOffset(HEADER_HEIGHT, HEADER_HEIGHT), BackgroundColor3 = "element", Text = "×", FontFace = FONT_ICON, TextSize = 16, TextColor3 = "muted", ZIndex = 3, Parent = ui.header})
ui.min_button = new("TextButton", {AutoButtonColor = false, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -(HEADER_HEIGHT + 6), 0.5, 0), Size = UDim2.fromOffset(HEADER_HEIGHT, HEADER_HEIGHT), BackgroundColor3 = "element", Text = "–", FontFace = FONT_ICON, TextSize = 16, TextColor3 = "muted", ZIndex = 3, Parent = ui.header})

corner(ui.close_button, 5)
corner(ui.min_button, 5)

ui.divider = new("Frame", {BackgroundColor3 = "accent", BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 1), LayoutOrder = next_order(), Parent = ui.window})

new("UIGradient", {Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.85), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 0.85)}), Parent = ui.divider})

ui.card = new("Frame", {BackgroundColor3 = "element", BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 72), LayoutOrder = next_order(), Parent = ui.window})

corner(ui.card, 7)
outline(ui.card)

ui.art = new("Frame", {BackgroundColor3 = "panel", BorderSizePixel = 0, Position = UDim2.fromOffset(8, 8), Size = UDim2.fromOffset(56, 56), ClipsDescendants = true, Parent = ui.card})

corner(ui.art, 6)
outline(ui.art)

ui.glow = new("Frame", {BackgroundColor3 = "accent", BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), Parent = ui.art})

corner(ui.glow, 6)
new("UIGradient", {Rotation = 90, Transparency = NumberSequence.new(1, 0.2), Parent = ui.glow})

ui.bar_frames = {}

do
    local span = BARS * 3 + (BARS - 1) * 2
    local left = math.floor((56 - span) / 2)

    for index = 1, BARS do
        local bar = new("Frame", {BackgroundColor3 = "accent", BorderSizePixel = 0, AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, left + (index - 1) * 5, 1, -8), Size = UDim2.fromOffset(3, BAR_MIN), ZIndex = 2, Parent = ui.art})

        corner(bar, 2)
        ui.bar_frames[index] = bar
    end
end

ui.name_clip = new("Frame", {BackgroundTransparency = 1, ClipsDescendants = true, Position = UDim2.fromOffset(74, 9), Size = UDim2.new(1, -84, 0, 20), Parent = ui.card})
ui.name_label = new("TextLabel", {BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 1, 0), FontFace = FONT, Text = "", TextColor3 = "text", TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left, Parent = ui.name_clip})
ui.status_label = new("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(74, 30), Size = UDim2.new(1, -84, 0, 16), FontFace = FONT_LIGHT, Text = "", TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = ui.card})
ui.meta_label = new("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(74, 48), Size = UDim2.new(1, -84, 0, 14), FontFace = FONT_LIGHT, Text = "", TextColor3 = "inactive", TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = ui.card})

ui.seek_row = new("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, SEEK_HEIGHT), LayoutOrder = next_order(), Parent = ui.window})
ui.time_left = new("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(0, 40, 1, 0), FontFace = FONT_LIGHT, Text = "0:00", TextColor3 = "muted", TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = ui.seek_row})
ui.time_right = new("TextLabel", {BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0), Position = UDim2.fromScale(1, 0), Size = UDim2.new(0, 40, 1, 0), FontFace = FONT_LIGHT, Text = "0:00", TextColor3 = "muted", TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right, Parent = ui.seek_row})
ui.seek_hit = new("TextButton", {AutoButtonColor = false, BackgroundTransparency = 1, Text = "", Position = UDim2.fromOffset(44, 0), Size = UDim2.new(1, -88, 1, 0), Parent = ui.seek_row})
ui.seek_track = new("Frame", {BackgroundColor3 = "track", BorderSizePixel = 0, AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.fromScale(0, 0.5), Size = UDim2.new(1, 0, 0, 4), Parent = ui.seek_hit})

corner(ui.seek_track, 2)

ui.seek_fill = new("Frame", {BackgroundColor3 = "accent", BorderSizePixel = 0, Size = UDim2.fromScale(0, 1), Parent = ui.seek_track})

corner(ui.seek_fill, 2)

ui.seek_knob = new("Frame", {BackgroundColor3 = "text", BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0, 0.5), Size = UDim2.fromOffset(10, 10), Visible = touch, ZIndex = 2, Parent = ui.seek_track})

corner(ui.seek_knob, 5)

ui.controls = new("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 42), LayoutOrder = next_order(), Parent = ui.window})

new("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 14), SortOrder = Enum.SortOrder.LayoutOrder, Parent = ui.controls})

local function control_button(size, index, fill)
    local button = new("TextButton", {AutoButtonColor = false, Text = "", BackgroundColor3 = fill or "element", BorderSizePixel = 0, Size = UDim2.fromOffset(size, size), LayoutOrder = index, Parent = ui.controls})

    corner(button, 9)

    if not fill then
        outline(button)
    end

    return button, new("UIScale", {Parent = button})
end

ui.prev_button, ui.prev_scale = control_button(34, 1)

new("Frame", {BackgroundColor3 = "text", BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, -6, 0.5, 0), Size = UDim2.fromOffset(2, 11), Parent = ui.prev_button})
new("TextLabel", {BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 2, 0.5, 0), Size = UDim2.fromOffset(14, 14), FontFace = FONT_ICON, Text = "◀", TextColor3 = "text", TextSize = 13, Parent = ui.prev_button})

ui.play_button, ui.play_scale = control_button(42, 2, "accent")
ui.play_icon = new("TextLabel", {BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 2, 0.5, 0), Size = UDim2.fromOffset(20, 20), FontFace = FONT_ICON, Text = "▶", TextColor3 = "background", TextSize = 18, Parent = ui.play_button})
ui.pause_icon = new("Frame", {BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(12, 14), Visible = false, Parent = ui.play_button})

for index = 0, 1 do
    local bar = new("Frame", {BackgroundColor3 = "background", BorderSizePixel = 0, Position = UDim2.fromOffset(index * 8, 0), Size = UDim2.fromOffset(4, 14), Parent = ui.pause_icon})

    corner(bar, 1)
end

ui.next_button, ui.next_scale = control_button(34, 3)

new("TextLabel", {BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, -2, 0.5, 0), Size = UDim2.fromOffset(14, 14), FontFace = FONT_ICON, Text = "▶", TextColor3 = "text", TextSize = 13, Parent = ui.next_button})
new("Frame", {BackgroundColor3 = "text", BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 6, 0.5, 0), Size = UDim2.fromOffset(2, 11), Parent = ui.next_button})

ui.volume_row = new("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, SLIDER_HEIGHT), LayoutOrder = next_order(), Parent = ui.window})
ui.mute_button = new("TextButton", {AutoButtonColor = false, BackgroundTransparency = 1, Size = UDim2.new(0, 58, 1, 0), FontFace = FONT_LIGHT, Text = "volume", TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = ui.volume_row})
ui.volume_hit = new("TextButton", {AutoButtonColor = false, BackgroundColor3 = "track", BorderSizePixel = 0, Text = "", Position = UDim2.fromOffset(62, 0), Size = UDim2.new(1, -62, 1, 0), Parent = ui.volume_row})

corner(ui.volume_hit, 3)

ui.volume_fill = new("Frame", {BackgroundColor3 = "accent", BorderSizePixel = 0, Size = UDim2.fromScale(0.5, 1), Parent = ui.volume_hit})

corner(ui.volume_fill, 3)

ui.volume_text = new("TextLabel", {BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), FontFace = FONT_LIGHT, Text = "", TextColor3 = "text", TextSize = 13, ZIndex = 2, Parent = ui.volume_hit})

ui.modes = new("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, BUTTON_HEIGHT), LayoutOrder = next_order(), Parent = ui.window})

new("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = ui.modes})

local function mode_button(index)
    local button = new("TextButton", {AutoButtonColor = false, BackgroundColor3 = "element", BorderSizePixel = 0, Size = UDim2.new(0.25, -4.5, 1, 0), FontFace = FONT_LIGHT, Text = "", TextSize = 13, TextTruncate = Enum.TextTruncate.AtEnd, LayoutOrder = index, Parent = ui.modes})

    corner(button, 5)

    return button, new("UIStroke", {ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = button})
end

ui.shuffle_button, ui.shuffle_edge = mode_button(1)
ui.repeat_button, ui.repeat_edge = mode_button(2)
ui.bass_button, ui.bass_edge = mode_button(3)
ui.speed_button, ui.speed_edge = mode_button(4)

ui.search_row = new("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, BUTTON_HEIGHT), LayoutOrder = next_order(), Parent = ui.window})
ui.search_box = new("TextBox", {BackgroundColor3 = "element", BorderSizePixel = 0, Size = UDim2.new(1, -72, 1, 0), FontFace = FONT_LIGHT, Text = "", PlaceholderText = "search songs...", PlaceholderColor3 = "muted", TextColor3 = "text", TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false, ClipsDescendants = true, Parent = ui.search_row})

corner(ui.search_box, 5)
outline(ui.search_box)
new("UIPadding", {PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), Parent = ui.search_box})

ui.random_button = new("TextButton", {AutoButtonColor = false, BackgroundColor3 = "element", BorderSizePixel = 0, AnchorPoint = Vector2.new(1, 0), Position = UDim2.fromScale(1, 0), Size = UDim2.new(0, 66, 1, 0), FontFace = FONT_LIGHT, Text = "random", TextColor3 = "text", TextSize = 13, Parent = ui.search_row})

corner(ui.random_button, 5)
outline(ui.random_button)

ui.list_holder = new("Frame", {BackgroundColor3 = "element", BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, LIST_HEIGHT), ClipsDescendants = true, LayoutOrder = next_order(), Parent = ui.window})

corner(ui.list_holder, 7)
outline(ui.list_holder)

ui.list = new("ScrollingFrame", {Active = true, BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingDirection = Enum.ScrollingDirection.Y, ScrollBarThickness = touch and 0 or 2, ScrollBarImageColor3 = "accent", ScrollBarImageTransparency = 0.3, Parent = ui.list_holder})

new("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2), Parent = ui.list})
new("UIPadding", {PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4), PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, touch and 4 or 8), Parent = ui.list})

ui.empty = new("Frame", {BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Visible = false, Parent = ui.list_holder})

new("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 3), Parent = ui.empty})

local function empty_line(text, key, size, index)
    return new("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(1, -16, 0, size + 4), FontFace = index == 1 and FONT or FONT_LIGHT, Text = text, TextColor3 = key, TextSize = size, TextTruncate = Enum.TextTruncate.AtEnd, LayoutOrder = index, Parent = ui.empty})
end

ui.empty_title = empty_line("no songs yet", "text", 14, 1)
ui.empty_text = empty_line("drag .mp3 files into the Songs folder", "muted", 13, 2)
ui.empty_path = empty_line(FOLDER_HINT, "accent", 13, 3)
ui.empty_foot = empty_line("or press " .. COMMUNITY_LABEL .. " below", "inactive", 12, 4)

ui.community_button = new("TextButton", {AutoButtonColor = false, BackgroundColor3 = "element", BorderSizePixel = 0, ClipsDescendants = true, Size = UDim2.new(1, 0, 0, BUTTON_HEIGHT), Text = "", LayoutOrder = next_order(), Parent = ui.window})

corner(ui.community_button, 5)
outline(ui.community_button)

ui.community_fill = new("Frame", {BackgroundColor3 = "accent", BackgroundTransparency = 0.7, BorderSizePixel = 0, Size = UDim2.fromScale(0, 1), Parent = ui.community_button})

corner(ui.community_fill, 5)

ui.community_text = new("TextLabel", {BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), FontFace = FONT_LIGHT, Text = COMMUNITY_LABEL, TextColor3 = "text", TextSize = 13, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 2, Parent = ui.community_button})

ui.hint = new("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, FontFace = FONT_LIGHT, RichText = true, Text = "", TextColor3 = "muted", TextSize = 12, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = next_order(), Parent = ui.window})

local TOAST_SHOWN = UDim2.new(0, 16, 0.62, 0)
local TOAST_HIDDEN = UDim2.new(0, -280, 0.62, 0)

ui.toast = new("Frame", {BackgroundColor3 = "element", BorderSizePixel = 0, AnchorPoint = Vector2.new(0, 0.5), Position = TOAST_HIDDEN, Size = UDim2.fromOffset(240, 46), Visible = false, Parent = gui})

corner(ui.toast, 7)
outline(ui.toast)
new("UIScale", {Scale = touch and 0.85 or 1, Parent = ui.toast})

ui.toast_bar = new("Frame", {BackgroundColor3 = "accent", BorderSizePixel = 0, Position = UDim2.fromOffset(8, 8), Size = UDim2.new(0, 3, 1, -16), Parent = ui.toast})

corner(ui.toast_bar, 2)
new("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(19, 6), Size = UDim2.new(1, -27, 0, 14), FontFace = FONT_LIGHT, Text = "now playing", TextColor3 = "muted", TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = ui.toast})

ui.toast_name = new("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(19, 21), Size = UDim2.new(1, -27, 0, 18), FontFace = FONT, Text = "", TextColor3 = "text", TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = ui.toast})

local api = {on_close = options.on_close}
local connections = {}
local rng = Random.new()
local songs = {}
local by_path = {}
local queue = {}
local cursor = 0
local current = nil
local playing = false
local loading = false
local finished = false
local load_token = 0
local pause_token = 0
local note_token = 0
local scan_token = 0
local toast_token = 0
local note = nil
local signature = nil
local scan_blocked = false
local query = ""
local enabled = not options.embedded
local menu_visible = true
local shown = false
local render_connection = nil
local camera_connection = nil
local fade_tween = nil
local seeking = false
local seek_fraction = 0
local seek_input = nil
local volume_input = nil
local drag_input = nil
local drag_start = nil
local drag_origin = nil
local natural_height = 0
local clock = 0
local level = 0
local loud_seen = false
local play_clock = 0
local marquee_time = 0
local marquee_offset = 0
local last_fill = -1
local last_left = nil
local last_right = nil
local last_glow = -1
local last_dot = -1
local bar_levels = table.create(BARS, 0)
local bar_heights = table.create(BARS, -1)

local refresh_now, style_row, style_modes, style_volume, apply_filter, build_queue, play_song, advance, pause, resume, show_toast, hide_toast, reveal, repaint

local function connect(signal, callback)
    local connection = signal:Connect(callback)

    connections[#connections + 1] = connection

    return connection
end

local function format_time(seconds)
    seconds = math.max(0, math.floor(tonumber(seconds) or 0))

    if seconds >= 3600 then
        return string.format("%d:%02d:%02d", seconds // 3600, seconds % 3600 // 60, seconds % 60)
    end

    return string.format("%d:%02d", seconds // 60, seconds % 60)
end

local function target_volume()
    return state.muted and 0 or state.volume / 100 * MAX_VOLUME
end

local function fade(volume, duration, done)
    if fade_tween then
        fade_tween:Cancel()
        fade_tween = nil
    end

    if duration <= 0 then
        sound.Volume = volume

        if done then done() end

        return
    end

    local tween = tween_service:Create(sound, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Volume = volume})

    fade_tween = tween

    tween.Completed:Connect(function(playback)
        if fade_tween == tween then
            fade_tween = nil
        end

        if done and playback == Enum.PlaybackState.Completed then
            done()
        end
    end)

    tween:Play()
end

local function hint_text()
    if scan_blocked then
        return string.format('<font color="#%s">%s</font>', BROKEN_COLOR:ToHex(), scan_blocked.hint)
    end

    local hex = theme.accent:ToHex()

    return string.format('load songs by dragging <font color="#%s">.mp3</font> files into the <font color="#%s">Songs</font> folder\n%s', hex, hex, FOLDER_HINT)
end

local function set_note(text, is_error, seconds)
    note_token += 1

    local token = note_token

    note = {text = text, error = is_error}

    refresh_now()

    task.delay(seconds or 3, function()
        if destroyed or token ~= note_token then return end

        note = nil

        refresh_now()
    end)
end

local function loaded_for(record)
    return record ~= nil and record.asset ~= nil and sound.SoundId == record.asset and sound.IsLoaded
end

capture = function()
    if current and not loading and loaded_for(current) then
        state.position = math.floor(sound.TimePosition * 10 + 0.5) / 10
    elseif not current then
        state.position = 0
    end

    state.playing = (playing or restore.resume) and not finished
end

refresh_now = function()
    if destroyed then return end

    local total = #songs

    ui.count_label.Text = total == 1 and "1 song" or (total .. " songs")
    ui.title.Text = state.minimized and current and current.name or "Music Player"

    local name

    if current then
        name = current.name
    elseif total == 0 then
        name = "no songs yet"
    else
        name = "nothing playing"
    end

    if ui.name_label.Text ~= name then
        ui.name_label.Text = name
        ui.name_label.Position = UDim2.new()
        marquee_time = 0
        marquee_offset = 0
    end

    local text, color = "", theme.muted

    if note then
        text = note.text
        color = note.error and BROKEN_COLOR or theme.muted
    elseif total == 0 and not current then
        text = "drop .mp3 files in the Songs folder"
    elseif loading then
        text = "loading..."
    elseif finished then
        text = "finished"
    elseif playing then
        text = "playing"
    elseif current then
        text = loaded_for(current) and "paused" or "ready"
    else
        text = "press play"
    end

    ui.status_label.Text = text
    ui.status_label.TextColor3 = color

    local meta = ""

    if current then
        local index = table.find(songs, current)

        meta = index and string.format("track %d of %d", index, total) or "removed from the folder"

        if current.folder then
            meta ..= "  ·  " .. current.folder
        end
    end

    ui.meta_label.Text = meta
    ui.play_icon.Visible = not playing
    ui.pause_icon.Visible = playing
end

style_row = function(record)
    local row = record and record.row

    if not row then return end

    local is_current = record == current

    row.button.BackgroundColor3 = is_current and theme.accent or theme.hover
    row.button.BackgroundTransparency = is_current and 0.86 or (row.hovered and 0 or 1)
    row.name.TextColor3 = record.broken and theme.inactive or (is_current and theme.accent or theme.text)
    row.index.TextColor3 = theme.muted
    row.index.Visible = not is_current
    row.eq.Visible = is_current

    for _, bar in row.bars do
        bar.BackgroundColor3 = theme.accent
    end

    if record.broken then
        row.info.Text = record.unreadable and "rename" or "broken"
        row.info.TextColor3 = BROKEN_COLOR
    else
        local length = record.length or state.lengths[record.path]

        row.info.Text = length and format_time(length) or ""
        row.info.TextColor3 = theme.muted
    end
end

local function style_mode(button, edge, active, text)
    button.Text = text
    button.TextColor3 = active and theme.accent or theme.muted
    edge.Color = active and theme.accent or theme.outline
    edge.Transparency = active and 0.35 or 0
end

style_modes = function()
    style_mode(ui.shuffle_button, ui.shuffle_edge, state.shuffle, "shuffle")
    style_mode(ui.repeat_button, ui.repeat_edge, state.repeat_mode ~= "off", REPEAT_NAMES[state.repeat_mode])
    style_mode(ui.bass_button, ui.bass_edge, state.bass, "bass boost")
    style_mode(ui.speed_button, ui.speed_edge, state.speed ~= "normal", state.speed)
end

style_volume = function()
    ui.volume_fill.Size = UDim2.fromScale(state.volume / 100, 1)
    ui.volume_fill.BackgroundTransparency = state.muted and 0.6 or 0
    ui.volume_text.Text = state.muted and "muted" or (math.floor(state.volume + 0.5) .. "%")
    ui.mute_button.TextColor3 = state.muted and theme.accent or theme.muted
end

repaint = function()
    theme_dirty = false

    for index = #painted, 1, -1 do
        local entry = painted[index]
        local object = entry[1]

        if object.Parent == nil then
            table.remove(painted, index)
        else
            object[entry[2]] = theme[entry[3]]
        end
    end

    ui.hint.Text = hint_text()

    style_modes()
    style_volume()
    refresh_now()

    for _, record in songs do
        style_row(record)
    end

    if current and not table.find(songs, current) then
        style_row(current)
    end
end

local function update_empty(visible)
    if #songs == 0 then
        ui.empty.Visible = true
        ui.empty_title.Text = "no songs yet"
        ui.empty_text.Text = "drag .mp3 files into the Songs folder"
        ui.empty_path.Visible = true
        ui.empty_foot.Visible = true
    elseif visible == 0 then
        ui.empty.Visible = true
        ui.empty_title.Text = "nothing found"
        ui.empty_text.Text = 'no song matches "' .. query .. '"'
        ui.empty_path.Visible = false
        ui.empty_foot.Visible = false
    else
        ui.empty.Visible = false
    end
end

apply_filter = function()
    local visible = 0

    for _, record in songs do
        local show = query == "" or record.key:find(query, 1, true) ~= nil

        if record.row then
            record.row.button.Visible = show
        end

        if show then
            visible += 1
        end
    end

    update_empty(visible)
end

local function shuffle_list(items)
    for index = #items, 2, -1 do
        local other = rng:NextInteger(1, index)

        items[index], items[other] = items[other], items[index]
    end
end

build_queue = function()
    queue = table.clone(songs)

    if state.shuffle then
        shuffle_list(queue)

        local at = current and table.find(queue, current)

        if at then
            table.remove(queue, at)
            table.insert(queue, 1, current)
        end
    end

    cursor = current and table.find(queue, current) or 0
end

local function window_place()
    local camera = workspace.CurrentCamera
    local view = camera and camera.ViewportSize or Vector2.new(1280, 720)
    local size = ui.window.AbsoluteSize
    local max_x = math.max(0, (view.X - size.X) / 2 - 4)
    local max_y = math.max(0, (view.Y - size.Y) / 2 - 4)

    state.x = math.clamp(state.x, -max_x, max_x)
    state.y = math.clamp(state.y, -max_y, max_y)

    ui.window.Position = UDim2.new(0.5, state.x, 0.5, state.y)
end

local function fit()
    local camera = workspace.CurrentCamera
    local view = camera and camera.ViewportSize or Vector2.new(1280, 720)
    local scale = ui.window_scale.Scale

    if not state.minimized and ui.window.AbsoluteSize.Y > 0 and scale > 0 then
        natural_height = ui.window.AbsoluteSize.Y / scale
    end

    if natural_height > 0 then
        local limit = tonumber(options.scale) or 1
        local wanted = math.clamp(math.min((view.X - 24) / WIDTH, (view.Y - 24) / natural_height), 0.45, limit)

        if math.abs(wanted - scale) > 0.01 then
            ui.window_scale.Scale = wanted
        end
    end

    window_place()
end

local function apply_minimized()
    local minimized = state.minimized

    for _, child in ui.window:GetChildren() do
        if child ~= ui.header and child:IsA("GuiObject") then
            child.Visible = not minimized
        end
    end

    ui.window.Size = UDim2.fromOffset(minimized and MINI_WIDTH or WIDTH, 0)
    ui.window_padding.PaddingBottom = UDim.new(0, minimized and 10 or 12)
    ui.count_label.Visible = not minimized
    ui.min_button.Text = minimized and "+" or "–"
    ui.title.Size = UDim2.new(1, minimized and -(HEADER_HEIGHT * 2 + 28) or -(HEADER_HEIGHT * 2 + 144), 1, 0)

    if minimized then
        seeking = false
        seek_input = nil
        volume_input = nil

        if ui.search_box:IsFocused() then
            ui.search_box:ReleaseFocus()
        end
    end

    refresh_now()
end

local function toggle_minimized()
    local scale = math.max(ui.window_scale.Scale, 0.01)
    local full = natural_height * scale
    local mini = (20 + HEADER_HEIGHT) * scale

    if full > mini then
        local shift = (full - mini) / 2

        state.y += (state.minimized and shift or -shift)
    end

    state.minimized = not state.minimized

    apply_minimized()
    window_place()
    save_state()
end

reveal = function(record)
    if not shown or not record or not record.row then return end

    task.defer(function()
        local row = record.row

        if destroyed or not shown or not row or not row.button.Visible then return end

        local scale = math.max(ui.window_scale.Scale, 0.01)
        local top = (row.button.AbsolutePosition.Y - ui.list.AbsolutePosition.Y) / scale + ui.list.CanvasPosition.Y
        local bottom = top + ROW_HEIGHT
        local height = ui.list.AbsoluteSize.Y / scale
        local canvas = ui.list.CanvasPosition.Y
        local target

        if top < canvas then
            target = top - 4
        elseif bottom > canvas + height then
            target = bottom - height + 4
        else
            return
        end

        tween_service:Create(ui.list, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CanvasPosition = Vector2.new(0, math.max(0, target))}):Play()
    end)
end

hide_toast = function()
    toast_token += 1
    ui.toast.Visible = false
    ui.toast.Position = TOAST_HIDDEN
end

show_toast = function(record)
    if destroyed or not enabled or shown or not record then return end

    if theme_dirty then
        repaint()
    end

    toast_token += 1

    local token = toast_token

    ui.toast_name.Text = record.name
    ui.toast.Position = TOAST_HIDDEN
    ui.toast.Visible = true

    tween_service:Create(ui.toast, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = TOAST_SHOWN}):Play()

    task.delay(TOAST_TIME, function()
        if destroyed or token ~= toast_token then return end

        local out = tween_service:Create(ui.toast, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Position = TOAST_HIDDEN})

        out.Completed:Connect(function()
            if token == toast_token then
                ui.toast.Visible = false
            end
        end)

        out:Play()
    end)
end

local function apply_effects()
    sound.Looped = state.repeat_mode == "one"
    sound.PlaybackSpeed = SPEEDS[state.speed] or 1
    ui.bass_effect.Enabled = state.bass
    ui.reverb_effect.Enabled = state.speed == "slowed"
end

local function stop_sound()
    load_token += 1
    pause_token += 1
    loading = false
    playing = false

    if fade_tween then
        fade_tween:Cancel()
        fade_tween = nil
    end

    pcall(function()
        sound:Stop()
    end)
end

play_song = function(record, direction, attempts)
    if destroyed or not record then return end

    attempts = attempts or 0
    direction = direction == -1 and -1 or 1
    load_token += 1
    pause_token += 1

    local token = load_token
    local previous = current

    current = record
    finished = false
    loading = true
    playing = true
    state.last = record.path
    state.position = 0

    save_state()

    local at = table.find(queue, record)

    if at then
        cursor = at
    end

    if fade_tween then
        fade_tween:Cancel()
        fade_tween = nil
    end

    sound:Stop()
    sound.Volume = 0

    if previous and previous ~= record then
        style_row(previous)
    end

    style_row(record)
    refresh_now()
    reveal(record)

    task.spawn(function()
        local asset, unreadable = record.asset, false

        if not asset then
            asset, unreadable = song_cache.resolve(record.path)
        end

        if destroyed or token ~= load_token then return end

        local ready = false

        if asset then
            record.asset = asset

            if sound.SoundId == asset and sound.IsLoaded then
                ready = true
            else
                if sound.SoundId == asset then
                    sound.SoundId = ""
                end

                sound.SoundId = asset

                local started = os.clock()

                repeat
                    task.wait(0.05)
                until destroyed or token ~= load_token or sound.IsLoaded or os.clock() - started > LOAD_TIMEOUT

                ready = sound.IsLoaded
            end
        end

        if destroyed or token ~= load_token then return end

        if not ready or sound.TimeLength <= 0 then
            loading = false
            record.broken = true
            record.unreadable = unreadable
            record.asset = nil

            style_row(record)

            local reason = unreadable and ("can't read " .. record.name .. ", rename it with english letters") or ("can't play " .. record.name .. ", skipping")

            if attempts + 1 < #queue then
                set_note(reason, true, unreadable and 5 or 3)
                advance(direction, false, attempts + 1)
            else
                playing = false

                set_note(unreadable and reason or "couldn't load any of your songs", true, 5)
            end

            return
        end

        record.broken = false
        record.unreadable = nil
        record.length = sound.TimeLength
        state.lengths[record.path] = math.floor(sound.TimeLength * 10 + 0.5) / 10
        loading = false

        apply_effects()

        local start = 0

        if restore.path == record.path then
            start = math.clamp(restore.position or 0, 0, math.max(sound.TimeLength - 1, 0))
        end

        restore.path = nil
        sound.TimePosition = start

        if playing then
            play_clock = clock
            sound:Play()
            fade(target_volume(), 0.25)
        end

        style_row(record)
        refresh_now()
        save_state()
        show_toast(record)
    end)
end

advance = function(direction, automatic, attempts)
    local count = #queue

    if count == 0 then
        stop_sound()
        refresh_now()

        return
    end

    local target = cursor + direction

    if cursor == 0 then
        target = direction > 0 and 1 or count
    end

    if target > count then
        if automatic and state.repeat_mode == "off" then
            finished = true
            playing = false

            refresh_now()

            return
        end

        if state.shuffle then
            local last = queue[count]

            queue = table.clone(songs)
            shuffle_list(queue)

            if #queue > 1 and queue[1] == last then
                queue[1], queue[2] = queue[2], queue[1]
            end
        end

        target = 1
    elseif target < 1 then
        target = count
    end

    cursor = target

    play_song(queue[cursor], direction, attempts)
end

pause = function()
    if not playing then return end

    playing = false
    pause_token += 1

    save_state()

    local token = pause_token

    if loading then
        refresh_now()

        return
    end

    fade(0, 0.15, function()
        if token == pause_token and not playing then
            sound:Pause()
        end
    end)

    refresh_now()
end

resume = function()
    if destroyed then return end

    if loading then
        playing = true

        refresh_now()

        return
    end

    if finished then
        finished = false
        cursor = 0

        return advance(1, false)
    end

    local record = current or queue[cursor > 0 and cursor or 1]

    if not record then
        set_note("no songs yet, drop some in the Songs folder", false, 3)

        return
    end

    if record ~= current or not loaded_for(record) then
        return play_song(record, 1)
    end

    pause_token += 1
    playing = true
    play_clock = clock

    save_state()

    if sound.IsPaused then
        sound:Resume()
    elseif not sound.IsPlaying then
        sound:Play()
    end

    fade(target_volume(), 0.2)
    refresh_now()
end

local function toggle_play()
    if playing then
        pause()
    else
        resume()
    end
end

local function previous_song()
    if current and not loading and loaded_for(current) and (finished or sound.TimePosition > RESTART_AFTER) then
        sound.TimePosition = 0

        if finished then
            finished = false

            refresh_now()
        end

        return
    end

    advance(-1, false)
end

local function next_song()
    advance(1, false)
end

local function random_song()
    local count = #songs

    if count == 0 then
        set_note("no songs yet, drop some in the Songs folder", false, 3)

        return
    end

    local pick = songs[rng:NextInteger(1, count)]

    if count > 1 then
        while pick == current do
            pick = songs[rng:NextInteger(1, count)]
        end
    end

    play_song(pick, 1)
end

local function set_volume(value)
    state.volume = math.clamp(math.floor(value + 0.5), 0, 100)

    if state.muted and state.volume > 0 then
        state.muted = false
    end

    style_volume()

    if playing and not loading then
        fade(target_volume(), 0)
    end

    save_state()
end

local function make_row(record, index)
    local button = new("TextButton", {AutoButtonColor = false, Text = "", BackgroundColor3 = theme.hover, BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, ROW_HEIGHT), LayoutOrder = index, Parent = ui.list})

    corner(button, 5)

    local index_label = new("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(6, 0), Size = UDim2.new(0, 22, 1, 0), FontFace = FONT_LIGHT, Text = string.format("%02d", index), TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = button})
    local eq = new("Frame", {BackgroundTransparency = 1, AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 7, 0.5, 0), Size = UDim2.fromOffset(13, 12), Visible = false, Parent = button})
    local bars = {}

    for bar_index = 1, 3 do
        local bar = new("Frame", {BackgroundColor3 = theme.accent, BorderSizePixel = 0, AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, (bar_index - 1) * 5, 1, 0), Size = UDim2.fromOffset(3, 3), Parent = eq})

        bars[bar_index] = bar
    end

    local name = new("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(32, 0), Size = UDim2.new(1, -84, 1, 0), FontFace = FONT_LIGHT, Text = record.name, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = button})
    local info = new("TextLabel", {BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -6, 0, 0), Size = UDim2.new(0, 46, 1, 0), FontFace = FONT_LIGHT, Text = "", TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right, Parent = button})

    record.row = {button = button, index = index_label, eq = eq, bars = bars, name = name, info = info, hovered = false}

    if not touch then
        button.MouseEnter:Connect(function()
            if record.row then
                record.row.hovered = true

                style_row(record)
            end
        end)

        button.MouseLeave:Connect(function()
            if record.row then
                record.row.hovered = false

                style_row(record)
            end
        end)
    end

    button.Activated:Connect(function()
        if record == current and not record.broken then
            toggle_play()

            return
        end

        record.broken = false

        play_song(record, 1)
    end)

    style_row(record)
end

local function collect(folder, depth, found)
    local ok, entries = try(listfiles, folder)

    if not ok or type(entries) ~= "table" then return false end

    for _, entry in entries do
        if type(entry) == "string" then
            local extension = entry:match("%.([%w]+)$")

            if extension and EXTENSIONS[extension:lower()] then
                found[#found + 1] = entry
            elseif depth < SCAN_DEPTH and is_folder(entry) then
                collect(entry, depth + 1, found)
            end
        end
    end

    return true
end

local function rebuild(found)
    local fresh, lookup = {}, {}

    for _, path in found do
        if not lookup[path] then
            local record = by_path[path]

            if not record then
                local clean = path:gsub("\\", "/")
                local name = clean:match("([^/]+)%.[%w]+$") or clean
                local folder = clean:match("([^/]+)/[^/]+$")
                local file_name = name

                if folder and folder:lower() == "songs" then
                    folder = nil
                end

                local info = folder and folder:lower() == "community" and community.files[clean:match("([^/]+)$") or ""]

                if info then
                    name = (info.remote:gsub("%.[%w]+$", ""))
                end

                record = {path = path, name = name, folder = folder, key = (name .. " " .. file_name .. " " .. (folder or "")):lower()}
            end

            lookup[path] = record
            fresh[#fresh + 1] = record
        end
    end

    table.sort(fresh, function(a, b)
        local left, right = a.name:lower(), b.name:lower()

        if left == right then
            return a.path < b.path
        end

        return left < right
    end)

    for path, record in by_path do
        if not lookup[path] and record.row then
            record.row.button:Destroy()
            record.row = nil
        end
    end

    by_path = lookup
    songs = fresh

    for index, record in songs do
        if record.row then
            record.row.button.LayoutOrder = index
            record.row.index.Text = string.format("%02d", index)
        else
            make_row(record, index)
        end
    end

    for path in state.lengths do
        if not lookup[path] then
            state.lengths[path] = nil
        end
    end

    if not current and state.last and lookup[state.last] then
        current = lookup[state.last]

        style_row(current)
    end

    song_cache.prune(songs)
    build_queue()
    apply_filter()
    refresh_now()
end

local function scan()
    if destroyed then return end

    ensure_folder(SONGS_FOLDER)

    local found = {}
    local blocked = false

    if not collect(SONGS_FOLDER, 0, found) then
        blocked = type(listfiles) == "function" and SCAN_BLOCKED.name or SCAN_BLOCKED.list

        for file in community.files do
            local path = COMMUNITY_FOLDER .. "/" .. file

            if is_file(path) then
                found[#found + 1] = path
            end
        end
    end

    if blocked ~= scan_blocked then
        scan_blocked = blocked
        ui.hint.Text = hint_text()

        if blocked then
            set_note(blocked.note, true, 6)
        end
    end

    table.sort(found)

    local next_signature = table.concat(found, "|")

    if next_signature == signature then return end

    signature = next_signature

    rebuild(found)
end

local function community_status(text, fraction)
    ui.community_text.Text = text
    ui.community_fill.Size = UDim2.fromScale(math.clamp(fraction or 0, 0, 1), 1)
end

local function community_finish(text, is_error)
    community.busy = false
    community.reset_token += 1

    local token = community.reset_token

    community_status(text, 0)
    set_note(text, is_error, 4)

    task.delay(4, function()
        if destroyed or community.busy or token ~= community.reset_token then return end

        community_status(COMMUNITY_LABEL, 0)
    end)
end

local function community_run()
    local body = http_get(COMMUNITY_API)

    if destroyed then return end

    local ok, listing = false, nil

    if body then
        ok, listing = pcall(http_service.JSONDecode, http_service, body)
    end

    if not ok or type(listing) ~= "table" or (listing[1] == nil and next(listing) ~= nil) then
        return community_finish("couldn't reach github, try again later", true)
    end

    local wanted = {}

    for _, item in listing do
        if type(item) == "table" and item.type == "file" and type(item.name) == "string" and type(item.download_url) == "string" then
            local extension = item.name:match("%.([%w]+)$")

            if extension and EXTENSIONS[extension:lower()] then
                wanted[#wanted + 1] = item
            end
        end
    end

    if #wanted == 0 then
        return community_finish("no community songs right now", false)
    end

    ensure_folder(SONGS_FOLDER)
    ensure_folder(COMMUNITY_FOLDER)

    local by_remote, used = {}, {}

    for file, info in community.files do
        by_remote[info.remote] = file
        used[file:lower()] = true
    end

    local jobs, present = {}, {}

    for _, item in wanted do
        local file = by_remote[item.name] or community_file_name(item.name, used)
        local info = community.files[file]
        local path = COMMUNITY_FOLDER .. "/" .. file

        present[file] = true

        if not (info and info.sha == tostring(item.sha or "") and is_file(path)) then
            jobs[#jobs + 1] = {item = item, file = file, path = path}
        end
    end

    local stale = {}

    for file in community.files do
        if not present[file] then
            stale[#stale + 1] = file
        end
    end

    for _, file in stale do
        try(delfile, COMMUNITY_FOLDER .. "/" .. file)
        community.files[file] = nil
    end

    if #stale > 0 then
        save_community()
    end

    local added, failed = 0, 0

    for index, job in jobs do
        if destroyed then return end

        community_status(string.format("downloading %d / %d", index, #jobs), (index - 1) / #jobs)

        local data = http_get(url_encode(job.item.download_url))
        local size = tonumber(job.item.size)

        if destroyed then return end

        if type(data) == "string" and #data > 1024 and (not size or #data == size) then
            write_file(job.path, data)

            if is_file(job.path) then
                community.files[job.file] = {remote = job.item.name, sha = tostring(job.item.sha or ""), size = size}
                added += 1

                save_community()
            else
                failed += 1
            end
        else
            failed += 1
        end
    end

    community_status("finishing up...", 1)

    signature = nil

    pcall(scan)

    if failed > 0 then
        community_finish(string.format("added %d, %d failed to download", added, failed), true)
    elseif added == 0 and #stale == 0 then
        community_finish("community songs are up to date", false)
    elseif added == 0 then
        community_finish(string.format("removed %d old community song%s", #stale, #stale == 1 and "" or "s"), false)
    else
        community_finish(string.format("added %d community song%s", added, added == 1 and "" or "s"), false)
    end
end

local function community_sync()
    if destroyed or community.busy then return end

    community.busy = true
    community.reset_token += 1

    community_status("checking github...", 0)

    task.spawn(function()
        local ok = pcall(community_run)

        if not ok and not destroyed and community.busy then
            community_finish("community download failed", true)
        end
    end)
end

local function update_marquee(dt)
    local scale = ui.window_scale.Scale

    if scale <= 0 then return end

    local overflow = (ui.name_label.AbsoluteSize.X - ui.name_clip.AbsoluteSize.X) / scale

    if overflow <= 1 then
        if marquee_offset ~= 0 then
            marquee_offset = 0
            ui.name_label.Position = UDim2.new()
        end

        return
    end

    marquee_time += dt

    local travel = overflow / 28
    local cycle = travel * 2 + 3
    local t = marquee_time % cycle
    local offset

    if t < 1.5 then
        offset = 0
    elseif t < 1.5 + travel then
        offset = (t - 1.5) / travel * overflow
    elseif t < 3 + travel then
        offset = overflow
    else
        offset = overflow - (t - 3 - travel) / travel * overflow
    end

    offset = math.floor(offset + 0.5)

    if offset ~= marquee_offset then
        marquee_offset = offset
        ui.name_label.Position = UDim2.fromOffset(-offset, 0)
    end
end

local function render(dt)
    if theme_dirty then
        repaint()
    end

    clock += dt

    if state.minimized then
        local active = playing and current ~= nil and not loading and loaded_for(current) and sound.IsPlaying
        local dot = active and math.floor((0.1 + 0.4 * (0.5 + 0.5 * math.sin(clock * 4))) * 50 + 0.5) / 50 or 0.7

        if dot ~= last_dot then
            last_dot = dot
            ui.live_dot.BackgroundTransparency = dot
        end

        return
    end

    local loaded = current ~= nil and not loading and loaded_for(current)
    local length = loaded and sound.TimeLength or 0
    local position = 0

    if length > 0 then
        position = seeking and seek_fraction * length or sound.TimePosition
    end

    local fraction = length > 0 and math.clamp(position / length, 0, 1) or 0

    if math.abs(fraction - last_fill) > 0.0005 then
        last_fill = fraction
        ui.seek_fill.Size = UDim2.fromScale(fraction, 1)
        ui.seek_knob.Position = UDim2.fromScale(fraction, 0.5)
    end

    local left = format_time(position)
    local known = length > 0 and length or (current and (current.length or state.lengths[current.path])) or 0
    local right = format_time(known)

    if left ~= last_left then
        last_left = left
        ui.time_left.Text = left
    end

    if right ~= last_right then
        last_right = right
        ui.time_right.Text = right
    end

    local active = playing and loaded and sound.IsPlaying
    local loud = 0

    if active then
        local raw = sound.PlaybackLoudness

        if raw > 1 then
            loud_seen = true
        end

        loud = math.clamp(raw / 500, 0, 1)

        if not loud_seen and clock - play_clock > 1.5 then
            loud = 0.35 + 0.15 * math.sin(clock * 2.3)
        end

        loud = math.sqrt(loud)
    end

    level += (loud - level) * (1 - math.exp(-dt * 10))

    local smoothing = 1 - math.exp(-dt * 16)

    for index = 1, BARS do
        local wave = math.abs(math.sin(clock * (2.6 + index * 0.41) + index * 1.9) * 0.6 + math.sin(clock * (1.1 + index * 0.23) + index * 0.7) * 0.4)
        local goal = level * (0.3 + 0.7 * wave)

        bar_levels[index] += (goal - bar_levels[index]) * smoothing

        local height = math.floor(BAR_MIN + (BAR_MAX - BAR_MIN) * bar_levels[index] + 0.5)

        if height ~= bar_heights[index] then
            bar_heights[index] = height
            ui.bar_frames[index].Size = UDim2.fromOffset(3, height)
        end
    end

    local glow_value = math.floor((1 - level * 0.35) * 100 + 0.5) / 100

    if glow_value ~= last_glow then
        last_glow = glow_value
        ui.glow.BackgroundTransparency = glow_value
    end

    local dot = active and math.floor((0.1 + 0.4 * (0.5 + 0.5 * math.sin(clock * 4))) * 50 + 0.5) / 50 or 0.7

    if dot ~= last_dot then
        last_dot = dot
        ui.live_dot.BackgroundTransparency = dot
    end

    local row = current and current.row

    if row and row.eq.Visible then
        for index, bar in row.bars do
            local height = active and math.floor(3 + 9 * math.abs(math.sin(clock * (5 + index * 1.7) + index)) + 0.5) or 3

            if bar.Size.Y.Offset ~= height then
                bar.Size = UDim2.fromOffset(3, height)
            end
        end
    end

    update_marquee(dt)
end

local function start_scanner()
    scan_token += 1

    local token = scan_token

    task.spawn(function()
        while not destroyed and shown and token == scan_token do
            pcall(scan)
            task.wait(SCAN_INTERVAL)
        end
    end)
end

local function update_shown()
    local show = enabled and menu_visible and not destroyed

    if show == shown then return end

    shown = show
    ui.window.Visible = show

    if show then
        hide_toast()

        if theme_dirty then
            repaint()
        end

        fit()

        if not render_connection then
            render_connection = run_service.RenderStepped:Connect(function(dt)
                pcall(render, dt)
            end)
        end

        start_scanner()
        reveal(current)
    else
        if render_connection then
            render_connection:Disconnect()
            render_connection = nil
        end

        scan_token += 1
        seeking = false
        seek_input = nil
        volume_input = nil
        drag_input = nil

        if not menu_visible and ui.search_box:IsFocused() then
            ui.search_box:ReleaseFocus()
        end
    end
end

local function fraction_at(x, frame)
    return math.clamp((x - frame.AbsolutePosition.X) / math.max(frame.AbsoluteSize.X, 1), 0, 1)
end

local function is_press(input)
    local kind = input.UserInputType

    return kind == Enum.UserInputType.MouseButton1 or kind == Enum.UserInputType.Touch
end

local function press_effect(button, scale)
    button.MouseButton1Down:Connect(function()
        tween_service:Create(scale, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 0.9}):Play()
    end)

    local function release()
        tween_service:Create(scale, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
    end

    button.MouseButton1Up:Connect(release)
    button.MouseLeave:Connect(release)
end

local function hover(button, base, lit)
    if touch then return end

    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = theme[lit or "hover"]
    end)

    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = theme[base or "element"]
    end)
end

press_effect(ui.prev_button, ui.prev_scale)
press_effect(ui.play_button, ui.play_scale)
press_effect(ui.next_button, ui.next_scale)

hover(ui.prev_button)
hover(ui.next_button)
hover(ui.play_button, "accent", "accent_hover")
hover(ui.close_button)
hover(ui.min_button)
hover(ui.random_button)
hover(ui.community_button)
hover(ui.shuffle_button)
hover(ui.repeat_button)
hover(ui.bass_button)
hover(ui.speed_button)

ui.prev_button.Activated:Connect(previous_song)
ui.play_button.Activated:Connect(toggle_play)
ui.next_button.Activated:Connect(next_song)
ui.random_button.Activated:Connect(random_song)
ui.community_button.Activated:Connect(community_sync)

ui.min_button.Activated:Connect(toggle_minimized)

ui.close_button.Activated:Connect(function()
    if options.embedded then
        local handler = api.on_close

        if type(handler) == "function" then
            task.spawn(pcall, handler)
        else
            api.set_enabled(false)
        end
    else
        api.destroy()
    end
end)

ui.shuffle_button.Activated:Connect(function()
    state.shuffle = not state.shuffle

    build_queue()
    style_modes()
    save_state()
end)

ui.repeat_button.Activated:Connect(function()
    local index = table.find(REPEAT_ORDER, state.repeat_mode) or 1

    state.repeat_mode = REPEAT_ORDER[index % #REPEAT_ORDER + 1]

    apply_effects()
    style_modes()
    save_state()
end)

ui.bass_button.Activated:Connect(function()
    state.bass = not state.bass

    apply_effects()
    style_modes()
    save_state()
end)

ui.speed_button.Activated:Connect(function()
    local index = table.find(SPEED_ORDER, state.speed) or 1

    state.speed = SPEED_ORDER[index % #SPEED_ORDER + 1]

    apply_effects()
    style_modes()
    save_state()
end)

ui.mute_button.Activated:Connect(function()
    state.muted = not state.muted

    if not state.muted and state.volume <= 0 then
        state.volume = 50
    end

    style_volume()

    if playing and not loading then
        fade(target_volume(), 0.15)
    end

    save_state()
end)

ui.search_box:GetPropertyChangedSignal("Text"):Connect(function()
    query = (ui.search_box.Text:lower():gsub("^%s+", ""):gsub("%s+$", ""))

    apply_filter()
end)

ui.drag_zone.InputBegan:Connect(function(input)
    if not is_press(input) then return end

    drag_input = input
    drag_start = input.Position
    drag_origin = Vector2.new(state.x, state.y)
end)

ui.seek_hit.InputBegan:Connect(function(input)
    if not is_press(input) or loading or not loaded_for(current) or sound.TimeLength <= 0 then return end

    seeking = true
    seek_input = input
    seek_fraction = fraction_at(input.Position.X, ui.seek_track)
end)

ui.volume_hit.InputBegan:Connect(function(input)
    if not is_press(input) then return end

    volume_input = input

    set_volume(fraction_at(input.Position.X, ui.volume_hit) * 100)
end)

ui.volume_hit.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseWheel then
        set_volume(state.volume + (input.Position.Z > 0 and 5 or -5))
    end
end)

if not touch then
    ui.seek_hit.MouseEnter:Connect(function()
        ui.seek_knob.Visible = true
    end)

    ui.seek_hit.MouseLeave:Connect(function()
        if not seeking then
            ui.seek_knob.Visible = false
        end
    end)
end

connect(user_input_service.InputChanged, function(input)
    local kind = input.UserInputType

    if kind ~= Enum.UserInputType.MouseMovement and kind ~= Enum.UserInputType.Touch then return end

    local mouse = kind == Enum.UserInputType.MouseMovement

    if seeking and (mouse or input == seek_input) then
        seek_fraction = fraction_at(input.Position.X, ui.seek_track)
    end

    if volume_input and (mouse or input == volume_input) then
        set_volume(fraction_at(input.Position.X, ui.volume_hit) * 100)
    end

    if drag_input and (mouse or input == drag_input) then
        local delta = input.Position - drag_start

        state.x = drag_origin.X + delta.X
        state.y = drag_origin.Y + delta.Y

        window_place()
    end
end)

connect(user_input_service.InputEnded, function(input)
    if not is_press(input) then return end

    local mouse = input.UserInputType == Enum.UserInputType.MouseButton1

    if seeking and (mouse or input == seek_input) then
        seeking = false
        seek_input = nil

        if not touch then
            ui.seek_knob.Visible = false
        end

        if not loading and loaded_for(current) and sound.TimeLength > 0 then
            sound.TimePosition = math.clamp(seek_fraction * sound.TimeLength, 0, math.max(sound.TimeLength - 0.1, 0))

            save_state()

            if finished then
                finished = false

                refresh_now()
            end
        end
    end

    if volume_input and (mouse or input == volume_input) then
        volume_input = nil
    end

    if drag_input and (mouse or input == drag_input) then
        drag_input = nil

        save_state()
    end
end)

connect(sound.Ended, function()
    if destroyed or loading or not playing then return end

    if state.repeat_mode == "one" then
        sound.TimePosition = 0
        sound:Play()

        return
    end

    advance(1, true)
end)

local function bind_camera()
    if camera_connection then
        camera_connection:Disconnect()
        camera_connection = nil
    end

    local camera = workspace.CurrentCamera

    if camera then
        camera_connection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
            if shown then
                fit()
            end
        end)
    end
end

connect(workspace:GetPropertyChangedSignal("CurrentCamera"), bind_camera)

bind_camera()

ui.window:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
    if shown then
        fit()
    end
end)

function api.set_enabled(value)
    value = value and true or false

    if destroyed or value == enabled then return end

    enabled = value

    if not enabled then
        restore.resume = playing

        if loading then
            stop_sound()
        elseif playing then
            pause()
        end

        hide_toast()
        refresh_now()
        save_state()
    elseif restore.resume then
        restore.resume = false

        if current then
            resume()
        end
    end

    update_shown()
end

function api.set_visible(value)
    if destroyed then return end

    menu_visible = value and true or false

    update_shown()
end

function api.set_theme(source)
    if destroyed then return end

    read_theme(source)

    theme_dirty = true
end

function api.play()
    if not destroyed then resume() end
end

function api.pause()
    if not destroyed then pause() end
end

function api.toggle()
    if not destroyed then toggle_play() end
end

function api.next()
    if not destroyed then next_song() end
end

function api.previous()
    if not destroyed then previous_song() end
end

function api.load_community()
    community_sync()
end

function api.clear_settings()
    if destroyed then return end

    local previous = current
    local lengths = state.lengths

    stop_sound()

    current = nil
    finished = false
    restore.path = nil
    restore.resume = false

    for key, value in default_state() do
        state[key] = value
    end

    state.last = nil
    state.lengths = lengths
    ui.search_box.Text = ""

    if previous then
        style_row(previous)
    end

    build_queue()
    apply_effects()
    style_modes()
    style_volume()
    apply_minimized()
    window_place()
    refresh_now()
    write_state()
end

function api.rescan()
    if destroyed then return end

    signature = nil

    pcall(scan)
end

function api.is_playing()
    return playing and not destroyed
end

function api.destroy()
    if destroyed then return end

    destroyed = true
    load_token += 1
    pause_token += 1
    scan_token += 1
    toast_token += 1

    if render_connection then
        render_connection:Disconnect()
        render_connection = nil
    end

    if camera_connection then
        camera_connection:Disconnect()
        camera_connection = nil
    end

    for _, connection in connections do
        pcall(function()
            connection:Disconnect()
        end)
    end

    table.clear(connections)

    write_state()

    pcall(function()
        sound:Stop()
    end)

    pcall(function()
        gui:Destroy()
    end)

    if genv.SleepyMusicPlayer == api then
        genv.SleepyMusicPlayer = nil
    end
end

apply_effects()
ui.hint.Text = hint_text()
style_modes()
style_volume()
apply_minimized()
pcall(scan)
refresh_now()

if enabled and restore.resume then
    restore.resume = false

    if current then
        resume()
    end
end

task.spawn(function()
    while not destroyed do
        task.wait(AUTOSAVE_INTERVAL)

        if playing and not destroyed then
            save_state()
        end
    end
end)

genv.SleepyMusicPlayer = api

update_shown()

return api
