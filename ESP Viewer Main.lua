local options = ...

if type(options) ~= "table" then
    options = {}
end

local genv = type(getgenv) == "function" and getgenv() or _G

if type(genv.SleepyESPViewer) == "table" and type(genv.SleepyESPViewer.destroy) == "function" then
    pcall(genv.SleepyESPViewer.destroy)
end

local clone = type(cloneref) == "function" and cloneref or function(object) return object end

local players = clone(game:GetService("Players"))
local user_input_service = clone(game:GetService("UserInputService"))
local local_player = players.LocalPlayer

local touch = user_input_service.TouchEnabled and not user_input_service.KeyboardEnabled

local ROOT = type(options.root) == "string" and options.root ~= "" and options.root or "Sleepy.gg"
local WIDTH = 260
local VIEW_HEIGHT = touch and 300 or 340
local HEADER_HEIGHT = touch and 26 or 20
local FIELD_OF_VIEW = 18
local ORBIT_SPEED = 0.012
local ZOOM_STEP = 0.85
local ZOOM_MIN = 0.35
local ZOOM_MAX = 6
local ELEVATION_LIMIT = math.pi / 2 - 0.1
local SETTLE_TIME = 0.2
local DEFAULT_WEAPON = "Assault Rifle"
local THEMED = {BackgroundColor3 = true, TextColor3 = true, Color = true}
local DEFAULT_THEME = {
    accent = Color3.fromRGB(0, 162, 255),
    background = Color3.fromRGB(14, 14, 16),
    element = Color3.fromRGB(25, 25, 29),
    outline = Color3.fromRGB(36, 36, 37),
    text = Color3.fromRGB(245, 245, 245),
    inactive = Color3.fromRGB(72, 72, 73),
}

local theme = {}

local function read_theme(source)
    for key, fallback in DEFAULT_THEME do
        local value = type(source) == "table" and source[key]

        theme[key] = typeof(value) == "Color3" and value or theme[key] or fallback
    end

    theme.panel = theme.background:Lerp(theme.element, 0.45)
    theme.hover = theme.element:Lerp(theme.outline, 0.55)
    theme.muted = theme.inactive:Lerp(theme.text, 0.3)
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

local function outline(parent)
    return new("UIStroke", {Color = "outline", ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = parent})
end

local function enum_font(name)
    local ok, font = pcall(function()
        return Font.fromEnum(Enum.Font[name])
    end)

    return ok and font or Font.fromEnum(Enum.Font.SourceSans)
end

local function load_font(file, fallback)
    local ok, font = pcall(function()
        local face = ROOT .. "/fonts/" .. file

        if type(isfile) ~= "function" or type(getcustomasset) ~= "function" or not isfile(face .. ".font") then
            return nil
        end

        if isfile(face .. ".ttf") then
            getcustomasset(face .. ".ttf")
        end

        return Font.new(getcustomasset(face .. ".font"), Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    end)

    return ok and font or enum_font(fallback)
end

local FONT = typeof(options.font) == "Font" and options.font or load_font("SemiBold", "BuilderSansMedium")
local FONT_LIGHT = typeof(options.font_light) == "Font" and options.font_light or load_font("Medium", "BuilderSans")
local FONT_ICON = enum_font("BuilderSansBold")

local gui = Instance.new("ScreenGui")

gui.Name = "\0"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 2147483644

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

local ui = {}

ui.window = new("Frame", {Name = "\0", AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -24, 0.5, 0), Size = UDim2.fromOffset(WIDTH, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = "background", BorderSizePixel = 0, Active = true, Visible = false, Parent = gui})

corner(ui.window, 10)
outline(ui.window)

new("UIPadding", {PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 12), PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12), Parent = ui.window})
new("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), Parent = ui.window})

ui.header = new("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, HEADER_HEIGHT), LayoutOrder = 1, Parent = ui.window})
ui.drag_zone = new("TextButton", {AutoButtonColor = false, BackgroundTransparency = 1, Text = "", Size = UDim2.fromScale(1, 1), ZIndex = 1, Parent = ui.header})
ui.live_dot = new("Frame", {BackgroundColor3 = "accent", BackgroundTransparency = 0.7, BorderSizePixel = 0, AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 1, 0.5, 0), Size = UDim2.fromOffset(6, 6), ZIndex = 2, Parent = ui.header})

corner(ui.live_dot, 3)

ui.title = new("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 0), Size = UDim2.new(1, -(HEADER_HEIGHT + 20), 1, 0), FontFace = FONT, Text = "ESP Preview", TextColor3 = "text", TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 2, Parent = ui.header})
ui.close_button = new("TextButton", {AutoButtonColor = false, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.fromOffset(HEADER_HEIGHT, HEADER_HEIGHT), BackgroundColor3 = "element", Text = "×", FontFace = FONT_ICON, TextSize = 16, TextColor3 = "muted", ZIndex = 3, Parent = ui.header})

corner(ui.close_button, 5)

ui.divider = new("Frame", {BackgroundColor3 = "accent", BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 1), LayoutOrder = 2, Parent = ui.window})

new("UIGradient", {Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.85), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 0.85)}), Parent = ui.divider})

ui.card = new("Frame", {BackgroundColor3 = "element", BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, VIEW_HEIGHT), ClipsDescendants = true, LayoutOrder = 3, Parent = ui.window})

corner(ui.card, 7)
outline(ui.card)

ui.backdrop = new("Frame", {BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), ZIndex = 1, Parent = ui.card})

corner(ui.backdrop, 7)

ui.backdrop_gradient = new("UIGradient", {Rotation = 90, Color = ColorSequence.new(theme.panel, theme.background), Parent = ui.backdrop})

ui.viewport = new("ViewportFrame", {BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Ambient = Color3.fromRGB(140, 140, 150), LightColor = Color3.new(1, 1, 1), LightDirection = Vector3.new(-1, -1, -1).Unit, ZIndex = 2, Parent = ui.card})
ui.world = new("WorldModel", {Parent = ui.viewport})
ui.camera = new("Camera", {FieldOfView = FIELD_OF_VIEW, Parent = ui.viewport})
ui.viewport.CurrentCamera = ui.camera

ui.overlay = new("Frame", {BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 3, Parent = ui.card})
ui.orbit = new("TextButton", {AutoButtonColor = false, BackgroundTransparency = 1, Text = "", Size = UDim2.fromScale(1, 1), ZIndex = 4, Parent = ui.card})
ui.status = new("TextLabel", {BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.new(1, -20, 0, 18), FontFace = FONT_LIGHT, Text = "loading avatar...", TextColor3 = "muted", TextSize = 13, TextWrapped = true, ZIndex = 5, Parent = ui.card})
ui.hint = new("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 14), FontFace = FONT_LIGHT, Text = touch and "drag to rotate" or "drag to rotate · scroll to zoom", TextColor3 = "muted", TextSize = 12, LayoutOrder = 4, Parent = ui.window})

local api = {on_close = options.on_close}
local connections = {}
local destroyed = false
local enabled = false
local menu_visible = true
local loading = false
local attached = false
local avatar = nil
local orbit = {rotation = math.rad(225), elevation = math.rad(20), zoom = 4, center = Vector3.zero, radius = 2.75, dragging = nil, last = nil}
local window_drag = {input = nil, start = nil, origin = nil}

local function connect(signal, callback)
    connections[#connections + 1] = signal:Connect(callback)
end

local function preview_api()
    local preview = genv.SleepyESPPreview

    return type(preview) == "table" and type(preview.attach) == "function" and preview or nil
end

local function weapon_name()
    local source = options.weapon
    local ok, name = pcall(function()
        return type(source) == "function" and source() or source
    end)

    return ok and type(name) == "string" and name ~= "" and name or DEFAULT_WEAPON
end

local function repaint()
    for _, entry in painted do
        pcall(function()
            entry[1][entry[2]] = theme[entry[3]]
        end)
    end

    ui.backdrop_gradient.Color = ColorSequence.new(theme.panel, theme.background)
end

local function render()
    local preview = attached and preview_api()

    if preview then
        pcall(preview.render)
    end
end

local function place_camera()
    local distance = math.max(orbit.radius * 2.4 * orbit.zoom, 4)
    local planar = math.cos(orbit.elevation)
    local offset = Vector3.new(math.cos(orbit.rotation) * planar, math.sin(orbit.elevation), math.sin(orbit.rotation) * planar) * distance

    ui.camera.CFrame = CFrame.lookAt(orbit.center + offset, orbit.center)

    render()
end

local function measure(model)
    local low, high

    for _, part in model:GetDescendants() do
        if part:IsA("BasePart") and not part:FindFirstAncestorOfClass("Accessory") then
            local half = part.Size * 0.5
            local position = part.Position

            low = low and low:Min(position - half) or position - half
            high = high and high:Max(position + half) or position + half
        end
    end

    if not low then return end

    local size = high - low

    orbit.center = (low + high) * 0.5
    orbit.radius = math.max(size.X, size.Y, size.Z) * 0.5
end

local function build_avatar()
    local described, description = pcall(players.GetHumanoidDescriptionFromUserIdAsync, players, local_player.UserId)

    if not described or typeof(description) ~= "Instance" then return nil end

    local built, model = pcall(players.CreateHumanoidModelFromDescriptionAsync, players, description, Enum.HumanoidRigType.R15)

    if not built or typeof(model) ~= "Instance" then return nil end

    for _, item in model:GetDescendants() do
        if item:IsA("LuaSourceContainer") then
            item:Destroy()
        end
    end

    local humanoid = model:FindFirstChildOfClass("Humanoid")

    if humanoid then
        humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
    end

    model:PivotTo(CFrame.identity)

    return model
end

local function attach()
    if attached or not avatar then return end

    local preview = preview_api()

    if not preview then
        ui.status.Text = "update the esp library to see the overlay"
        ui.status.Visible = true

        return
    end

    local ok, result = pcall(preview.attach, ui.overlay, avatar, ui.camera, weapon_name())

    attached = ok and result == true
    ui.status.Visible = not attached

    if not attached then
        ui.status.Text = "esp overlay failed to load"
    end
end

local function detach()
    if not attached then return end

    attached = false

    local preview = preview_api()

    if preview and type(preview.detach) == "function" then
        pcall(preview.detach)
    end
end

local update_shown

local function load_avatar()
    loading = true
    ui.status.Text = "loading avatar..."
    ui.status.Visible = true

    task.spawn(function()
        local model = build_avatar()

        loading = false

        if destroyed then
            if model then model:Destroy() end

            return
        end

        if not model then
            ui.status.Text = "couldn't load your avatar"

            return
        end

        avatar = model
        model.Parent = ui.world

        task.wait(SETTLE_TIME)

        if destroyed then return end

        measure(model)
        update_shown()
    end)
end

update_shown = function()
    local shown = enabled and menu_visible and not destroyed

    ui.window.Visible = shown

    if not shown then
        detach()

        return
    end

    if not avatar then
        if not loading then load_avatar() end

        return
    end

    attach()
    place_camera()
end

connect(ui.close_button.Activated, function()
    if type(api.on_close) == "function" then
        pcall(api.on_close)
    end

    api.set_enabled(false)
end)

connect(ui.close_button.MouseEnter, function()
    ui.close_button.BackgroundColor3 = theme.hover
end)

connect(ui.close_button.MouseLeave, function()
    ui.close_button.BackgroundColor3 = theme.element
end)

connect(ui.drag_zone.InputBegan, function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end

    window_drag.input, window_drag.start, window_drag.origin = input, input.Position, ui.window.Position
end)

connect(ui.orbit.InputBegan, function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end

    orbit.dragging, orbit.last = input, nil
end)

connect(ui.orbit.InputChanged, function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseWheel then return end

    orbit.zoom = math.clamp(orbit.zoom * (input.Position.Z > 0 and ZOOM_STEP or 1 / ZOOM_STEP), ZOOM_MIN, ZOOM_MAX)
    place_camera()
end)

connect(user_input_service.InputChanged, function(input)
    local moving = input.UserInputType == Enum.UserInputType.MouseMovement

    if window_drag.input and (moving or input == window_drag.input) then
        local delta = input.Position - window_drag.start
        local origin = window_drag.origin

        ui.window.Position = UDim2.new(origin.X.Scale, origin.X.Offset + delta.X, origin.Y.Scale, origin.Y.Offset + delta.Y)
    end

    if orbit.dragging and (moving or input == orbit.dragging) then
        local position = Vector2.new(input.Position.X, input.Position.Y)

        if orbit.last then
            local delta = position - orbit.last

            orbit.rotation -= delta.X * ORBIT_SPEED
            orbit.elevation = math.clamp(orbit.elevation - delta.Y * ORBIT_SPEED, -ELEVATION_LIMIT, ELEVATION_LIMIT)
            place_camera()
        end

        orbit.last = position
    end
end)

connect(user_input_service.InputEnded, function(input)
    local released = input.UserInputType == Enum.UserInputType.MouseButton1

    if input == window_drag.input or (window_drag.input and released) then
        window_drag.input = nil
    end

    if input == orbit.dragging or (orbit.dragging and released) then
        orbit.dragging, orbit.last = nil, nil
    end
end)

connect(ui.overlay:GetPropertyChangedSignal("AbsoluteSize"), render)

function api.set_enabled(value)
    if destroyed then return end

    enabled = value and true or false

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
    repaint()
end

function api.refresh()
    local preview = attached and preview_api()

    if preview and type(preview.restyle) == "function" then
        pcall(preview.restyle)
    end
end

function api.destroy()
    if destroyed then return end

    destroyed = true

    detach()

    for _, connection in connections do
        pcall(function()
            connection:Disconnect()
        end)
    end

    table.clear(connections)

    pcall(function()
        gui:Destroy()
    end)

    if genv.SleepyESPViewer == api then
        genv.SleepyESPViewer = nil
    end
end

genv.SleepyESPViewer = api

return api
