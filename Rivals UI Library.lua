if LPH_OBFUSCATED == nil then
    local assert = assert
    local type = type
    local setfenv = setfenv
    LPH_ENCNUM = function(toEncrypt, ...)
        assert(type(toEncrypt) == "number" and #{...} == 0, "LPH_ENCNUM only accepts a single constant double or integer as an argument.")
        return toEncrypt
    end
    LPH_NUMENC = LPH_ENCNUM
    LPH_ENCSTR = function(toEncrypt, ...)
        assert(type(toEncrypt) == "string" and #{...} == 0, "LPH_ENCSTR only accepts a single constant string as an argument.")
        return toEncrypt
    end
    LPH_STRENC = LPH_ENCSTR
    LPH_ENCFUNC = function(toEncrypt, encKey, decKey, ...)

        assert(type(toEncrypt) == "function" and type(encKey) == "string" and #{...} == 0, "LPH_ENCFUNC accepts a constant function, constant string, and string variable as arguments.")
        return toEncrypt
    end
    LPH_FUNCENC = LPH_ENCFUNC
    LPH_JIT = function(f, ...)
        assert(type(f) == "function" and #{...} == 0, "LPH_JIT only accepts a single constant function as an argument.")
        return f
    end
    LPH_JIT_MAX = LPH_JIT
    LPH_NO_VIRTUALIZE = function(f, ...)
        assert(type(f) == "function" and #{...} == 0, "LPH_NO_VIRTUALIZE only accepts a single constant function as an argument.")
        return f
    end
    LPH_NO_UPVALUES = function(f, ...)
        assert(type(setfenv) == "function", "LPH_NO_UPVALUES can only be used on Lua versions with getfenv & setfenv")
        assert(type(f) == "function" and #{...} == 0, "LPH_NO_UPVALUES only accepts a single constant function as an argument.")
        local env = getrenv()
        return setfenv(
            LPH_NO_VIRTUALIZE(function(...)
                return func(...)
            end),
            setmetatable(
                {
                    func = f
                },
                {
                    __index = env,
                    __newindex = env
                }
            )
        )
    end
    LPH_CRASH = function(...)
        assert(#{...} == 0, "LPH_CRASH does not accept any arguments.")
        game:Shutdown()
        while true do end
    end
end;

local run_service = cloneref(game.GetService(game, "RunService"));
local replicated_storage = cloneref(game.GetService(game, "ReplicatedStorage"));
local user_input_service = cloneref(game.GetService(game, "UserInputService"));
local replicated_first = cloneref(game.GetService(game, "ReplicatedFirst"));
local tween_service = cloneref(game.GetService(game, "TweenService"));
local script_context = cloneref(game.GetService(game, "ScriptContext"));
local collection_service = cloneref(game.GetService(game, "CollectionService"));
local log_service = cloneref(game.GetService(game, "LogService"));
local game_settings = cloneref(UserSettings().GetService(UserSettings(), "UserGameSettings"));

task.spawn(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/SleepyScriptsHolderAntiSkids/storage/refs/heads/main/luraphsdk"))();
    end)
end)

Players, players = cloneref(game:GetService("Players")), cloneref(game:GetService("Players"))
LocalPlayer = cloneref(game:GetService("Players")).LocalPlayer

ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
UserInputService = cloneref(game:GetService("UserInputService"))
Workspace = cloneref(game:GetService("Workspace"))
RunService = cloneref(game:GetService("RunService"))
ProximityPromptService = cloneref(game:GetService("ProximityPromptService"))
StarterGui = cloneref(game:GetService("StarterGui"))
Lighting = cloneref(game:GetService("Lighting"))
lighting = cloneref(game:GetService("Lighting"))

mathrandom = math.random
mathabs = math.abs

local ffc_child = Workspace.FindFirstChild
local ffc_children = Workspace.GetChildren
local ffc_isa = Workspace.IsA

function child_of_class(parent, class_name, known_name)
    if not parent then return nil end

    if known_name then
        local named = ffc_child(parent, known_name)
        if named and ffc_isa(named, class_name) then return named end
    end

    local children = ffc_children(parent)

    for i = 1, #children do
        local child = children[i]
        if ffc_isa(child, class_name) then return child end
    end

    return nil
end

local function keep_identity()
    if setthreadidentity then pcall(setthreadidentity, 8) end
end

Mobile = UserInputService.PreferredInput

Camera = cloneref(Workspace.CurrentCamera)

local Mouse = setmetatable({}, {
    __index = LPH_JIT_MAX(function(self, key)
        local MouseLocation = UserInputService:GetMouseLocation()

        if key == "X" then
            return MouseLocation.X
        elseif key == "Y" then
            return MouseLocation.Y - 58
        end

        return MouseLocation
    end)
})

if not LocalPlayer.Character then
    local deadline = os.clock() + 10

    repeat task.wait() until LocalPlayer.Character or os.clock() > deadline
end

getgenv().LIB_BUILD = "depends-v1"

getgenv().library = {
    directory = "Sleepy.gg",
    folders = {
        "/fonts",
        "/configs",
        "/assets",
        "/autoload",
        "/unlockall",
        "/data",
        "/Songs"
    },
    flags = {},
    config_flags = {},
    connections = {},
    notifications = {notifs = {}},
    setup_complete = false,
    current_open;
}

getgenv().Images = {"Character.png", "Rust.mp3", "TF2.mp3", "Quake.mp3", "Dyssodia.mp3", "Bubble.mp3", "MW2019.mp3", "Sparkle.mp3", "Impact.mp3","WhiteBeam.png", "ESP.png", "World.png", "Wrench.png", "Settings.png", "Node.png", "cursor.png", "Bullet.png", "Snapline.png", "Pistol.png", "folder.png", "UZI.png", "FieldOfView2.png", "Lock.png", "Aimlock.png", "Cash.png", "Wheatt.png", "Pickkaxe.png", "unlocked.png"}

for _, path in next, library.folders do
    makefolder(library.directory .. path)
end

do
    local pending = 0
    local missing = {}

    for Index, Value in Images do
        local Location = library.directory.."/assets/"..Value

        if not isfile(Location) then
            pending += 1

            task.spawn(function()
                local url = "https://raw.githubusercontent.com/SleepyScriptsHolderAntiSkids/Images/main/"..Value
                local ok, data = pcall(game.HttpGet, game, url)

                if not ok then
                    missing[#missing + 1] = Value
                    warn("[Sleepy.gg] asset DOWNLOAD failed: " .. Value .. " -- " .. tostring(data))
                elseif type(data) ~= "string" or #data == 0 then
                    missing[#missing + 1] = Value
                    warn("[Sleepy.gg] asset EMPTY on server: " .. Value .. " -- check the name is spelled and cased exactly as it is on GitHub")
                else
                    local wrote, err = pcall(writefile, Location, data)

                    if not wrote then
                        missing[#missing + 1] = Value
                        warn("[Sleepy.gg] asset WRITE failed: " .. Location .. " -- " .. tostring(err))
                    elseif not isfile(Location) then
                        missing[#missing + 1] = Value
                        warn("[Sleepy.gg] asset MISSING after write: " .. Location)
                    end
                end

                pending -= 1
            end)
        end
    end

    while pending > 0 do task.wait() end

    if #missing > 0 then
        warn("[Sleepy.gg] " .. #missing .. " asset(s) unavailable, their icons will be blank: " .. table.concat(missing, ", "))
    end
end

getgenv().MissingAssets = getgenv().MissingAssets or {}

getgenv().GetImage = LPH_JIT_MAX(function(Name)
    local Location = library.directory.."/assets/"..Name

    if isfile(Location) then
        return getcustomasset(Location)
    end

    if not MissingAssets[Name] then
        MissingAssets[Name] = true
        warn("[Sleepy.gg] GetImage(\"" .. tostring(Name) .. "\") -- no such file in " .. library.directory .. "/assets, icon will be blank. Check spelling, capitalisation, and that it is listed in getgenv().Images")
    end
end)

getgenv().HideUI = LPH_JIT_MAX(function(Title, Timing)
    getgenv().HideScreenGUI = Instance.new("ScreenGui")
    getgenv().HideScreenGUI.Name = "\n\n\n\n\n"
    getgenv().HideScreenGUI.Parent = gethui and gethui() or cloneref(game:GetService("CoreGui"))

    local frame = Instance.new("Frame")
    frame.Name = "BlackFrame"
    frame.Size = UDim2.new(2, 0, 2, 0)
    frame.Position = UDim2.new(0, -155, 0, -155)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0
    frame.Parent = getgenv().HideScreenGUI

    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "\nhideuisleepygg"
    textLabel.Size = UDim2.new(0, 400, 0, 100)
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.RichText = true
    textLabel.Text = '<font color="rgb(0,163,224)">Sleepy.</font>gg\n' .. Title
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.BackgroundTransparency = 1
    textLabel.TextSize = 36
    textLabel.TextStrokeTransparency = 0.8
    textLabel.TextXAlignment = Enum.TextXAlignment.Center
    textLabel.TextYAlignment = Enum.TextYAlignment.Center
    textLabel.TextWrapped = true
    textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    textLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
    textLabel.Parent = getgenv().HideScreenGUI

    if Timing then
        task.spawn(LPH_NO_VIRTUALIZE(function()
            local startTime = tick()
            local endTime = startTime + Timing
            while tick() < endTime do
                local timeLeft = endTime - tick()

                textLabel.Text = string.format(
                    '<font color="rgb(0,163,224)">Sleepy.</font>gg\n%s\nplease wait : <font color="rgb(0,163,224)">%.2f</font> seconds',
                    Title, math.max(timeLeft, 0)
                )

                task.wait()
            end
        end))
    end

    return textLabel
end)

getgenv().DeleteSecretUI = LPH_JIT_MAX(function(Title)
    if getgenv().HideScreenGUI then
        getgenv().HideScreenGUI:Destroy()
        getgenv().HideScreenGUI = nil
    end
end)

getgenv().Fonts = {}; do
    local RegisterFont = LPH_JIT_MAX(function(Name, Weight, Style, Asset)
        local asset_path = library.directory.."/assets/"..Asset.Id

        if not isfile(asset_path) then
            local ok, data = pcall(game.HttpGet, game, Asset.Url)

            if not ok or not data or #data == 0 then return end

            writefile(asset_path, data)
        end

        local Data = {
            name = Name,
            faces = {
                {
                    Name = "Normal",
                    weight = Weight,
                    style = Style,
                    assetId = getcustomasset(library.directory.."/assets/"..Asset.Id),
                },
            },
        }

        writefile(library.directory.."/fonts/"..Name .. ".font", game:GetService("HttpService"):JSONEncode(Data))

        return getcustomasset(library.directory.."/fonts/"..Name .. ".font")
end)

    getgenv().Tahoma = RegisterFont("Tahoma", 400, "Normal", {
        Id = "Tahoma.ttf",
        Url = "https://github.com/SleepyScriptsHolderAntiSkids/OctoHook-UI/raw/refs/heads/main/fs-tahoma-8px%20(3).ttf",
    })

    getgenv().Pixel = RegisterFont("Pixel", 400, "Normal", {
        Id = "Pixel.ttf",
        Url = "https://github.com/SleepyScriptsHolderAntiSkids/vaderpaste.luau/raw/refs/heads/main/Pixel.ttf",
    })

    getgenv().Minecraftia = RegisterFont("Minecraftia", 400, "Normal", {
        Id = "Minecraftia.ttf",
        Url = "https://github.com/SleepyScriptsHolderAntiSkids/storage/raw/refs/heads/main/fonts/Minecraftia-Regular.ttf",
    })

    getgenv().Verdana = RegisterFont("Verdana", 400, "Normal", {
        Id = "Verdana.ttf",
        Url = "https://github.com/SleepyScriptsHolderAntiSkids/storage/raw/refs/heads/main/fonts/Verdana-Font.ttf",
    })

    Fonts["Plex"] = Font.new(Tahoma, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
    Fonts["Pixel"] = Font.new(Pixel, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
    Fonts["Minecraftia"] = Font.new(Minecraftia, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
    Fonts["Verdana"] = Font.new(Verdana, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
end
print(tostring(math.random(1,10)))
COMMUNITY_CONFIG_DATA = {

    ["[LEGIT] Magma"] = [==[{"movement_maul_slam":false,"AimbotFilledFov_Color1":{"Color":"f1d983","Transparency":0.94},"AimbotFilledFov_Color2":{"Color":"f1d983","Transparency":0.85},"AimbotFilledFov_Color3":{"Color":"f1d983","Transparency":0.94},"AimlockDropdown_":[],"AntiAim_enabled":false,"AntiFlash":true,"AntiSmoke":false,"FakePosition":false,"FakePositionPanic":false,"FakePositionWalk":false,"FilledFov_Color1":{"Color":"f1d983","Transparency":0.94},"FilledFov_Color2":{"Color":"f1d983","Transparency":0.85},"FilledFov_Color3":{"Color":"f1d983","Transparency":0.94},"HideHead_enabled":false,"InfiniteJump":false,"IsInvincible":true,"NoBobbing":false,"Noclip":false,"RapidBody_enabled":false,"SilentaimDropdown_":[],"TriggerbotDropdown_":["no delay between targets"],"VelocitySpeedEnabled":false,"aim_lock_range":100,"aimbot_closest_part":false,"aimbot_closest_position":false,"aimbot_delay_position":true,"aimbot_enabled":false,"aimbot_fov_lerp":25,"aimbot_fov_moving_rotation":false,"aimbot_fov_outline":true,"aimbot_fov_outline_color":{"Color":"f1d983","Transparency":0.84},"aimbot_fov_outline_color2":{"Color":"fbe186","Transparency":0.7},"aimbot_fov_outline_color3":{"Color":"fbe186","Transparency":0.25},"aimbot_fov_outline_thickness":2,"aimbot_fov_settings":[],"aimbot_hitmethod":"Camera","aimbot_jump_smooth":18,"aimbot_range_color":{"Color":"ffffff","Transparency":0},"aimbot_range_color2":{"Color":"fbe186","Transparency":0},"aimbot_range_color3":{"Color":"f1d983","Transparency":0},"aimbot_smoothing":12,"aimbot_visualise_filled_range":false,"aimbot_visualise_range":false,"aimbot_x_smooth":10,"aimbot_y_smooth":10,"aimlock_delay":0,"aimlock_jitter":0,"aimlock_trigger":"Aiming","aimlock_wallcheck":true,"anti_aim_enabled":false,"anti_flash_keep_sound":true,"arm_override_appearance":false,"camera_fov_amount":95,"camera_fov_enabled":true,"crosshair_bounce":0,"crosshair_bounce_speed":2.9,"crosshair_color_1":{"Color":"e3ca71","Transparency":0},"crosshair_color_2":{"Color":"dfc053","Transparency":0},"crosshair_color_3":{"Color":"ddbb43","Transparency":0},"crosshair_color_4":{"Color":"dbb634","Transparency":0},"crosshair_enabled":true,"crosshair_length":8,"crosshair_lerp":0.25,"crosshair_offset":2,"crosshair_outline":true,"crosshair_outline_color_1":{"Color":"000000","Transparency":0},"crosshair_outline_color_2":{"Color":"000000","Transparency":0},"crosshair_outline_color_3":{"Color":"000000","Transparency":0},"crosshair_outline_color_4":{"Color":"000000","Transparency":0},"crosshair_rotation":45,"crosshair_rotation_speed":0,"crosshair_settings":[],"crosshair_thickness":2,"custom_tracer_color":{"Color":"f1d983","Transparency":0},"custom_tracer_color2":{"Color":"dab329","Transparency":0},"custom_tracer_emission":1,"custom_tracer_enabled":true,"custom_tracer_fade":1,"custom_tracer_glow":5,"custom_tracer_length":4,"custom_tracer_lifetime":1,"custom_tracer_outline":false,"custom_tracer_position_lerp":0.5,"custom_tracer_selected":"drawing","custom_tracer_speed":2,"custom_tracer_width":0.2,"esp_body_color":false,"esp_bounds_type":"dynamic","esp_bounds_width_scale":100,"esp_box":false,"esp_chams":true,"esp_chams_alpha_fill":-1,"esp_chams_alpha_outline":1,"esp_chams_color":{"Color":"000000","Transparency":0},"esp_chams_color2":{"Color":"dab329","Transparency":0},"esp_chams_settings":[],"esp_distance":true,"esp_distance_color1":{"Color":"ffffff","Transparency":0},"esp_distance_color2":{"Color":"ffffff","Transparency":0},"esp_distance_color3":{"Color":"ffffff","Transparency":0},"esp_effects_aura":false,"esp_effects_particle":true,"esp_effects_particle_color1":{"Color":"f1d983","Transparency":0},"esp_effects_particle_color2":{"Color":"dab329","Transparency":0},"esp_effects_particle_color3":{"Color":"e5c248","Transparency":0},"esp_effects_particle_value":["glowing"],"esp_fill":false,"esp_flag_health_text":false,"esp_flag_staring_text":false,"esp_font":"proggy tiny","esp_healthbar":true,"esp_healthbar_color_end":{"Color":"8a6a0c","Transparency":0},"esp_healthbar_color_middle":{"Color":"e5c248","Transparency":0},"esp_healthbar_color_start":{"Color":"fbe186","Transparency":0},"esp_healthbar_health_lerp":0.05,"esp_healthbar_moving":false,"esp_healthbar_resize":false,"esp_healthbar_type":"gradient","esp_material":false,"esp_name":true,"esp_name_color1":{"Color":"ffffff","Transparency":0},"esp_name_color2":{"Color":"fbe186","Transparency":0},"esp_name_color3":{"Color":"f1d983","Transparency":0},"esp_name_font":"default","esp_name_type":"Name","esp_override_appearance":false,"esp_round_only":true,"esp_show_team":false,"esp_skeleton":true,"esp_skeleton_color1":{"Color":"ffffff","Transparency":0},"esp_skeleton_color2":{"Color":"ffffff","Transparency":0},"esp_skeleton_color3":{"Color":"ffffff","Transparency":0},"esp_skeleton_outline":false,"esp_skeleton_thickness":1,"esp_weapon":true,"esp_weapon_color1":{"Color":"ffffff","Transparency":0},"esp_weapon_color2":{"Color":"ffffff","Transparency":0},"esp_weapon_color3":{"Color":"ffffff","Transparency":0},"esp_world_distance":true,"esp_world_distance_color":{"Color":"f1d983","Transparency":0},"esp_world_font":"proggy tiny","esp_world_image":true,"esp_world_name":true,"esp_world_name_color":{"Color":"ffffff","Transparency":0},"esp_world_object_scale":75,"esp_world_whitelist":["Flashbang","Smoke Grenade","Satchel","Subspace Tripmine","Molotov","Grenade"],"exploits_always_backstab":false,"faster_reload":false,"fly_enabled":false,"fov_fill_speed":100,"fov_fill_style":"Inner Fade","fov_lerp":25,"fov_moving_rotation":true,"fov_outline":true,"fov_outline_color":{"Color":"f1d983","Transparency":0.84},"fov_outline_color2":{"Color":"fbe186","Transparency":0.7},"fov_outline_color3":{"Color":"fbe186","Transparency":0.25},"fov_outline_thickness":2,"fov_position":"position on screen","fov_rotation":0,"fov_rotation_speed":10,"full_auto_enabled":true,"game_crosshair":true,"grenade_options":["explode on impact"],"hit_effects_col_1":{"Color":"ffffff","Transparency":0},"hit_effects_col_2":{"Color":"f1d983","Transparency":0},"hit_effects_col_3":{"Color":"dab329","Transparency":0},"hit_effects_disable_marker":true,"hit_effects_disable_numbers":true,"hit_effects_enabled":true,"hit_effects_material":"ForceField","hit_effects_selected":["slashes","phantom forces"],"hit_effects_settings":["stack damage together"],"hit_effects_weld":false,"hit_notifications_enabled":false,"hit_sounds_disable":true,"hit_sounds_enabled":true,"hit_sounds_selected":"impact","hit_sounds_volume":0.9,"hitmarker_enabled":false,"indicator_ammo":true,"indicator_ammo_color":{"Color":"ffffff","Transparency":0},"indicator_ammo_divider_color":{"Color":"e3ca71","Transparency":0},"indicator_ammo_max_color":{"Color":"ffffff","Transparency":0},"indicator_ammo_style":["ammo","max ammo","reserve","\"out of ammo\" if empty"],"indicator_empty_color":{"Color":"ff5f5f","Transparency":0},"indicator_font":"proggy tiny","indicator_lerp":0.25,"indicator_manipulated":false,"indicator_manipulated_color":{"Color":"e3ca71","Transparency":0},"indicator_offset_x":0,"indicator_offset_y":25,"indicator_ragebot":false,"indicator_ragebot_status_color":{"Color":"ffffff","Transparency":0},"indicator_ragebot_style":["text","status"],"indicator_ragebot_text_color":{"Color":"e3ca71","Transparency":0},"indicator_reserve_color":{"Color":"f1d983","Transparency":0},"indicator_settings":[],"indicator_text_style":"lower","instant_aim_enabled":false,"item_remove_vignette":true,"item_status_enabled":true,"item_status_override":"Prime","manipulation_enabled":false,"movement_double_jump":false,"movement_slideboost":true,"movement_slideboost_value":1.1,"no_fire_sound":false,"no_muzzle_flash":false,"no_recoil_enabled":false,"no_spread_enabled":false,"quickequip":false,"ragebot_enabled":false,"shoot_sound_change":true,"shoot_sound_change_value":"bow","shoot_sound_speed":1,"shoot_sound_start":0,"shoot_sound_volume":0.3,"silent_aim_enabled":true,"silent_aim_range":110,"silent_aim_range_color":{"Color":"ffffff","Transparency":0},"silent_aim_range_color2":{"Color":"fbe186","Transparency":0},"silent_aim_range_color3":{"Color":"f1d983","Transparency":0},"silent_aim_target_mode":"FOV - Closest","silent_aim_visualise_filled_range":true,"silent_aim_visualise_range":true,"silent_closest_part":true,"silent_hitchance":35,"silent_visualize":true,"silent_wallbang":false,"stretch_enabled":false,"target_highlight":false,"target_highlight_fill":{"Color":"dab329","Transparency":0.6},"target_highlight_outline":{"Color":"f1d983","Transparency":0},"target_highlight_type":"AlwaysOnTop","target_tracer":false,"target_tracer_customization":{"Color":"dab329","Transparency":0},"target_ui_enabled":true,"target_ui_item_scale":170,"target_ui_position_x":50,"target_ui_position_y":72,"target_ui_scale":150,"targeting_ignore_protected_settings":["blocked by riot shield","katana deflecting"],"targeting_limitdistance":false,"targeting_part":"Head","third_person_enabled":false,"trigger_distance":250,"trigger_enabled":true,"trigger_forget_time":1.5,"trigger_part_blacklist":[],"trigger_reaction":25,"trigger_reaction_offset":5,"trigger_scoped":["Sniper","Crossbow"],"trigger_shoot_delay":0,"viewmodel_chams":true,"viewmodel_chams_alpha_fill":-0.6,"viewmodel_chams_alpha_outline":1,"viewmodel_chams_color":{"Color":"000000","Transparency":0},"viewmodel_chams_color2":{"Color":"ffe7a3","Transparency":0},"viewmodel_chams_settings":["through walls"],"viewmodel_frames_override":false,"viewmodel_offset":true,"viewmodel_offset_x":0,"viewmodel_offset_y":0,"viewmodel_offset_z":-0.5,"viewmodel_options":["sway","bobbing","muzzle flash","idle animation","jump animation","slide animation","sprint animation","shoot animation"],"viewmodel_override_appearance":false,"viewmodel_recoil":0,"viewmodel_scale_enabled":false,"viewmodel_wire_enabled":false,"voidspam_enabled":false,"wallbang_method":"Classic V1","world_ambience_enabled":false,"world_ambience_type":"Rain","world_ambience_volume":35,"world_atm_decay":{"Color":"7a3c12","Transparency":0},"world_atm_density":0.35,"world_atm_enabled":true,"world_atm_glare":2.5,"world_atm_haze":1.5,"world_atm_offset":0.4,"world_atm_tint":{"Color":"ffb35c","Transparency":0},"world_bloom_enabled":true,"world_bloom_intensity":1.3,"world_bloom_size":40,"world_bloom_threshold":0.9,"world_blur_enabled":false,"world_cc_brightness":-0.05,"world_cc_contrast":0.1,"world_cc_enabled":true,"world_cc_saturation":0.15,"world_cc_tint":{"Color":"ffe9a8","Transparency":0},"world_dof_enabled":false,"world_env_enabled":false,"world_ltg_ambient":true,"world_ltg_ambient_color":{"Color":"ffffff","Transparency":0},"world_ltg_brightness":true,"world_ltg_brightness_val":1.7,"world_ltg_clock":true,"world_ltg_clock_val":17.6,"world_ltg_colorshift_bottom":true,"world_ltg_colorshift_bottom_color":{"Color":"ffffff","Transparency":0},"world_ltg_colorshift_top":true,"world_ltg_colorshift_top_color":{"Color":"f1d983","Transparency":0},"world_ltg_exposure":true,"world_ltg_exposure_val":-1.1,"world_ltg_fog_color_enabled":false,"world_ltg_fog_end":false,"world_ltg_fog_start":false,"world_ltg_shadows":true,"world_marker_enabled":false,"world_shadow_soft_enabled":true,"world_shadow_soft_val":25,"world_sky_autorotate":false,"world_sky_celestial":false,"world_skybox_disable":[],"world_skybox_enabled":true,"world_skybox_mode":"SunSet","world_sunrays_enabled":true,"world_sunrays_intensity":0.2,"world_sunrays_spread":1,"world_weather_color":{"Color":"ffcf4a","Transparency":0},"world_weather_color_end":{"Color":"5a2a0a","Transparency":0},"world_weather_color_mid":{"Color":"ff8a1f","Transparency":0},"world_weather_density":35,"world_weather_enabled":true,"world_weather_lifetime":100,"world_weather_opacity":80,"world_weather_size":100,"world_weather_speed":100,"world_weather_timescale":1,"world_weather_type":"Ash"}]==],

    ["[LEGIT] Sakura"] = [==[{"movement_maul_slam":false,"AimbotFilledFov_Color1":{"Color":"fccbfa","Transparency":0.94},"AimbotFilledFov_Color2":{"Color":"fccbfa","Transparency":0.85},"AimbotFilledFov_Color3":{"Color":"fccbfa","Transparency":0.94},"AimlockDropdown_":[],"AntiAim_enabled":false,"AntiFlash":true,"AntiSmoke":false,"FakePosition":false,"FakePositionPanic":false,"FakePositionWalk":false,"FilledFov_Color1":{"Color":"fccbfa","Transparency":0.94},"FilledFov_Color2":{"Color":"fccbfa","Transparency":0.85},"FilledFov_Color3":{"Color":"fccbfa","Transparency":0.94},"HideHead_enabled":false,"InfiniteJump":false,"IsInvincible":true,"NoBobbing":false,"Noclip":false,"RapidBody_enabled":false,"SilentaimDropdown_":[],"TriggerbotDropdown_":["no delay between targets"],"VelocitySpeedEnabled":false,"aim_lock_range":100,"aimbot_closest_part":false,"aimbot_closest_position":false,"aimbot_delay_position":true,"aimbot_enabled":true,"aimbot_fov_lerp":25,"aimbot_fov_moving_rotation":false,"aimbot_fov_outline":true,"aimbot_fov_outline_color":{"Color":"fccbfa","Transparency":0.84},"aimbot_fov_outline_color2":{"Color":"fde3fc","Transparency":0.7},"aimbot_fov_outline_color3":{"Color":"fde3fc","Transparency":0.25},"aimbot_fov_outline_thickness":2,"aimbot_fov_settings":[],"aimbot_hitmethod":"Camera","aimbot_jump_smooth":18,"aimbot_range_color":{"Color":"ffffff","Transparency":0},"aimbot_range_color2":{"Color":"fde3fc","Transparency":0},"aimbot_range_color3":{"Color":"fccbfa","Transparency":0},"aimbot_smoothing":12,"aimbot_visualise_filled_range":true,"aimbot_visualise_range":true,"aimbot_x_smooth":10,"aimbot_y_smooth":10,"aimlock_delay":0,"aimlock_jitter":0,"aimlock_trigger":"Aiming","aimlock_wallcheck":true,"anti_aim_enabled":false,"anti_flash_keep_sound":true,"arm_override_appearance":false,"camera_fov_amount":95,"camera_fov_enabled":true,"crosshair_bounce":0,"crosshair_bounce_speed":2.9,"crosshair_color_1":{"Color":"fccbfa","Transparency":0},"crosshair_color_2":{"Color":"f7b1f4","Transparency":0},"crosshair_color_3":{"Color":"f5a3f1","Transparency":0},"crosshair_color_4":{"Color":"f296ee","Transparency":0},"crosshair_enabled":true,"crosshair_length":8,"crosshair_lerp":0.25,"crosshair_offset":2,"crosshair_outline":true,"crosshair_outline_color_1":{"Color":"000000","Transparency":0},"crosshair_outline_color_2":{"Color":"000000","Transparency":0},"crosshair_outline_color_3":{"Color":"000000","Transparency":0},"crosshair_outline_color_4":{"Color":"000000","Transparency":0},"crosshair_rotation":45,"crosshair_rotation_speed":0,"crosshair_settings":[],"crosshair_thickness":2,"custom_tracer_color":{"Color":"fccbfa","Transparency":0},"custom_tracer_color2":{"Color":"f296ee","Transparency":0},"custom_tracer_emission":1,"custom_tracer_enabled":true,"custom_tracer_fade":1,"custom_tracer_glow":4,"custom_tracer_length":4,"custom_tracer_lifetime":1,"custom_tracer_outline":false,"custom_tracer_position_lerp":0.5,"custom_tracer_selected":"lightning","custom_tracer_speed":2,"custom_tracer_width":0.2,"esp_body_color":false,"esp_bounds_type":"dynamic","esp_bounds_width_scale":100,"esp_box":false,"esp_chams":true,"esp_chams_alpha_fill":-1,"esp_chams_alpha_outline":1,"esp_chams_color":{"Color":"000000","Transparency":0},"esp_chams_color2":{"Color":"f296ee","Transparency":0},"esp_chams_settings":[],"esp_distance":true,"esp_distance_color1":{"Color":"ffffff","Transparency":0},"esp_distance_color2":{"Color":"ffffff","Transparency":0},"esp_distance_color3":{"Color":"ffffff","Transparency":0},"esp_effects_aura":false,"esp_effects_particle":true,"esp_effects_particle_color1":{"Color":"fccbfa","Transparency":0},"esp_effects_particle_color2":{"Color":"f296ee","Transparency":0},"esp_effects_particle_color3":{"Color":"bc75ba","Transparency":0},"esp_effects_particle_value":["glowing"],"esp_fill":false,"esp_flag_health_text":false,"esp_flag_staring_text":false,"esp_font":"proggy tiny","esp_healthbar":true,"esp_healthbar_color_end":{"Color":"9d539b","Transparency":0},"esp_healthbar_color_middle":{"Color":"bc75ba","Transparency":0},"esp_healthbar_color_start":{"Color":"fde3fc","Transparency":0},"esp_healthbar_health_lerp":0.05,"esp_healthbar_moving":false,"esp_healthbar_resize":false,"esp_healthbar_type":"gradient","esp_material":false,"esp_name":true,"esp_name_color1":{"Color":"ffffff","Transparency":0},"esp_name_color2":{"Color":"fde3fc","Transparency":0},"esp_name_color3":{"Color":"fccbfa","Transparency":0},"esp_name_font":"default","esp_name_type":"Name","esp_override_appearance":false,"esp_round_only":true,"esp_show_team":false,"esp_skeleton":true,"esp_skeleton_color1":{"Color":"ffffff","Transparency":0},"esp_skeleton_color2":{"Color":"ffffff","Transparency":0},"esp_skeleton_color3":{"Color":"ffffff","Transparency":0},"esp_skeleton_outline":false,"esp_skeleton_thickness":1,"esp_weapon":true,"esp_weapon_color1":{"Color":"ffffff","Transparency":0},"esp_weapon_color2":{"Color":"ffffff","Transparency":0},"esp_weapon_color3":{"Color":"ffffff","Transparency":0},"esp_world_distance":true,"esp_world_distance_color":{"Color":"fccbfa","Transparency":0},"esp_world_font":"proggy tiny","esp_world_image":true,"esp_world_name":true,"esp_world_name_color":{"Color":"ffffff","Transparency":0},"esp_world_object_scale":75,"esp_world_whitelist":["Flashbang","Smoke Grenade","Satchel","Subspace Tripmine","Molotov","Grenade"],"exploits_always_backstab":false,"faster_reload":false,"fly_enabled":false,"fov_fill_speed":100,"fov_fill_style":"Inner Fade","fov_lerp":25,"fov_moving_rotation":true,"fov_outline":true,"fov_outline_color":{"Color":"fccbfa","Transparency":0.84},"fov_outline_color2":{"Color":"fde3fc","Transparency":0.7},"fov_outline_color3":{"Color":"fde3fc","Transparency":0.25},"fov_outline_thickness":2,"fov_position":"position on screen","fov_rotation":0,"fov_rotation_speed":10,"full_auto_enabled":true,"game_crosshair":true,"grenade_options":[],"hit_effects_col_1":{"Color":"ffffff","Transparency":0},"hit_effects_col_2":{"Color":"fccbfa","Transparency":0},"hit_effects_col_3":{"Color":"f296ee","Transparency":0},"hit_effects_disable_marker":true,"hit_effects_disable_numbers":true,"hit_effects_enabled":true,"hit_effects_material":"ForceField","hit_effects_selected":["Electricity","phantom forces"],"hit_effects_settings":["stack damage together"],"hit_effects_weld":false,"hit_notifications_enabled":false,"hit_sounds_disable":true,"hit_sounds_enabled":true,"hit_sounds_selected":"sparkle","hit_sounds_volume":0.9,"hitmarker_enabled":false,"indicator_ammo":true,"indicator_ammo_color":{"Color":"ffffff","Transparency":0},"indicator_ammo_divider_color":{"Color":"f296ee","Transparency":0},"indicator_ammo_max_color":{"Color":"ffffff","Transparency":0},"indicator_ammo_style":["ammo","max ammo","reserve","\"out of ammo\" if empty"],"indicator_empty_color":{"Color":"ff5f5f","Transparency":0},"indicator_font":"proggy tiny","indicator_lerp":0.25,"indicator_manipulated":false,"indicator_manipulated_color":{"Color":"f296ee","Transparency":0},"indicator_offset_x":0,"indicator_offset_y":25,"indicator_ragebot":false,"indicator_ragebot_status_color":{"Color":"ffffff","Transparency":0},"indicator_ragebot_style":["text","status"],"indicator_ragebot_text_color":{"Color":"f296ee","Transparency":0},"indicator_reserve_color":{"Color":"fccbfa","Transparency":0},"indicator_settings":[],"indicator_text_style":"lower","instant_aim_enabled":false,"item_remove_vignette":true,"item_status_enabled":true,"item_status_override":"Prime","manipulation_enabled":false,"movement_double_jump":false,"movement_slideboost":true,"movement_slideboost_value":1.1,"no_fire_sound":false,"no_muzzle_flash":false,"no_recoil_enabled":false,"no_spread_enabled":false,"quickequip":false,"ragebot_enabled":false,"shoot_sound_change":true,"shoot_sound_change_value":"crossbow","shoot_sound_speed":1,"shoot_sound_start":0,"shoot_sound_volume":0.6,"silent_aim_enabled":true,"silent_aim_range":45,"silent_aim_range_color":{"Color":"ffffff","Transparency":0},"silent_aim_range_color2":{"Color":"fde3fc","Transparency":0},"silent_aim_range_color3":{"Color":"fccbfa","Transparency":0},"silent_aim_target_mode":"FOV - Closest","silent_aim_visualise_filled_range":true,"silent_aim_visualise_range":true,"silent_closest_part":true,"silent_hitchance":100,"silent_visualize":true,"silent_wallbang":false,"stretch_enabled":false,"target_highlight":false,"target_highlight_fill":{"Color":"f296ee","Transparency":0.6},"target_highlight_outline":{"Color":"fccbfa","Transparency":0},"target_highlight_type":"AlwaysOnTop","target_tracer":false,"target_tracer_customization":{"Color":"f296ee","Transparency":0},"target_ui_enabled":true,"target_ui_item_scale":170,"target_ui_position_x":50,"target_ui_position_y":72,"target_ui_scale":150,"targeting_ignore_protected_settings":["katana deflecting"],"targeting_limitdistance":false,"targeting_part":"Head","third_person_enabled":false,"trigger_distance":250,"trigger_enabled":true,"trigger_forget_time":1.5,"trigger_part_blacklist":[],"trigger_reaction":25,"trigger_reaction_offset":5,"trigger_scoped":["Sniper","Crossbow"],"trigger_shoot_delay":0,"viewmodel_chams":true,"viewmodel_chams_alpha_fill":-1.2,"viewmodel_chams_alpha_outline":1,"viewmodel_chams_color":{"Color":"000000","Transparency":0},"viewmodel_chams_color2":{"Color":"ffd6fb","Transparency":0},"viewmodel_chams_settings":["through walls"],"viewmodel_frames_override":false,"viewmodel_offset":true,"viewmodel_offset_x":0,"viewmodel_offset_y":0,"viewmodel_offset_z":-0.5,"viewmodel_options":["sway","bobbing","muzzle flash","idle animation","jump animation","slide animation","sprint animation","shoot animation"],"viewmodel_override_appearance":false,"viewmodel_recoil":0,"viewmodel_scale_enabled":false,"viewmodel_wire_enabled":false,"voidspam_enabled":false,"wallbang_method":"Classic V1","world_ambience_enabled":true,"world_ambience_type":"Rain","world_ambience_volume":35,"world_atm_decay":{"Color":"b45aa8","Transparency":0},"world_atm_density":0.4,"world_atm_enabled":true,"world_atm_glare":3,"world_atm_haze":2.5,"world_atm_offset":0.4,"world_atm_tint":{"Color":"ffc8fd","Transparency":0},"world_bloom_enabled":true,"world_bloom_intensity":1.3,"world_bloom_size":40,"world_bloom_threshold":0.9,"world_blur_enabled":false,"world_cc_brightness":-0.05,"world_cc_contrast":0.1,"world_cc_enabled":true,"world_cc_saturation":0.15,"world_cc_tint":{"Color":"ffe3f7","Transparency":0},"world_dof_enabled":false,"world_env_enabled":false,"world_ltg_ambient":true,"world_ltg_ambient_color":{"Color":"ffffff","Transparency":0},"world_ltg_brightness":true,"world_ltg_brightness_val":1.7,"world_ltg_clock":true,"world_ltg_clock_val":17.2,"world_ltg_colorshift_bottom":true,"world_ltg_colorshift_bottom_color":{"Color":"ffffff","Transparency":0},"world_ltg_colorshift_top":true,"world_ltg_colorshift_top_color":{"Color":"fccbfa","Transparency":0},"world_ltg_exposure":true,"world_ltg_exposure_val":-1.1,"world_ltg_fog_color_enabled":false,"world_ltg_fog_end":false,"world_ltg_fog_start":false,"world_ltg_shadows":true,"world_marker_enabled":false,"world_shadow_soft_enabled":true,"world_shadow_soft_val":25,"world_sky_autorotate":false,"world_sky_celestial":false,"world_skybox_disable":[],"world_skybox_enabled":true,"world_skybox_mode":"Pink Clouds","world_sunrays_enabled":false,"world_sunrays_intensity":0.2,"world_sunrays_spread":1,"world_weather_color":{"Color":"ffd1f2","Transparency":0},"world_weather_color_end":{"Color":"c85ab8","Transparency":0},"world_weather_color_mid":{"Color":"f296ee","Transparency":0},"world_weather_density":60,"world_weather_enabled":true,"world_weather_lifetime":100,"world_weather_opacity":80,"world_weather_size":100,"world_weather_speed":100,"world_weather_timescale":1,"world_weather_type":"Cherry Blossom"}]==],

    ["[RAGE; HVH] Curger's Config"] = [==[{"movement_maul_slam":false,"ACO":false,"AimLock_Key":{"active":false,"key":"Enum.UserInputType.MouseButton2","mode":"Hold"},"AimbotFilledFov_Color1":{"Color":"ffffff","Transparency":0.75},"AimbotFilledFov_Color2":{"Color":"000000","Transparency":0},"AimbotFilledFov_Color3":{"Color":"4669af","Transparency":0},"AimlockDropdown_":[],"AntiAim_enabled":true,"AntiFlash":false,"AntiSmoke":false,"FakePosition":true,"FakePositionPanic":false,"FakePositionWalk":true,"FakePositionY":7,"FilledFov_Color1":{"Color":"7778ff","Transparency":0.75},"FilledFov_Color2":{"Color":"000000","Transparency":0},"FilledFov_Color3":{"Color":"4669af","Transparency":0},"FlyKeybind":{"active":false,"key":"Enum.KeyCode.F2","mode":"Toggle"},"HideHead_enabled":true,"InfiniteJump":false,"IsInvincible":false,"Melee_auto_load":"Chainsaw","NoBobbing":true,"Noclip":false,"PanicPositionXMax":7,"PanicPositionXMin":7,"RapidBody_enabled":true,"Secondary_auto_load":"Spray","SilentaimDropdown_":[],"TriggerbotDropdown_":[],"Utility_auto_load":"Grenade","VelocitySpeedEnabled":false,"VelocitySpeedValue":43,"aco_ammo":true,"aco_health":true,"aco_infinite_range":false,"aco_interval":200,"aco_only_needed":true,"aco_range":60,"aim_lock_range":12,"aimbot_enabled":false,"aimbot_fov_lerp":100,"aimbot_fov_moving_rotation":false,"aimbot_fov_outline":false,"aimbot_fov_outline_color":{"Color":"000000","Transparency":0},"aimbot_fov_outline_color2":{"Color":"000000","Transparency":0},"aimbot_fov_outline_color3":{"Color":"000000","Transparency":0},"aimbot_fov_outline_thickness":2,"aimbot_fov_rotation":0,"aimbot_fov_rotation_speed":10,"aimbot_fov_settings":[],"aimbot_hitmethod":"Camera","aimbot_range_color":{"Color":"ffffff","Transparency":0.75},"aimbot_visualise_filled_range":false,"aimbot_visualise_range":false,"aimlock_delay":0,"aimlock_jitter":0,"aimlock_jitter_rate":60,"aimlock_wallcheck":false,"anim_custom_id":"","anim_enabled":true,"anim_end":100,"anim_key":{"active":true,"key":"NONE","mode":"Always"},"anim_preset":"small / hide","anim_speed":2,"anim_start":0,"anti_aim_enabled":true,"anti_aim_speed":100,"anti_flash_keep_sound":true,"antiaim_key":{"active":true,"key":"NONE","mode":"Always"},"antiaim_speed":100,"arm_override_appearance":false,"auto_ban_first":"Riot Shield","auto_ban_first_delay":1,"auto_ban_map_delay":1,"auto_ban_random_map":false,"auto_ban_second":"Katana","auto_ban_second_delay":2,"auto_ban_weapons":false,"auto_queue_enabled":false,"auto_vote_enabled":false,"auto_vote_map":"Arena","autoload_enabled_auto_slot":false,"camera_fov_amount":90,"camera_fov_enabled":false,"chat_spam_delay":5,"chat_spam_enabled":false,"chat_spam_mode":"custom","chat_spam_list":["sleepy.gg"],"chat_spam_trigger":"always","crosshair_bounce":5,"crosshair_bounce_speed":2.9,"crosshair_color_1":{"Color":"c9caff","Transparency":0},"crosshair_color_2":{"Color":"a9aaff","Transparency":0},"crosshair_color_3":{"Color":"8f90ff","Transparency":0},"crosshair_color_4":{"Color":"7778ff","Transparency":0},"crosshair_enabled":true,"crosshair_length":13,"crosshair_lerp":0.25,"crosshair_offset":5,"crosshair_outline":true,"crosshair_outline_color_1":{"Color":"000000","Transparency":0},"crosshair_outline_color_2":{"Color":"000000","Transparency":0},"crosshair_outline_color_3":{"Color":"000000","Transparency":0},"crosshair_outline_color_4":{"Color":"000000","Transparency":0},"crosshair_rotation":0,"crosshair_rotation_speed":0.2,"crosshair_settings":["position on target"],"crosshair_thickness":2,"custom_pitch_angle":90,"custom_tracer_color":{"Color":"b3b4ff","Transparency":0},"custom_tracer_color2":{"Color":"7778ff","Transparency":0},"custom_tracer_emission":1,"custom_tracer_enabled":true,"custom_tracer_fade":1,"custom_tracer_glow":4,"custom_tracer_length":4,"custom_tracer_lifetime":1,"custom_tracer_outline":false,"custom_tracer_position_lerp":0.5,"custom_tracer_selected":"lightning","custom_tracer_speed":2,"custom_tracer_width":0.2,"custom_yaw_angle":180,"death_sound_enabled":false,"death_sound_id":"","death_sound_pitch":100,"death_sound_preset":"Sparkle","death_sound_url":"","death_sound_volume":50,"device_spoofer_enabled":false,"esp_body_color":false,"esp_bounds_type":"dynamic","esp_bounds_width_scale":100,"esp_box":false,"esp_chams":true,"esp_chams_alpha_fill":-1,"esp_chams_alpha_outline":1,"esp_chams_color":{"Color":"000000","Transparency":0},"esp_chams_color2":{"Color":"7778ff","Transparency":0},"esp_chams_settings":["through walls"],"esp_distance":true,"esp_distance_color1":{"Color":"ffffff","Transparency":0},"esp_distance_color2":{"Color":"ffffff","Transparency":0},"esp_distance_color3":{"Color":"ffffff","Transparency":0},"esp_effects_aura":false,"esp_effects_particle":true,"esp_effects_particle_color1":{"Color":"b3b4ff","Transparency":0},"esp_effects_particle_color2":{"Color":"7778ff","Transparency":0},"esp_effects_particle_color3":{"Color":"5a5bdc","Transparency":0},"esp_effects_particle_value":["glowing"],"esp_fill":false,"esp_flag_health_text":false,"esp_flag_staring_text":true,"esp_font":"proggy tiny","esp_healthbar":true,"esp_healthbar_color_end":{"Color":"3e3fb8","Transparency":0},"esp_healthbar_color_middle":{"Color":"5a5bdc","Transparency":0},"esp_healthbar_color_start":{"Color":"d6d6ff","Transparency":0},"esp_healthbar_health_lerp":0.05,"esp_healthbar_moving":false,"esp_healthbar_resize":false,"esp_healthbar_type":"gradient","esp_material":false,"esp_name":true,"esp_name_color1":{"Color":"ffffff","Transparency":0},"esp_name_color2":{"Color":"d6d6ff","Transparency":0},"esp_name_color3":{"Color":"b3b4ff","Transparency":0},"esp_name_font":"default","esp_name_type":"Name","esp_override_appearance":false,"esp_round_only":true,"esp_show_team":false,"esp_skeleton":true,"esp_skeleton_color1":{"Color":"ffffff","Transparency":0},"esp_skeleton_color2":{"Color":"ffffff","Transparency":0},"esp_skeleton_color3":{"Color":"ffffff","Transparency":0},"esp_skeleton_outline":false,"esp_skeleton_thickness":1,"esp_weapon":true,"esp_weapon_color1":{"Color":"ffffff","Transparency":0},"esp_weapon_color2":{"Color":"ffffff","Transparency":0},"esp_weapon_color3":{"Color":"ffffff","Transparency":0},"esp_world_distance":true,"esp_world_distance_color":{"Color":"b3b4ff","Transparency":0},"esp_world_font":"proggy tiny","esp_world_image":true,"esp_world_name":true,"esp_world_name_color":{"Color":"ffffff","Transparency":0},"esp_world_object_scale":75,"esp_world_whitelist":["Flashbang","Smoke Grenade","Satchel","Subspace Tripmine","Molotov","Grenade"],"exploits_always_backstab":true,"fakepos_key":{"active":false,"key":"NONE","mode":"Always"},"faster_reload":true,"firerate_multiplier":10,"fly_enabled":false,"flyvalue":50,"fov_fill_speed":100,"fov_fill_style":"Inner Fade","fov_lerp":100,"fov_moving_rotation":false,"fov_outline":false,"fov_outline_color":{"Color":"000000","Transparency":0},"fov_outline_color2":{"Color":"000000","Transparency":0},"fov_outline_color3":{"Color":"000000","Transparency":0},"fov_outline_thickness":2,"fov_position":"position on screen","fov_rotation":0,"fov_rotation_speed":10,"full_auto_enabled":false,"game_crosshair":true,"hit_effects_col_1":{"Color":"ffffff","Transparency":0},"hit_effects_col_2":{"Color":"b3b4ff","Transparency":0},"hit_effects_col_3":{"Color":"7778ff","Transparency":0},"hit_effects_disable_marker":true,"hit_effects_disable_numbers":true,"hit_effects_enabled":true,"hit_effects_material":"ForceField","hit_effects_selected":["Electricity","phantom forces"],"hit_effects_settings":["stack damage together"],"hit_effects_weld":false,"hit_notifications_enabled":false,"hit_notify_list":["hit {NAME} for {DMG} in the {PART}"],"hit_notify_duration":1.3,"hit_sounds_disable":true,"hit_sounds_enabled":true,"hit_sounds_selected":"neverlose","hit_sounds_volume":0.9,"hitmarker_color":{"Color":"ffffff","Transparency":0},"hitmarker_duration":200,"hitmarker_enabled":false,"hitmarker_fade":true,"hitmarker_gap":1,"hitmarker_length":22,"hitmarker_style":"Cross","hitmarker_thickness":1,"indicator_ammo":true,"indicator_ammo_color":{"Color":"ffffff","Transparency":0},"indicator_ammo_divider_color":{"Color":"9a9bff","Transparency":0},"indicator_ammo_max_color":{"Color":"ffffff","Transparency":0},"indicator_ammo_style":["ammo","max ammo","reserve","\"out of ammo\" if empty"],"indicator_empty_color":{"Color":"ff5f5f","Transparency":0},"indicator_font":"proggy tiny","indicator_lerp":0.25,"indicator_manipulated":true,"indicator_manipulated_color":{"Color":"9a9bff","Transparency":0},"indicator_offset_x":0,"indicator_offset_y":25,"indicator_ragebot":true,"indicator_ragebot_status_color":{"Color":"ffffff","Transparency":0},"indicator_ragebot_style":["text","status"],"indicator_ragebot_text_color":{"Color":"9a9bff","Transparency":0},"indicator_reserve_color":{"Color":"b3b4ff","Transparency":0},"indicator_settings":[],"indicator_text_style":"lower","instant_aim_enabled":true,"item_remove_vignette":true,"item_status_enabled":true,"item_status_override":"Prime","kill_sound_enabled":false,"kill_sound_id":"","kill_sound_pitch":100,"kill_sound_preset":"Sparkle","kill_sound_url":"","kill_sound_volume":50,"leaderboard_Current Highest Win Streak":false,"leaderboard_Highest ELO":false,"leaderboard_Highest Level":false,"leaderboard_Most Eliminations":false,"leaderboard_Most Wins":false,"leaderboard_value":"999999","matchmaking_mode":"1v1","mod_detector":true,"mod_detector_evade":false,"mod_detector_leave":true,"movement_double_jump":false,"movement_double_jump_height":1,"movement_slideboost":false,"movement_slideboost_value":1.5,"no_bullet_tracer":true,"no_fire_sound":true,"no_muzzle_flash":true,"no_recoil_enabled":true,"no_spread_enabled":true,"noclip_key":{"active":false,"key":"NONE","mode":"Always"},"offsetX":0,"offsetY":-7,"offsetZ":-5,"pitch_type":"None","primary_auto_load":"Sniper","profile_displayname_enabled":false,"profile_displayname_value":"fog","profile_elo_enabled":false,"profile_elo_value":"67000","profile_level_enabled":false,"profile_level_value":"0","profile_streak_enabled":false,"profile_streak_value":"333","profile_username_enabled":false,"profile_username_value":"im feeling dizzy","quickequip":true,"ragebot_enabled":true,"ragebot_key":{"active":false,"key":"NONE","mode":"Always"},"ragebot_method":"Advanced","ragebot_mode":"gun","ragebot_settings":["swap weapons when empty"],"ragebot_weapon":"primary","random_offset_max":8,"random_offset_min":-8,"reload_sound_enabled":false,"reload_sound_id":"","reload_sound_pitch":100,"reload_sound_preset":"Sparkle","reload_sound_url":"","reload_sound_volume":50,"shoot_sound_change":true,"shoot_sound_change_value":"plasma pistol","shoot_sound_speed":1,"shoot_sound_start":0,"shoot_sound_volume":0.4,"silent_aim_enabled":true,"silent_aim_range":100,"silent_aim_range_color":{"Color":"ffffff","Transparency":0.75},"silent_aim_target_mode":"FOV - Closest","silent_aim_visualise_filled_range":false,"silent_aim_visualise_range":false,"silent_hitchance":100,"silent_key":{"active":false,"key":"NONE","mode":"Always"},"silent_wallbang":true,"spoof_device_type":"Controller","stretch_amount":71,"stretch_enabled":false,"target_highlight":true,"target_highlight_fill":{"Color":"7778ff","Transparency":0.6},"target_highlight_outline":{"Color":"b3b4ff","Transparency":0},"target_highlight_type":"AlwaysOnTop","target_method_ragebot":"Closest","target_tracer":true,"target_tracer_customization":{"Color":"7778ff","Transparency":0},"target_ui_enabled":true,"target_ui_item_scale":170,"target_ui_position_x":50,"target_ui_position_y":72,"target_ui_scale":150,"targeting_ignore_protected_settings":[],"targeting_limitdistance":false,"targeting_part":"Head","third_person_enabled":false,"third_person_key":{"active":false,"key":"NONE","mode":"Always"},"trigger_distance":500,"trigger_enabled":false,"trigger_forget_time":1,"trigger_key":{"active":false,"key":"NONE","mode":"Always"},"trigger_reaction":40,"trigger_scoped":["Crossbow","Sniper"],"unlock_all_enabled":false,"velocity_key":{"active":false,"key":"NONE","mode":"Always"},"viewmodel_chams":true,"viewmodel_chams_alpha_fill":-0.8,"viewmodel_chams_alpha_outline":1,"viewmodel_chams_color":{"Color":"000000","Transparency":0},"viewmodel_chams_color2":{"Color":"c9caff","Transparency":0},"viewmodel_chams_settings":["through walls"],"viewmodel_disable_textures":false,"viewmodel_frames_override":false,"viewmodel_glow_color":{"Color":"ffffff","Transparency":0},"viewmodel_glow_intensity":28,"viewmodel_offset":true,"viewmodel_offset_x":0,"viewmodel_offset_y":0,"viewmodel_offset_z":-0.5,"viewmodel_options":["sway","bobbing","muzzle flash","idle animation","jump animation","slide animation","sprint animation","shoot animation","tilt","aiming animation","equip animation"],"viewmodel_override_appearance":false,"viewmodel_recoil":0,"viewmodel_scale":68,"viewmodel_scale_enabled":false,"viewmodel_wire_color":{"Color":"ffffff","Transparency":0},"viewmodel_wire_enabled":false,"viewmodel_wire_hide_base":true,"viewmodel_wire_mode":"Lines + Glow","voidspam_enabled":false,"wallbang_method":"Classic V1","world_ambience_enabled":false,"world_ambience_type":"Rain","world_ambience_volume":35,"world_atm_decay":{"Color":"3a2a7a","Transparency":0},"world_atm_density":0.3,"world_atm_enabled":true,"world_atm_glare":1,"world_atm_haze":1,"world_atm_offset":0.4,"world_atm_tint":{"Color":"9a8cff","Transparency":0},"world_bloom_enabled":true,"world_bloom_intensity":0.8,"world_bloom_size":40,"world_bloom_threshold":0.9,"world_blur_enabled":false,"world_blur_size":5,"world_cc_brightness":-0.05,"world_cc_contrast":0.1,"world_cc_enabled":true,"world_cc_saturation":0.15,"world_cc_tint":{"Color":"e6e3ff","Transparency":0},"world_dof_enabled":false,"world_dof_far":0.25,"world_dof_focus":116,"world_dof_near":0.14,"world_dof_radius":20,"world_env_diffuse":0.8,"world_env_enabled":false,"world_env_specular":1.1,"world_ltg_ambient":true,"world_ltg_ambient_color":{"Color":"ffffff","Transparency":0},"world_ltg_brightness":true,"world_ltg_brightness_val":1.7,"world_ltg_clock":true,"world_ltg_clock_val":0,"world_ltg_colorshift_bottom":true,"world_ltg_colorshift_bottom_color":{"Color":"ffffff","Transparency":0},"world_ltg_colorshift_top":true,"world_ltg_colorshift_top_color":{"Color":"b3b4ff","Transparency":0},"world_ltg_exposure":true,"world_ltg_exposure_val":-0.6,"world_ltg_fog_color":{"Color":"bfbfbf","Transparency":0},"world_ltg_fog_color_enabled":false,"world_ltg_fog_end":false,"world_ltg_fog_end_val":3643,"world_ltg_fog_start":false,"world_ltg_fog_start_val":0,"world_ltg_shadows":true,"world_marker_color":{"Color":"ffffff","Transparency":0},"world_marker_duration":0.6,"world_marker_enabled":false,"world_marker_growth":150,"world_marker_length":25,"world_marker_size":100,"world_marker_thickness":3,"world_shadow_soft_enabled":true,"world_shadow_soft_val":25,"world_sky_autorotate":false,"world_sky_bk":"","world_sky_celestial":false,"world_sky_dn":"","world_sky_ft":"","world_sky_lf":"","world_sky_moon_size":11,"world_sky_rotate_speed":100,"world_sky_rt":"","world_sky_stars":0,"world_sky_sun_size":21,"world_sky_up":"","world_skybox_custom_id":"","world_skybox_disable":[],"world_skybox_enabled":true,"world_skybox_mode":"PurpleNight","world_sunrays_enabled":false,"world_sunrays_intensity":0.2,"world_sunrays_spread":1,"world_weather_color":{"Color":"ffffff","Transparency":0},"world_weather_color_end":{"Color":"7778ff","Transparency":0},"world_weather_color_mid":{"Color":"b3b4ff","Transparency":0},"world_weather_density":40,"world_weather_enabled":false,"world_weather_height":23,"world_weather_lifetime":100,"world_weather_opacity":80,"world_weather_radius":120,"world_weather_size":100,"world_weather_speed":100,"world_weather_timescale":1,"world_weather_type":"Snow","yaw_type":"Block"}]==],

    ["[RAGE; HVH] Sakura"] = [==[{"movement_maul_slam":false,"AntiAim_enabled":true,"AntiFlash":true,"AntiSmoke":true,"FakePosition":false,"FakePositionPanic":false,"FakePositionWalk":false,"FilledFov_Color1":{"Color":"fccbfa","Transparency":0.94},"FilledFov_Color2":{"Color":"fccbfa","Transparency":0.85},"FilledFov_Color3":{"Color":"fccbfa","Transparency":0.94},"HideHead_enabled":true,"InfiniteJump":true,"IsInvincible":true,"NoBobbing":false,"Noclip":false,"RapidBody_enabled":false,"SilentaimDropdown_":[],"VelocitySpeedEnabled":false,"aimbot_enabled":false,"aimbot_fov_settings":[],"anti_aim_enabled":false,"anti_flash_keep_sound":true,"antiaim_speed":100,"arm_override_appearance":false,"camera_fov_amount":100,"camera_fov_enabled":true,"crosshair_bounce":5,"crosshair_bounce_speed":2.9,"crosshair_color_1":{"Color":"fccbfa","Transparency":0},"crosshair_color_2":{"Color":"f7b1f4","Transparency":0},"crosshair_color_3":{"Color":"f5a3f1","Transparency":0},"crosshair_color_4":{"Color":"f296ee","Transparency":0},"crosshair_enabled":true,"crosshair_length":13,"crosshair_lerp":0.25,"crosshair_offset":5,"crosshair_outline":true,"crosshair_outline_color_1":{"Color":"000000","Transparency":0},"crosshair_outline_color_2":{"Color":"000000","Transparency":0},"crosshair_outline_color_3":{"Color":"000000","Transparency":0},"crosshair_outline_color_4":{"Color":"000000","Transparency":0},"crosshair_rotation":0,"crosshair_rotation_speed":0.2,"crosshair_settings":["position on target"],"crosshair_thickness":2,"custom_tracer_color":{"Color":"fccbfa","Transparency":0},"custom_tracer_color2":{"Color":"f296ee","Transparency":0},"custom_tracer_emission":1,"custom_tracer_enabled":true,"custom_tracer_fade":1,"custom_tracer_glow":4,"custom_tracer_length":4,"custom_tracer_lifetime":1,"custom_tracer_outline":false,"custom_tracer_position_lerp":0.5,"custom_tracer_selected":"lightning","custom_tracer_speed":2,"custom_tracer_width":0.2,"esp_body_color":false,"esp_bounds_type":"dynamic","esp_bounds_width_scale":100,"esp_box":false,"esp_chams":true,"esp_chams_alpha_fill":-1,"esp_chams_alpha_outline":1,"esp_chams_color":{"Color":"000000","Transparency":0},"esp_chams_color2":{"Color":"f296ee","Transparency":0},"esp_chams_settings":["through walls"],"esp_distance":true,"esp_distance_color1":{"Color":"ffffff","Transparency":0},"esp_distance_color2":{"Color":"ffffff","Transparency":0},"esp_distance_color3":{"Color":"ffffff","Transparency":0},"esp_effects_aura":false,"esp_effects_particle":true,"esp_effects_particle_color1":{"Color":"fccbfa","Transparency":0},"esp_effects_particle_color2":{"Color":"f296ee","Transparency":0},"esp_effects_particle_color3":{"Color":"bc75ba","Transparency":0},"esp_effects_particle_value":["glowing"],"esp_fill":false,"esp_flag_health_text":false,"esp_flag_staring_text":true,"esp_font":"proggy tiny","esp_healthbar":true,"esp_healthbar_color_end":{"Color":"9d539b","Transparency":0},"esp_healthbar_color_middle":{"Color":"bc75ba","Transparency":0},"esp_healthbar_color_start":{"Color":"fde3fc","Transparency":0},"esp_healthbar_health_lerp":0.05,"esp_healthbar_moving":false,"esp_healthbar_resize":false,"esp_healthbar_type":"gradient","esp_material":false,"esp_name":true,"esp_name_color1":{"Color":"ffffff","Transparency":0},"esp_name_color2":{"Color":"fde3fc","Transparency":0},"esp_name_color3":{"Color":"fccbfa","Transparency":0},"esp_name_font":"default","esp_name_type":"Name","esp_override_appearance":false,"esp_round_only":true,"esp_show_team":false,"esp_skeleton":true,"esp_skeleton_color1":{"Color":"ffffff","Transparency":0},"esp_skeleton_color2":{"Color":"ffffff","Transparency":0},"esp_skeleton_color3":{"Color":"ffffff","Transparency":0},"esp_skeleton_outline":false,"esp_skeleton_thickness":1,"esp_weapon":true,"esp_weapon_color1":{"Color":"ffffff","Transparency":0},"esp_weapon_color2":{"Color":"ffffff","Transparency":0},"esp_weapon_color3":{"Color":"ffffff","Transparency":0},"esp_world_distance":true,"esp_world_distance_color":{"Color":"fccbfa","Transparency":0},"esp_world_font":"proggy tiny","esp_world_image":true,"esp_world_name":true,"esp_world_name_color":{"Color":"ffffff","Transparency":0},"esp_world_object_scale":75,"esp_world_whitelist":["Flashbang","Smoke Grenade","Satchel","Subspace Tripmine","Molotov","Grenade"],"exploits_always_backstab":true,"faster_reload":true,"fly_enabled":false,"fov_fill_speed":100,"fov_fill_style":"Inner Fade","fov_lerp":25,"fov_moving_rotation":true,"fov_outline":true,"fov_outline_color":{"Color":"fccbfa","Transparency":0.84},"fov_outline_color2":{"Color":"fde3fc","Transparency":0.7},"fov_outline_color3":{"Color":"fde3fc","Transparency":0.25},"fov_outline_thickness":2,"fov_position":"position on screen","fov_rotation":0,"fov_rotation_speed":10,"full_auto_enabled":true,"game_crosshair":true,"grenade_options":["explode on impact"],"hit_effects_col_1":{"Color":"ffffff","Transparency":0},"hit_effects_col_2":{"Color":"fccbfa","Transparency":0},"hit_effects_col_3":{"Color":"f296ee","Transparency":0},"hit_effects_disable_marker":true,"hit_effects_disable_numbers":true,"hit_effects_enabled":true,"hit_effects_material":"ForceField","hit_effects_selected":["Electricity","phantom forces"],"hit_effects_settings":["stack damage together"],"hit_effects_weld":false,"hit_notifications_enabled":true,"hit_notify_duration":1.3,"hit_sounds_disable":true,"hit_sounds_enabled":true,"hit_sounds_selected":"sparkle","hit_sounds_volume":0.9,"hitmarker_enabled":false,"indicator_ammo":true,"indicator_ammo_color":{"Color":"ffffff","Transparency":0},"indicator_ammo_divider_color":{"Color":"f296ee","Transparency":0},"indicator_ammo_max_color":{"Color":"ffffff","Transparency":0},"indicator_ammo_style":["ammo","max ammo","reserve","\"out of ammo\" if empty"],"indicator_empty_color":{"Color":"ff5f5f","Transparency":0},"indicator_font":"proggy tiny","indicator_lerp":0.25,"indicator_manipulated":true,"indicator_manipulated_color":{"Color":"f296ee","Transparency":0},"indicator_offset_x":0,"indicator_offset_y":25,"indicator_ragebot":true,"indicator_ragebot_status_color":{"Color":"ffffff","Transparency":0},"indicator_ragebot_style":["text","status"],"indicator_ragebot_text_color":{"Color":"f296ee","Transparency":0},"indicator_reserve_color":{"Color":"fccbfa","Transparency":0},"indicator_settings":[],"indicator_text_style":"lower","instant_aim_enabled":true,"item_remove_vignette":true,"item_status_enabled":true,"item_status_override":"Prime","manipulation_enabled":true,"movement_double_jump":false,"movement_slideboost":true,"movement_slideboost_value":2.5,"no_fire_sound":false,"no_muzzle_flash":false,"no_recoil_enabled":true,"no_spread_enabled":true,"pitch_type":"Up & Down","quickequip":true,"ragebot_enabled":true,"ragebot_method":"Lite","ragebot_mode":"gun","ragebot_priority":true,"ragebot_priority_notification":true,"ragebot_priority_settings":["attackers","voided players"],"ragebot_settings":["swap weapons when empty"],"ragebot_weapon":"primary","shoot_sound_change":true,"shoot_sound_change_value":"crossbow","shoot_sound_speed":1,"shoot_sound_start":0,"shoot_sound_volume":0.6,"silent_aim_enabled":true,"silent_aim_range":300,"silent_aim_range_color":{"Color":"ffffff","Transparency":0},"silent_aim_range_color2":{"Color":"fde3fc","Transparency":0},"silent_aim_range_color3":{"Color":"fccbfa","Transparency":0},"silent_aim_target_mode":"FOV - Closest","silent_aim_visualise_filled_range":true,"silent_aim_visualise_range":true,"silent_closest_part":false,"silent_hitchance":100,"silent_visualize":true,"silent_wallbang":true,"stretch_enabled":false,"target_highlight":true,"target_highlight_fill":{"Color":"f296ee","Transparency":0.6},"target_highlight_outline":{"Color":"fccbfa","Transparency":0},"target_highlight_type":"AlwaysOnTop","target_method_ragebot":"Closest","target_tracer":true,"target_tracer_customization":{"Color":"f296ee","Transparency":0},"target_ui_enabled":true,"target_ui_item_scale":170,"target_ui_position_x":50,"target_ui_position_y":72,"target_ui_scale":150,"targeting_ignore_protected_settings":["blocked by riot shield","katana deflecting"],"targeting_limitdistance":false,"targeting_part":"Head","third_person_enabled":true,"trigger_enabled":false,"viewmodel_chams":true,"viewmodel_chams_alpha_fill":-1.2,"viewmodel_chams_alpha_outline":1,"viewmodel_chams_color":{"Color":"000000","Transparency":0},"viewmodel_chams_color2":{"Color":"ffd6fb","Transparency":0},"viewmodel_chams_settings":["through walls"],"viewmodel_frames_override":false,"viewmodel_offset":true,"viewmodel_offset_x":0,"viewmodel_offset_y":0,"viewmodel_offset_z":-0.5,"viewmodel_options":["sway","bobbing","muzzle flash","idle animation","jump animation","slide animation","sprint animation","shoot animation","tilt","aiming animation","equip animation"],"viewmodel_override_appearance":false,"viewmodel_recoil":0,"viewmodel_scale_enabled":false,"viewmodel_wire_enabled":false,"voidspam_enabled":true,"voidspam_hide_time":0.25,"voidspam_shoot_attempts":2,"voidspam_shoot_time":0.01,"wallbang_method":"Classic V1","world_ambience_enabled":false,"world_ambience_type":"Rain","world_ambience_volume":35,"world_atm_decay":{"Color":"b45aa8","Transparency":0},"world_atm_density":0.4,"world_atm_enabled":true,"world_atm_glare":3,"world_atm_haze":2.5,"world_atm_offset":0.4,"world_atm_tint":{"Color":"ffc8fd","Transparency":0},"world_bloom_enabled":true,"world_bloom_intensity":0.8,"world_bloom_size":40,"world_bloom_threshold":0.9,"world_blur_enabled":false,"world_cc_brightness":-0.05,"world_cc_contrast":0.1,"world_cc_enabled":true,"world_cc_saturation":0.15,"world_cc_tint":{"Color":"ffe3f7","Transparency":0},"world_dof_enabled":false,"world_env_enabled":false,"world_ltg_ambient":true,"world_ltg_ambient_color":{"Color":"ffffff","Transparency":0},"world_ltg_brightness":true,"world_ltg_brightness_val":1.7,"world_ltg_clock":true,"world_ltg_clock_val":17.2,"world_ltg_colorshift_bottom":true,"world_ltg_colorshift_bottom_color":{"Color":"ffffff","Transparency":0},"world_ltg_colorshift_top":true,"world_ltg_colorshift_top_color":{"Color":"fccbfa","Transparency":0},"world_ltg_exposure":true,"world_ltg_exposure_val":-1.1,"world_ltg_fog_color_enabled":false,"world_ltg_fog_end":false,"world_ltg_fog_start":false,"world_ltg_shadows":true,"world_marker_enabled":false,"world_shadow_soft_enabled":true,"world_shadow_soft_val":25,"world_sky_autorotate":false,"world_sky_celestial":false,"world_skybox_disable":[],"world_skybox_enabled":true,"world_skybox_mode":"Pink Clouds","world_sunrays_enabled":false,"world_sunrays_intensity":0.2,"world_sunrays_spread":1,"world_weather_color":{"Color":"ffd1f2","Transparency":0},"world_weather_color_end":{"Color":"c85ab8","Transparency":0},"world_weather_color_mid":{"Color":"f296ee","Transparency":0},"world_weather_density":60,"world_weather_enabled":false,"world_weather_lifetime":100,"world_weather_opacity":80,"world_weather_size":100,"world_weather_speed":100,"world_weather_timescale":1,"world_weather_type":"Cherry Blossom","yaw_type":"Random"}]==],

    ["[RAGE; NO HVH] Winter"] = [==[{"movement_maul_slam":false,"ACO":false,"AimLock_Key":{"active":false,"key":"Enum.KeyCode.LeftControl","mode":"Hold"},"AimbotFilledFov_Color1":{"Color":"78aaff","Transparency":0.65},"AimbotFilledFov_Color2":{"Color":"1e285a","Transparency":0},"AimbotFilledFov_Color3":{"Color":"4669af","Transparency":0},"AimlockDropdown_":[],"AntiAim_enabled":true,"AntiFlash":true,"AntiSmoke":true,"FakePosition":true,"FakePositionPanic":false,"FakePositionWalk":true,"FakePositionY":7,"FilledFov_Color1":{"Color":"0149c3","Transparency":0.6111111111111112},"FilledFov_Color2":{"Color":"00b5ff","Transparency":0},"FilledFov_Color3":{"Color":"002878","Transparency":0.8611111111111112},"FlyKeybind":{"active":false,"key":"Enum.KeyCode.F","mode":"Toggle"},"HideHead_enabled":true,"InfiniteJump":false,"IsInvincible":true,"NoBobbing":true,"Noclip":true,"PanicPositionXMax":7,"PanicPositionXMin":7,"RapidBody_enabled":false,"SilentaimDropdown_":[],"TriggerbotDropdown_":[],"VelocitySpeedEnabled":true,"VelocitySpeedValue":52,"aco_ammo":true,"aco_health":true,"aco_infinite_range":false,"aco_interval":200,"aco_only_needed":true,"aco_range":60,"aim_lock_range":100,"aimbot_enabled":false,"aimbot_fov_lerp":100,"aimbot_fov_moving_rotation":false,"aimbot_fov_outline":false,"aimbot_fov_outline_color":{"Color":"000000","Transparency":0},"aimbot_fov_outline_color2":{"Color":"000000","Transparency":0},"aimbot_fov_outline_color3":{"Color":"000000","Transparency":0},"aimbot_fov_outline_thickness":2,"aimbot_fov_rotation":0,"aimbot_fov_rotation_speed":10,"aimbot_fov_settings":[],"aimbot_hitmethod":"Camera","aimbot_range_color":{"Color":"ffffff","Transparency":0.75},"aimbot_visualise_filled_range":false,"aimbot_visualise_range":false,"aimlock_delay":0,"aimlock_jitter":0,"aimlock_jitter_rate":166,"aimlock_wallcheck":false,"anim_custom_id":"","anim_enabled":true,"anim_end":100,"anim_key":{"active":true,"key":"NONE","mode":"Always"},"anim_preset":"small / hide","anim_speed":10,"anim_start":0,"anti_aim_enabled":true,"anti_aim_speed":100,"anti_flash_keep_sound":true,"antiaim_key":{"active":true,"key":"NONE","mode":"Always"},"antiaim_speed":100,"arm_override_appearance":false,"auto_ban_first":"Riot Shield","auto_ban_first_delay":1,"auto_ban_map_delay":1,"auto_ban_random_map":false,"auto_ban_second":"Katana","auto_ban_second_delay":2,"auto_ban_weapons":false,"auto_queue_enabled":false,"auto_vote_enabled":true,"auto_vote_map":"Arena","autoload_enabled_auto_slot":false,"camera_fov_amount":90,"camera_fov_enabled":false,"chat_spam_delay":5,"chat_spam_enabled":false,"chat_spam_mode":"custom","chat_spam_list":["sleepy.gg"],"chat_spam_trigger":"always","crosshair_bounce":5,"crosshair_bounce_speed":2.9,"crosshair_color_1":{"Color":"d1e9ff","Transparency":0},"crosshair_color_2":{"Color":"bbdfff","Transparency":0},"crosshair_color_3":{"Color":"b1d9ff","Transparency":0},"crosshair_color_4":{"Color":"a6d4ff","Transparency":0},"crosshair_enabled":true,"crosshair_length":13,"crosshair_lerp":0.25,"crosshair_offset":5,"crosshair_outline":true,"crosshair_outline_color_1":{"Color":"000000","Transparency":0},"crosshair_outline_color_2":{"Color":"000000","Transparency":0},"crosshair_outline_color_3":{"Color":"000000","Transparency":0},"crosshair_outline_color_4":{"Color":"000000","Transparency":0},"crosshair_rotation":0,"crosshair_rotation_speed":0.2,"crosshair_settings":["position on target"],"crosshair_thickness":2,"custom_pitch_angle":90,"custom_tracer_color":{"Color":"d1e9ff","Transparency":0},"custom_tracer_color2":{"Color":"a6d4ff","Transparency":0},"custom_tracer_emission":1,"custom_tracer_enabled":true,"custom_tracer_fade":1,"custom_tracer_glow":5,"custom_tracer_length":4,"custom_tracer_lifetime":1,"custom_tracer_outline":false,"custom_tracer_position_lerp":0.5,"custom_tracer_selected":"lightning","custom_tracer_speed":2,"custom_tracer_width":0.2,"custom_yaw_angle":180,"death_sound_enabled":false,"death_sound_id":"","death_sound_pitch":100,"death_sound_preset":"Sparkle","death_sound_url":"","death_sound_volume":50,"device_spoofer_enabled":false,"esp_body_color":false,"esp_bounds_type":"dynamic","esp_bounds_width_scale":100,"esp_box":false,"esp_chams":true,"esp_chams_alpha_fill":-1,"esp_chams_alpha_outline":1,"esp_chams_color":{"Color":"000000","Transparency":0},"esp_chams_color2":{"Color":"a6d4ff","Transparency":0},"esp_chams_settings":["through walls"],"esp_distance":true,"esp_distance_color1":{"Color":"ffffff","Transparency":0},"esp_distance_color2":{"Color":"ffffff","Transparency":0},"esp_distance_color3":{"Color":"ffffff","Transparency":0},"esp_effects_aura":false,"esp_effects_particle":true,"esp_effects_particle_color1":{"Color":"d1e9ff","Transparency":0},"esp_effects_particle_color2":{"Color":"a6d4ff","Transparency":0},"esp_effects_particle_color3":{"Color":"4e99de","Transparency":0},"esp_effects_particle_value":["glowing"],"esp_fill":false,"esp_flag_health_text":false,"esp_flag_staring_text":true,"esp_font":"proggy tiny","esp_healthbar":true,"esp_healthbar_color_end":{"Color":"227bce","Transparency":0},"esp_healthbar_color_middle":{"Color":"4e99de","Transparency":0},"esp_healthbar_color_start":{"Color":"e6f3ff","Transparency":0},"esp_healthbar_health_lerp":0.05,"esp_healthbar_moving":false,"esp_healthbar_resize":false,"esp_healthbar_type":"gradient","esp_material":false,"esp_name":true,"esp_name_color1":{"Color":"ffffff","Transparency":0},"esp_name_color2":{"Color":"e6f3ff","Transparency":0},"esp_name_color3":{"Color":"d1e9ff","Transparency":0},"esp_name_font":"default","esp_name_type":"Name","esp_override_appearance":false,"esp_round_only":true,"esp_show_team":false,"esp_skeleton":true,"esp_skeleton_color1":{"Color":"ffffff","Transparency":0},"esp_skeleton_color2":{"Color":"ffffff","Transparency":0},"esp_skeleton_color3":{"Color":"ffffff","Transparency":0},"esp_skeleton_outline":false,"esp_skeleton_thickness":1,"esp_weapon":true,"esp_weapon_color1":{"Color":"ffffff","Transparency":0},"esp_weapon_color2":{"Color":"ffffff","Transparency":0},"esp_weapon_color3":{"Color":"ffffff","Transparency":0},"esp_world_distance":true,"esp_world_distance_color":{"Color":"d1e9ff","Transparency":0},"esp_world_font":"proggy tiny","esp_world_image":true,"esp_world_name":true,"esp_world_name_color":{"Color":"ffffff","Transparency":0},"esp_world_object_scale":75,"esp_world_whitelist":["Flashbang","Smoke Grenade","Satchel","Subspace Tripmine","Molotov","Grenade"],"exploits_always_backstab":true,"fakepos_key":{"active":false,"key":"NONE","mode":"Always"},"faster_reload":true,"firerate_multiplier":10,"fly_enabled":false,"flyvalue":50,"fov_fill_speed":400,"fov_fill_style":"Inner Fade","fov_lerp":100,"fov_moving_rotation":true,"fov_outline":false,"fov_outline_color":{"Color":"3c4e7c","Transparency":0},"fov_outline_color2":{"Color":"000000","Transparency":0},"fov_outline_color3":{"Color":"000000","Transparency":0},"fov_outline_thickness":1,"fov_position":"position on screen","fov_rotation":360,"fov_rotation_speed":12.1,"full_auto_enabled":false,"game_crosshair":true,"hit_effects_col_1":{"Color":"ffffff","Transparency":0},"hit_effects_col_2":{"Color":"d1e9ff","Transparency":0},"hit_effects_col_3":{"Color":"a6d4ff","Transparency":0},"hit_effects_disable_marker":true,"hit_effects_disable_numbers":true,"hit_effects_enabled":true,"hit_effects_material":"ForceField","hit_effects_selected":["fortnite damage","slashes"],"hit_effects_settings":["stack damage together"],"hit_effects_weld":false,"hit_notifications_enabled":true,"hit_notify_list":["Hit {NAME} for {DMG} in the {PART}"],"hit_notify_duration":1.3,"hit_sounds_disable":true,"hit_sounds_enabled":true,"hit_sounds_selected":"sparkle","hit_sounds_volume":0.9,"hitmarker_color":{"Color":"ffffff","Transparency":0},"hitmarker_duration":200,"hitmarker_enabled":false,"hitmarker_fade":true,"hitmarker_gap":3,"hitmarker_length":6,"hitmarker_style":"Cross","hitmarker_thickness":2,"indicator_ammo":true,"indicator_ammo_color":{"Color":"ffffff","Transparency":0},"indicator_ammo_divider_color":{"Color":"a6d4ff","Transparency":0},"indicator_ammo_max_color":{"Color":"ffffff","Transparency":0},"indicator_ammo_style":["ammo","max ammo","reserve","\"out of ammo\" if empty"],"indicator_empty_color":{"Color":"ff5f5f","Transparency":0},"indicator_font":"proggy tiny","indicator_lerp":0.25,"indicator_manipulated":true,"indicator_manipulated_color":{"Color":"a6d4ff","Transparency":0},"indicator_offset_x":0,"indicator_offset_y":25,"indicator_ragebot":true,"indicator_ragebot_status_color":{"Color":"ffffff","Transparency":0},"indicator_ragebot_style":["text","status"],"indicator_ragebot_text_color":{"Color":"a6d4ff","Transparency":0},"indicator_reserve_color":{"Color":"d1e9ff","Transparency":0},"indicator_settings":[],"indicator_text_style":"lower","instant_aim_enabled":true,"item_remove_vignette":true,"item_status_enabled":true,"item_status_override":"Prime","kill_sound_enabled":true,"kill_sound_id":"","kill_sound_pitch":100,"kill_sound_preset":"Rust","kill_sound_url":"","kill_sound_volume":79,"leaderboard_Current Highest Win Streak":false,"leaderboard_Highest ELO":false,"leaderboard_Highest Level":false,"leaderboard_Most Eliminations":false,"leaderboard_Most Wins":false,"leaderboard_value":"9999","matchmaking_mode":"1v1","mod_detector":true,"mod_detector_evade":true,"mod_detector_leave":false,"movement_double_jump":true,"movement_double_jump_height":1,"movement_slideboost":true,"movement_slideboost_value":2.1,"no_bullet_tracer":true,"no_fire_sound":true,"no_muzzle_flash":true,"no_recoil_enabled":true,"no_spread_enabled":true,"noclip_key":{"active":true,"key":"NONE","mode":"Always"},"offsetX":0,"offsetY":-7,"offsetZ":-5,"pitch_type":"None","profile_displayname_enabled":false,"profile_displayname_value":"","profile_elo_enabled":false,"profile_elo_value":"3000","profile_level_enabled":false,"profile_level_value":"9999","profile_streak_enabled":false,"profile_streak_value":"9999","profile_username_enabled":false,"profile_username_value":"","quickequip":true,"ragebot_enabled":true,"ragebot_key":{"active":false,"key":"NONE","mode":"Always"},"ragebot_method":"Advanced","ragebot_mode":"gun","ragebot_settings":["swap weapons when empty"],"ragebot_weapon":"primary","random_offset_max":8,"random_offset_min":-8,"reload_sound_enabled":false,"reload_sound_id":"","reload_sound_pitch":100,"reload_sound_preset":"Sparkle","reload_sound_url":"","reload_sound_volume":50,"shoot_sound_change":true,"shoot_sound_change_value":"crossbow","shoot_sound_speed":1,"shoot_sound_start":0,"shoot_sound_volume":0.6,"silent_aim_enabled":true,"silent_aim_range":245,"silent_aim_range_color":{"Color":"ffffff","Transparency":0},"silent_aim_target_mode":"FOV - Closest","silent_aim_visualise_filled_range":true,"silent_aim_visualise_range":true,"silent_hitchance":100,"silent_key":{"active":false,"key":"NONE","mode":"Always"},"silent_wallbang":true,"spoof_device_type":"Controller","stretch_amount":67,"stretch_enabled":false,"target_highlight":true,"target_highlight_fill":{"Color":"a6d4ff","Transparency":0.6},"target_highlight_outline":{"Color":"d1e9ff","Transparency":0},"target_highlight_type":"AlwaysOnTop","target_method_ragebot":"Closest","target_tracer":true,"target_tracer_customization":{"Color":"a6d4ff","Transparency":0},"target_ui_enabled":true,"target_ui_item_scale":170,"target_ui_position_x":50,"target_ui_position_y":72,"target_ui_scale":150,"targeting_ignore_protected_settings":["blocked by riot shield","katana deflecting"],"targeting_limitdistance":false,"targeting_part":"Head","third_person_enabled":false,"third_person_key":{"active":false,"key":"NONE","mode":"Always"},"trigger_distance":500,"trigger_enabled":false,"trigger_forget_time":1,"trigger_key":{"active":false,"key":"Enum.KeyCode.C","mode":"Always"},"trigger_reaction":40,"trigger_scoped":["Crossbow","Sniper"],"unlock_all_enabled":true,"velocity_key":{"active":false,"key":"NONE","mode":"Always"},"viewmodel_chams":true,"viewmodel_chams_alpha_fill":-0.4,"viewmodel_chams_alpha_outline":1,"viewmodel_chams_color":{"Color":"000000","Transparency":0},"viewmodel_chams_color2":{"Color":"d8e9ff","Transparency":0},"viewmodel_chams_settings":["through walls"],"viewmodel_disable_textures":true,"viewmodel_frames_override":false,"viewmodel_glow_color":{"Color":"c896ff","Transparency":0},"viewmodel_glow_intensity":28,"viewmodel_offset":true,"viewmodel_offset_x":0,"viewmodel_offset_y":0,"viewmodel_offset_z":-0.5,"viewmodel_options":["sway","bobbing","muzzle flash","idle animation","jump animation","slide animation","sprint animation","shoot animation","tilt","aiming animation","equip animation"],"viewmodel_override_appearance":false,"viewmodel_recoil":0,"viewmodel_scale":100,"viewmodel_scale_enabled":false,"viewmodel_wire_color":{"Color":"ffffff","Transparency":0},"viewmodel_wire_enabled":false,"viewmodel_wire_hide_base":false,"viewmodel_wire_mode":"Lines + Glow","voidspam_enabled":false,"wallbang_method":"Teleport V2","world_ambience_enabled":false,"world_ambience_type":"Windy Day","world_ambience_volume":35,"world_atm_decay":{"Color":"6f8fb3","Transparency":0},"world_atm_density":0.4,"world_atm_enabled":true,"world_atm_glare":1.5,"world_atm_haze":1.2,"world_atm_offset":0.4,"world_atm_tint":{"Color":"cfe6ff","Transparency":0},"world_bloom_enabled":true,"world_bloom_intensity":0.8,"world_bloom_size":40,"world_bloom_threshold":0.9,"world_blur_enabled":false,"world_blur_size":5,"world_cc_brightness":-0.05,"world_cc_contrast":0.1,"world_cc_enabled":true,"world_cc_saturation":0.15,"world_cc_tint":{"Color":"dceeff","Transparency":0},"world_dof_enabled":false,"world_dof_far":0.36,"world_dof_focus":42,"world_dof_near":0.1,"world_dof_radius":28,"world_env_diffuse":1.1,"world_env_enabled":false,"world_env_specular":1.15,"world_ltg_ambient":true,"world_ltg_ambient_color":{"Color":"ffffff","Transparency":0},"world_ltg_brightness":true,"world_ltg_brightness_val":1.7,"world_ltg_clock":true,"world_ltg_clock_val":9.2,"world_ltg_colorshift_bottom":true,"world_ltg_colorshift_bottom_color":{"Color":"ffffff","Transparency":0},"world_ltg_colorshift_top":true,"world_ltg_colorshift_top_color":{"Color":"d1e9ff","Transparency":0},"world_ltg_exposure":true,"world_ltg_exposure_val":-1.1,"world_ltg_fog_color":{"Color":"bfbfbf","Transparency":0},"world_ltg_fog_color_enabled":false,"world_ltg_fog_end":false,"world_ltg_fog_end_val":10000,"world_ltg_fog_start":false,"world_ltg_fog_start_val":0,"world_ltg_shadows":true,"world_marker_color":{"Color":"ffffff","Transparency":0},"world_marker_duration":0.6,"world_marker_enabled":false,"world_marker_growth":150,"world_marker_length":25,"world_marker_size":100,"world_marker_thickness":3,"world_shadow_soft_enabled":true,"world_shadow_soft_val":25,"world_sky_autorotate":false,"world_sky_bk":"","world_sky_celestial":false,"world_sky_dn":"","world_sky_ft":"","world_sky_lf":"","world_sky_moon_size":11,"world_sky_rotate_speed":100,"world_sky_rt":"","world_sky_stars":0,"world_sky_sun_size":21,"world_sky_up":"","world_skybox_custom_id":"","world_skybox_disable":[],"world_skybox_enabled":true,"world_skybox_mode":"Winter","world_sunrays_enabled":true,"world_sunrays_intensity":0.2,"world_sunrays_spread":1,"world_weather_color":{"Color":"ffffff","Transparency":0},"world_weather_color_end":{"Color":"a6d4ff","Transparency":0},"world_weather_color_mid":{"Color":"d1e9ff","Transparency":0},"world_weather_density":70,"world_weather_enabled":false,"world_weather_height":22,"world_weather_lifetime":100,"world_weather_opacity":80,"world_weather_radius":50,"world_weather_size":100,"world_weather_speed":100,"world_weather_timescale":1,"world_weather_type":"Snow","yaw_type":"Block"}]==],

    ["[RAGE] Rem's Config"] = [==[{"movement_maul_slam":false,"ACO":true,"AimLock_Key":{"active":false,"key":"Enum.UserInputType.MouseButton2","mode":"Hold"},"AimbotFilledFov_Color1":{"Color":"000000","Transparency":0.8181818181818181},"AimbotFilledFov_Color2":{"Color":"000000","Transparency":1},"AimbotFilledFov_Color3":{"Color":"000000","Transparency":0.8181818181818181},"AimlockDropdown_":[],"AntiAim_enabled":true,"AntiFlash":true,"FakePosition":true,"FakePositionWalk":true,"FakePositionY":5,"FilledFov_Color1":{"Color":"823b75","Transparency":0.85},"FilledFov_Color2":{"Color":"d7a6d5","Transparency":0.7},"FilledFov_Color3":{"Color":"9f83a0","Transparency":0.6},"FlyKeybind":{"active":false,"key":"Enum.KeyCode.X","mode":"Toggle"},"InfiniteJump":true,"IsInvincible":true,"Noclip":true,"SilentaimDropdown_":[],"TriggerbotDropdown_":["no delay between targets"],"VelocitySpeedEnabled":true,"VelocitySpeedValue":50,"aim_lock_range":1000,"aimbot_closest_part":false,"aimbot_closest_position":false,"aimbot_delay_position":false,"aimbot_enabled":false,"aimbot_fov_lerp":25,"aimbot_fov_moving_rotation":false,"aimbot_fov_outline":true,"aimbot_fov_outline_color":{"Color":"c576bd","Transparency":0.7863636363636364},"aimbot_fov_outline_color2":{"Color":"e38bde","Transparency":0.7},"aimbot_fov_outline_color3":{"Color":"f296ee","Transparency":0.2681818181818182},"aimbot_fov_rotation":0,"aimbot_fov_rotation_speed":100,"aimbot_fov_settings":[],"aimbot_jump_smooth":10,"aimbot_range_color":{"Color":"ffffff","Transparency":1},"aimbot_range_color2":{"Color":"e4c4ca","Transparency":0},"aimbot_range_color3":{"Color":"d7a6c3","Transparency":0},"aimbot_smoothing":100,"aimbot_visualise_filled_range":true,"aimbot_visualise_range":false,"aimbot_x_smooth":4,"aimbot_y_smooth":4,"aimlock_wallcheck":true,"anim_custom_id":"","anim_enabled":true,"anim_end":100,"anim_key":{"active":false,"key":"NONE","mode":"Toggle"},"anim_preset":"solar system","anim_speed":1,"anim_start":0,"anti_aim_enabled":true,"auto_ban_first":"Riot Shield","auto_ban_random_map":true,"auto_ban_second":"Katana","auto_ban_weapons":true,"auto_queue_enabled":false,"camera_fov_amount":100,"camera_fov_enabled":true,"chat_spam_enabled":false,"chat_spam_mode":"custom","crosshair_bounce":5,"crosshair_bounce_speed":2.9,"crosshair_color_1":{"Color":"fccbfa","Transparency":0},"crosshair_color_2":{"Color":"f7b1f4","Transparency":0},"crosshair_color_3":{"Color":"f5a3f1","Transparency":0},"crosshair_color_4":{"Color":"f296ee","Transparency":0},"crosshair_enabled":true,"crosshair_length":13,"crosshair_lerp":0.25,"crosshair_offset":5,"crosshair_outline":true,"crosshair_outline_color_1":{"Color":"000000","Transparency":0},"crosshair_outline_color_2":{"Color":"000000","Transparency":0},"crosshair_outline_color_3":{"Color":"000000","Transparency":0},"crosshair_outline_color_4":{"Color":"000000","Transparency":0},"crosshair_rotation":0,"crosshair_rotation_speed":0.2,"crosshair_settings":["position on target"],"crosshair_thickness":2,"custom_tracer_color":{"Color":"c47cc1","Transparency":0},"custom_tracer_color2":{"Color":"c47cc1","Transparency":0},"custom_tracer_emission":1,"custom_tracer_enabled":true,"custom_tracer_fade":1,"custom_tracer_glow":4,"custom_tracer_length":4,"custom_tracer_lifetime":1,"custom_tracer_outline":false,"custom_tracer_position_lerp":0.5,"custom_tracer_selected":"lightning","custom_tracer_speed":2,"custom_tracer_width":0.2,"device_spoofer_enabled":false,"esp_body_color":false,"esp_body_color_value":{"Color":"ffffff","Transparency":0},"esp_body_disables":[],"esp_body_transparency":100,"esp_bounds_type":"dynamic","esp_bounds_width_scale":100,"esp_box":false,"esp_box_color1":{"Color":"ffffff","Transparency":0},"esp_box_color2":{"Color":"ffffff","Transparency":0},"esp_box_color3":{"Color":"ffffff","Transparency":0},"esp_box_moving":false,"esp_box_rotation":0,"esp_box_rotation_speed":0.1,"esp_chams":true,"esp_chams_alpha_fill":-1,"esp_chams_alpha_outline":1,"esp_chams_color":{"Color":"000000","Transparency":0},"esp_chams_color2":{"Color":"ff4ded","Transparency":0},"esp_chams_settings":[],"esp_distance":true,"esp_distance_color1":{"Color":"ffffff","Transparency":0},"esp_distance_color2":{"Color":"ffffff","Transparency":0},"esp_distance_color3":{"Color":"ffffff","Transparency":0},"esp_distance_rotation":0,"esp_effects_aura":false,"esp_effects_aura_color1":{"Color":"f296ee","Transparency":0},"esp_effects_aura_color2":{"Color":"f296ee","Transparency":0},"esp_effects_aura_color3":{"Color":"f296ee","Transparency":0},"esp_effects_aura_value":[],"esp_effects_particle":true,"esp_effects_particle_color1":{"Color":"f296ee","Transparency":0},"esp_effects_particle_color2":{"Color":"f296ee","Transparency":0},"esp_effects_particle_color3":{"Color":"f296ee","Transparency":0},"esp_effects_particle_value":["glowing"],"esp_fill":false,"esp_fill_color1":{"Color":"f296ee","Transparency":0.5727272727272728},"esp_fill_color2":{"Color":"320055","Transparency":0.9409090909090909},"esp_fill_color3":{"Color":"000000","Transparency":1},"esp_fill_moving":true,"esp_fill_rotation":45,"esp_fill_rotation_speed":0.5,"esp_font":"proggy tiny","esp_healthbar":true,"esp_healthbar_color_end":{"Color":"9d539b","Transparency":0},"esp_healthbar_color_middle":{"Color":"bc75ba","Transparency":0},"esp_healthbar_color_start":{"Color":"fbb8f8","Transparency":0},"esp_healthbar_health_lerp":0.05,"esp_healthbar_moving":false,"esp_healthbar_resize":false,"esp_healthbar_slices":1,"esp_healthbar_speed":1,"esp_healthbar_type":"gradient","esp_material":false,"esp_material_value":"Neon","esp_name":true,"esp_name_color1":{"Color":"ffffff","Transparency":0},"esp_name_color2":{"Color":"ffffff","Transparency":0},"esp_name_color3":{"Color":"ffffff","Transparency":0},"esp_name_rotation":0,"esp_name_type":"Name","esp_override_appearance":false,"esp_show_team":false,"esp_skeleton":true,"esp_skeleton_color1":{"Color":"ffffff","Transparency":0},"esp_skeleton_color2":{"Color":"ffffff","Transparency":0},"esp_skeleton_color3":{"Color":"ffffff","Transparency":0},"esp_skeleton_outline":false,"esp_skeleton_thickness":1,"esp_weapon":true,"esp_weapon_color1":{"Color":"ffffff","Transparency":0},"esp_weapon_color2":{"Color":"ffffff","Transparency":0},"esp_weapon_color3":{"Color":"ffffff","Transparency":0},"esp_weapon_rotation":0,"esp_world_distance":true,"esp_world_distance_color":{"Color":"ffffff","Transparency":0},"esp_world_font":"proggy tiny","esp_world_image":true,"esp_world_name":true,"esp_world_name_color":{"Color":"ffffff","Transparency":0},"esp_world_object_scale":75,"esp_world_whitelist":["Flashbang","Smoke Grenade","Satchel","Subspace Tripmine","Molotov","Grenade"],"exploits_always_backstab":true,"fakepos_key":{"active":true,"key":"NONE","mode":"Always"},"firerate_multiplier":6.7,"fly_enabled":true,"flyvalue":100,"fov_lerp":25,"fov_moving_rotation":true,"fov_outline":true,"fov_outline_color":{"Color":"c576bd","Transparency":0.7863636363636364},"fov_outline_color2":{"Color":"e38cde","Transparency":0.7},"fov_outline_color3":{"Color":"f296ee","Transparency":0.2681818181818182},"fov_position":"position on screen","fov_rotation":0,"fov_rotation_speed":10,"full_auto_enabled":true,"game_crosshair":true,"hit_effects_col_1":{"Color":"ffffff","Transparency":0},"hit_effects_col_2":{"Color":"f6b9f4","Transparency":0},"hit_effects_col_3":{"Color":"f296ee","Transparency":0},"hit_effects_disable_marker":true,"hit_effects_disable_numbers":true,"hit_effects_enabled":true,"hit_effects_material":"ForceField","hit_effects_selected":["Electricity","phantom forces"],"hit_effects_settings":[],"hit_effects_weld":false,"hit_notifications_enabled":false,"hit_notify_duration":1,"hit_sounds_disable":true,"hit_sounds_enabled":true,"hit_sounds_selected":"sparkle","hit_sounds_volume":0.9,"indicator_ammo":true,"indicator_ammo_color":{"Color":"ffffff","Transparency":0},"indicator_ammo_divider_color":{"Color":"f296ee","Transparency":0},"indicator_ammo_max_color":{"Color":"ffffff","Transparency":0},"indicator_ammo_style":["ammo","max ammo","reserve"],"indicator_font":"proggy tiny","indicator_lerp":0.25,"indicator_manipulated":true,"indicator_manipulated_color":{"Color":"ffffff","Transparency":0},"indicator_offset_x":0,"indicator_offset_y":25,"indicator_ragebot":true,"indicator_ragebot_status_color":{"Color":"ffffff","Transparency":0},"indicator_ragebot_style":["status","text"],"indicator_ragebot_text_color":{"Color":"f296ee","Transparency":0},"indicator_reserve_color":{"Color":"ffffff","Transparency":0},"indicator_settings":[],"indicator_text_style":"lower","item_remove_vignette":true,"item_status_enabled":true,"item_status_override":"Prime","manipulation_enabled":true,"matchmaking_mode":"1v1","movement_double_jump":true,"movement_double_jump_height":2,"movement_slideboost":true,"movement_slideboost_value":2.5,"no_spread_enabled":true,"noclip_key":{"active":false,"key":"Enum.KeyCode.X","mode":"Toggle"},"pitch_type":"Random","ragebot_enabled":true,"ragebot_key":{"active":true,"key":"NONE","mode":"Always"},"ragebot_method":"Lite","ragebot_mode":"gun","ragebot_priority":true,"ragebot_priority_notification":true,"ragebot_priority_settings":["voided players","attackers"],"ragebot_settings":["swap weapons when empty"],"ragebot_weapon":"primary","shoot_sound_change":true,"shoot_sound_change_value":"crossbow","shoot_sound_speed":1,"shoot_sound_start":0,"shoot_sound_volume":1,"silent_aim_enabled":true,"silent_aim_range":300,"silent_aim_range_color":{"Color":"ffffff","Transparency":1},"silent_aim_range_color2":{"Color":"e4c4ca","Transparency":0},"silent_aim_range_color3":{"Color":"d7a6c3","Transparency":0},"silent_aim_visualise_filled_range":true,"silent_aim_visualise_range":true,"silent_closest_part":false,"silent_hitchance":100,"silent_key":{"active":true,"key":"Enum.KeyCode.LeftAlt","mode":"Always"},"silent_visualize":true,"silent_wallbang":false,"spoof_device_type":"Controller","stretch_enabled":false,"target_highlight":false,"target_highlight_fill":{"Color":"ffffff","Transparency":0},"target_highlight_outline":{"Color":"ffffff","Transparency":0},"target_highlight_type":"AlwaysOnTop","target_tracer":false,"target_tracer_customization":{"Color":"ffffff","Transparency":0},"targeting_disableflash":false,"targeting_ignore_protected_settings":["blocked by riot shield","katana deflecting"],"targeting_limitdistance":false,"targeting_maxdistance":250,"targeting_part":"Head","third_person_enabled":true,"third_person_key":{"active":false,"key":"Enum.KeyCode.H","mode":"Toggle"},"trigger_distance":250,"trigger_enabled":false,"trigger_forget_time":1.5,"trigger_key":{"active":false,"key":"Enum.UserInputType.MouseButton2","mode":"Hold"},"trigger_part_blacklist":[],"trigger_reaction":25,"trigger_reaction_offset":5,"trigger_scoped":["Sniper","Crossbow"],"trigger_shoot_delay":0,"velocity_key":{"active":true,"key":"Enum.KeyCode.G","mode":"Always"},"viewmodel_chams":true,"viewmodel_chams_alpha_fill":-1.6,"viewmodel_chams_alpha_outline":1,"viewmodel_chams_color":{"Color":"000000","Transparency":0},"viewmodel_chams_color2":{"Color":"d8e9ff","Transparency":0},"viewmodel_chams_settings":["through walls"],"viewmodel_frames_override":false,"viewmodel_frames_value":1,"viewmodel_offset":true,"viewmodel_offset_x":0,"viewmodel_offset_y":0,"viewmodel_offset_z":-0.7,"viewmodel_options":["tilt","aiming animation","sway","equip animation","bobbing","jump animation","muzzle flash","shoot animation","idle animation","sprint animation","slide animation"],"viewmodel_recoil":0,"voidspam_enabled":true,"voidspam_hide_time":0.25,"voidspam_shoot_attempts":2,"voidspam_shoot_time":0.01,"world_ambience_enabled":true,"world_ambience_type":"Rain","world_ambience_volume":50,"world_atm_decay":{"Color":"fecaff","Transparency":0},"world_atm_density":0.4,"world_atm_enabled":true,"world_atm_glare":4.1,"world_atm_haze":10,"world_atm_offset":0.4,"world_atm_tint":{"Color":"ffc8fd","Transparency":0},"world_bloom_enabled":true,"world_bloom_intensity":1.38,"world_bloom_size":50,"world_bloom_threshold":0.85,"world_blur_enabled":false,"world_cc_brightness":-0.09,"world_cc_contrast":0,"world_cc_enabled":true,"world_cc_saturation":1,"world_cc_tint":{"Color":"ffffff","Transparency":0},"world_ltg_ambient":true,"world_ltg_ambient_color":{"Color":"ffffff","Transparency":0},"world_ltg_brightness":true,"world_ltg_brightness_val":1.7,"world_ltg_clock":true,"world_ltg_clock_val":0,"world_ltg_colorshift_bottom":true,"world_ltg_colorshift_bottom_color":{"Color":"ffffff","Transparency":0},"world_ltg_colorshift_top":false,"world_ltg_colorshift_top_color":{"Color":"ffffff","Transparency":0},"world_ltg_exposure":true,"world_ltg_exposure_val":-1.1,"world_ltg_fog_color":{"Color":"ffffff","Transparency":0},"world_ltg_fog_color_enabled":false,"world_ltg_fog_end":false,"world_ltg_fog_end_val":2500,"world_ltg_fog_start":false,"world_ltg_fog_start_val":0,"world_ltg_shadows":true,"world_skybox_enabled":true,"world_skybox_mode":"Heaven","world_sunrays_enabled":false,"world_sunrays_intensity":0.25,"world_sunrays_spread":1,"world_weather_color":{"Color":"ffffff","Transparency":0},"world_weather_color_end":{"Color":"ffffff","Transparency":0},"world_weather_color_mid":{"Color":"ffffff","Transparency":0},"world_weather_density":100,"world_weather_enabled":true,"world_weather_lifetime":100,"world_weather_timescale":1,"world_weather_type":"Rain","yaw_type":"Random"}]==],
    ["[RAGE] Halloween"] = [==[{"movement_maul_slam":false,"AntiAim_enabled":true,"AntiFlash":true,"AntiSmoke":true,"FakePosition":false,"FakePositionPanic":false,"FakePositionWalk":false,"FilledFov_Color1":{"Color":"ff7a1a","Transparency":0.94},"FilledFov_Color2":{"Color":"ff7a1a","Transparency":0.85},"FilledFov_Color3":{"Color":"ff7a1a","Transparency":0.94},"HideHead_enabled":true,"InfiniteJump":true,"IsInvincible":true,"NoBobbing":false,"Noclip":false,"RapidBody_enabled":false,"SilentaimDropdown_":[],"VelocitySpeedEnabled":false,"aimbot_enabled":false,"aimbot_fov_settings":[],"anti_aim_enabled":false,"anti_flash_keep_sound":true,"antiaim_speed":100,"arm_override_appearance":false,"camera_fov_amount":100,"camera_fov_enabled":true,"crosshair_bounce":5,"crosshair_bounce_speed":2.9,"crosshair_color_1":{"Color":"ff7a1a","Transparency":0},"crosshair_color_2":{"Color":"ff6a0f","Transparency":0},"crosshair_color_3":{"Color":"f25a00","Transparency":0},"crosshair_color_4":{"Color":"a855f7","Transparency":0},"crosshair_enabled":true,"crosshair_length":13,"crosshair_lerp":0.25,"crosshair_offset":5,"crosshair_outline":true,"crosshair_outline_color_1":{"Color":"000000","Transparency":0},"crosshair_outline_color_2":{"Color":"000000","Transparency":0},"crosshair_outline_color_3":{"Color":"000000","Transparency":0},"crosshair_outline_color_4":{"Color":"000000","Transparency":0},"crosshair_rotation":0,"crosshair_rotation_speed":0.2,"crosshair_settings":["position on target"],"crosshair_thickness":2,"custom_tracer_color":{"Color":"ff7a1a","Transparency":0},"custom_tracer_color2":{"Color":"a855f7","Transparency":0},"custom_tracer_emission":1,"custom_tracer_enabled":true,"custom_tracer_fade":1,"custom_tracer_glow":4,"custom_tracer_length":4,"custom_tracer_lifetime":1,"custom_tracer_outline":false,"custom_tracer_position_lerp":0.5,"custom_tracer_selected":"lightning","custom_tracer_speed":2,"custom_tracer_width":0.2,"esp_body_color":false,"esp_bounds_type":"dynamic","esp_bounds_width_scale":100,"esp_box":false,"esp_chams":true,"esp_chams_alpha_fill":-1,"esp_chams_alpha_outline":1,"esp_chams_color":{"Color":"000000","Transparency":0},"esp_chams_color2":{"Color":"a855f7","Transparency":0},"esp_chams_settings":["through walls"],"esp_distance":true,"esp_distance_color1":{"Color":"ffffff","Transparency":0},"esp_distance_color2":{"Color":"ffffff","Transparency":0},"esp_distance_color3":{"Color":"ffffff","Transparency":0},"esp_effects_aura":false,"esp_effects_particle":true,"esp_effects_particle_color1":{"Color":"ff7a1a","Transparency":0},"esp_effects_particle_color2":{"Color":"a855f7","Transparency":0},"esp_effects_particle_color3":{"Color":"7e22ce","Transparency":0},"esp_effects_particle_value":["glowing"],"esp_fill":false,"esp_flag_health_text":false,"esp_flag_staring_text":true,"esp_font":"proggy tiny","esp_healthbar":true,"esp_healthbar_color_end":{"Color":"4c1d95","Transparency":0},"esp_healthbar_color_middle":{"Color":"7e22ce","Transparency":0},"esp_healthbar_color_start":{"Color":"ffc285","Transparency":0},"esp_healthbar_health_lerp":0.05,"esp_healthbar_moving":false,"esp_healthbar_resize":false,"esp_healthbar_type":"gradient","esp_material":false,"esp_name":true,"esp_name_color1":{"Color":"ffffff","Transparency":0},"esp_name_color2":{"Color":"ffc285","Transparency":0},"esp_name_color3":{"Color":"ff7a1a","Transparency":0},"esp_name_font":"default","esp_name_type":"Name","esp_override_appearance":false,"esp_round_only":true,"esp_show_team":false,"esp_skeleton":true,"esp_skeleton_color1":{"Color":"ffffff","Transparency":0},"esp_skeleton_color2":{"Color":"ffffff","Transparency":0},"esp_skeleton_color3":{"Color":"ffffff","Transparency":0},"esp_skeleton_outline":false,"esp_skeleton_thickness":1,"esp_weapon":true,"esp_weapon_color1":{"Color":"ffffff","Transparency":0},"esp_weapon_color2":{"Color":"ffffff","Transparency":0},"esp_weapon_color3":{"Color":"ffffff","Transparency":0},"esp_world_distance":true,"esp_world_distance_color":{"Color":"ff7a1a","Transparency":0},"esp_world_font":"proggy tiny","esp_world_image":true,"esp_world_name":true,"esp_world_name_color":{"Color":"ffffff","Transparency":0},"esp_world_object_scale":75,"esp_world_whitelist":["Flashbang","Smoke Grenade","Satchel","Subspace Tripmine","Molotov","Grenade"],"exploits_always_backstab":true,"faster_reload":true,"fly_enabled":false,"fov_fill_speed":100,"fov_fill_style":"Inner Fade","fov_lerp":25,"fov_moving_rotation":true,"fov_outline":true,"fov_outline_color":{"Color":"ff7a1a","Transparency":0.84},"fov_outline_color2":{"Color":"ffc285","Transparency":0.7},"fov_outline_color3":{"Color":"ffc285","Transparency":0.25},"fov_outline_thickness":2,"fov_position":"position on screen","fov_rotation":0,"fov_rotation_speed":10,"full_auto_enabled":true,"game_crosshair":true,"grenade_options":["explode on impact"],"hit_effects_col_1":{"Color":"ffffff","Transparency":0},"hit_effects_col_2":{"Color":"ff7a1a","Transparency":0},"hit_effects_col_3":{"Color":"a855f7","Transparency":0},"hit_effects_disable_marker":true,"hit_effects_disable_numbers":true,"hit_effects_enabled":true,"hit_effects_material":"ForceField","hit_effects_selected":["Electricity","phantom forces"],"hit_effects_settings":["stack damage together"],"hit_effects_weld":false,"hit_notifications_enabled":true,"hit_notify_duration":1.3,"hit_sounds_disable":true,"hit_sounds_enabled":true,"hit_sounds_selected":"sparkle","hit_sounds_volume":0.9,"hitmarker_enabled":false,"indicator_ammo":true,"indicator_ammo_color":{"Color":"ffffff","Transparency":0},"indicator_ammo_divider_color":{"Color":"a855f7","Transparency":0},"indicator_ammo_max_color":{"Color":"ffffff","Transparency":0},"indicator_ammo_style":["ammo","max ammo","reserve","\"out of ammo\" if empty"],"indicator_empty_color":{"Color":"ff5f5f","Transparency":0},"indicator_font":"proggy tiny","indicator_lerp":0.25,"indicator_manipulated":true,"indicator_manipulated_color":{"Color":"a855f7","Transparency":0},"indicator_offset_x":0,"indicator_offset_y":25,"indicator_ragebot":true,"indicator_ragebot_status_color":{"Color":"ffffff","Transparency":0},"indicator_ragebot_style":["text","status"],"indicator_ragebot_text_color":{"Color":"a855f7","Transparency":0},"indicator_reserve_color":{"Color":"ff7a1a","Transparency":0},"indicator_settings":[],"indicator_text_style":"lower","instant_aim_enabled":true,"item_remove_vignette":true,"item_status_enabled":true,"item_status_override":"Prime","manipulation_enabled":true,"movement_double_jump":false,"movement_slideboost":true,"movement_slideboost_value":2.5,"no_fire_sound":false,"no_muzzle_flash":false,"no_recoil_enabled":true,"no_spread_enabled":true,"pitch_type":"Up & Down","quickequip":true,"ragebot_enabled":true,"ragebot_method":"Lite","ragebot_mode":"gun","ragebot_priority":true,"ragebot_priority_notification":true,"ragebot_priority_settings":["attackers","voided players"],"ragebot_settings":["swap weapons when empty"],"ragebot_weapon":"primary","shoot_sound_change":true,"shoot_sound_change_value":"crossbow","shoot_sound_speed":1,"shoot_sound_start":0,"shoot_sound_volume":0.6,"silent_aim_enabled":true,"silent_aim_range":300,"silent_aim_range_color":{"Color":"ffffff","Transparency":0},"silent_aim_range_color2":{"Color":"ffc285","Transparency":0},"silent_aim_range_color3":{"Color":"ff7a1a","Transparency":0},"silent_aim_target_mode":"FOV - Closest","silent_aim_visualise_filled_range":true,"silent_aim_visualise_range":true,"silent_closest_part":false,"silent_hitchance":100,"silent_visualize":true,"silent_wallbang":true,"stretch_enabled":false,"target_highlight":true,"target_highlight_fill":{"Color":"a855f7","Transparency":0.6},"target_highlight_outline":{"Color":"ff7a1a","Transparency":0},"target_highlight_type":"AlwaysOnTop","target_method_ragebot":"Closest","target_tracer":true,"target_tracer_customization":{"Color":"a855f7","Transparency":0},"target_ui_enabled":true,"target_ui_item_scale":170,"target_ui_position_x":50,"target_ui_position_y":72,"target_ui_scale":150,"targeting_ignore_protected_settings":["blocked by riot shield","katana deflecting"],"targeting_limitdistance":false,"targeting_part":"Head","third_person_enabled":true,"trigger_enabled":false,"viewmodel_chams":true,"viewmodel_chams_alpha_fill":-1.2,"viewmodel_chams_alpha_outline":1,"viewmodel_chams_color":{"Color":"000000","Transparency":0},"viewmodel_chams_color2":{"Color":"ffd9b3","Transparency":0},"viewmodel_chams_settings":["through walls"],"viewmodel_frames_override":false,"viewmodel_offset":true,"viewmodel_offset_x":0,"viewmodel_offset_y":0,"viewmodel_offset_z":-0.5,"viewmodel_options":["sway","bobbing","muzzle flash","idle animation","jump animation","slide animation","sprint animation","shoot animation","tilt","aiming animation","equip animation"],"viewmodel_override_appearance":false,"viewmodel_recoil":0,"viewmodel_scale_enabled":false,"viewmodel_wire_enabled":false,"voidspam_enabled":true,"voidspam_hide_time":0.25,"voidspam_shoot_attempts":2,"voidspam_shoot_time":0.01,"wallbang_method":"Classic V1","world_ambience_enabled":true,"world_ambience_type":"Thunder","world_ambience_volume":30,"world_atm_decay":{"Color":"3b0764","Transparency":0},"world_atm_density":0.38,"world_atm_enabled":true,"world_atm_glare":2.5,"world_atm_haze":2.2,"world_atm_offset":0.35,"world_atm_tint":{"Color":"ff8c42","Transparency":0},"world_bloom_enabled":true,"world_bloom_intensity":1.2,"world_bloom_size":40,"world_bloom_threshold":0.9,"world_blur_enabled":false,"world_cc_brightness":-0.08,"world_cc_contrast":0.18,"world_cc_enabled":true,"world_cc_saturation":0.3,"world_cc_tint":{"Color":"ffd9b8","Transparency":0},"world_dof_enabled":false,"world_env_enabled":false,"world_ltg_ambient":true,"world_ltg_ambient_color":{"Color":"5b2186","Transparency":0},"world_ltg_brightness":true,"world_ltg_brightness_val":2,"world_ltg_clock":true,"world_ltg_clock_val":0.5,"world_ltg_colorshift_bottom":true,"world_ltg_colorshift_bottom_color":{"Color":"7e22ce","Transparency":0},"world_ltg_colorshift_top":true,"world_ltg_colorshift_top_color":{"Color":"ff7518","Transparency":0},"world_ltg_exposure":true,"world_ltg_exposure_val":-0.6,"world_ltg_fog_color_enabled":false,"world_ltg_fog_end":false,"world_ltg_fog_start":false,"world_ltg_shadows":true,"world_marker_enabled":false,"world_shadow_soft_enabled":true,"world_shadow_soft_val":25,"world_sky_autorotate":false,"world_sky_celestial":false,"world_skybox_disable":[],"world_skybox_enabled":true,"world_skybox_mode":"PurpleNight","world_sunrays_enabled":false,"world_sunrays_intensity":0.2,"world_sunrays_spread":1,"world_weather_color":{"Color":"ff9a3c","Transparency":0},"world_weather_color_end":{"Color":"4c1d95","Transparency":0},"world_weather_color_mid":{"Color":"ff6a00","Transparency":0},"world_weather_density":45,"world_weather_enabled":true,"world_weather_lifetime":100,"world_weather_opacity":85,"world_weather_size":110,"world_weather_speed":80,"world_weather_timescale":1,"world_weather_type":"Ash","yaw_type":"Random","cosmetics_changer_save_data":"{\"Assault Rifle\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true,\"name\":\"Boneclaw Rifle\"},\"wrap\":{\"enabled\":true}},\"Battle Axe\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Hallow\"}},\"Bow\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true,\"name\":\"Bat Bow\"},\"wrap\":{\"enabled\":true}},\"Burst Rifle\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true,\"name\":\"Spectral Burst\"},\"wrap\":{\"enabled\":true}},\"Chainsaw\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Hallow\"}},\"Crossbow\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true,\"name\":\"Crossbone\"},\"wrap\":{\"enabled\":true}},\"Daggers\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true,\"name\":\"Bat Daggers\"},\"wrap\":{\"enabled\":true}},\"Distortion\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Hallow\"}},\"Energy Pistols\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true,\"name\":\"Soul Pistols\"},\"wrap\":{\"enabled\":true}},\"Energy Rifle\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true,\"name\":\"Soul Rifle\"},\"wrap\":{\"enabled\":true}},\"Exogun\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true,\"name\":\"Exogourd\"},\"wrap\":{\"enabled\":true}},\"Fists\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true,\"name\":\"Pumpkin Claws\"},\"wrap\":{\"enabled\":true}},\"Flamethrower\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true,\"name\":\"Jack O'Thrower\"},\"wrap\":{\"enabled\":true}},\"Flare Gun\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true,\"name\":\"Vexed Flare Gun\"},\"wrap\":{\"enabled\":true}},\"Flashbang\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true,\"name\":\"Skullbang\"},\"wrap\":{\"enabled\":true}},\"Freeze Ray\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true,\"name\":\"Spider Ray\"},\"wrap\":{\"enabled\":true}},\"Grappler\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Hallow\"}},\"Grenade\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true,\"name\":\"Soul Grenade\"},\"wrap\":{\"enabled\":true}},\"Grenade Launcher\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true,\"name\":\"Skull Launcher\"},\"wrap\":{\"enabled\":true}},\"Gunblade\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true,\"name\":\"Boneblade\"},\"wrap\":{\"enabled\":true}},\"Handgun\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true,\"name\":\"Pumpkin Handgun\"},\"wrap\":{\"enabled\":true}},\"Jump Pad\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true,\"name\":\"Spider Web\"},\"wrap\":{\"enabled\":true}},\"Katana\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true,\"name\":\"Evil Trident\"},\"wrap\":{\"enabled\":true}},\"Knife\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Hallow\"}},\"Maul\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Hallow\"}},\"Medkit\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true,\"name\":\"Bucket of Candy\"},\"wrap\":{\"enabled\":true}},\"Minigun\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true,\"name\":\"Pumpkin Minigun\"},\"wrap\":{\"enabled\":true}},\"Molotov\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true,\"name\":\"Vexed Candle\"},\"wrap\":{\"enabled\":true}},\"Paintball Gun\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Hallow\"}},\"Permafrost\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Hallow\"}},\"RPG\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true,\"name\":\"Pumpkin Launcher\"},\"wrap\":{\"enabled\":true}},\"Revolver\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true,\"name\":\"Boneclaw Revolver\"},\"wrap\":{\"enabled\":true}},\"Riot Shield\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true,\"name\":\"Tombstone Shield\"},\"wrap\":{\"enabled\":true}},\"Satchel\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true,\"name\":\"Potion Satchel\"},\"wrap\":{\"enabled\":true}},\"Scythe\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true,\"name\":\"Bat Scythe\"},\"wrap\":{\"enabled\":true}},\"Shorty\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true,\"name\":\"Demon Shorty\"},\"wrap\":{\"enabled\":true}},\"Shotgun\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true,\"name\":\"Broomstick\"},\"wrap\":{\"enabled\":true}},\"Slingshot\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true,\"name\":\"Boneshot\"},\"wrap\":{\"enabled\":true}},\"Smoke Grenade\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true,\"name\":\"Eyeball\"},\"wrap\":{\"enabled\":true}},\"Sniper\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true,\"name\":\"Eyething Sniper\"},\"wrap\":{\"enabled\":true}},\"Spear\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Hallow\"}},\"Spray\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true,\"name\":\"Boneclaw Spray\"},\"wrap\":{\"enabled\":true}},\"Subspace Tripmine\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true,\"name\":\"Trick or Treat\"},\"wrap\":{\"enabled\":true}},\"Trowel\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true,\"name\":\"Pumpkin Carver\"},\"wrap\":{\"enabled\":true}},\"Uzi\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true,\"name\":\"Demon Uzi\"},\"wrap\":{\"enabled\":true}},\"War Horn\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true,\"name\":\"Boneclaw Horn\"},\"wrap\":{\"enabled\":true}},\"Warper\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Hallow\"}},\"Warpstone\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true,\"name\":\"Warpbone\"},\"wrap\":{\"enabled\":true}},\"Wildcat\":{\"charm\":{\"enabled\":true,\"name\":\"Pumpkin Cat\"},\"finisher\":{\"enabled\":true,\"name\":\"Reaper\"},\"skin\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Hallow\"}}}"}]==],
    ["[LEGIT] Ocean"] = [==[{"movement_maul_slam":false,"AimbotFilledFov_Color1":{"Color":"38bdf8","Transparency":0.94},"AimbotFilledFov_Color2":{"Color":"38bdf8","Transparency":0.85},"AimbotFilledFov_Color3":{"Color":"38bdf8","Transparency":0.94},"AimlockDropdown_":[],"AntiAim_enabled":false,"AntiFlash":true,"AntiSmoke":false,"FakePosition":false,"FakePositionPanic":false,"FakePositionWalk":false,"FilledFov_Color1":{"Color":"38bdf8","Transparency":0.94},"FilledFov_Color2":{"Color":"38bdf8","Transparency":0.85},"FilledFov_Color3":{"Color":"38bdf8","Transparency":0.94},"HideHead_enabled":false,"InfiniteJump":false,"IsInvincible":true,"NoBobbing":false,"Noclip":false,"RapidBody_enabled":false,"SilentaimDropdown_":[],"TriggerbotDropdown_":["no delay between targets"],"VelocitySpeedEnabled":false,"aim_lock_range":100,"aimbot_closest_part":false,"aimbot_closest_position":false,"aimbot_delay_position":true,"aimbot_enabled":false,"aimbot_fov_lerp":25,"aimbot_fov_moving_rotation":false,"aimbot_fov_outline":true,"aimbot_fov_outline_color":{"Color":"38bdf8","Transparency":0.84},"aimbot_fov_outline_color2":{"Color":"7dd3fc","Transparency":0.7},"aimbot_fov_outline_color3":{"Color":"7dd3fc","Transparency":0.25},"aimbot_fov_outline_thickness":2,"aimbot_fov_settings":[],"aimbot_hitmethod":"Camera","aimbot_jump_smooth":18,"aimbot_range_color":{"Color":"ffffff","Transparency":0},"aimbot_range_color2":{"Color":"7dd3fc","Transparency":0},"aimbot_range_color3":{"Color":"38bdf8","Transparency":0},"aimbot_smoothing":12,"aimbot_visualise_filled_range":false,"aimbot_visualise_range":false,"aimbot_x_smooth":10,"aimbot_y_smooth":10,"aimlock_delay":0,"aimlock_jitter":0,"aimlock_trigger":"Aiming","aimlock_wallcheck":true,"anti_aim_enabled":false,"anti_flash_keep_sound":true,"arm_override_appearance":false,"camera_fov_amount":95,"camera_fov_enabled":true,"crosshair_bounce":0,"crosshair_bounce_speed":2.9,"crosshair_color_1":{"Color":"4cc9f0","Transparency":0},"crosshair_color_2":{"Color":"22b8e6","Transparency":0},"crosshair_color_3":{"Color":"0ea5e9","Transparency":0},"crosshair_color_4":{"Color":"0891d1","Transparency":0},"crosshair_enabled":true,"crosshair_length":8,"crosshair_lerp":0.25,"crosshair_offset":2,"crosshair_outline":true,"crosshair_outline_color_1":{"Color":"000000","Transparency":0},"crosshair_outline_color_2":{"Color":"000000","Transparency":0},"crosshair_outline_color_3":{"Color":"000000","Transparency":0},"crosshair_outline_color_4":{"Color":"000000","Transparency":0},"crosshair_rotation":45,"crosshair_rotation_speed":0,"crosshair_settings":[],"crosshair_thickness":2,"custom_tracer_color":{"Color":"38bdf8","Transparency":0},"custom_tracer_color2":{"Color":"0284c7","Transparency":0},"custom_tracer_emission":1,"custom_tracer_enabled":true,"custom_tracer_fade":1,"custom_tracer_glow":5,"custom_tracer_length":4,"custom_tracer_lifetime":1,"custom_tracer_outline":false,"custom_tracer_position_lerp":0.5,"custom_tracer_selected":"drawing","custom_tracer_speed":2,"custom_tracer_width":0.2,"esp_body_color":false,"esp_bounds_type":"dynamic","esp_bounds_width_scale":100,"esp_box":false,"esp_chams":true,"esp_chams_alpha_fill":-1,"esp_chams_alpha_outline":1,"esp_chams_color":{"Color":"000000","Transparency":0},"esp_chams_color2":{"Color":"0284c7","Transparency":0},"esp_chams_settings":[],"esp_distance":true,"esp_distance_color1":{"Color":"ffffff","Transparency":0},"esp_distance_color2":{"Color":"ffffff","Transparency":0},"esp_distance_color3":{"Color":"ffffff","Transparency":0},"esp_effects_aura":false,"esp_effects_particle":true,"esp_effects_particle_color1":{"Color":"38bdf8","Transparency":0},"esp_effects_particle_color2":{"Color":"0284c7","Transparency":0},"esp_effects_particle_color3":{"Color":"0ea5e9","Transparency":0},"esp_effects_particle_value":["glowing"],"esp_fill":false,"esp_flag_health_text":false,"esp_flag_staring_text":false,"esp_font":"proggy tiny","esp_healthbar":true,"esp_healthbar_color_end":{"Color":"0c4a6e","Transparency":0},"esp_healthbar_color_middle":{"Color":"0ea5e9","Transparency":0},"esp_healthbar_color_start":{"Color":"7dd3fc","Transparency":0},"esp_healthbar_health_lerp":0.05,"esp_healthbar_moving":false,"esp_healthbar_resize":false,"esp_healthbar_type":"gradient","esp_material":false,"esp_name":true,"esp_name_color1":{"Color":"ffffff","Transparency":0},"esp_name_color2":{"Color":"7dd3fc","Transparency":0},"esp_name_color3":{"Color":"38bdf8","Transparency":0},"esp_name_font":"default","esp_name_type":"Name","esp_override_appearance":false,"esp_round_only":true,"esp_show_team":false,"esp_skeleton":true,"esp_skeleton_color1":{"Color":"ffffff","Transparency":0},"esp_skeleton_color2":{"Color":"ffffff","Transparency":0},"esp_skeleton_color3":{"Color":"ffffff","Transparency":0},"esp_skeleton_outline":false,"esp_skeleton_thickness":1,"esp_weapon":true,"esp_weapon_color1":{"Color":"ffffff","Transparency":0},"esp_weapon_color2":{"Color":"ffffff","Transparency":0},"esp_weapon_color3":{"Color":"ffffff","Transparency":0},"esp_world_distance":true,"esp_world_distance_color":{"Color":"38bdf8","Transparency":0},"esp_world_font":"proggy tiny","esp_world_image":true,"esp_world_name":true,"esp_world_name_color":{"Color":"ffffff","Transparency":0},"esp_world_object_scale":75,"esp_world_whitelist":["Flashbang","Smoke Grenade","Satchel","Subspace Tripmine","Molotov","Grenade"],"exploits_always_backstab":false,"faster_reload":false,"fly_enabled":false,"fov_fill_speed":100,"fov_fill_style":"Inner Fade","fov_lerp":25,"fov_moving_rotation":true,"fov_outline":true,"fov_outline_color":{"Color":"38bdf8","Transparency":0.84},"fov_outline_color2":{"Color":"7dd3fc","Transparency":0.7},"fov_outline_color3":{"Color":"7dd3fc","Transparency":0.25},"fov_outline_thickness":2,"fov_position":"position on screen","fov_rotation":0,"fov_rotation_speed":10,"full_auto_enabled":true,"game_crosshair":true,"grenade_options":["explode on impact"],"hit_effects_col_1":{"Color":"ffffff","Transparency":0},"hit_effects_col_2":{"Color":"38bdf8","Transparency":0},"hit_effects_col_3":{"Color":"0284c7","Transparency":0},"hit_effects_disable_marker":true,"hit_effects_disable_numbers":true,"hit_effects_enabled":true,"hit_effects_material":"ForceField","hit_effects_selected":["slashes","phantom forces"],"hit_effects_settings":["stack damage together"],"hit_effects_weld":false,"hit_notifications_enabled":false,"hit_sounds_disable":true,"hit_sounds_enabled":true,"hit_sounds_selected":"impact","hit_sounds_volume":0.9,"hitmarker_enabled":false,"indicator_ammo":true,"indicator_ammo_color":{"Color":"ffffff","Transparency":0},"indicator_ammo_divider_color":{"Color":"4cc9f0","Transparency":0},"indicator_ammo_max_color":{"Color":"ffffff","Transparency":0},"indicator_ammo_style":["ammo","max ammo","reserve","\"out of ammo\" if empty"],"indicator_empty_color":{"Color":"ff5f5f","Transparency":0},"indicator_font":"proggy tiny","indicator_lerp":0.25,"indicator_manipulated":false,"indicator_manipulated_color":{"Color":"4cc9f0","Transparency":0},"indicator_offset_x":0,"indicator_offset_y":25,"indicator_ragebot":false,"indicator_ragebot_status_color":{"Color":"ffffff","Transparency":0},"indicator_ragebot_style":["text","status"],"indicator_ragebot_text_color":{"Color":"4cc9f0","Transparency":0},"indicator_reserve_color":{"Color":"38bdf8","Transparency":0},"indicator_settings":[],"indicator_text_style":"lower","instant_aim_enabled":false,"item_remove_vignette":true,"item_status_enabled":true,"item_status_override":"Prime","manipulation_enabled":false,"movement_double_jump":false,"movement_slideboost":true,"movement_slideboost_value":1.1,"no_fire_sound":false,"no_muzzle_flash":false,"no_recoil_enabled":false,"no_spread_enabled":false,"quickequip":false,"ragebot_enabled":false,"shoot_sound_change":true,"shoot_sound_change_value":"bow","shoot_sound_speed":1,"shoot_sound_start":0,"shoot_sound_volume":0.3,"silent_aim_enabled":true,"silent_aim_range":110,"silent_aim_range_color":{"Color":"ffffff","Transparency":0},"silent_aim_range_color2":{"Color":"7dd3fc","Transparency":0},"silent_aim_range_color3":{"Color":"38bdf8","Transparency":0},"silent_aim_target_mode":"FOV - Closest","silent_aim_visualise_filled_range":true,"silent_aim_visualise_range":true,"silent_closest_part":true,"silent_hitchance":35,"silent_visualize":true,"silent_wallbang":false,"stretch_enabled":false,"target_highlight":false,"target_highlight_fill":{"Color":"0284c7","Transparency":0.6},"target_highlight_outline":{"Color":"38bdf8","Transparency":0},"target_highlight_type":"AlwaysOnTop","target_tracer":false,"target_tracer_customization":{"Color":"0284c7","Transparency":0},"target_ui_enabled":true,"target_ui_item_scale":170,"target_ui_position_x":50,"target_ui_position_y":72,"target_ui_scale":150,"targeting_ignore_protected_settings":["blocked by riot shield","katana deflecting"],"targeting_limitdistance":false,"targeting_part":"Head","third_person_enabled":false,"trigger_distance":250,"trigger_enabled":true,"trigger_forget_time":1.5,"trigger_part_blacklist":[],"trigger_reaction":25,"trigger_reaction_offset":5,"trigger_scoped":["Sniper","Crossbow"],"trigger_shoot_delay":0,"viewmodel_chams":true,"viewmodel_chams_alpha_fill":-0.6,"viewmodel_chams_alpha_outline":1,"viewmodel_chams_color":{"Color":"000000","Transparency":0},"viewmodel_chams_color2":{"Color":"bae6fd","Transparency":0},"viewmodel_chams_settings":["through walls"],"viewmodel_frames_override":false,"viewmodel_offset":true,"viewmodel_offset_x":0,"viewmodel_offset_y":0,"viewmodel_offset_z":-0.5,"viewmodel_options":["sway","bobbing","muzzle flash","idle animation","jump animation","slide animation","sprint animation","shoot animation"],"viewmodel_override_appearance":false,"viewmodel_recoil":0,"viewmodel_scale_enabled":false,"viewmodel_wire_enabled":false,"voidspam_enabled":false,"wallbang_method":"Classic V1","world_ambience_enabled":false,"world_ambience_type":"Rain","world_ambience_volume":35,"world_atm_decay":{"Color":"0c4a6e","Transparency":0},"world_atm_density":0.32,"world_atm_enabled":true,"world_atm_glare":2.2,"world_atm_haze":1.8,"world_atm_offset":0.4,"world_atm_tint":{"Color":"9fd8ff","Transparency":0},"world_bloom_enabled":true,"world_bloom_intensity":1.1,"world_bloom_size":36,"world_bloom_threshold":0.92,"world_blur_enabled":false,"world_cc_brightness":-0.02,"world_cc_contrast":0.1,"world_cc_enabled":true,"world_cc_saturation":0.2,"world_cc_tint":{"Color":"d9f1ff","Transparency":0},"world_dof_enabled":false,"world_env_enabled":false,"world_ltg_ambient":true,"world_ltg_ambient_color":{"Color":"c7e9ff","Transparency":0},"world_ltg_brightness":true,"world_ltg_brightness_val":2,"world_ltg_clock":true,"world_ltg_clock_val":14.5,"world_ltg_colorshift_bottom":true,"world_ltg_colorshift_bottom_color":{"Color":"e0f2fe","Transparency":0},"world_ltg_colorshift_top":true,"world_ltg_colorshift_top_color":{"Color":"7dd3fc","Transparency":0},"world_ltg_exposure":true,"world_ltg_exposure_val":-0.4,"world_ltg_fog_color_enabled":false,"world_ltg_fog_end":false,"world_ltg_fog_start":false,"world_ltg_shadows":true,"world_marker_enabled":false,"world_shadow_soft_enabled":true,"world_shadow_soft_val":25,"world_sky_autorotate":false,"world_sky_celestial":false,"world_skybox_disable":[],"world_skybox_enabled":true,"world_skybox_mode":"Ocean Sky","world_sunrays_enabled":true,"world_sunrays_intensity":0.15,"world_sunrays_spread":0.8,"world_weather_color":{"Color":"ffcf4a","Transparency":0},"world_weather_color_end":{"Color":"5a2a0a","Transparency":0},"world_weather_color_mid":{"Color":"ff8a1f","Transparency":0},"world_weather_density":35,"world_weather_enabled":false,"world_weather_lifetime":100,"world_weather_opacity":80,"world_weather_size":100,"world_weather_speed":100,"world_weather_timescale":1,"world_weather_type":"Ash"}]==],
    ["[LEGIT] Snow White"] = [==[{"movement_maul_slam":false,"AimbotFilledFov_Color1":{"Color":"e8f4ff","Transparency":0.94},"AimbotFilledFov_Color2":{"Color":"e8f4ff","Transparency":0.85},"AimbotFilledFov_Color3":{"Color":"e8f4ff","Transparency":0.94},"AimlockDropdown_":[],"AntiAim_enabled":false,"AntiFlash":true,"AntiSmoke":false,"FakePosition":false,"FakePositionPanic":false,"FakePositionWalk":false,"FilledFov_Color1":{"Color":"e8f4ff","Transparency":0.94},"FilledFov_Color2":{"Color":"e8f4ff","Transparency":0.85},"FilledFov_Color3":{"Color":"e8f4ff","Transparency":0.94},"HideHead_enabled":false,"InfiniteJump":false,"IsInvincible":true,"NoBobbing":false,"Noclip":false,"RapidBody_enabled":false,"SilentaimDropdown_":[],"TriggerbotDropdown_":["no delay between targets"],"VelocitySpeedEnabled":false,"aim_lock_range":100,"aimbot_closest_part":false,"aimbot_closest_position":false,"aimbot_delay_position":true,"aimbot_enabled":true,"aimbot_fov_lerp":25,"aimbot_fov_moving_rotation":false,"aimbot_fov_outline":true,"aimbot_fov_outline_color":{"Color":"e8f4ff","Transparency":0.84},"aimbot_fov_outline_color2":{"Color":"ffffff","Transparency":0.7},"aimbot_fov_outline_color3":{"Color":"ffffff","Transparency":0.25},"aimbot_fov_outline_thickness":2,"aimbot_fov_settings":[],"aimbot_hitmethod":"Camera","aimbot_jump_smooth":18,"aimbot_range_color":{"Color":"ffffff","Transparency":0},"aimbot_range_color2":{"Color":"ffffff","Transparency":0},"aimbot_range_color3":{"Color":"e8f4ff","Transparency":0},"aimbot_smoothing":12,"aimbot_visualise_filled_range":true,"aimbot_visualise_range":true,"aimbot_x_smooth":10,"aimbot_y_smooth":10,"aimlock_delay":0,"aimlock_jitter":0,"aimlock_trigger":"Aiming","aimlock_wallcheck":true,"anti_aim_enabled":false,"anti_flash_keep_sound":true,"arm_override_appearance":false,"camera_fov_amount":95,"camera_fov_enabled":true,"crosshair_bounce":0,"crosshair_bounce_speed":2.9,"crosshair_color_1":{"Color":"e8f4ff","Transparency":0},"crosshair_color_2":{"Color":"dbeeff","Transparency":0},"crosshair_color_3":{"Color":"cde6ff","Transparency":0},"crosshair_color_4":{"Color":"a5d8ff","Transparency":0},"crosshair_enabled":true,"crosshair_length":8,"crosshair_lerp":0.25,"crosshair_offset":2,"crosshair_outline":true,"crosshair_outline_color_1":{"Color":"000000","Transparency":0},"crosshair_outline_color_2":{"Color":"000000","Transparency":0},"crosshair_outline_color_3":{"Color":"000000","Transparency":0},"crosshair_outline_color_4":{"Color":"000000","Transparency":0},"crosshair_rotation":45,"crosshair_rotation_speed":0,"crosshair_settings":[],"crosshair_thickness":2,"custom_tracer_color":{"Color":"e8f4ff","Transparency":0},"custom_tracer_color2":{"Color":"a5d8ff","Transparency":0},"custom_tracer_emission":1,"custom_tracer_enabled":true,"custom_tracer_fade":1,"custom_tracer_glow":4,"custom_tracer_length":4,"custom_tracer_lifetime":1,"custom_tracer_outline":false,"custom_tracer_position_lerp":0.5,"custom_tracer_selected":"lightning","custom_tracer_speed":2,"custom_tracer_width":0.2,"esp_body_color":false,"esp_bounds_type":"dynamic","esp_bounds_width_scale":100,"esp_box":false,"esp_chams":true,"esp_chams_alpha_fill":-1,"esp_chams_alpha_outline":1,"esp_chams_color":{"Color":"000000","Transparency":0},"esp_chams_color2":{"Color":"a5d8ff","Transparency":0},"esp_chams_settings":[],"esp_distance":true,"esp_distance_color1":{"Color":"ffffff","Transparency":0},"esp_distance_color2":{"Color":"ffffff","Transparency":0},"esp_distance_color3":{"Color":"ffffff","Transparency":0},"esp_effects_aura":false,"esp_effects_particle":true,"esp_effects_particle_color1":{"Color":"e8f4ff","Transparency":0},"esp_effects_particle_color2":{"Color":"a5d8ff","Transparency":0},"esp_effects_particle_color3":{"Color":"7fb8e6","Transparency":0},"esp_effects_particle_value":["glowing"],"esp_fill":false,"esp_flag_health_text":false,"esp_flag_staring_text":false,"esp_font":"proggy tiny","esp_healthbar":true,"esp_healthbar_color_end":{"Color":"5b8fbf","Transparency":0},"esp_healthbar_color_middle":{"Color":"7fb8e6","Transparency":0},"esp_healthbar_color_start":{"Color":"ffffff","Transparency":0},"esp_healthbar_health_lerp":0.05,"esp_healthbar_moving":false,"esp_healthbar_resize":false,"esp_healthbar_type":"gradient","esp_material":false,"esp_name":true,"esp_name_color1":{"Color":"ffffff","Transparency":0},"esp_name_color2":{"Color":"ffffff","Transparency":0},"esp_name_color3":{"Color":"e8f4ff","Transparency":0},"esp_name_font":"default","esp_name_type":"Name","esp_override_appearance":false,"esp_round_only":true,"esp_show_team":false,"esp_skeleton":true,"esp_skeleton_color1":{"Color":"ffffff","Transparency":0},"esp_skeleton_color2":{"Color":"ffffff","Transparency":0},"esp_skeleton_color3":{"Color":"ffffff","Transparency":0},"esp_skeleton_outline":false,"esp_skeleton_thickness":1,"esp_weapon":true,"esp_weapon_color1":{"Color":"ffffff","Transparency":0},"esp_weapon_color2":{"Color":"ffffff","Transparency":0},"esp_weapon_color3":{"Color":"ffffff","Transparency":0},"esp_world_distance":true,"esp_world_distance_color":{"Color":"e8f4ff","Transparency":0},"esp_world_font":"proggy tiny","esp_world_image":true,"esp_world_name":true,"esp_world_name_color":{"Color":"ffffff","Transparency":0},"esp_world_object_scale":75,"esp_world_whitelist":["Flashbang","Smoke Grenade","Satchel","Subspace Tripmine","Molotov","Grenade"],"exploits_always_backstab":false,"faster_reload":false,"fly_enabled":false,"fov_fill_speed":100,"fov_fill_style":"Inner Fade","fov_lerp":25,"fov_moving_rotation":true,"fov_outline":true,"fov_outline_color":{"Color":"e8f4ff","Transparency":0.84},"fov_outline_color2":{"Color":"ffffff","Transparency":0.7},"fov_outline_color3":{"Color":"ffffff","Transparency":0.25},"fov_outline_thickness":2,"fov_position":"position on screen","fov_rotation":0,"fov_rotation_speed":10,"full_auto_enabled":true,"game_crosshair":true,"grenade_options":[],"hit_effects_col_1":{"Color":"ffffff","Transparency":0},"hit_effects_col_2":{"Color":"e8f4ff","Transparency":0},"hit_effects_col_3":{"Color":"a5d8ff","Transparency":0},"hit_effects_disable_marker":true,"hit_effects_disable_numbers":true,"hit_effects_enabled":true,"hit_effects_material":"ForceField","hit_effects_selected":["Electricity","phantom forces"],"hit_effects_settings":["stack damage together"],"hit_effects_weld":false,"hit_notifications_enabled":false,"hit_sounds_disable":true,"hit_sounds_enabled":true,"hit_sounds_selected":"sparkle","hit_sounds_volume":0.9,"hitmarker_enabled":false,"indicator_ammo":true,"indicator_ammo_color":{"Color":"ffffff","Transparency":0},"indicator_ammo_divider_color":{"Color":"a5d8ff","Transparency":0},"indicator_ammo_max_color":{"Color":"ffffff","Transparency":0},"indicator_ammo_style":["ammo","max ammo","reserve","\"out of ammo\" if empty"],"indicator_empty_color":{"Color":"ff5f5f","Transparency":0},"indicator_font":"proggy tiny","indicator_lerp":0.25,"indicator_manipulated":false,"indicator_manipulated_color":{"Color":"a5d8ff","Transparency":0},"indicator_offset_x":0,"indicator_offset_y":25,"indicator_ragebot":false,"indicator_ragebot_status_color":{"Color":"ffffff","Transparency":0},"indicator_ragebot_style":["text","status"],"indicator_ragebot_text_color":{"Color":"a5d8ff","Transparency":0},"indicator_reserve_color":{"Color":"e8f4ff","Transparency":0},"indicator_settings":[],"indicator_text_style":"lower","instant_aim_enabled":false,"item_remove_vignette":true,"item_status_enabled":true,"item_status_override":"Prime","manipulation_enabled":false,"movement_double_jump":false,"movement_slideboost":true,"movement_slideboost_value":1.1,"no_fire_sound":false,"no_muzzle_flash":false,"no_recoil_enabled":false,"no_spread_enabled":false,"quickequip":false,"ragebot_enabled":false,"shoot_sound_change":true,"shoot_sound_change_value":"crossbow","shoot_sound_speed":1,"shoot_sound_start":0,"shoot_sound_volume":0.6,"silent_aim_enabled":true,"silent_aim_range":45,"silent_aim_range_color":{"Color":"ffffff","Transparency":0},"silent_aim_range_color2":{"Color":"ffffff","Transparency":0},"silent_aim_range_color3":{"Color":"e8f4ff","Transparency":0},"silent_aim_target_mode":"FOV - Closest","silent_aim_visualise_filled_range":true,"silent_aim_visualise_range":true,"silent_closest_part":true,"silent_hitchance":100,"silent_visualize":true,"silent_wallbang":false,"stretch_enabled":false,"target_highlight":false,"target_highlight_fill":{"Color":"a5d8ff","Transparency":0.6},"target_highlight_outline":{"Color":"e8f4ff","Transparency":0},"target_highlight_type":"AlwaysOnTop","target_tracer":false,"target_tracer_customization":{"Color":"a5d8ff","Transparency":0},"target_ui_enabled":true,"target_ui_item_scale":170,"target_ui_position_x":50,"target_ui_position_y":72,"target_ui_scale":150,"targeting_ignore_protected_settings":["katana deflecting"],"targeting_limitdistance":false,"targeting_part":"Head","third_person_enabled":false,"trigger_distance":250,"trigger_enabled":true,"trigger_forget_time":1.5,"trigger_part_blacklist":[],"trigger_reaction":25,"trigger_reaction_offset":5,"trigger_scoped":["Sniper","Crossbow"],"trigger_shoot_delay":0,"viewmodel_chams":true,"viewmodel_chams_alpha_fill":-1.2,"viewmodel_chams_alpha_outline":1,"viewmodel_chams_color":{"Color":"000000","Transparency":0},"viewmodel_chams_color2":{"Color":"f5fbff","Transparency":0},"viewmodel_chams_settings":["through walls"],"viewmodel_frames_override":false,"viewmodel_offset":true,"viewmodel_offset_x":0,"viewmodel_offset_y":0,"viewmodel_offset_z":-0.5,"viewmodel_options":["sway","bobbing","muzzle flash","idle animation","jump animation","slide animation","sprint animation","shoot animation"],"viewmodel_override_appearance":false,"viewmodel_recoil":0,"viewmodel_scale_enabled":false,"viewmodel_wire_enabled":false,"voidspam_enabled":false,"wallbang_method":"Classic V1","world_ambience_enabled":true,"world_ambience_type":"Windy Day","world_ambience_volume":30,"world_atm_decay":{"Color":"b9d7f0","Transparency":0},"world_atm_density":0.4,"world_atm_enabled":true,"world_atm_glare":1.5,"world_atm_haze":3,"world_atm_offset":0.4,"world_atm_tint":{"Color":"ffffff","Transparency":0},"world_bloom_enabled":true,"world_bloom_intensity":1.0,"world_bloom_size":45,"world_bloom_threshold":0.88,"world_blur_enabled":false,"world_cc_brightness":0.03,"world_cc_contrast":0.12,"world_cc_enabled":true,"world_cc_saturation":-0.12,"world_cc_tint":{"Color":"f2f8ff","Transparency":0},"world_dof_enabled":false,"world_env_enabled":false,"world_ltg_ambient":true,"world_ltg_ambient_color":{"Color":"dbeeff","Transparency":0},"world_ltg_brightness":true,"world_ltg_brightness_val":2.2,"world_ltg_clock":true,"world_ltg_clock_val":10,"world_ltg_colorshift_bottom":true,"world_ltg_colorshift_bottom_color":{"Color":"ffffff","Transparency":0},"world_ltg_colorshift_top":true,"world_ltg_colorshift_top_color":{"Color":"e8f4ff","Transparency":0},"world_ltg_exposure":true,"world_ltg_exposure_val":-0.3,"world_ltg_fog_color_enabled":false,"world_ltg_fog_end":false,"world_ltg_fog_start":false,"world_ltg_shadows":true,"world_marker_enabled":false,"world_shadow_soft_enabled":true,"world_shadow_soft_val":25,"world_sky_autorotate":false,"world_sky_celestial":false,"world_skybox_disable":[],"world_skybox_enabled":true,"world_skybox_mode":"Winter","world_sunrays_enabled":true,"world_sunrays_intensity":0.12,"world_sunrays_spread":1,"world_weather_color":{"Color":"ffffff","Transparency":0},"world_weather_color_end":{"Color":"cde6ff","Transparency":0},"world_weather_color_mid":{"Color":"e8f4ff","Transparency":0},"world_weather_density":70,"world_weather_enabled":true,"world_weather_lifetime":100,"world_weather_opacity":90,"world_weather_size":100,"world_weather_speed":100,"world_weather_timescale":1,"world_weather_type":"Snow"}]==]

}



getgenv().DATA_PATH = library.directory .. "/data/startup.cfg"

local data_http = cloneref(game:GetService("HttpService"))

getgenv().CONFIG_EXCLUDED = {
    config_import_text = true,
    autoload_config = true,
    autoload_enabled = true,
    silent_load = true,
    config_name_list = true,
    config_name_text = true,
    world_preset = true,
    antiaim_preset = true,
    hit_effect_preset = true,
    menu_theme_preset = true,
    community_config_name = true,
    menu_bind = true
}

getgenv().notifications_allowed = function()
    if not getgenv().silent_load_active then return true end

    local gui = library and library[ "items" ]

    return gui ~= nil and gui.Enabled == true
end

getgenv().read_startup_data = LPH_JIT_MAX(function()
    local defaults = { autoload_config = false, autoload_enabled = false, silent_load = false }

    if not isfile(DATA_PATH) then
        pcall(writefile, DATA_PATH, data_http:JSONEncode(defaults))
        return defaults
    end

    local read_ok, raw = pcall(readfile, DATA_PATH)

    if not read_ok or type(raw) ~= "string" or raw == "" then
        pcall(writefile, DATA_PATH, data_http:JSONEncode(defaults))
        return defaults
    end

    local decode_ok, decoded = pcall(data_http.JSONDecode, data_http, raw)

    if not decode_ok or type(decoded) ~= "table" then
        pcall(writefile, DATA_PATH, data_http:JSONEncode(defaults))
        return defaults
    end

    return {
        autoload_config = decoded.autoload_config == true,
        autoload_enabled = decoded.autoload_enabled == true,
        silent_load = decoded.silent_load == true
    }
end)

getgenv().write_startup_data = LPH_JIT_MAX(function(key, value)
    local data = read_startup_data()

    data[key] = value == true

    pcall(writefile, DATA_PATH, data_http:JSONEncode(data))
end)

getgenv().MENU_BIND_PATH = library.directory .. "/data/menu_bind.json"

getgenv().menu_bind_key = function(text)
    if text == "NONE" then return "NONE" end

    if type(text) ~= "string" or text:sub(1, 5) ~= "Enum." then return nil end

    local ok, value = pcall(library.convert_enum, library, text)

    return ok and typeof(value) == "EnumItem" and value or nil
end

getgenv().persist_menu_bind = function(bind)
    if type(bind) ~= "table" or type(bind.set) ~= "function" then return end

    local raw_set = bind.set

    local function snapshot()
        return tostring(bind.key or "NONE"), tostring(bind.mode or "Toggle")
    end

    local exists_ok, exists = pcall(isfile, MENU_BIND_PATH)

    if exists_ok and exists then
        local read_ok, raw = pcall(readfile, MENU_BIND_PATH)
        local decode_ok, decoded = false, nil

        if read_ok and type(raw) == "string" and raw ~= "" then
            decode_ok, decoded = pcall(data_http.JSONDecode, data_http, raw)
        end

        if decode_ok and type(decoded) == "table" then
            local key = menu_bind_key(decoded.key)
            local mode = decoded.mode

            if mode ~= "Toggle" and mode ~= "Hold" and mode ~= "Always" then
                mode = bind.mode
            end

            local current_key, current_mode = snapshot()

            if key ~= nil and (tostring(key) ~= current_key or mode ~= current_mode) then
                pcall(raw_set, {key = key, mode = mode, active = bind.active})
            end
        end
    end

    local last_key, last_mode = snapshot()

    bind.set = function(input)
        raw_set(input)

        local key, mode = snapshot()

        if key == last_key and mode == last_mode then return end

        last_key, last_mode = key, mode

        pcall(writefile, MENU_BIND_PATH, data_http:JSONEncode({key = key, mode = mode}))
    end
end

getgenv().silent_load_active = read_startup_data().silent_load
getgenv().silent_load_block = getgenv().silent_load_active

getgenv().silent_hide_menu = function()
    if library.set_menu_visible then
        pcall(library.set_menu_visible, false)
    elseif library[ "items" ] then
        pcall(function()
            library[ "items" ].Enabled = false
        end)
    end
end

getgenv().apply_recording_style = function(button, label, stroke)
    button.Size = UDim2.fromOffset(54, 54)
    button.BackgroundColor3 = Color3.fromRGB(255, 90, 20)
    button.BackgroundTransparency = 0

    if stroke then stroke.Enabled = false end
    if label then label.Text = "" end

    for _, child in pairs(button:GetChildren()) do
        if child:IsA("UICorner") then
            child.CornerRadius = UDim.new(1, 0)
        end
    end

    local gradient = Instance.new("UIGradient")
    gradient.Name = "\0"
    gradient.Color = ColorSequence.new(Color3.fromRGB(255, 55, 0), Color3.fromRGB(255, 195, 0))
    gradient.Rotation = 45
    gradient.Parent = button

    local dot = Instance.new("Frame")
    dot.Name = "\0"
    dot.AnchorPoint = Vector2.new(0.5, 0.5)
    dot.Position = UDim2.fromScale(0.5, 0.5)
    dot.Size = UDim2.fromOffset(20, 20)
    dot.BackgroundColor3 = Color3.new(1, 1, 1)
    dot.BorderSizePixel = 0
    dot.ZIndex = 3
    dot.Parent = button

    local dot_corner = Instance.new("UICorner")
    dot_corner.CornerRadius = UDim.new(1, 0)
    dot_corner.Parent = dot
end

getgenv().SafeDisconnect = LPH_JIT_MAX(function(conn)
    if conn and typeof(conn) == "RBXScriptConnection" then
        conn:Disconnect()
    end
end)

getgenv().DefaultPlayerSettings = {}

getgenv().Config = {
    ["Legit"] = {
        ["SilentAim"] = {
            ["Enabled"] = false;
            ["WallbangMethod"] = "Teleport V2";
            ["SilentRedirection"] = false;
            ["Manipulation"] = false;
            ["ManipulationRange"] = 6;
            ["EnabledFieldOfView"] = 100;
            ["FieldOfViewRange"] = 100;
            ["Hitpart"] = "HitboxHead";
            ["Hitpart2"] = "HitboxHead";
        };
    };

    ["Gunmods"] = {
        ["ProjectileEnabled"] = false;
        ["ProjectileSpeed"] = 10;
    };

    ["ViewModelChams"] = { Color3.fromRGB(255, 255, 255);
    };

    ["FakePosition"]  = false;

    ["Silent"] = {
        ["FieldOfViewColor"] = Color3.fromRGB(255, 255, 255);
        ["FilledFOVColor1"] = Color3.fromRGB(119, 120, 255);
        ["FilledFOVColor2"] = Color3.fromRGB(0, 0, 0);
        ["FilledFOVAlpha"] = 0.25;
        ["FilledFOVAlpha2"] = 0.25;
    };

    ["Aimbot"] = {
        ["FieldOfViewColor"] = Color3.fromRGB(255, 255, 255);
    };

     ["Ragebot"] = {
        ["TargetMethod"]  = "Closest";
    };

     ["Aimlock"] = {
        ["AimLockActive"]  = false;
    };

    ["BulletTracers"] = {
        ["BulletColor1"] = Color3.fromRGB(255, 255, 255);
        ["BulletColor2"] = Color3.fromRGB(255, 255, 255);
    };

    ["AmmoDisplay"] = {
        ["Color1"] = Color3.fromRGB(255, 100, 100);
        ["Color2"] = Color3.fromRGB(200, 50, 80);
        ["Color3"] = Color3.fromRGB(180, 40, 60);
        ["Outline"] = true;
        ["TextSize"] = 13;
    };

    ["World"] = {
        ["CC"] = {
            ["TintColor"] = Color3.fromRGB(255, 255, 255);
            ["Saturation"] = 0;
            ["Contrast"] = 0;
            ["Brightness"] = 0;
        };
        ["Atmosphere"] = {
            ["Tint"] = Color3.fromRGB(199, 199, 199);
            ["Decay"] = Color3.fromRGB(92, 92, 92);
            ["Glare"] = 0;
            ["Haze"] = 0;
            ["Offset"] = 0;
            ["Density"] = 4;
        };
        ["Bloom"] = {
            ["Intensity"] = 5;
            ["Size"] = 24;
            ["Threshold"] = 9;
        };
        ["SunRays"] = {
            ["Intensity"] = 3;
            ["Spread"] = 5;
        };
        ["Blur"] = {
            ["Size"] = 10;
        };
        ["DOF"] = {
            ["Far"] = 5;
            ["Near"] = 5;
            ["Focus"] = 50;
            ["Radius"] = 100;
        };
        ["Skybox"] = {
            ["Mode"] = "Dreamy Sky";
        };
        ["Lighting"] = {
            ["AmbientColor"] = Color3.fromRGB(127, 127, 127);
            ["ColorShiftBottomColor"] = Color3.fromRGB(127, 127, 127);
            ["ColorShiftTopColor"] = Color3.fromRGB(127, 127, 127);
            ["FogColor"] = Color3.fromRGB(191, 191, 191);
            ["FogEnd"] = 10000;
            ["FogStart"] = 0;
            ["ExpComp"] = 0;
            ["Brightness"] = 2;
            ["ClockTime"] = 14;
            ["Technology"] = "ShadowMap";
        };
        ["DarkMode"] = {
            ["Color"] = Color3.fromRGB(30, 30, 40);
        };
},

    ESP = {
    Enabled = false,
    TeamCheck = false,
    RoundOnly = true,
    MaxDistance = 500,
    FontSize = 12,
    Font = Enum.Font.Code,
    FadeOut = {
        OnDistance = false,
        OnDeath = true,
        OnLeave = false,
    },
    Options = {
        Teamcheck = true, TeamcheckRGB = Color3.fromRGB(0, 255, 0),
        Friendcheck = true, FriendcheckRGB = Color3.fromRGB(0, 255, 0),
        Highlight = false, HighlightRGB = Color3.fromRGB(255, 0, 0),
    },
    Drawing = {
        Chams = {
            Enabled  = false,
            Thermal = true,
            FillRGB = Color3.fromRGB(119, 120, 255),
            Fill_Transparency = 80,
            OutlineRGB = Color3.fromRGB(0,0,0),
            Outline_Transparency = 80,
            VisibleCheck = false,
        },
        Names = {
            Enabled = false,
            Transparency = 0,
            RGB = Color3.fromRGB(255, 255, 255),
        },
        Flags = {
            Enabled = false,
        },
        Stats = {
            Level = false, LevelRGB = Color3.fromRGB(255, 255, 255),
            Rank = false, RankRGB = Color3.fromRGB(255, 255, 255),
            Streak = false, StreakRGB = Color3.fromRGB(255, 255, 255),
        },
        Distances = {
            Enabled = false,
            Position = "Bottom",
            Transparency = 0,
            RGB = Color3.fromRGB(255, 255, 255),
        },
        Weapons = {
            Enabled = false, WeaponTextRGB = Color3.fromRGB(119, 120, 255),
            Outlined = false,
            Gradient = false,
            Transparency = 0,
            Mode = "Image",
            IconSize = 28,
            GradientRGB1 = Color3.fromRGB(255, 255, 255), GradientRGB2 = Color3.fromRGB(119, 120, 255),
        },
        StateFlags = {
            Enabled = false, Color = Color3.fromRGB(255, 255, 255),
        },
        Utility = {
            Enabled = false, Color = Color3.fromRGB(255, 180, 120),
            ShowName = true, ShowDistance = true, MaxDistance = 300,
        },
        Inventory = {
            Enabled = false, RGB = Color3.fromRGB(255, 255, 255),
            Transparency = 0,
        },
        Healthbar = {
            Enabled = false,
            HealthText = false, Lerp = true, HealthTextRGB = Color3.fromRGB(0, 255, 0),
            Width = 2.5,
            Transparency = 0,
            HealthTextTransparency = 0,
            Gradient = true, GradientRGB1 = Color3.fromRGB(255, 0, 0), GradientRGB2 = Color3.fromRGB(0,255,0)
        },
        Boxes = {
            Animate = true,
            RotationSpeed = 300,
            Gradient = false, GradientRGB1 = Color3.fromRGB(119, 120, 255), GradientRGB2 = Color3.fromRGB(0, 0, 0),
            GradientFill = true, GradientFillRGB1 = Color3.fromRGB(119, 120, 255), GradientFillRGB2 = Color3.fromRGB(0, 0, 0),
            Filled = {
                Enabled = false,
                Transparency = 0.75,
                RGB = Color3.fromRGB(0, 0, 0),
            },
            Full = {
                Enabled = true,
                Transparency = 0,
                RGB = Color3.fromRGB(255, 255, 255),
            },
            Bounding = {
                Enabled = false,
                Transparency = 0,
                RGB = Color3.fromRGB(255, 255, 255),
            },
            Corner = {
                Enabled = false,
                Transparency = 0,
                RGB = Color3.fromRGB(255, 255, 255),
            },
            Outline = {
                Enabled = true,
                Thickness = 1,
                RGB = Color3.fromRGB(0, 0, 0),
            },
        };
    };
    Connections = {
        RunService = game:GetService("RunService")
    };
    Fonts = {};
    };
};

getgenv().crosshair = {
    enabled = false,
    refreshrate = 0,
    mode = "mouse",
    position = Vector2.new(0, 0),
    crosshair_mode = "static",

    width = 1.5,
    length = 10,
    radius = 11,

    crosshair_color = Color3.fromRGB(0, 163, 224),

    outline = true,
    outline_color = Color3.new(0, 0, 0),
    outline_alpha = 0,

    bounce = 0,
    bounce_speed = 1,
    lerp = 20,

    color1 = Color3.fromRGB(0, 163, 224),
    color2 = Color3.fromRGB(0, 163, 224),
    color3 = Color3.fromRGB(0, 163, 224),
    gradient_rotation = 0,
    gradient_animate = false,
    gradient_speed = 60,

    spin = true,
    spin_speed = 150,
    spin_max = 340,
    spin_style = Enum.EasingStyle.Sine,

    resize = true,
    resize_speed = 150,
    resize_min = 5,
    resize_max = 22,
    scale_min = 1,
    scale_max = 1,

    text = "Sleepy.gg",
    text_size = 13,
    show_text = true,
    fade_speed = 5
}

if Mobile ~= Enum.PreferredInput.Touch then
    local uis = cloneref(game:GetService("UserInputService"))
    local players, Players = cloneref(game:GetService("Players")), cloneref(game:GetService("Players"))
    local ws = cloneref(game:GetService("Workspace"))
    local rs = cloneref(game:GetService("ReplicatedStorage"))
    local http_service = cloneref(game:GetService("HttpService"))
    local gui_service = cloneref(game:GetService("GuiService"))
    local lighting = cloneref(game:GetService("Lighting"))
    local run = cloneref(game:GetService("RunService"))
    local stats = cloneref(game:GetService("Stats"))
    local coregui = cloneref(game:GetService("CoreGui"))
    local debris = cloneref(game:GetService("Debris"))
    local tween_service = cloneref(game:GetService("TweenService"))
    local sound_service = cloneref(game:GetService("SoundService"))
    local run_service = cloneref(game:GetService("RunService"))

    local vec2 = Vector2.new
    local vec3 = Vector3.new
    local dim2 = UDim2.new
    local dim = UDim.new
    local rect = Rect.new
    local cfr = CFrame.new
    local empty_cfr = cfr()
    local point_object_space = empty_cfr.PointToObjectSpace
    local angle = CFrame.Angles
    local dim_offset = UDim2.fromOffset

    local color = Color3.new
    local rgb = Color3.fromRGB
    local hex = Color3.fromHex
    local hsv = Color3.fromHSV
    local rgbseq = ColorSequence.new
    local rgbkey = ColorSequenceKeypoint.new
    local numseq = NumberSequence.new
    local numkey = NumberSequenceKeypoint.new

    local camera = ws.CurrentCamera
    local lp = players.LocalPlayer
    local gui_offset = gui_service:GetGuiInset().Y

    local max = math.max
    local floor = math.floor
    local min = math.min
    local abs = math.abs
    local noise = math.noise
    local rad = math.rad
    local random = math.random
    local pow = math.pow
    local sin = math.sin
    local pi = math.pi
    local tan = math.tan
    local atan2 = math.atan2
    local clamp = math.clamp

    local insert = table.insert
    local find = table.find
    local remove = table.remove
    local concat = table.concat

    local themes = {
        preset = {
            accent = rgb(0, 162, 255),
            background = rgb(14, 14, 16),
            element = rgb(25, 25, 29),
            outline = rgb(36, 36, 37),
            text = rgb(245, 245, 245),
            inactive = rgb(72, 72, 73),
        },

        utility = {
            accent = {
                BackgroundColor3 = {},
                TextColor3 = {},
                ImageColor3 = {},
                ScrollBarImageColor3 = {},
                Color = {}
            },
        }
    }

    local keys = {
        ["NONE"] = "...",
        [Enum.KeyCode.LeftShift] = "LS",
        [Enum.KeyCode.RightShift] = "RS",
        [Enum.KeyCode.LeftControl] = "LC",
        [Enum.KeyCode.RightControl] = "RC",
        [Enum.KeyCode.Insert] = "INS",
        [Enum.KeyCode.Backspace] = "BS",
        [Enum.KeyCode.Return] = "Ent",
        [Enum.KeyCode.LeftAlt] = "LA",
        [Enum.KeyCode.RightAlt] = "RA",
        [Enum.KeyCode.CapsLock] = "CAPS",
        [Enum.KeyCode.One] = "1",
        [Enum.KeyCode.Two] = "2",
        [Enum.KeyCode.Three] = "3",
        [Enum.KeyCode.Four] = "4",
        [Enum.KeyCode.Five] = "5",
        [Enum.KeyCode.Six] = "6",
        [Enum.KeyCode.Seven] = "7",
        [Enum.KeyCode.Eight] = "8",
        [Enum.KeyCode.Nine] = "9",
        [Enum.KeyCode.Zero] = "0",
        [Enum.KeyCode.KeypadOne] = "Num1",
        [Enum.KeyCode.KeypadTwo] = "Num2",
        [Enum.KeyCode.KeypadThree] = "Num3",
        [Enum.KeyCode.KeypadFour] = "Num4",
        [Enum.KeyCode.KeypadFive] = "Num5",
        [Enum.KeyCode.KeypadSix] = "Num6",
        [Enum.KeyCode.KeypadSeven] = "Num7",
        [Enum.KeyCode.KeypadEight] = "Num8",
        [Enum.KeyCode.KeypadNine] = "Num9",
        [Enum.KeyCode.KeypadZero] = "Num0",
        [Enum.KeyCode.Minus] = "-",
        [Enum.KeyCode.Equals] = "=",
        [Enum.KeyCode.Tilde] = "~",
        [Enum.KeyCode.LeftBracket] = "[",
        [Enum.KeyCode.RightBracket] = "]",
        [Enum.KeyCode.RightParenthesis] = ")",
        [Enum.KeyCode.LeftParenthesis] = "(",
        [Enum.KeyCode.Semicolon] = ",",
        [Enum.KeyCode.Quote] = "'",
        [Enum.KeyCode.BackSlash] = "\\",
        [Enum.KeyCode.Comma] = ",",
        [Enum.KeyCode.Period] = ".",
        [Enum.KeyCode.Slash] = "/",
        [Enum.KeyCode.Asterisk] = "*",
        [Enum.KeyCode.Plus] = "+",
        [Enum.KeyCode.Period] = ".",
        [Enum.KeyCode.Backquote] = "`",
        [Enum.UserInputType.MouseButton1] = "MB1",
        [Enum.UserInputType.MouseButton2] = "MB2",
        [Enum.UserInputType.MouseButton3] = "MB3",
        [Enum.KeyCode.Escape] = "ESC",
        [Enum.KeyCode.Space] = "SPC",
        [Enum.KeyCode.End] = "END",
    }

    library.__index = library

    local flags = library.flags
    local config_flags = library.config_flags
    local notifications = library.notifications

    getgenv().fonts = {}; do
        local Register_Font = LPH_JIT_MAX(function(Name, Weight, Style, Asset)
            local AssetPath = library.directory .. "/fonts/" .. Asset.Id
            local FontPath = library.directory .. "/fonts/" .. Name .. ".font"

            if not isfile(AssetPath) then
                local ok, data = pcall(game.HttpGet, game, Asset.Url)

                if not ok or not data or #data == 0 then return end

                writefile(AssetPath, data)
            end

            if isfile(FontPath) then
                delfile(FontPath)
            end

            local Data = {
                name = Name,
                faces = {
                    {
                        name = "Normal",
                        weight = Weight,
                        style = Style,
                        assetId = getcustomasset(AssetPath),
                    },
                },
            }

            writefile(FontPath, http_service:JSONEncode(Data))

            return getcustomasset(FontPath);
        end)

        local Medium = Register_Font("Medium", 200, "Normal", {
            Id = "Medium.ttf",
            Url = "https://github.com/SleepyScriptsHolderAntiSkids/storage/raw/refs/heads/main/fonts/Inter_28pt-Medium.ttf",
        })

        local SemiBold = Register_Font("SemiBold", 200, "Normal", {
            Id = "SemiBold.ttf",
            Url = "https://github.com/SleepyScriptsHolderAntiSkids/storage/raw/refs/heads/main/fonts/Inter_28pt-SemiBold.ttf",
        })

        fonts = {
            small = Font.new(Medium, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
            font = Font.new(SemiBold, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
        }
    end

        function library:tween(obj, properties, easing_style, time)
            local tween = tween_service:Create(obj, TweenInfo.new(time or 0.25, easing_style or Enum.EasingStyle.Quint, Enum.EasingDirection.InOut, 0, false, 0), properties):Play()

            return tween
        end

        function library:resizify(frame)
            local Frame = Instance.new("TextButton")
            Frame.Position = dim2(1, -10, 1, -10)
            Frame.BorderColor3 = rgb(0, 0, 0)
            Frame.Size = dim2(0, 10, 0, 10)
            Frame.BorderSizePixel = 0
            Frame.BackgroundColor3 = rgb(255, 255, 255)
            Frame.Parent = frame
            Frame.BackgroundTransparency = 1
            Frame.Text = ""

            local resizing = false
            local start_size
            local start
            local og_size = frame.Size

            Frame.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    resizing = true
                    start = input.Position
                    start_size = frame.Size
                end
            end))

            Frame.InputEnded:Connect(LPH_NO_VIRTUALIZE(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    resizing = false
                end
            end))

            library:connection(uis.InputChanged, LPH_NO_VIRTUALIZE(function(input, game_event)
                if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local viewport_x = camera.ViewportSize.X
                    local viewport_y = camera.ViewportSize.Y

                    local current_size = dim2(
                        start_size.X.Scale,
                        math.clamp(
                            start_size.X.Offset + (input.Position.X - start.X),
                            og_size.X.Offset,
                            viewport_x
                        ),
                        start_size.Y.Scale,
                        math.clamp(
                            start_size.Y.Offset + (input.Position.Y - start.Y),
                            og_size.Y.Offset,
                            viewport_y
                        )
                    )

                    library:tween(frame, {Size = current_size}, Enum.EasingStyle.Linear, 0.05)
                end
            end))
        end

         fag = LPH_NO_VIRTUALIZE(function(tbl)
            local Size = 0

            for _ in tbl do
                Size = Size + 1
            end

            return Size
        end)

        function library:next_flag()
            local index = fag(library.flags) + 1;
            local str = string.format("flagnumber%s", index)

            return str;
        end

        function library:mouse_in_frame(uiobject)
            local y_cond = uiobject.AbsolutePosition.Y <= Mouse.Y and Mouse.Y <= uiobject.AbsolutePosition.Y + uiobject.AbsoluteSize.Y
            local x_cond = uiobject.AbsolutePosition.X <= Mouse.X and Mouse.X <= uiobject.AbsolutePosition.X + uiobject.AbsoluteSize.X

            return (y_cond and x_cond)
        end

        function library:draggify(frame)
            local dragging = false
            local start_size = frame.Position
            local start

            frame.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    start = input.Position
                    start_size = frame.Position
                end
            end))

            frame.InputEnded:Connect(LPH_NO_VIRTUALIZE(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end))

            library:connection(uis.InputChanged, LPH_NO_VIRTUALIZE(function(input, game_event)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local viewport_x = camera.ViewportSize.X
                    local viewport_y = camera.ViewportSize.Y

                    local current_position = dim2(
                        0,
                        clamp(
                            start_size.X.Offset + (input.Position.X - start.X),
                            0,
                            viewport_x - frame.Size.X.Offset
                        ),
                        0,
                        math.clamp(
                            start_size.Y.Offset + (input.Position.Y - start.Y),
                            0,
                            viewport_y - frame.Size.Y.Offset
                        )
                    )

                    library:tween(frame, {Position = current_position}, Enum.EasingStyle.Linear, 0.05)
                    library:close_element()
                end
            end))
        end

        function library:convert(str)
            local values = {}

            for value in string.gmatch(str, "[^,]+") do
                insert(values, tonumber(value))
            end

            if #values == 4 then
                return unpack(values)
            else
                return
            end
        end

        function library:convert_enum(enum)
            local enum_parts = {}

            for part in string.gmatch(enum, "[%w_]+") do
                insert(enum_parts, part)
            end

            local enum_table = Enum
            for i = 2, #enum_parts do
                local enum_item = enum_table[enum_parts[i]]

                enum_table = enum_item
            end

            return enum_table
        end

        local CONFIG_WRITE_EXTENSION = ".txt"
        local CONFIG_EXTENSIONS = {".txt", ".cfg"}

        function library:config_path(name, extension)
            return library.directory .. "/configs/" .. name .. (extension or CONFIG_WRITE_EXTENSION)
        end

        function library:find_config(name)
            if type(name) ~= "string" or name == "" then
                return nil
            end

            for _, extension in CONFIG_EXTENSIONS do
                local path = library:config_path(name, extension)

                if isfile(path) then
                    return path, extension
                end
            end

            return nil
        end

        function library:recent_configs()
            local ok, list = pcall(function()
                return http_service:JSONDecode(readfile(library.directory .. "/recent_configs.json"))
            end)

            return ok and type(list) == "table" and list or {}
        end

        function library:touch_config(name, removed)
            if type(name) ~= "string" or name == "" then return end

            local list = library:recent_configs()

            for i = #list, 1, -1 do
                if list[i] == name then
                    table.remove(list, i)
                end
            end

            if not removed then
                table.insert(list, 1, name)
            end

            pcall(writefile, library.directory .. "/recent_configs.json", http_service:JSONEncode(list))
        end

        local config_holder;
        function library:update_config_list()
            if not config_holder then
                return
            end

            local list, seen = {}, {}

            for _, file in listfiles(library.directory .. "/configs") do
                local leaf = file:match("[^/\\]+$") or file
                local name = leaf:match("^(.*)%.txt$") or leaf:match("^(.*)%.cfg$")

                if name and name ~= "" and not seen[name] then
                    seen[name] = true

                    list[#list + 1] = name
                end
            end

            local order = {}

            for index, name in library:recent_configs() do
                if order[name] == nil then
                    order[name] = index
                end
            end

            table.sort(list, function(a, b)
                local rank_a, rank_b = order[a], order[b]

                if rank_a and rank_b then return rank_a < rank_b end
                if rank_a or rank_b then return rank_a ~= nil end

                return a:lower() < b:lower()
            end)

            config_holder.refresh_options(list)
        end

        function library:get_config()
            local Config = {}

            for _, v in next, flags do
                if CONFIG_EXCLUDED[_] then
                    continue
                elseif library.armed[_] ~= nil then
                    Config[_] = library.armed[_]
                elseif type(v) == "table" and v.key then
                    Config[_] = {active = v.active, mode = v.mode, key = tostring(v.key)}
                elseif type(v) == "table" and v["Transparency"] and v["Color"] then
                    Config[_] = {Transparency = v["Transparency"], Color = v["Color"]:ToHex()}
                else
                    Config[_] = v
                end
            end

            return http_service:JSONEncode(Config)
        end

        function library:load_config(config_json)
            local config = http_service:JSONDecode(config_json)

            if type(config) == "table" and type(library.default_config) == "string" and config_json ~= library.default_config then
                local decoded, defaults = pcall(http_service.JSONDecode, http_service, library.default_config)

                if decoded and type(defaults) == "table" then
                    local menu = library.menu_flags or {}

                    for key, value in defaults do
                        if config[key] == nil and not menu[key] and not (type(value) == "table" and value["key"] ~= nil) then
                            config[key] = value
                        end
                    end
                end
            end

            local applied = 0

            for _, v in config do
                local function_set = library.config_flags[_]

                if CONFIG_EXCLUDED[_] then
                    continue
                end

                if function_set then
                    applied = applied + 1

                    if applied % 20 == 0 then
                        task.wait()
                    end

                    pcall(function()
                        if type(v) == "table" and v["Transparency"] and v["Color"] then
                            function_set(hex(v["Color"]), v["Transparency"])
                        elseif type(v) == "table" and v["active"] then
                            function_set(v)
                        else
                            function_set(v)
                        end
                    end)
                end
            end
        end

        local IMPORT_BYTE_LIMIT = 512 * 1024

        local function tidy_error(err)
            local text = tostring(err)
            local stripped = text:gsub("^.-:%d+:%s*", "")

            return stripped ~= "" and stripped or text
        end

        function library:validate_config(text)
            if type(text) ~= "string" then
                return nil, "nothing was pasted"
            end

            local payload = text:match("^%s*(.-)%s*$") or ""

            if payload == "" then
                return nil, "the box is empty"
            end

            if #payload > IMPORT_BYTE_LIMIT then
                return nil, ("that is %d kb, the limit is %d kb"):format(#payload // 1024, IMPORT_BYTE_LIMIT // 1024)
            end

            if payload:sub(1, 1) ~= "{" or payload:sub(-1) ~= "}" then
                return nil, "that is not a config, it has to start with { and end with }"
            end

            local decoded_ok, decoded = pcall(function()
                return http_service:JSONDecode(payload)
            end)

            if not decoded_ok then
                return nil, "the json is malformed, " .. tidy_error(decoded)
            end

            if type(decoded) ~= "table" then
                return nil, ("that decoded to a %s, expected a config"):format(type(decoded))
            end

            local total, known, unknown = 0, 0, 0

            for key, value in pairs(decoded) do
                if type(key) ~= "string" then
                    return nil, ("setting names have to be text, found a %s"):format(type(key))
                end

                local kind = type(value)

                if kind ~= "boolean" and kind ~= "number" and kind ~= "string" and kind ~= "table" then
                    return nil, ("setting '%s' holds a %s, which cannot be applied"):format(key, kind)
                end

                total += 1

                if CONFIG_EXCLUDED[key] then
                elseif library.config_flags[key] then
                    known += 1
                else
                    unknown += 1
                end
            end

            if total == 0 then
                return nil, "the config is empty"
            end

            if known == 0 then
                return nil, ("none of the %d setting(s) belong to this build"):format(total)
            end

            return payload, nil, known, unknown
        end

        function library:import_config(text)
            local payload, reason, known, unknown = library:validate_config(text)

            if not payload then
                return false, reason
            end

            local applied, err = pcall(function()
                library:load_config(payload)
            end)

            if not applied then
                return false, "the config could not be applied, " .. tidy_error(err)
            end

            return true, ("loaded %d setting(s)%s"):format(known,
                unknown > 0 and (", ignored " .. unknown .. " unknown") or "")
        end

        function library:export_config()
            if type(setclipboard) ~= "function" then
                return false, "your executor has no clipboard support"
            end

            local built, payload = pcall(function()
                return library:get_config()
            end)

            if not built then
                return false, "the config could not be built, " .. tidy_error(payload)
            end

            if type(payload) ~= "string" or payload == "" then
                return false, "the config came back empty"
            end

            local copied, err = pcall(setclipboard, payload)

            if not copied then
                return false, "the clipboard write failed, " .. tidy_error(err)
            end

            return true, ("%d characters copied"):format(#payload)
        end

        local AUTOLOAD_PATH = library.directory .. "/autoload/autoload.cfg"

        local AUTOLOAD_ENABLED = false

        task.spawn(LPH_NO_VIRTUALIZE(function()
            local deadline = os.clock() + 30

            repeat task.wait() until library.setup_complete or os.clock() > deadline

            if not library.setup_complete then
                local last = -1

                repeat
                    local count = 0
                    for _ in next, library.config_flags do count += 1 end

                    if count > 0 and count == last then break end

                    last = count
                    task.wait(0.5)
                until os.clock() > deadline + 10
            end

            if getgenv().silent_load_active then
                silent_hide_menu()
            end

            library.default_config = library:get_config()

            if isfile(AUTOLOAD_PATH) then
                local name = readfile(AUTOLOAD_PATH)
                local path = library:find_config(name)

                if path then
                    local loaded = pcall(function()
                        library:load_config(readfile(path))
                    end)

                    if loaded then
                        library:touch_config(name)
                    end

                    if getgenv().silent_load_active then
                        silent_hide_menu()
                    end

                    pcall(function()
                        library.notifications:create_notification({
                            name = "configs",
                            info = loaded and ("auto load config: " .. name) or ("auto load failed: " .. name),
                            lifetime = 5
                        })
                    end)
                end
            end

            if getgenv().silent_load_active then
                silent_hide_menu()
            end

            if getgenv().silent_load_active and library.menu_bind then
                local bind = library.menu_bind

                bind.active = false

                local mirror = bind.flag and library.flags and library.flags[bind.flag]

                if type(mirror) == "table" then mirror.active = false end

                silent_hide_menu()
            end

            getgenv().silent_load_block = false
        end))

        function library:relayout_sections()
            local refreshers = library.autosize_refresh
            if not refreshers then return end

            if library._relayout_queued then return end
            library._relayout_queued = true

            task.defer(function()
                library._relayout_queued = false

                for i = 1, #refreshers do
                    pcall(refreshers[i])
                end
            end)
        end

        function library:depends(parent, children, invert)
            local roots = {"toggle", "slider_object", "dropdown_object", "textbox", "keybind_element", "button_element", "list", "label"}

            local function apply(state)
                local shown = state and true or false
                if invert then shown = not shown end

                for i = 1, #children do
                    local child = children[i]
                    local items = child and child.items

                    if items then
                        for r = 1, #roots do
                            local element = items[roots[r]]

                            if typeof(element) == "Instance" then
                                element.Visible = shown
                            end
                        end

                        if not shown and child.set_visible then pcall(child.set_visible, false) end
                    end

                end

                library:relayout_sections()
            end

            local previous = parent.callback

            parent.raw_callback = parent.raw_callback or previous

            parent.callback = function(state, ...)
                if previous then previous(state, ...) end
                apply(state)
            end

            apply(parent.enabled)

            return parent
        end

        function library:round(number, float)
            local multiplier = 1 / (float or 1)

            return floor(number * multiplier + 0.5) / multiplier
        end

        local THEME_BASES = {
            background = rgb(14, 14, 16),
            element    = rgb(25, 25, 29),
            outline    = rgb(36, 36, 37),
            text       = rgb(245, 245, 245),
            inactive   = rgb(72, 72, 73)
        }

        local THEME_LOOKUP = {
            ["14,14,16"]    = "background",
            ["23,23,29"]    = "background",
            ["18,18,20"]    = "background",
            ["25,25,29"]    = "element",
            ["33,33,35"]    = "element",
            ["28,28,32"]    = "element",
            ["36,36,37"]    = "outline",
            ["22,22,24"]    = "outline",
            ["50,50,50"]    = "outline",
            ["245,245,245"] = "text",
            ["211,211,211"] = "text",
            ["72,72,73"]    = "inactive",
            ["72,72,72"]    = "inactive",
            ["130,130,130"] = "inactive",
            ["58,58,62"]    = "inactive",
            ["67,67,68"]    = "inactive",
            ["86,86,88"]    = "inactive",
            ["86,86,87"]    = "inactive"
        }

        local THEME_PROPERTIES = { "BackgroundColor3", "TextColor3", "ImageColor3", "ScrollBarImageColor3" }

        local theme_tracked = {}

        local function theme_key_of(color)
            if typeof(color) ~= "Color3" then return nil end

            local id = math.floor(color.R * 255 + 0.5) .. "," .. math.floor(color.G * 255 + 0.5) .. "," .. math.floor(color.B * 255 + 0.5)

            return THEME_LOOKUP[id]
        end

        local function theme_shade(base, original, target)
            local base_level = (base.R + base.G + base.B) / 3
            local original_level = (original.R + original.G + original.B) / 3
            local ratio = base_level > 0.004 and (original_level / base_level) or 1

            return Color3.new(
                math.clamp(target.R * ratio, 0, 1),
                math.clamp(target.G * ratio, 0, 1),
                math.clamp(target.B * ratio, 0, 1)
            )
        end

        function library:track_theme(instance, options)
            for _, property in THEME_PROPERTIES do
                local value = options[property]
                local key = theme_key_of(value)

                if key then
                    insert(theme_tracked, {
                        instance = instance,
                        property = property,
                        original = value,
                        key = key
                    })

                    local current = themes.preset[key]
                    local base = THEME_BASES[key]

                    if current and base and current ~= base then
                        instance[property] = theme_shade(base, value, current)
                    end
                end
            end
        end

        function library:paint_theme(key, color)
            themes.preset[key] = color

            for i = #theme_tracked, 1, -1 do
                local entry = theme_tracked[i]

                if not entry.instance or not entry.instance.Parent then
                    remove(theme_tracked, i)
                elseif entry.key == key then
                    entry.instance[entry.property] = theme_shade(THEME_BASES[key], entry.original, color)
                end
            end

            if library.theme_listeners then
                for _, fn in library.theme_listeners do
                    pcall(fn, key, color)
                end
            end
        end

        function library:theme_text(level)
            local base = themes.preset.text

            return Color3.new(base.R * level, base.G * level, base.B * level)
        end

        library.theme_listeners = {}

        function library:on_theme(fn)
            insert(library.theme_listeners, fn)
        end

        library.edge_strokes = {}

        function library:track_edge(stroke, base)
            insert(library.edge_strokes, {stroke = stroke, base = base})
        end

        function library:refresh_edges()
            local on = flags.menu_edge_enabled

            if on == nil then on = true end

            local scale = (tonumber(flags.menu_edge_opacity) or 100) / 100

            for i = #library.edge_strokes, 1, -1 do
                local entry = library.edge_strokes[i]

                if not entry.stroke or not entry.stroke.Parent then
                    remove(library.edge_strokes, i)
                else
                    entry.stroke.Transparency = on and (1 - (1 - entry.base) * scale) or 1
                end
            end
        end

        function library:track_theme_as(instance, property, original, key)
            local entry = {
                instance = instance,
                property = property,
                original = original,
                key = key
            }

            insert(theme_tracked, entry)

            return entry
        end

        THEME_PRESETS = {
            ["Sleepy"]     = { accent = rgb(0, 162, 255),   background = rgb(14, 14, 16),  element = rgb(25, 25, 29),  outline = rgb(36, 36, 37),  text = rgb(245, 245, 245), inactive = rgb(72, 72, 73) },
            ["Midnight"]   = { accent = rgb(120, 120, 255), background = rgb(10, 10, 18),  element = rgb(20, 20, 34),  outline = rgb(34, 34, 52),  text = rgb(238, 238, 255), inactive = rgb(76, 76, 100) },
            ["Crimson"]    = { accent = rgb(230, 45, 60),   background = rgb(16, 10, 11),  element = rgb(28, 18, 20),  outline = rgb(48, 30, 32),  text = rgb(250, 238, 238), inactive = rgb(92, 66, 68) },
            ["Emerald"]    = { accent = rgb(40, 210, 130),  background = rgb(10, 16, 14),  element = rgb(18, 28, 24),  outline = rgb(30, 46, 40),  text = rgb(236, 250, 244), inactive = rgb(66, 92, 82) },
            ["Amber"]      = { accent = rgb(255, 176, 32),  background = rgb(16, 14, 10),  element = rgb(28, 24, 18),  outline = rgb(48, 42, 30),  text = rgb(250, 246, 236), inactive = rgb(96, 88, 68) },
            ["Ultraviolet"]= { accent = rgb(190, 90, 255),  background = rgb(14, 10, 18),  element = rgb(26, 20, 34),  outline = rgb(44, 34, 56),  text = rgb(244, 238, 252), inactive = rgb(88, 72, 104) },
            ["Monochrome"] = { accent = rgb(225, 225, 225), background = rgb(12, 12, 12),  element = rgb(24, 24, 24),  outline = rgb(42, 42, 42),  text = rgb(245, 245, 245), inactive = rgb(96, 96, 96) },
            ["Ocean"]      = { accent = rgb(0, 200, 220),   background = rgb(8, 14, 18),   element = rgb(16, 26, 32),  outline = rgb(28, 44, 54),  text = rgb(234, 248, 252), inactive = rgb(64, 92, 104) },
            ["Rose"]       = { accent = rgb(255, 105, 170), background = rgb(18, 12, 15),  element = rgb(30, 20, 26),  outline = rgb(50, 34, 42),  text = rgb(252, 240, 246), inactive = rgb(100, 74, 86) },
            ["Halloween"]  = { accent = rgb(255, 117, 24),  background = rgb(13, 9, 15),   element = rgb(26, 17, 28),  outline = rgb(52, 30, 48),  text = rgb(255, 236, 214), inactive = rgb(110, 78, 96) }
        }

        THEME_PRESET_NAMES = { "Sleepy", "Midnight", "Crimson", "Emerald", "Amber", "Ultraviolet", "Monochrome", "Ocean", "Rose", "Halloween" }

        function library:apply_theme_preset(name)
            local preset = THEME_PRESETS[name]

            if not preset then return end

            library:update_theme("accent", preset.accent)

            for key in THEME_BASES do
                if preset[key] then
                    library:paint_theme(key, preset[key])
                end
            end

            if library.theme_pickers then
                for key, picker in library.theme_pickers do
                    local color = key == "accent" and preset.accent or preset[key]

                    if color and picker and picker.set then
                        pcall(picker.set, color, 0)
                    end
                end
            end
        end

        function library:apply_theme(instance, theme, property)
            insert(themes.utility[theme][property], instance)
        end

        function library:update_theme(theme, color)
            for _, property in themes.utility[theme] do

                for m, object in property do
                    if object[_] == themes.preset[theme] then
                        object[_] = color
                    end
                end
            end

            themes.preset[theme] = color

            if theme == "accent" and library.accent_refreshers then
                for _, refresh in library.accent_refreshers do
                    pcall(refresh)
                end
            end
        end

        function library:connection(signal, callback)
            local connection = signal:Connect(callback)

            insert(library.connections, connection)

            return connection
        end

        library.overlays = {}
        library.armed = {}

        function library:guard_overlay(cfg, instance, anchor)
            library.overlays[#library.overlays + 1] = {cfg = cfg, frame = instance, anchor = anchor}

            local inside = {}

            local function watch(element)
                element.MouseEnter:Connect(function()
                    inside[element] = true
                    library.overlay_inside = instance
                end)

                element.MouseLeave:Connect(function()
                    inside[element] = nil

                    if next(inside) == nil and library.overlay_inside == instance then
                        library.overlay_inside = nil
                    end
                end)
            end

            local function stamp(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then
                    library.overlay_pressed = instance
                    library.overlay_pressed_at = os.clock()
                end
            end

            watch(instance)
            instance.InputBegan:Connect(stamp)

            if anchor then
                watch(anchor)
                anchor.InputBegan:Connect(stamp)
            end

            local function bind(descendant)
                if descendant:IsA("ScrollingFrame") then
                    watch(descendant)
                end

                if descendant:IsA("GuiObject") then
                    descendant.InputBegan:Connect(stamp)
                end
            end

            for _, descendant in instance:GetDescendants() do
                bind(descendant)
            end

            instance.DescendantAdded:Connect(bind)
        end

        function library:open_overlay()
            local list = library.overlays

            for index = #list, 1, -1 do
                local entry = list[index]

                if not entry.frame.Parent then
                    remove(list, index)
                elseif entry.frame.Parent == library[ "items" ] and entry.frame.Visible then
                    return entry
                end
            end
        end

        function library:overlay_holding(frame)
            if library.overlay_inside == frame then return true end

            return library.overlay_pressed == frame
                and os.clock() - (library.overlay_pressed_at or 0) < 0.2
        end

        library:connection(uis.InputBegan, function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1
                and input.UserInputType ~= Enum.UserInputType.Touch then
                return
            end

            local entry = library:open_overlay()

            if not entry then return end
            if library:overlay_holding(entry.frame) then return end

            entry.cfg.open = false
            entry.cfg.set_visible(false)
        end)

        function library:overlay_guarding(cfg, instance)
            local entry = library:open_overlay()

            if not entry then return false end

            if cfg and entry.cfg == cfg then return false end
            if instance and instance == entry.anchor then return false end

            return not (instance and instance:IsDescendantOf(entry.frame))
        end

        function library:close_element(new_path)
            local open_element = library.current_open

            if open_element and new_path ~= open_element then
                open_element.set_visible(false)
                open_element.open = false;
            end

            if new_path ~= open_element then
                library.current_open = new_path or nil;
            end
        end

        function library:create(instance, options)
            local ins = Instance.new(instance)

            for prop, value in options do
                ins[prop] = value
            end

            library:track_theme(ins, options)

            return ins
        end

        function library:unload_menu()
            if library[ "items" ] then
                library[ "items" ]:Destroy()
            end

            if library[ "other" ] then
                library[ "other" ]:Destroy()
            end

            for index, connection in library.connections do
                connection:Disconnect()
                connection = nil
            end

            library = nil
        end

        function library:window(properties)
            local cfg = {
                suffix = properties.suffix or properties.Suffix or "tech";
                name = properties.name or properties.Name or "nebula";
                game_name = properties.gameInfo or properties.game_info or properties.GameInfo or "milenium for counter-strike: global offensive";
                size = properties.size or properties.Size or dim2(0, 700, 0, 565);
                selected_tab;
                items = {};

                tween;
            }

            library[ "items" ] = library:create( "ScreenGui" , {
                Parent = gethui();
                Name = "\0";
                Enabled = not getgenv().silent_load_active;
                ZIndexBehavior = Enum.ZIndexBehavior.Global;
                IgnoreGuiInset = true;
            });

            library[ "notifs" ] = library:create( "ScreenGui" , {
                Parent = gethui();
                Name = "\0";
                Enabled = true;
                DisplayOrder = 2147483646;
                ZIndexBehavior = Enum.ZIndexBehavior.Global;
                IgnoreGuiInset = true;
            });

            library[ "other" ] = library:create( "ScreenGui" , {
                Parent = gethui();
                Name = "\0";
                Enabled = false;
                ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
                IgnoreGuiInset = true;
            });

            local items = cfg.items; do
                items[ "main" ] = library:create( "Frame" , {
                    Parent = library[ "items" ];
                    Size = cfg.size;
                    Name = "\0";
                    Position = dim2(0.5, -cfg.size.X.Offset / 2, 0.5, -cfg.size.Y.Offset / 2);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(14, 14, 16),
                }); items[ "main" ].Position = dim2(0, items[ "main" ].AbsolutePosition.X, 0, items[ "main" ].AbsolutePosition.Y)

                library.ui_scale = library:create( "UIScale" , {
                    Parent = items[ "main" ];
                    Scale = 1;
                });

                library:create( "UICorner" , {
                    Parent = items[ "main" ];
                    CornerRadius = dim(0, 10)
                });

                library:create( "UIStroke" , {
                    Color = rgb(23, 23, 29);
                    Parent = items[ "main" ];
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                });

                items[ "side_frame" ] = library:create( "Frame" , {
                    Parent = items[ "main" ];
                    BackgroundTransparency = 1;
                    Name = "\0";
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 196, 1, -25);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(14, 14, 16)
                });

                library:create( "Frame" , {
                    AnchorPoint = vec2(1, 0);
                    Parent = items[ "side_frame" ];
                    Position = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 1, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(21, 21, 23)
                });

                items[ "button_holder" ] = library:create( "Frame" , {
                    Parent = items[ "side_frame" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 0, 0, 60);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 1, -60);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); cfg.button_holder = items[ "button_holder" ];

                library:create( "UIListLayout" , {
                    Parent = items[ "button_holder" ];
                    Padding = dim(0, 5);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });

                library:create( "UIPadding" , {
                    PaddingTop = dim(0, 16);
                    PaddingBottom = dim(0, 36);
                    Parent = items[ "button_holder" ];
                    PaddingRight = dim(0, 11);
                    PaddingLeft = dim(0, 10)
                });

                local accent = themes.preset.accent
                items[ "title" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    BorderColor3 = rgb(0, 0, 0);
                    Text = name;
                    Parent = items[ "side_frame" ];
                    Name = "\0";
                    Text = string.format('<u>%s</u><font color = "rgb(255, 255, 255)">%s</font>', cfg.name, cfg.suffix);
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 70);
                    TextColor3 = themes.preset.accent;
                    BorderSizePixel = 0;
                    RichText = true;
                    TextSize = 30;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); library:apply_theme(items[ "title" ], "accent", "TextColor3");

                items[ "multi_holder" ] = library:create( "Frame" , {
                    Parent = items[ "main" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 196, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -196, 0, 56);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); cfg.multi_holder = items[ "multi_holder" ];

                library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = items[ "multi_holder" ];
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(21, 21, 23)
                });

                items[ "shadow" ] = library:create( "ImageLabel" , {
                    ImageColor3 = rgb(0, 0, 0);
                    ScaleType = Enum.ScaleType.Slice;
                    Parent = items[ "main" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Name = "\0";
                    BackgroundColor3 = rgb(255, 255, 255);
                    Size = dim2(1, 75, 1, 75);
                    AnchorPoint = vec2(0.5, 0.5);
                    Image = "rbxassetid://112971167999062";
                    BackgroundTransparency = 1;
                    Position = dim2(0.5, 0, 0.5, 0);
                    SliceScale = 0.75;
                    ZIndex = -100;
                    BorderSizePixel = 0;
                    SliceCenter = rect(vec2(112, 112), vec2(147, 147))
                });

                items[ "global_fade" ] = library:create( "Frame" , {
                    Parent = items[ "main" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 196, 0, 56);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -196, 1, -81);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(14, 14, 16);
                    ZIndex = 2;
                });

                library:create( "UICorner" , {
                    Parent = items[ "shadow" ];
                    CornerRadius = dim(0, 5)
                });

                items[ "info" ] = library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = items[ "main" ];
                    Name = "\0";
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 25);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(23, 23, 25)
                });

                library:create( "UICorner" , {
                    Parent = items[ "info" ];
                    CornerRadius = dim(0, 10)
                });

                items[ "grey_fill" ] = library:create( "Frame" , {
                    Name = "\0";
                    Parent = items[ "info" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 6);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(23, 23, 25)
                });

                items[ "game" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    Parent = items[ "info" ];
                    TextColor3 = rgb(72, 72, 73);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.game_name;
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    AnchorPoint = vec2(0, 0.5);
                    Position = dim2(0, 10, 0.5, -1);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                if not LRM_SecondsLeft then
                    LRM_SecondsLeft = math.huge
                end

                local time_left = tostring((LRM_SecondsLeft < math.huge and ""..tostring(math.floor(((LRM_SecondsLeft / 60) / 60) / 24)).." days" or LRM_SecondsLeft == math.huge and "lifetime"))

                items[ "other_info" ] = library:create( "TextLabel" , {
                    Parent = items[ "info" ];
                    RichText = true;
                    Name = "\0";
                    TextColor3 = themes.preset.accent;
                    BorderColor3 = rgb(0, 0, 0);
                    Text = '<font color="rgb(72, 72, 73)">'..time_left..', </font>' .. cfg.name:lower() .. cfg.suffix:lower();
                    Size = dim2(1, 0, 0, 0);
                    Position = dim2(0, -10, 0.5, -1);
                    AnchorPoint = vec2(0, 0.5);
                    BorderSizePixel = 0;
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Right;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    FontFace = fonts.font;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); library:apply_theme(items[ "other_info" ], "accent", "TextColor3");
            end

            do
                library:draggify(items[ "main" ])
                library:resizify(items[ "main" ])
            end

             cfg.toggle_menu = LPH_NO_VIRTUALIZE(function(bool)

                if bool and getgenv().silent_load_block then return end

                library[ "items" ].Enabled = bool
            end)

            if getgenv().silent_load_active then
                local stealth_gui = library:create( "ScreenGui" , {
                    Parent = gethui();
                    Name = "\0";
                    Enabled = true;
                    DisplayOrder = 2147483645;
                    ZIndexBehavior = Enum.ZIndexBehavior.Global;
                    IgnoreGuiInset = true;
                })

                local stealth_btn = library:create( "TextButton" , {
                    Parent = stealth_gui;
                    Name = "\0";
                    Position = dim2(0, 20, 1, -20);
                    AnchorPoint = vec2(0, 1);
                    Size = dim2(0, 75, 0, 50);
                    Text = "";
                    AutoButtonColor = false;
                    BorderSizePixel = 0;
                    BorderColor3 = rgb(0, 0, 0);
                    BackgroundColor3 = rgb(25, 25, 29)
                })

                local stealth_label = library:create( "TextLabel" , {
                    Parent = stealth_btn;
                    Name = "\0";
                    Text = "toggle ui";
                    Size = dim2(1, 0, 1, 0);
                    BackgroundTransparency = 1;
                    TextColor3 = rgb(245, 245, 245);
                    TextXAlignment = Enum.TextXAlignment.Center;
                    FontFace = fonts.font;
                    BorderSizePixel = 0;
                    TextSize = 14;
                    ZIndex = 2;
                    BackgroundColor3 = rgb(255, 255, 255)
                })

                library:create( "UICorner" , {
                    Parent = stealth_btn;
                    CornerRadius = dim(0, 10)
                })

                local stealth_stroke = library:create( "UIStroke" , {
                    Color = rgb(23, 23, 29);
                    Parent = stealth_btn;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })

                local stealth_input, stealth_start, stealth_origin, stealth_moved

                apply_recording_style(stealth_btn, stealth_label, stealth_stroke)

                stealth_btn.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(input)
                    if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end

                    stealth_input = input
                    stealth_start = input.Position
                    stealth_origin = stealth_btn.Position
                    stealth_moved = false
                end))

                uis.InputChanged:Connect(LPH_NO_VIRTUALIZE(function(input)
                    if stealth_input ~= input and not (stealth_input and input.UserInputType == Enum.UserInputType.MouseMovement) then return end
                    if not stealth_input then return end

                    local dx = input.Position.X - stealth_start.X
                    local dy = input.Position.Y - stealth_start.Y

                    if not stealth_moved and (dx * dx + dy * dy) > 100 then
                        stealth_moved = true
                    end

                    if stealth_moved then
                        stealth_btn.Position = dim2(stealth_origin.X.Scale, stealth_origin.X.Offset + dx, stealth_origin.Y.Scale, stealth_origin.Y.Offset + dy)
                    end
                end))

                uis.InputEnded:Connect(LPH_NO_VIRTUALIZE(function(input)
                    if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
                    if not stealth_input then return end

                    stealth_input = nil

                    if stealth_moved then return end

                    cfg.toggle_menu(not library[ "items" ].Enabled)
                end))
            end

            RunService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function()
                if not library[ "items" ].Enabled then return end

                if uis.MouseBehavior ~= Enum.MouseBehavior.Default then
                    uis.MouseBehavior = Enum.MouseBehavior.Default
                end

                if not uis.MouseIconEnabled then
                    uis.MouseIconEnabled = true
                end
            end))

            return setmetatable(cfg, library)
        end

        function library:tab(properties)
            local cfg = {
                name = properties.name or properties.Name or "visuals";
                icon = properties.icon or properties.Icon or "http://www.roblox.com/asset/?id=6034767608";

                tabs = properties.tabs or properties.Tabs or {"Main", "Misc.", "Settings"};
                pages = {};
                current_multi;

                items = {};
            }

            local items = cfg.items; do
                items[ "tab_holder" ] = library:create( "Frame" , {
                    Parent = library.cache;
                    Name = "\0";
                    Visible = false;
                    BackgroundTransparency = 1;
                    Position = dim2(0, 196, 0, 56);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -216, 1, -101);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                    items[ "button" ] = library:create( "TextButton" , {
                        FontFace = fonts.font;
                        TextColor3 = rgb(255, 255, 255);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        Parent = self.items[ "button_holder" ];
                        AutoButtonColor = false;
                        BackgroundTransparency = 1;
                        Name = "\0";
                        Size = dim2(1, 0, 0, 35);
                        BorderSizePixel = 0;
                        TextSize = 16;
                        BackgroundColor3 = rgb(29, 29, 29)
                    });

                    items[ "icon" ] = library:create( "ImageLabel" , {
                        ImageColor3 = rgb(72, 72, 73);
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = items[ "button" ];
                        AnchorPoint = vec2(0, 0.5);
                        Image = cfg.icon;
                        BackgroundTransparency = 1;
                        Position = dim2(0, 10, 0.5, 0);
                        Name = "\0";
                        Size = dim2(0, 22, 0, 22);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    }); library:apply_theme(items[ "icon" ], "accent", "ImageColor3");

                    items[ "name" ] = library:create( "TextLabel" , {
                        FontFace = fonts.font;
                        TextColor3 = rgb(72, 72, 73);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = cfg.name;
                        Parent = items[ "button" ];
                        Name = "\0";
                        Size = dim2(0, 0, 1, 0);
                        Position = dim2(0, 40, 0, 0);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.X;
                        TextSize = 16;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    library:create( "UIPadding" , {
                        Parent = items[ "name" ];
                        PaddingRight = dim(0, 5);
                        PaddingLeft = dim(0, 5)
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "button" ];
                        CornerRadius = dim(0, 7)
                    });

                    library:create( "UIStroke" , {
                        Color = rgb(23, 23, 29);
                        Parent = items[ "button" ];
                        Enabled = false;
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    });

                    items[ "multi_section_button_holder" ] = library:create( "Frame" , {
                        Parent = library.cache;
                        BackgroundTransparency = 1;
                        Name = "\0";
                        Visible = false;
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    library:create( "UIListLayout" , {
                        Parent = items[ "multi_section_button_holder" ];
                        Padding = dim(0, 7);
                        SortOrder = Enum.SortOrder.LayoutOrder;
                        FillDirection = Enum.FillDirection.Horizontal
                    });

                    library:create( "UIPadding" , {
                        PaddingTop = dim(0, 8);
                        PaddingBottom = dim(0, 7);
                        Parent = items[ "multi_section_button_holder" ];
                        PaddingRight = dim(0, 7);
                        PaddingLeft = dim(0, 7)
                    });

                    for _, section in cfg.tabs do
                        local data = {items = {}}

                        local multi_items = data.items; do
                                multi_items[ "button" ] = library:create( "TextButton" , {
                                    FontFace = fonts.font;
                                    TextColor3 = rgb(255, 255, 255);
                                    BorderColor3 = rgb(0, 0, 0);
                                    AutoButtonColor = false;
                                    Text = "";
                                    Parent = items[ "multi_section_button_holder" ];
                                    Name = "\0";
                                    Size = dim2(0, 0, 0, 39);
                                    BackgroundTransparency = 1;
                                    ClipsDescendants = true;
                                    BorderSizePixel = 0;
                                    AutomaticSize = Enum.AutomaticSize.X;
                                    TextSize = 16;
                                    BackgroundColor3 = rgb(25, 25, 29)
                                });

                                multi_items[ "name" ] = library:create( "TextLabel" , {
                                    FontFace = fonts.font;
                                    TextColor3 = rgb(62, 62, 63);
                                    BorderColor3 = rgb(0, 0, 0);
                                    Text = section;
                                    Parent = multi_items[ "button" ];
                                    Name = "\0";
                                    Size = dim2(0, 0, 1, 0);
                                    BackgroundTransparency = 1;
                                    TextXAlignment = Enum.TextXAlignment.Left;
                                    BorderSizePixel = 0;
                                    AutomaticSize = Enum.AutomaticSize.XY;
                                    TextSize = 16;
                                    BackgroundColor3 = rgb(255, 255, 255)
                                });

                                library:create( "UIPadding" , {
                                    Parent = multi_items[ "name" ];
                                    PaddingRight = dim(0, 5);
                                    PaddingLeft = dim(0, 5)
                                });

                                multi_items[ "accent" ] = library:create( "Frame" , {
                                    BorderColor3 = rgb(0, 0, 0);
                                    AnchorPoint = vec2(0, 1);
                                    Parent = multi_items[ "button" ];
                                    BackgroundTransparency = 1;
                                    Position = dim2(0, 10, 1, 4);
                                    Name = "\0";
                                    Size = dim2(1, -20, 0, 6);
                                    BorderSizePixel = 0;
                                    BackgroundColor3 = themes.preset.accent
                                }); library:apply_theme(multi_items[ "accent" ], "accent", "BackgroundColor3");

                                library:create( "UICorner" , {
                                    Parent = multi_items[ "accent" ];
                                    CornerRadius = dim(0, 999)
                                });

                                library:create( "UIPadding" , {
                                    Parent = multi_items[ "button" ];
                                    PaddingRight = dim(0, 10);
                                    PaddingLeft = dim(0, 10)
                                });

                                library:create( "UICorner" , {
                                    Parent = multi_items[ "button" ];
                                    CornerRadius = dim(0, 7)
                                });

                                multi_items[ "tab" ] = library:create( "Frame" , {
                                    Parent = library.cache;
                                    BackgroundTransparency = 1;
                                    Name = "\0";
                                    BorderColor3 = rgb(0, 0, 0);
                                    Size = dim2(1, -20, 1, -20);
                                    BorderSizePixel = 0;
                                    Visible = false;
                                    BackgroundColor3 = rgb(255, 255, 255)
                                });

                                library:create( "UIListLayout" , {
                                    FillDirection = Enum.FillDirection.Vertical;
                                    HorizontalFlex = Enum.UIFlexAlignment.Fill;
                                    Parent = multi_items[ "tab" ];
                                    Padding = dim(0, 7);
                                    SortOrder = Enum.SortOrder.LayoutOrder;
                                    VerticalFlex = Enum.UIFlexAlignment.Fill
                                });

                                library:create( "UIPadding" , {
                                    PaddingTop = dim(0, 7);
                                    PaddingBottom = dim(0, 7);
                                    Parent = multi_items[ "tab" ];
                                    PaddingRight = dim(0, 7);
                                    PaddingLeft = dim(0, 7)
                                });
                        end

                        data.text = multi_items[ "name" ]
                        data.accent = multi_items[ "accent" ]
                        data.button = multi_items[ "button" ]
                        data.page = multi_items[ "tab" ]
                        data.parent = setmetatable(data, library):sub_tab({}).items[ "tab_parent" ]

						 data.open_page = LPH_NO_VIRTUALIZE(function()
							local page = cfg.current_multi;

                            if page and page.text ~= data.text then
                                self.items[ "global_fade" ].BackgroundTransparency = 0
                                library:tween(self.items[ "global_fade" ], {BackgroundTransparency = 1}, Enum.EasingStyle.Quad, 0.4)

                                local old_size = page.page.Size
                                page.page.Size = dim2(1, -20, 1, -20)
                            end

                            if page then
                                library:tween(page.text, {TextColor3 = rgb(62, 62, 63)})
                                library:tween(page.accent, {BackgroundTransparency = 1})
                                library:tween(page.button, {BackgroundTransparency = 1})

                                page.page.Visible = false
                                page.page.Parent = library[ "cache" ]
                            end

                            library:tween(data.text, {TextColor3 = rgb(255, 255, 255)})
                            library:tween(data.accent, {BackgroundTransparency = 0})
                            library:tween(data.button, {BackgroundTransparency = 0})
                            library:tween(data.page, {Size = dim2(1, 0, 1, 0)}, Enum.EasingStyle.Quad, 0.4)

                            data.page.Visible = true
                            data.page.Parent = items["tab_holder"]

                            cfg.current_multi = data

                            library:close_element()
						end)

						multi_items[ "button" ].MouseButton1Down:Connect(LPH_NO_VIRTUALIZE(function()
							data.open_page()
						end))

						cfg.pages[#cfg.pages + 1] = setmetatable(data, library)
                    end

                    cfg.pages[1].open_page()
            end

            cfg.fit_tabs = function()
                if cfg.fitted then return end

                local holder = items[ "multi_section_button_holder" ]
                local layout = holder:FindFirstChildOfClass("UIListLayout")

                if not layout then return end

                cfg.fitted = true

                task.defer(function()
                    task.wait()

                    local size = 16
                    local pad = 7

                    for _ = 1, 8 do
                        local available = holder.AbsoluteSize.X - 16

                        if available <= 0 then
                            cfg.fitted = false
                            return
                        end

                        if layout.AbsoluteContentSize.X <= available then break end
                        if size <= 10 then break end

                        size -= 1
                        pad = math.max(2, pad - 1)

                        for _, page in cfg.pages do
                            if page.text then page.text.TextSize = size end
                        end

                        layout.Padding = dim(0, pad)

                        task.wait()
                    end
                end)
            end

             cfg.open_tab = LPH_NO_VIRTUALIZE(function()
                local selected_tab = self.selected_tab

                if selected_tab then
                    if selected_tab[ 4 ] ~= items[ "tab_holder" ] then
                        self.items[ "global_fade" ].BackgroundTransparency = 0

                        library:tween(self.items[ "global_fade" ], {BackgroundTransparency = 1}, Enum.EasingStyle.Quad, 0.4)
                        selected_tab[ 4 ].Size = dim2(1, -216, 1, -101)
                    end

                    library:tween(selected_tab[ 1 ], {BackgroundTransparency = 1})
                    library:tween(selected_tab[ 2 ], {ImageColor3 = rgb(72, 72, 73)})
                    library:tween(selected_tab[ 3 ], {TextColor3 = rgb(72, 72, 73)})

                    selected_tab[ 4 ].Visible = false
                    selected_tab[ 4 ].Parent = library[ "cache" ]
                    selected_tab[ 5 ].Visible = false
                    selected_tab[ 5 ].Parent = library[ "cache" ]
                end

                library:tween(items[ "button" ], {BackgroundTransparency = 0})
                library:tween(items[ "icon" ], {ImageColor3 = themes.preset.accent})
                library:tween(items[ "name" ], {TextColor3 = rgb(255, 255, 255)})
                library:tween(items[ "tab_holder" ], {Size = dim2(1, -196, 1, -81)}, Enum.EasingStyle.Quad, 0.4)

                items[ "tab_holder" ].Visible = true
                items[ "tab_holder" ].Parent = self.items[ "main" ]
                items[ "multi_section_button_holder" ].Visible = true
                items[ "multi_section_button_holder" ].Parent = self.items[ "multi_holder" ]

                cfg.fit_tabs()

                self.selected_tab = {
                    items[ "button" ];
                    items[ "icon" ];
                    items[ "name" ];
                    items[ "tab_holder" ];
                    items[ "multi_section_button_holder" ];
                }

                library:close_element()
            end)

            items[ "button" ].MouseButton1Down:Connect(LPH_NO_VIRTUALIZE(function()
                cfg.open_tab()
            end))

            if not self.selected_tab then
                cfg.open_tab(true)
                library.first_tab = cfg.open_tab
            end

            return unpack(cfg.pages)
        end

        function library:open_first_tab()
            if library.first_tab then library.first_tab() end
        end

        function library:seperator(properties)
            local cfg = {items = {}, name = properties.Name or properties.name or "General"}

            local items = cfg.items do
                items[ "name" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(72, 72, 73);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = self.items[ "button_holder" ];
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    Position = dim2(0, 40, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 16;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library:create( "UIPadding" , {
                    Parent = items[ "name" ];
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });
            end;

            return setmetatable(cfg, library)
        end

            function library:column(properties)
                local cfg = {items = {}, size = properties.size or 1}

                local items = cfg.items; do
                    items[ "column" ] = library:create( "Frame" , {
                        Parent = self[ "parent" ] or self.items["tab_parent"];
                        BackgroundTransparency = 1;
                        Name = "\0";
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 0, cfg.size, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    library:create( "UIListLayout" , {
                        Parent = items[ "column" ];
                        HorizontalFlex = Enum.UIFlexAlignment.Fill;
                        Padding = dim(0, 6);
                        FillDirection = Enum.FillDirection.Vertical;
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });
                end

                return setmetatable(cfg, library)
            end

            function library:sub_tab(properties)
                local cfg = {items = {}, order = properties.order or 0; size = properties.size or 1}

                local items = cfg.items; do
                    items[ "tab_parent" ] = library:create( "Frame" , {
                        Parent = self.items[ "tab" ];
                        BackgroundTransparency = 1;
                        Name = "\0";
                        Size = dim2(0,0,cfg.size,0);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        Visible = true;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    library:create( "UIListLayout" , {
                        FillDirection = Enum.FillDirection.Horizontal;
                        HorizontalFlex = Enum.UIFlexAlignment.Fill;
                        VerticalFlex = Enum.UIFlexAlignment.Fill;
                        Parent = items[ "tab_parent" ];
                        Padding = dim(0, 7);
                        SortOrder = Enum.SortOrder.LayoutOrder;
                    });
                end

                return setmetatable(cfg, library)
            end

        function library:section(properties)
            local cfg = {
                name = properties.name or properties.Name or "section";
                side = properties.side or properties.Side or "left";
                default = properties.default or properties.Default or false;
                size = properties.size or properties.Size or self.size or 0.5;
                autosize = (properties.autosize ~= false and properties.AutoSize ~= false);
                icon = properties.icon or properties.Icon or "http://www.roblox.com/asset/?id=6022668898";
                fading_toggle = properties.fading or properties.Fading or false;
                items = {};
            };

            local items = cfg.items; do
                items[ "outline" ] = library:create( "Frame" , {
                    Name = "\0";
                    Parent = self.items[ "column" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 0, cfg.size, -3);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(25, 25, 29)
                });

                library:create( "UICorner" , {
                    Parent = items[ "outline" ];
                    CornerRadius = dim(0, 7)
                });

                do
                    local edge = library:create( "UIStroke" , {
                        Parent = items[ "outline" ];
                        Thickness = 1;
                        Transparency = 1;
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                        Color = themes.preset.accent
                    })

                    library:apply_theme(edge, "accent", "Color")
                    library:track_edge(edge, 0.82)
                end

                items[ "inline" ] = library:create( "Frame" , {
                    Parent = items[ "outline" ];
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(22, 22, 24)
                });

                library:create( "UICorner" , {
                    Parent = items[ "inline" ];
                    CornerRadius = dim(0, 7)
                });

                items[ "scrolling" ] = library:create( "ScrollingFrame" , {
                    ScrollBarImageColor3 = rgb(44, 44, 46);
                    Active = true;
                    AutomaticCanvasSize = Enum.AutomaticSize.Y;
                    ScrollBarThickness = 2;
                    Parent = items[ "inline" ];
                    Name = "\0";
                    Size = dim2(1, 0, 1, -33);
                    BackgroundTransparency = 1;
                    Position = dim2(0, 0, 0, 28);
                    BackgroundColor3 = rgb(255, 255, 255);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    CanvasSize = dim2(0, 0, 0, 0)
                });

                items[ "elements" ] = library:create( "Frame" , {
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = items[ "scrolling" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 10, 0, 10);
                    Size = dim2(1, -20, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library:create( "UIListLayout" , {
                    Parent = items[ "elements" ];
                    Padding = dim(0, 6);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });


                if cfg.autosize then
                    local layout = child_of_class(items[ "elements" ], "UIListLayout")

                    local fit_retry = 0

                    local function fit()
                        local column = self.items[ "column" ]
                        if not (layout and column) then return end

                        local available = column.AbsoluteSize.Y

                        if available <= 0 then
                            if fit_retry < 12 then
                                fit_retry = fit_retry + 1
                                task.delay(0.1, function() fit() end)
                            end

                            return
                        end

                        fit_retry = 0

                        items[ "outline" ]:SetAttribute("FitScale", ((cfg.active_layout or layout).AbsoluteContentSize.Y + 50) / available)

                        local frames = {}

                        for _, child in column:GetChildren() do
                            local wanted = child:IsA("GuiObject") and child:GetAttribute("FitScale")

                            if wanted and wanted > 0 then
                                frames[#frames + 1] = { frame = child, need = wanted }
                            end
                        end

                        local count = #frames
                        if count == 0 then return end

                        local budget = 0.98

                        table.sort(frames, function(a, b) return a.need < b.need end)

                        local remaining = budget
                        local unassigned = count

                        for i = 1, count do
                            local share = remaining / unassigned
                            local grant = math.min(frames[i].need, share)

                            frames[i].frame.Size = dim2(0, 0, grant, -3)

                            remaining = remaining - grant
                            unassigned = unassigned - 1
                        end
                    end

                    local fit_queued = false

                    local function queue_fit()
                        if fit_queued then return end
                        fit_queued = true

                        task.defer(function()
                            fit_queued = false
                            fit()
                        end)
                    end

                    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(queue_fit)
                    items[ "elements" ].ChildAdded:Connect(queue_fit)
                    self.items[ "column" ]:GetPropertyChangedSignal("AbsoluteSize"):Connect(queue_fit)

                    library.autosize_refresh = library.autosize_refresh or {}
                    library.autosize_refresh[#library.autosize_refresh + 1] = queue_fit

                    cfg.queue_fit = queue_fit

                    queue_fit()
                end

                items[ "button" ] = library:create( "TextButton" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(255, 255, 255);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    AutoButtonColor = false;
                    Parent = items[ "outline" ];
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    Size = dim2(1, -2, 0, 28);
                    BorderSizePixel = 0;
                    TextSize = 16;
                    BackgroundColor3 = rgb(19, 19, 21)
                });

                library:create( "UIStroke" , {
                    Color = rgb(23, 23, 29);
                    Parent = items[ "button" ];
                    Enabled = false;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                });

                library:create( "UICorner" , {
                    Parent = items[ "button" ];
                    CornerRadius = dim(0, 7)
                });

                items[ "Icon" ] = library:create( "ImageLabel" , {
                    ImageColor3 = themes.preset.accent;
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = items[ "button" ];
                    AnchorPoint = vec2(0, 0.5);
                    Image = cfg.icon;
                    BackgroundTransparency = 1;
                    Position = dim2(0, 10, 0.5, 0);
                    Name = "\0";
                    Size = dim2(0, 22, 0, 22);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); library:apply_theme(items[ "Icon" ], "accent", "ImageColor3");

                items[ "section_title" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(255, 255, 255);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = items[ "button" ];
                    Name = "\0";
                    Size = dim2(0, 0, 1, 0);
                    Position = dim2(0, 40, 0, -1);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.X;
                    TextSize = 16;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = items[ "button" ];
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(36, 36, 37)
                });

                if cfg.fading_toggle then
                    items[ "toggle" ] = library:create( "TextButton" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        AutoButtonColor = false;
                        Text = "";
                        AnchorPoint = vec2(1, 0.5);
                        Parent = items[ "button" ];
                        Name = "\0";
                        Position = dim2(1, -9, 0.5, 0);
                        Size = dim2(0, 36, 0, 18);
                        BorderSizePixel = 0;
                        TextSize = 14;
                        BackgroundColor3 = rgb(58, 58, 62)
                    });  library:apply_theme(items[ "toggle" ], "accent", "BackgroundColor3");

                    library:create( "UICorner" , {
                        Parent = items[ "toggle" ];
                        CornerRadius = dim(0, 999)
                    });

                    items[ "toggle_outline" ] = library:create( "Frame" , {
                        Parent = items[ "toggle" ];
                        Size = dim2(1, -2, 1, -2);
                        Name = "\0";
                        BorderMode = Enum.BorderMode.Inset;
                        BorderColor3 = rgb(0, 0, 0);
                        Position = dim2(0, 1, 0, 1);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(50, 50, 50)
                    });  library:apply_theme(items[ "toggle_outline" ], "accent", "BackgroundColor3");

                    library:create( "UICorner" , {
                        Parent = items[ "toggle_outline" ];
                        CornerRadius = dim(0, 999)
                    });

                    library:create( "UIGradient" , {
                        Color = rgbseq{rgbkey(0, rgb(211, 211, 211)), rgbkey(1, rgb(211, 211, 211))};
                        Parent = items[ "toggle_outline" ]
                    });

                    items[ "toggle_circle" ] = library:create( "Frame" , {
                        Parent = items[ "toggle_outline" ];
                        Name = "\0";
                        Position = dim2(0, 2, 0, 2);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 12, 0, 12);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(86, 86, 88)
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "toggle_circle" ];
                        CornerRadius = dim(0, 999)
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "outline" ];
                        CornerRadius = dim(0, 7)
                    });

                    items[ "fade" ] = library:create( "Frame" , {
                        Parent = items[ "outline" ];
                        BackgroundTransparency = 0.800000011920929;
                        Name = "\0";
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "fade" ];
                        CornerRadius = dim(0, 7)
                    });
                end
            end;

            if cfg.fading_toggle then
                items[ "button" ].MouseButton1Click:Connect(LPH_NO_VIRTUALIZE(function()
                    cfg.default = not cfg.default
                    cfg.toggle_section(cfg.default)
                end))

                 cfg.toggle_section = LPH_NO_VIRTUALIZE(function(bool)
                    library:tween(items[ "toggle" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(58, 58, 62)}, Enum.EasingStyle.Quad)
                    library:tween(items[ "toggle_outline" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(50, 50, 50)}, Enum.EasingStyle.Quad)
                    library:tween(items[ "toggle_circle" ], {BackgroundColor3 = bool and rgb(255, 255, 255) or rgb(86, 86, 88), Position = bool and dim2(1, -14, 0, 2) or dim2(0, 2, 0, 2)}, Enum.EasingStyle.Quad)
                    library:tween(items[ "fade" ], {BackgroundTransparency = bool and 1 or 0.8}, Enum.EasingStyle.Quad)
                end)
            end

            local tab_names = properties.tabs or properties.Tabs

            if type(tab_names) == "table" and #tab_names > 0 then
                local pages, layouts, buttons, accents, proxies, paddings = {}, {}, {}, {}, {}, {}
                local tab_pad, tab_gap, tab_fit_queued = 9, 4, false

                items[ "section_title" ].Visible = false

                items[ "tab_holder" ] = library:create( "Frame" , {
                    Parent = items[ "button" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 36, 0, 0);
                    Size = dim2(1, -44, 1, -1);
                    BorderSizePixel = 0;
                    ClipsDescendants = true;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library:create( "UIListLayout" , {
                    Parent = items[ "tab_holder" ];
                    FillDirection = Enum.FillDirection.Horizontal;
                    VerticalAlignment = Enum.VerticalAlignment.Center;
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    Padding = dim(0, tab_gap)
                });

                items[ "tab_fade" ] = library:create( "Frame" , {
                    Parent = items[ "inline" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 0, 0, 28);
                    Size = dim2(1, 0, 1, -28);
                    BorderSizePixel = 0;
                    ZIndex = 2;
                    BackgroundColor3 = rgb(22, 22, 24)
                });

                library:create( "UICorner" , {
                    Parent = items[ "tab_fade" ];
                    CornerRadius = dim(0, 7)
                });

                local function fit_tabs()
                    tab_fit_queued = false

                    local holder = items[ "tab_holder" ]
                    local unit = (holder.AbsolutePosition.X - items[ "button" ].AbsolutePosition.X) / 36
                    local available = holder.AbsoluteSize.X

                    if unit <= 0 or available <= 0 or #buttons == 0 then return end

                    local text = 0

                    for i = 1, #buttons do
                        text = text + buttons[i].AbsoluteSize.X / unit - tab_pad * 2
                    end

                    local pad = math.clamp(math.floor((available / unit - text - tab_gap * (#buttons - 1)) / (#buttons * 2)), 3, 9)

                    if pad == tab_pad then return end

                    tab_pad = pad

                    for i = 1, #paddings do
                        paddings[i].PaddingLeft = dim(0, pad)
                        paddings[i].PaddingRight = dim(0, pad)
                    end
                end

                local function queue_tabs()
                    if tab_fit_queued then return end

                    tab_fit_queued = true

                    task.defer(fit_tabs)
                end

                local function paint(index)
                    for i = 1, #pages do
                        local active = i == index

                        library:tween(buttons[i], {TextColor3 = library:theme_text(active and 1 or 0.29)})
                        library:tween(accents[i], {BackgroundTransparency = active and 0 or 1})
                    end
                end

                function cfg.select_tab(index)
                    if not pages[index] then return end

                    local switching = cfg.active_tab ~= nil and cfg.active_tab ~= index

                    cfg.active_tab = index
                    cfg.active_layout = layouts[index]

                    for i = 1, #pages do
                        pages[i].Visible = i == index
                    end

                    items[ "scrolling" ].CanvasPosition = vec2(0, 0)

                    paint(index)

                    if switching then
                        items[ "tab_fade" ].BackgroundTransparency = 0
                        library:tween(items[ "tab_fade" ], {BackgroundTransparency = 1}, Enum.EasingStyle.Quad, 0.4)

                        library:close_element()
                    end

                    if cfg.queue_fit then cfg.queue_fit() end

                    library:relayout_sections()
                end

                for index, tab_name in ipairs(tab_names) do
                    local page = items[ "elements" ]
                    local layout

                    if index == 1 then
                        layout = child_of_class(page, "UIListLayout")
                    else
                        page = library:create( "Frame" , {
                            BorderColor3 = rgb(0, 0, 0);
                            Parent = items[ "scrolling" ];
                            Name = "\0";
                            BackgroundTransparency = 1;
                            Position = dim2(0, 10, 0, 10);
                            Size = dim2(1, -20, 0, 0);
                            BorderSizePixel = 0;
                            AutomaticSize = Enum.AutomaticSize.Y;
                            Visible = false;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });

                        layout = library:create( "UIListLayout" , {
                            Parent = page;
                            Padding = dim(0, 6);
                            SortOrder = Enum.SortOrder.LayoutOrder
                        });

                        if cfg.queue_fit then
                            layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(cfg.queue_fit)
                            page.ChildAdded:Connect(cfg.queue_fit)
                        end
                    end

                    local button = library:create( "TextButton" , {
                        FontFace = fonts.font;
                        Text = tostring(tab_name);
                        TextColor3 = library:theme_text(index == 1 and 1 or 0.29);
                        AutoButtonColor = false;
                        Parent = items[ "tab_holder" ];
                        Name = "\0";
                        LayoutOrder = index;
                        AutomaticSize = Enum.AutomaticSize.X;
                        Size = dim2(0, 0, 1, 0);
                        BackgroundTransparency = 1;
                        BorderSizePixel = 0;
                        TextSize = 16;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    paddings[index] = library:create( "UIPadding" , {
                        Parent = button;
                        PaddingLeft = dim(0, tab_pad);
                        PaddingRight = dim(0, tab_pad)
                    });

                    button:GetPropertyChangedSignal("TextBounds"):Connect(queue_tabs)

                    local accent = library:create( "Frame" , {
                        Parent = button;
                        Name = "\0";
                        AnchorPoint = vec2(0, 1);
                        Position = dim2(0, 0, 1, 0);
                        Size = dim2(1, 0, 0, 2);
                        BorderSizePixel = 0;
                        BackgroundTransparency = index == 1 and 0 or 1;
                        BackgroundColor3 = themes.preset.accent
                    }); library:apply_theme(accent, "accent", "BackgroundColor3");

                    library:create( "UICorner" , {
                        Parent = accent;
                        CornerRadius = dim(0, 999)
                    });

                    pages[index], layouts[index], buttons[index], accents[index] = page, layout, button, accent

                    if library.on_tap then
                        library:on_tap(button, function()
                            cfg.select_tab(index)
                        end)
                    else
                        button.MouseButton1Click:Connect(function()
                            cfg.select_tab(index)
                        end)
                    end

                    if index > 1 then
                        proxies[#proxies + 1] = setmetatable({
                            name = tostring(tab_name);
                            parent_section = cfg;
                            items = {
                                elements = page;
                                outline = items[ "outline" ];
                                inline = items[ "inline" ];
                                scrolling = items[ "scrolling" ];
                                button = items[ "button" ]
                            }
                        }, library)
                    end
                end

                items[ "tab_holder" ]:GetPropertyChangedSignal("AbsoluteSize"):Connect(queue_tabs)
                queue_tabs()

                cfg.tab_pages = pages
                cfg.active_tab = 1
                cfg.active_layout = layouts[1]

                library:on_theme(function(key)
                    if key == "text" then paint(cfg.active_tab or 1) end
                end)

                return setmetatable(cfg, library), table.unpack(proxies)
            end

            return setmetatable(cfg, library)
        end

        function library:toggle(options)
            local rand = math.random(1, 2)
            local cfg = {
                enabled = options.default or false,
                name = options.name or "Toggle",
                info = options.info or nil,
                flag = options.flag or library:next_flag(),

                type = options.type and string.lower(options.type) or rand == 1 and "toggle" or "checkbox";

                default = options.default or false,
                folding = options.folding or false,
                callback = options.callback or function() end,

                items = {};
                seperator = options.seperator or options.Seperator or false;
            }

            flags[cfg.flag] = cfg.default

            local items = cfg.items; do
                items[ "toggle" ] = library:create( "TextButton" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    Parent = self.items[ "elements" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                items[ "name" ] = library:create( "TextLabel" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(245, 245, 245);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = items[ "toggle" ];
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 16;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                if cfg.info then
                    items[ "info" ] = library:create( "TextLabel" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(130, 130, 130);
                        BorderColor3 = rgb(0, 0, 0);
                        TextWrapped = true;
                        Text = cfg.info;
                        Parent = items[ "toggle" ];
                        Name = "\0";
                        Position = dim2(0, 5, 0, 17);
                        Size = dim2(1, -10, 0, 0);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 16;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                end

                library:create( "UIPadding" , {
                    Parent = items[ "name" ];
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });

                items[ "right_components" ] = library:create( "Frame" , {
                    Parent = items[ "toggle" ];
                    Name = "\0";
                    Position = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 0, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library:create( "UIListLayout" , {
                    FillDirection = Enum.FillDirection.Horizontal;
                    HorizontalAlignment = Enum.HorizontalAlignment.Right;
                    Parent = items[ "right_components" ];
                    Padding = dim(0, 9);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });

                    if cfg.type == "checkbox" then
                        items[ "toggle_button" ] = library:create( "TextButton" , {
                            FontFace = fonts.small;
                            TextColor3 = rgb(0, 0, 0);
                            BorderColor3 = rgb(0, 0, 0);
                            Text = "";
                            LayoutOrder = 2;
                            AutoButtonColor = false;
                            AnchorPoint = vec2(1, 0);
                            Parent = items[ "right_components" ];
                            Name = "\0";
                            Position = dim2(1, 0, 0, 0);
                            Size = dim2(0, 16, 0, 16);
                            BorderSizePixel = 0;
                            TextSize = 14;
                            BackgroundColor3 = rgb(67, 67, 68)
                        }); library:apply_theme(items[ "toggle_button" ], "accent", "BackgroundColor3");

                        library:create( "UICorner" , {
                            Parent = items[ "toggle_button" ];
                            CornerRadius = dim(0, 4)
                        });

                        items[ "outline" ] = library:create( "Frame" , {
                            Parent = items[ "toggle_button" ];
                            Size = dim2(1, -2, 1, -2);
                            Name = "\0";
                            BorderMode = Enum.BorderMode.Inset;
                            BorderColor3 = rgb(0, 0, 0);
                            Position = dim2(0, 1, 0, 1);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(22, 22, 24)
                        }); library:apply_theme(items[ "outline" ], "accent", "BackgroundColor3");

                        items[ "tick" ] = library:create( "ImageLabel" , {
                            ImageTransparency = 1;
                            BorderColor3 = rgb(0, 0, 0);
                            Image = "rbxassetid://111862698467575";
                            BackgroundTransparency = 1;
                            Position = dim2(0, -1, 0, 0);
                            Parent = items[ "outline" ];
                            Size = dim2(1, 2, 1, 2);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(255, 255, 255);
                            ZIndex = 1;
                        });

                        library:create( "UICorner" , {
                            Parent = items[ "outline" ];
                            CornerRadius = dim(0, 4)
                        });

                        library:create( "UIGradient" , {
                            Enabled = false;
                            Parent = items[ "outline" ];
                            Color = rgbseq{rgbkey(0, rgb(211, 211, 211)), rgbkey(1, rgb(211, 211, 211))}
                        });
                    else
                        items[ "toggle_button" ] = library:create( "TextButton" , {
                            FontFace = fonts.font;
                            TextColor3 = rgb(0, 0, 0);
                            BorderColor3 = rgb(0, 0, 0);
                            Text = "";
                            LayoutOrder = 2;
                            AnchorPoint = vec2(1, 0.5);
                            Parent = items[ "right_components" ];
                            Name = "\0";
                            Position = dim2(1, -9, 0.5, 0);
                            Size = dim2(0, 36, 0, 18);
                            BorderSizePixel = 0;
                            TextSize = 14;
                            BackgroundColor3 = themes.preset.accent
                        }); library:apply_theme(items[ "toggle_button" ], "accent", "BackgroundColor3");

                        library:create( "UICorner" , {
                            Parent = items[ "toggle_button" ];
                            CornerRadius = dim(0, 999)
                        });

                        do
                            local edge = library:create( "UIStroke" , {
                                Parent = items[ "toggle_button" ];
                                Thickness = 1;
                                Transparency = 1;
                                ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                                Color = themes.preset.accent
                            })

                            library:apply_theme(edge, "accent", "Color")
                            library:track_edge(edge, 0.6)
                        end

                        items[ "inline" ] = library:create( "Frame" , {
                            Parent = items[ "toggle_button" ];
                            Size = dim2(1, -2, 1, -2);
                            Name = "\0";
                            BorderMode = Enum.BorderMode.Inset;
                            BorderColor3 = rgb(0, 0, 0);
                            Position = dim2(0, 1, 0, 1);
                            BorderSizePixel = 0;
                            BackgroundColor3 = themes.preset.accent
                        }); library:apply_theme(items[ "inline" ], "accent", "BackgroundColor3");

                        library:create( "UICorner" , {
                            Parent = items[ "inline" ];
                            CornerRadius = dim(0, 999)
                        });

                        library:create( "UIGradient" , {
                            Color = rgbseq{rgbkey(0, rgb(211, 211, 211)), rgbkey(1, rgb(211, 211, 211))};
                            Parent = items[ "inline" ]
                        });

                        items[ "circle" ] = library:create( "Frame" , {
                            Parent = items[ "inline" ];
                            Name = "\0";
                            Position = dim2(1, -14, 0, 2);
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(0, 12, 0, 12);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });

                        library:create( "UICorner" , {
                            Parent = items[ "circle" ];
                            CornerRadius = dim(0, 999)
                        });
                    end
            end;

             library.accent_refreshers = library.accent_refreshers or {}

             insert(library.accent_refreshers, function()
                 if not cfg.enabled or not items[ "toggle_button" ] or not items[ "toggle_button" ].Parent then return end

                 library:tween(items[ "toggle_button" ], {BackgroundColor3 = themes.preset.accent}, Enum.EasingStyle.Quad, 0.15)

                 if cfg.type == "checkbox" and items[ "outline" ] then
                     library:tween(items[ "outline" ], {BackgroundColor3 = themes.preset.accent}, Enum.EasingStyle.Quad, 0.15)
                 elseif items[ "inline" ] then
                     library:tween(items[ "inline" ], {BackgroundColor3 = themes.preset.accent}, Enum.EasingStyle.Quad, 0.15)
                 end
             end)

             cfg.set = LPH_NO_VIRTUALIZE(function(bool)
                cfg.enabled = bool
                flags[cfg.flag] = bool
                library.armed[cfg.flag] = bool

                cfg.callback(bool)
                keep_identity()

                if cfg.bound_key then
                    cfg.bound_key.apply_owner()
                end

                if cfg.folding then
                    elements.Visible = bool
                end

                if cfg.type == "checkbox" then
                    library:tween(items[ "tick" ], {Rotation = bool and 0 or 45, ImageTransparency = bool and 0 or 1})
                    library:tween(items[ "toggle_button" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(67, 67, 68)})
                    library:tween(items[ "outline" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(22, 22, 24)})
                else
                    library:tween(items[ "toggle_button" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(58, 58, 62)}, Enum.EasingStyle.Quad)
                    library:tween(items[ "inline" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(50, 50, 50)}, Enum.EasingStyle.Quad)
                    library:tween(items[ "circle" ], {BackgroundColor3 = bool and rgb(255, 255, 255) or rgb(86, 86, 88), Position = bool and dim2(1, -14, 0, 2) or dim2(0, 2, 0, 2)}, Enum.EasingStyle.Quad)
                end
            end)

            items[ "toggle" ].MouseButton1Click:Connect(LPH_NO_VIRTUALIZE(function()
                if library:overlay_guarding(cfg, items[ "toggle" ]) then return end

                cfg.enabled = not cfg.enabled
                cfg.set(cfg.enabled)
            end))

            items[ "toggle_button" ].MouseButton1Click:Connect(LPH_NO_VIRTUALIZE(function()
                if library:overlay_guarding(cfg, items[ "toggle_button" ]) then return end

                cfg.enabled = not cfg.enabled
                cfg.set(cfg.enabled)
            end))

            if cfg.seperator then
                library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = self.items[ "elements" ];
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 1, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(36, 36, 37)
                });
            end

            cfg.set(cfg.default)

            config_flags[cfg.flag] = cfg.set

            return setmetatable(cfg, library)
        end

        function library:slider(options)
            local cfg = {
                name = options.name or nil,
                suffix = options.suffix or "",
                flag = options.flag or library:next_flag(),
                callback = options.callback or function() end,
                info = options.info or nil;

                min = options.min or options.minimum or 0,
                max = options.max or options.maximum or 100,
                intervals = options.interval or options.decimal or 1,
                default = options.default or 10,
                value = options.default or 10,
                seperator = options.seperator or options.Seperator or false;
                half = options.half or false;

                dragging = false,
                items = {}
            }

            flags[cfg.flag] = cfg.default

            local row, side

            if cfg.half and self.items and self.items[ "elements" ] then
                if self.half_row and self.half_row.Parent then
                    row = self.half_row
                    side = 1

                    self.half_row = nil
                else
                    row = library:create( "Frame" , {
                        Parent = self.items[ "elements" ];
                        Name = "\0";
                        BackgroundTransparency = 1;
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 0, 16);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    })

                    side = 0
                    self.half_row = row
                end
            end

            local items = cfg.items; do
                items[ "slider_object" ] = library:create( "TextButton" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    Parent = row or self.items[ "elements" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                if row then
                    items[ "slider_object" ].AutomaticSize = Enum.AutomaticSize.None
                    items[ "slider_object" ].Size = dim2(0.5, -3, 1, 0)
                    items[ "slider_object" ].Position = side == 0 and dim2(0, 0, 0, 0) or dim2(0.5, 3, 0, 0)
                end

                items[ "slider" ] = library:create( "TextButton" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    AutoButtonColor = false;
                    Parent = items[ "slider_object" ];
                    Name = "\0";
                    Position = dim2(0, 0, 0, 0);
                    Size = dim2(1, 0, 0, 16);
                    BorderSizePixel = 0;
                    TextSize = 14;
                    BackgroundColor3 = rgb(33, 33, 35)
                });

                library:create( "UICorner" , {
                    Parent = items[ "slider" ];
                    CornerRadius = dim(0, 3)
                });

                items[ "fill" ] = library:create( "Frame" , {
                    Name = "\0";
                    Parent = items[ "slider" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0.5, 0, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.accent
                });  library:apply_theme(items[ "fill" ], "accent", "BackgroundColor3");

                library:create( "UICorner" , {
                    Parent = items[ "fill" ];
                    CornerRadius = dim(0, 3)
                });

                items[ "value" ] = library:create( "TextLabel" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(235, 235, 235);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    Parent = items[ "slider" ];
                    Name = "\0";
                    Position = dim2(0, 6, 0, 0);
                    Size = dim2(1, -12, 1, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Center;
                    TextYAlignment = Enum.TextYAlignment.Center;
                    TextTruncate = Enum.TextTruncate.AtEnd;
                    BorderSizePixel = 0;
                    ZIndex = 3;
                    TextSize = 13;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library:create( "UIStroke" , {
                    Parent = items[ "value" ];
                    Thickness = 1;
                    Transparency = 0.25;
                    Color = rgb(0, 0, 0)
                });

                items[ "name" ] = items[ "value" ]

                if cfg.info then
                    items[ "info" ] = library:create( "TextLabel" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(130, 130, 130);
                        BorderColor3 = rgb(0, 0, 0);
                        TextWrapped = true;
                        Text = cfg.info;
                        Parent = items[ "slider_object" ];
                        Name = "\0";
                        Position = dim2(0, 5, 0, 23);
                        Size = dim2(1, -10, 0, 0);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 16;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                end
            end

            local function render_value()
                local text = tostring(cfg.value) .. cfg.suffix

                items[ "value" ].Text = cfg.name and (cfg.name .. ": " .. text) or text
            end

             cfg.changetext = LPH_NO_VIRTUALIZE(function(text)
                cfg.name = text

                render_value()
            end)

             cfg.set = LPH_NO_VIRTUALIZE(function(value)
                cfg.value = clamp(library:round(value, cfg.intervals), cfg.min, cfg.max)

                flags[cfg.flag] = cfg.value
                cfg.callback(flags[cfg.flag])
                keep_identity()

                library:tween(items[ "fill" ], {Size = dim2((cfg.value - cfg.min) / (cfg.max - cfg.min), 0, 1, 0)}, Enum.EasingStyle.Linear, 0.05)

                render_value()
            end)

            local function slide_to(position)
                local track = items[ "slider" ]
                local size_x = (position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X

                cfg.set(((cfg.max - cfg.min) * math.clamp(size_x, 0, 1)) + cfg.min)
            end

            local function begin_slide(input)
                if library:overlay_guarding(cfg, items[ "slider" ]) then return end

                cfg.dragging = true
                library:tween(items[ "value" ], {TextColor3 = rgb(255, 255, 255)}, Enum.EasingStyle.Quad, 0.2)
                slide_to(input.Position)
            end

            items[ "slider" ].InputBegan:Connect(LPH_NO_VIRTUALIZE(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    begin_slide(input)
                end
            end))

            items[ "slider_object" ].InputBegan:Connect(LPH_NO_VIRTUALIZE(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    begin_slide(input)
                end
            end))

            library:connection(uis.InputChanged, function(input)
                if cfg.dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    slide_to(input.Position)
                end
            end)

            library:connection(uis.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    cfg.dragging = false
                    library:tween(items[ "value" ], {TextColor3 = rgb(235, 235, 235)}, Enum.EasingStyle.Quad, 0.2)
                end
            end)

            if cfg.seperator then
                library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = self.items[ "elements" ];
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 1, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(36, 36, 37)
                });
            end

            cfg.set(cfg.default)
            config_flags[cfg.flag] = cfg.set

            return setmetatable(cfg, library)
        end

        function library:dropdown(options)
            local cfg = {
                name = options.name or nil;
                info = options.info or nil;
                flag = options.flag or library:next_flag();
                options = options.items or {""};
                callback = options.callback or function() end;
                multi = options.multi or false;
                scrolling = options.scrolling or false;

                width = options.width or 130;

                open = false;
                option_instances = {};
                multi_items = {};
                ignore = options.ignore or false;
                items = {};
                y_size;
                seperator = options.seperator or options.Seperator or false;
            }

            cfg.default = options.default or (cfg.multi and {cfg.items[1]}) or cfg.items[1] or "None"
            flags[cfg.flag] = cfg.default

            local items = cfg.items; do
                    items[ "dropdown_object" ] = library:create( "TextButton" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        Parent = self.items[ "elements" ];
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Size = dim2(1, 0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.Y;
                        TextSize = 14;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    items[ "name" ] = library:create( "TextLabel" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(245, 245, 245);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = cfg.name;
                        Parent = items[ "dropdown_object" ];
                        Name = "\0";
                        Size = dim2(1, 0, 0, 0);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 16;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    if cfg.info then
                        items[ "info" ] = library:create( "TextLabel" , {
                            FontFace = fonts.small;
                            TextColor3 = rgb(130, 130, 130);
                            BorderColor3 = rgb(0, 0, 0);
                            TextWrapped = true;
                            Text = cfg.info;
                            Parent = items[ "dropdown_object" ];
                            Name = "\0";
                            Position = dim2(0, 5, 0, 17);
                            Size = dim2(1, -10, 0, 0);
                            BackgroundTransparency = 1;
                            TextXAlignment = Enum.TextXAlignment.Left;
                            BorderSizePixel = 0;
                            AutomaticSize = Enum.AutomaticSize.XY;
                            TextSize = 16;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });
                    end

                    library:create( "UIPadding" , {
                        Parent = items[ "name" ];
                        PaddingRight = dim(0, 5);
                        PaddingLeft = dim(0, 5)
                    });

                    items[ "right_components" ] = library:create( "Frame" , {
                        Parent = items[ "dropdown_object" ];
                        Name = "\0";
                        Position = dim2(1, 0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    library:create( "UIListLayout" , {
                        FillDirection = Enum.FillDirection.Horizontal;
                        HorizontalAlignment = Enum.HorizontalAlignment.Right;
                        Parent = items[ "right_components" ];
                        Padding = dim(0, 7);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });

                    items[ "dropdown" ] = library:create( "TextButton" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        AutoButtonColor = false;
                        AnchorPoint = vec2(1, 0);
                        Parent = items[ "right_components" ];
                        Name = "\0";
                        Position = dim2(1, 0, 0, 0);
                        Size = dim2(0, cfg.width, 0, 16);
                        BorderSizePixel = 0;
                        TextSize = 14;
                        BackgroundColor3 = rgb(33, 33, 35)
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "dropdown" ];
                        CornerRadius = dim(0, 6)
                    });

                    do
                        local edge = library:create( "UIStroke" , {
                            Parent = items[ "dropdown" ];
                            Thickness = 1;
                            Transparency = 1;
                            ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                            Color = themes.preset.accent
                        })

                        library:apply_theme(edge, "accent", "Color")
                        library:track_edge(edge, 0.72)
                    end

                    items[ "sub_text" ] = library:create( "TextLabel" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(86, 86, 87);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "awdawdawdawdawdawdawdaw";
                        Parent = items[ "dropdown" ];
                        Name = "\0";
                        Size = dim2(1, -12, 0, 0);
                        BorderSizePixel = 0;
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        TextTruncate = Enum.TextTruncate.AtEnd;
                        AutomaticSize = Enum.AutomaticSize.Y;
                        TextSize = 14;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    library:create( "UIPadding" , {
                        Parent = items[ "sub_text" ];
                        PaddingTop = dim(0, 1);
                        PaddingRight = dim(0, 5);
                        PaddingLeft = dim(0, 5)
                    });

                    items[ "indicator" ] = library:create( "Frame" , {
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = items[ "dropdown" ];
                        AnchorPoint = vec2(1, 0.5);
                        BackgroundTransparency = 1;
                        Position = dim2(1, -6, 0.5, 0);
                        Name = "\0";
                        Size = dim2(0, 10, 0, 10);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    for _, arm in {{-2, 38}, {2, -38}} do
                        local bar = library:create( "Frame" , {
                            Parent = items[ "indicator" ];
                            Name = "\0";
                            AnchorPoint = vec2(0.5, 0.5);
                            Position = dim2(0.5, arm[1], 0.5, -1);
                            Size = dim2(0, 7, 0, 1);
                            Rotation = arm[2];
                            BorderSizePixel = 0;
                            BorderColor3 = rgb(0, 0, 0);
                            BackgroundColor3 = rgb(120, 120, 122)
                        });

                        library:create( "UICorner" , {
                            Parent = bar;
                            CornerRadius = dim(0, 1)
                        });
                    end

                    items[ "dropdown_holder" ] = library:create( "Frame" , {
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = library[ "items" ];
                        Name = "\0";
                        Visible = false;
                        BackgroundTransparency = 1;
                        Size = dim2(0, 0, 0, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0);
                        ZIndex = 10;
                    });

                    items[ "outline" ] = library:create( "ScrollingFrame" , {
                        Parent = items[ "dropdown_holder" ];
                        Size = dim2(1, 0, 1, 0);
                        ClipsDescendants = true;
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(33, 33, 35);
                        ZIndex = 10;
                        CanvasSize = dim2(0, 0, 0, 0);
                        AutomaticCanvasSize = Enum.AutomaticSize.Y;
                        ScrollBarThickness = 0;
                        Visible = false;
                        ScrollBarImageColor3 = themes.preset.accent;
                        ScrollBarImageTransparency = 0.2;
                        ScrollingDirection = Enum.ScrollingDirection.Y;
                        ElasticBehavior = Enum.ElasticBehavior.Never;
                        VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar;
                    });

                    library:create( "UIPadding" , {
                        PaddingBottom = dim(0, 6);
                        PaddingTop = dim(0, 3);
                        PaddingLeft = dim(0, 3);
                        Parent = items[ "outline" ]
                    });

                    items[ "outline_layout" ] = library:create( "UIListLayout" , {
                        Parent = items[ "outline" ];
                        Padding = dim(0, 5);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "outline" ];
                        CornerRadius = dim(0, 4)
                    });
            end

            function cfg.render_option(text)
                local button = library:create( "TextButton" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(72, 72, 73);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = text;
                    Parent = items[ "outline" ];
                    Name = "\0";
                    Size = dim2(1, -12, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255);
                    ZIndex = 10;
                }); library:apply_theme(button, "accent", "TextColor3");

                library:create( "UIPadding" , {
                    Parent = button;
                    PaddingTop = dim(0, 1);
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });

                return button
            end

            function cfg.max_height()
                local top = items[ "dropdown" ].AbsolutePosition.Y + 80
                local viewport = camera and camera.ViewportSize

                if not viewport then return 220 end

                return math.clamp(viewport.Y - top - 24, 160, 460)
            end

            function cfg.measure()
                local count = #cfg.option_instances

                if count == 0 then
                    cfg.y_size, cfg.overflow, cfg.x_size = 0, false, nil
                    cfg.measured = false

                    return
                end

                if not cfg.measured then
                    local layout = items[ "outline_layout" ]
                    local content = layout and layout.AbsoluteContentSize.Y or 0
                    local settled = content > 0

                    if not settled then
                        content = (count - 1) * 5

                        for _, option in cfg.option_instances do
                            content += option.AbsoluteSize.Y > 0 and option.AbsoluteSize.Y or 19
                        end
                    end

                    cfg.y_size = content + 9

                    local widest = 0
                    local guessed = false

                    for _, option in cfg.option_instances do
                        local bounds = option.TextBounds.X

                        if bounds <= 0 then
                            bounds = #option.Text * option.TextSize * 0.55
                            guessed = true
                        end

                        if bounds > widest then widest = bounds end
                    end

                    cfg.widest = widest

                    cfg.measured = settled and not guessed
                end

                cfg.overflow = cfg.y_size > cfg.max_height()

                cfg.x_size = math.ceil((cfg.widest or 0) + 25 + (cfg.overflow and 6 or 0))
            end

            function cfg.set_visible(bool)
                if bool then cfg.measure() end

                if items[ "indicator" ] then
                    library:tween(items[ "indicator" ], {Rotation = bool and 90 or 0})
                end

                local a = bool and math.min(cfg.y_size, cfg.max_height()) or 0
                local holder = items[ "dropdown_holder" ]
                local outline = items[ "outline" ]

                cfg._visible_token = (cfg._visible_token or 0) + 1

                local token = cfg._visible_token

                if bool then
                    holder.Visible = true

                    if outline then
                        outline.Visible = true
                        outline.ScrollBarThickness = cfg.overflow and 6 or 0
                    end
                elseif outline then
                    outline.ScrollBarThickness = 0
                    outline.ScrollingEnabled = false
                    outline.Visible = false
                end

                local anchor = items[ "dropdown" ]
                local base = anchor.AbsoluteSize.X
                local viewport = camera and camera.ViewportSize
                local width = base
                local x = anchor.AbsolutePosition.X

                if bool then
                    width = math.max(base, cfg.x_size or base)

                    if viewport then
                        width = math.min(width, math.max(base, viewport.X - 16))

                        if x + width > viewport.X - 8 then
                            x = math.max(8, viewport.X - 8 - width)
                        end
                    end
                end

                library:tween(holder, {Size = dim_offset(width, a)})

                holder.Position = dim2(0, x, 0, anchor.AbsolutePosition.Y + 80)

                if bool and outline then
                    outline.ScrollingEnabled = cfg.overflow
                end

                if not bool then
                    holder.Visible = false
                end

                if not (self.sanity and library.current_open == self) then
                    library:close_element(cfg)
                end
            end

            function cfg.set(value)
                local selected = {}
                local isTable = type(value) == "table"

                for _, option in cfg.option_instances do
                    if option.Text == value or (isTable and find(value, option.Text)) then
                        insert(selected, option.Text)
                        cfg.multi_items = selected
                        option.TextColor3 = themes.preset.accent
                    else
                        option.TextColor3 = rgb(72, 72, 73)
                    end
                end

                items[ "sub_text" ].Text = isTable and concat(selected, ", ") or selected[1] or ""
                flags[cfg.flag] = isTable and selected or selected[1]

                cfg.callback(flags[cfg.flag])
                keep_identity()
            end

            function cfg.changetext(text)
                items[ "name" ].Text = text
            end

            function cfg.refresh_options(list)
                cfg.y_size = 0
                cfg.measured = false

                for _, option in cfg.option_instances do
                    option:Destroy()
                end

                cfg.option_instances = {}

                for _, option in list do
                    local button = cfg.render_option(option)
                    insert(cfg.option_instances, button)

                    button.MouseButton1Down:Connect(function()
                        if cfg.multi then
                            local selected_index = find(cfg.multi_items, button.Text)

                            if selected_index then
                                remove(cfg.multi_items, selected_index)
                            else
                                insert(cfg.multi_items, button.Text)
                            end

                            cfg.set(cfg.multi_items)
                        else
                            cfg.set_visible(false)
                            cfg.open = false

                            cfg.set(button.Text)
                        end
                    end)
                end
            end

            library:guard_overlay(cfg, items[ "dropdown_holder" ], items[ "dropdown" ])

            items[ "dropdown" ].MouseButton1Click:Connect(LPH_NO_VIRTUALIZE(function()
                if library:overlay_guarding(cfg, items[ "dropdown" ]) then return end

                cfg.open = not cfg.open

                cfg.set_visible(cfg.open)
            end))

            if cfg.seperator then
                library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = self.items[ "elements" ];
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 1, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(36, 36, 37)
                });
            end

            flags[cfg.flag] = {}
            config_flags[cfg.flag] = cfg.set

            cfg.refresh_options(cfg.options)
            cfg.set(cfg.default)

            library:on_theme(function()
                local current = flags[cfg.flag]
                local idle = library:theme_text(0.29)

                for _, option in cfg.option_instances do
                    if option.Parent then
                        local chosen

                        if cfg.multi then
                            chosen = find(cfg.multi_items, option.Text) ~= nil
                        else
                            chosen = option.Text == current
                        end

                        option.TextColor3 = chosen and themes.preset.accent or idle
                    end
                end
            end)

            return setmetatable(cfg, library)
        end

        function library:label(options)
            local cfg = {
                enabled = options.enabled or nil,
                name = options.name or "Toggle",
                wrapped = options.wrapped or false,
                seperator = options.seperator or options.Seperator or false;
                info = options.info or nil;

                items = {};
            }

            local items = cfg.items; do
                items[ "label" ] = library:create( "TextButton" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    Parent = self.items[ "elements" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                items[ "name" ] = library:create( "TextLabel" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(245, 245, 245);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    TextWrapped = cfg.wrapped,
                    Parent = items[ "label" ];
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 16;
                    RichText = true,
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                if cfg.info then
                    items[ "info" ] = library:create( "TextLabel" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(130, 130, 130);
                        BorderColor3 = rgb(0, 0, 0);
                        TextWrapped = true;
                        Text = cfg.info;
                        Parent = items[ "label" ];
                        Name = "\0";
                        Position = dim2(0, 5, 0, 17);
                        Size = dim2(1, -10, 0, 0);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 16;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                end

                library:create( "UIPadding" , {
                    Parent = items[ "name" ];
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });

                items[ "right_components" ] = library:create( "Frame" , {
                    Parent = items[ "label" ];
                    Name = "\0";
                    Position = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 0, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library:create( "UIListLayout" , {
                    FillDirection = Enum.FillDirection.Horizontal;
                    HorizontalAlignment = Enum.HorizontalAlignment.Right;
                    Parent = items[ "right_components" ];
                    Padding = dim(0, 9);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });
            end

            if cfg.seperator then
                library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = self.items[ "elements" ];
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 1, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(36, 36, 37)
                });
            end

            function cfg.set(text)
                items[ "name" ].Text = text
            end

            return setmetatable(cfg, library)
        end

        function library:colorpicker(options)
            local cfg = {
                name = options.name or "Color",
                flag = options.flag or library:next_flag(),

                color = options.color or color(1, 1, 1),
                alpha = options.alpha and 1 - options.alpha or 0,

                no_alpha = options.no_alpha or false,

                open = false,
                callback = options.callback or function() end,
                items = {};

                seperator = options.seperator or options.Seperator or false;
            }

            local dragging_sat = false
            local dragging_hue = false
            local dragging_alpha = false

            local h, s, v = cfg.color:ToHSV()
            local a = cfg.alpha

            flags[cfg.flag] = {Color = cfg.color, Transparency = cfg.alpha}

            local label;
            if not self.items.right_components then
                label = self:label({name = cfg.name, seperator = cfg.seperator})
            end

            local items = cfg.items; do
                    items[ "colorpicker" ] = library:create( "TextButton" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        AutoButtonColor = false;
                        AnchorPoint = vec2(1, 0);
                        Parent = label and label.items.right_components or self.items[ "right_components" ];
                        Name = "\0";
                        Position = dim2(1, 0, 0, 0);
                        Size = dim2(0, 16, 0, 16);
                        BorderSizePixel = 0;
                        TextSize = 14;
                        BackgroundColor3 = rgb(54, 31, 184)
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "colorpicker" ];
                        CornerRadius = dim(0, 4)
                    });

                    items[ "colorpicker_inline" ] = library:create( "Frame" , {
                        Parent = items[ "colorpicker" ];
                        Size = dim2(1, -2, 1, -2);
                        Name = "\0";
                        BorderMode = Enum.BorderMode.Inset;
                        BorderColor3 = rgb(0, 0, 0);
                        Position = dim2(0, 1, 0, 1);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(54, 31, 184)
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "colorpicker_inline" ];
                        CornerRadius = dim(0, 4)
                    });

                    library:create( "UIGradient" , {
                        Color = rgbseq{rgbkey(0, rgb(211, 211, 211)), rgbkey(1, rgb(211, 211, 211))};
                        Parent = items[ "colorpicker_inline" ]
                    });

                    items[ "colorpicker_holder" ] = library:create( "Frame" , {
                        Parent = library[ "other" ];
                        Name = "\0";
                        Position = dim2(0.20000000298023224, 20, 0.296999990940094, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 166, 0, 197);
                        BorderSizePixel = 0;
                        Visible = true;

                        Active = true;

                        BackgroundColor3 = rgb(25, 25, 29)
                    });

                    items[ "colorpicker_fade" ] = library:create( "Frame" , {
                        Parent = items[ "colorpicker_holder" ];
                        Name = "\0";
                        BackgroundTransparency = 0;
                        Position = dim2(0, 0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        ZIndex = 100;
                        BackgroundColor3 = rgb(25, 25, 29)
                    });

                    items[ "colorpicker_components" ] = library:create( "Frame" , {
                        Parent = items[ "colorpicker_holder" ];
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(22, 22, 24)
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "colorpicker_components" ];
                        CornerRadius = dim(0, 6)
                    });

                    items[ "saturation_holder" ] = library:create( "Frame" , {
                        Parent = items[ "colorpicker_components" ];
                        Name = "\0";
                        Position = dim2(0, 7, 0, 7);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -14, 1, -80);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 39, 39)
                    });

                    items[ "sat" ] = library:create( "TextButton" , {
                        Parent = items[ "saturation_holder" ];
                        Name = "\0";
                        Size = dim2(1, 0, 1, 0);
                        Text = "";
                        AutoButtonColor = false;
                        BorderColor3 = rgb(0, 0, 0);
                        ZIndex = 2;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "sat" ];
                        CornerRadius = dim(0, 4)
                    });

                    library:create( "UIGradient" , {
                        Rotation = 270;
                        Transparency = numseq{numkey(0, 0), numkey(1, 1)};
                        Parent = items[ "sat" ];
                        Color = rgbseq{rgbkey(0, rgb(0, 0, 0)), rgbkey(1, rgb(0, 0, 0))}
                    });

                    items[ "val" ] = library:create( "Frame" , {
                        Name = "\0";
                        Parent = items[ "saturation_holder" ];
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    library:create( "UIGradient" , {
                        Parent = items[ "val" ];
                        Transparency = numseq{numkey(0, 0), numkey(1, 1)}
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "val" ];
                        CornerRadius = dim(0, 4)
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "saturation_holder" ];
                        CornerRadius = dim(0, 4)
                    });

                    items[ "satvalpicker" ] = library:create( "TextButton" , {
                        BorderColor3 = rgb(0, 0, 0);
                        AutoButtonColor = false;
                        Text = "";
                        AnchorPoint = vec2(0, 1);
                        Parent = items[ "saturation_holder" ];
                        Name = "\0";
                        Position = dim2(0, 0, 4, 0);
                        Size = dim2(0, 8, 0, 8);
                        ZIndex = 5;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 0, 0)
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "satvalpicker" ];
                        CornerRadius = dim(0, 9999)
                    });

                    library:create( "UIStroke" , {
                        Color = rgb(255, 255, 255);
                        Parent = items[ "satvalpicker" ];
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    });

                    items[ "hue_gradient" ] = library:create( "TextButton" , {
                        Parent = items[ "colorpicker_components" ];
                        Name = "\0";
                        Position = dim2(0, 10, 1, -64);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -20, 0, 8);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255);
                        AutoButtonColor = false;
                        Text = "";
                    });

                    library:create( "UIGradient" , {
                        Color = rgbseq{rgbkey(0, rgb(255, 0, 0)), rgbkey(0.17, rgb(255, 255, 0)), rgbkey(0.33, rgb(0, 255, 0)), rgbkey(0.5, rgb(0, 255, 255)), rgbkey(0.67, rgb(0, 0, 255)), rgbkey(0.83, rgb(255, 0, 255)), rgbkey(1, rgb(255, 0, 0))};
                        Parent = items[ "hue_gradient" ]
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "hue_gradient" ];
                        CornerRadius = dim(0, 6)
                    });

                    items[ "hue_picker" ] = library:create( "TextButton" , {
                        BorderColor3 = rgb(0, 0, 0);
                        AutoButtonColor = false;
                        Text = "";
                        AnchorPoint = vec2(0, 0.5);
                        Parent = items[ "hue_gradient" ];
                        Name = "\0";
                        Position = dim2(0, 0, 0.5, 0);
                        Size = dim2(0, 8, 0, 8);
                        ZIndex = 5;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 0, 0)
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "hue_picker" ];
                        CornerRadius = dim(0, 9999)
                    });

                    library:create( "UIStroke" , {
                        Color = rgb(255, 255, 255);
                        Parent = items[ "hue_picker" ];
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    });

                    items[ "alpha_gradient" ] = library:create( "TextButton" , {
                        Parent = items[ "colorpicker_components" ];
                        Name = "\0";
                        Position = dim2(0, 10, 1, -46);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -20, 0, 8);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(25, 25, 29);
                        AutoButtonColor = false;
                        Text = "";
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "alpha_gradient" ];
                        CornerRadius = dim(0, 6)
                    });

                    items[ "alpha_picker" ] = library:create( "TextButton" , {
                        BorderColor3 = rgb(0, 0, 0);
                        AutoButtonColor = false;
                        Text = "";
                        AnchorPoint = vec2(0, 0.5);
                        Parent = items[ "alpha_gradient" ];
                        Name = "\0";
                        Position = dim2(1, 0, 0.5, 0);
                        Size = dim2(0, 8, 0, 8);
                        ZIndex = 5;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 0, 0)
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "alpha_picker" ];
                        CornerRadius = dim(0, 9999)
                    });

                    library:create( "UIStroke" , {
                        Color = rgb(255, 255, 255);
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                        Parent = items[ "alpha_picker" ]
                    });

                    library:create( "UIGradient" , {
                        Color = rgbseq{rgbkey(0, rgb(0, 0, 0)), rgbkey(1, rgb(255, 255, 255))};
                        Parent = items[ "alpha_gradient" ]
                    });

                    items[ "alpha_indicator" ] = library:create( "ImageLabel" , {
                        ScaleType = Enum.ScaleType.Tile;
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = items[ "alpha_gradient" ];
                        Image = "rbxassetid://18274452449";
                        BackgroundTransparency = 1;
                        Name = "\0";
                        Size = dim2(1, 0, 1, 0);
                        TileSize = dim2(0, 6, 0, 6);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });

                    library:create( "UIGradient" , {
                        Color = rgbseq{rgbkey(0, rgb(112, 112, 112)), rgbkey(1, rgb(255, 0, 0))};
                        Transparency = numseq{numkey(0, 0.8062499761581421), numkey(1, 0)};
                        Parent = items[ "alpha_indicator" ]
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "alpha_indicator" ];
                        CornerRadius = dim(0, 6)
                    });

                    library:create( "UIGradient" , {
                        Rotation = 90;
                        Parent = items[ "colorpicker_components" ];
                        Color = rgbseq{rgbkey(0, rgb(255, 255, 255)), rgbkey(1, rgb(66, 66, 66))}
                    });

                    items[ "input" ] = library:create( "TextBox" , {
                        FontFace = fonts.font;
                        AnchorPoint = vec2(1, 1);
                        Text = "";
                        Parent = items[ "colorpicker_components" ];
                        Name = "\0";
                        TextTruncate = Enum.TextTruncate.AtEnd;
                        BorderSizePixel = 0;
                        PlaceholderColor3 = rgb(255, 255, 255);
                        CursorPosition = -1;
                        ClearTextOnFocus = false;
                        TextSize = 14;
                        BackgroundColor3 = rgb(255, 255, 255);
                        TextColor3 = rgb(72, 72, 72);
                        BorderColor3 = rgb(0, 0, 0);
                        Position = dim2(1, -8, 1, -11);
                        Size = dim2(1, -16, 0, 18);
                        BackgroundColor3 = rgb(33, 33, 35)
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "input" ];
                        CornerRadius = dim(0, 3)
                    });

                    items[ "UICorenr" ] = library:create( "UICorner" , {
                        Parent = items[ "colorpicker_holder" ];
                        Name = "\0";
                        CornerRadius = dim(0, 4)
                    });
            end;

            for _, object in items[ "colorpicker_holder" ]:GetDescendants() do
                if object:IsA("GuiObject") then
                    object.ZIndex += 200
                end
            end

            items[ "colorpicker_holder" ].ZIndex += 200

            function cfg.set_visible(bool)
                items[ "colorpicker_fade" ].BackgroundTransparency = 0
                items[ "colorpicker_holder" ].Parent = bool and library[ "items" ] or library[ "other" ]
                items[ "colorpicker_holder" ].Position = dim_offset(items[ "colorpicker" ].AbsolutePosition.X, items[ "colorpicker" ].AbsolutePosition.Y + items[ "colorpicker" ].AbsoluteSize.Y + 45)

                library:tween(items[ "colorpicker_fade" ], {BackgroundTransparency = 1}, Enum.EasingStyle.Quad, 0.4)
                library:tween(items[ "colorpicker_holder" ], {Position = items[ "colorpicker_holder" ].Position + dim_offset(0, 20)})

                if not (self.sanity and library.current_open == self and self.open) then
                    library:close_element(cfg)
                end
            end

            function cfg.set(color, alpha)
                if type(color) == "boolean" then
                    return
                end

                if color then
                    h, s, v = color:ToHSV()
                end

                if alpha then
                    a = alpha
                end

                local Color = hsv(h, s, v)

                library:tween(items[ "hue_picker" ], {Position = dim2(0, (items[ "hue_gradient" ].AbsoluteSize.X - items[ "hue_picker" ].AbsoluteSize.X) * h, 0.5, 0)}, Enum.EasingStyle.Linear, 0.05)
                library:tween(items[ "alpha_picker" ], {Position = dim2(0, (items[ "alpha_gradient" ].AbsoluteSize.X - items[ "alpha_picker" ].AbsoluteSize.X) * (1 - a), 0.5, 0)}, Enum.EasingStyle.Linear, 0.05)
                library:tween(items[ "satvalpicker" ], {Position = dim2(0, s * (items[ "saturation_holder" ].AbsoluteSize.X - items[ "satvalpicker" ].AbsoluteSize.X), 1, 1 - v * (items[ "saturation_holder" ].AbsoluteSize.Y - items[ "satvalpicker" ].AbsoluteSize.Y))}, Enum.EasingStyle.Linear, 0.05)

                child_of_class(items[ "alpha_indicator" ], "UIGradient").Color = rgbseq{rgbkey(0, rgb(112, 112, 112)), rgbkey(1, hsv(h, 1, 1))};

                items[ "colorpicker" ].BackgroundColor3 = Color
                items[ "colorpicker_inline" ].BackgroundColor3 = Color
                items[ "saturation_holder" ].BackgroundColor3 = hsv(h, 1, 1)

                items[ "hue_picker" ].BackgroundColor3 = hsv(h, 1, 1)
                items[ "alpha_picker" ].BackgroundColor3 = hsv(h, 1, 1 - a)
                items[ "satvalpicker" ].BackgroundColor3 = hsv(h, s, v)

                flags[cfg.flag] = {
                    Color = Color;
                    Transparency = a
                }

                local color = items[ "colorpicker" ].BackgroundColor3
                items[ "input" ].Text = string.format("%s, %s, %s, ", library:round(color.R * 255), library:round(color.G * 255), library:round(color.B * 255))
                items[ "input" ].Text ..= library:round(1 - a, 0.01)

                cfg.callback(Color, a)
                keep_identity()
            end

            function cfg.update_color()
                local offset = vec2(Mouse.X, Mouse.Y - gui_offset)

                if dragging_sat then
                    s = math.clamp((offset - items["sat"].AbsolutePosition).X / items["sat"].AbsoluteSize.X, 0, 1)
                    v = 1 - math.clamp((offset - items["sat"].AbsolutePosition).Y / items["sat"].AbsoluteSize.Y, 0, 1)
                elseif dragging_hue then
                    h = math.clamp((offset - items[ "hue_gradient" ].AbsolutePosition).X / items[ "hue_gradient" ].AbsoluteSize.X, 0, 1)
                elseif dragging_alpha then
                    a = 1 - math.clamp((offset - items[ "alpha_gradient" ].AbsolutePosition).X / items[ "alpha_gradient" ].AbsoluteSize.X, 0, 1)
                end

                cfg.set()
            end

            library:guard_overlay(cfg, items[ "colorpicker_holder" ], items[ "colorpicker" ])

            items[ "colorpicker" ].MouseButton1Click:Connect(function()
                if library:overlay_guarding(cfg, items[ "colorpicker" ]) then return end

                cfg.open = not cfg.open

                cfg.set_visible(cfg.open)
            end)

            uis.InputChanged:Connect(function(input)
                if (dragging_sat or dragging_hue or dragging_alpha) and input.UserInputType == Enum.UserInputType.MouseMovement then
                    cfg.update_color()
                end
            end)

            library:connection(uis.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging_sat = false
                    dragging_hue = false
                    dragging_alpha = false
                end
            end)

            items[ "alpha_gradient" ].MouseButton1Down:Connect(function()
                dragging_alpha = true
            end)

            items[ "hue_gradient" ].MouseButton1Down:Connect(function()
                dragging_hue = true
            end)

            items[ "sat" ].MouseButton1Down:Connect(function()
                dragging_sat = true
            end)

            items[ "input" ].FocusLost:Connect(function()
                local text = items[ "input" ].Text
                local r, g, b, a = library:convert(text)

                if r and g and b and a then
                    cfg.set(rgb(r, g, b), 1 - a)
                end
            end)

            items[ "input" ].Focused:Connect(function()
                library:tween(items[ "input" ], {TextColor3 = rgb(245, 245, 245)})
            end)

            items[ "input" ].FocusLost:Connect(function()
                library:tween(items[ "input" ], {TextColor3 = rgb(72, 72, 72)})
            end)

            if cfg.no_alpha then
                items[ "alpha_gradient" ].Visible = false
                items[ "colorpicker_holder" ].Size = dim2(0, 166, 0, 179)
                cfg.alpha = 0
            end

            cfg.set(cfg.color, cfg.alpha)
            config_flags[cfg.flag] = cfg.set

            return setmetatable(cfg, library)
        end

        function library:textbox(options)
            local cfg = {
                name = options.name or "TextBox",
                placeholder = options.placeholder or options.placeholdertext or options.holder or options.holdertext or "type here...",
                default = options.default or "",
                flag = options.flag or library:next_flag(),
                callback = options.callback or function() end,
                visible = options.visible or true,

                tall = options.tall or options.Tall or false;
                seperator = options.seperator or options.Seperator or false;

                layout = options.layout or options.LayoutOrder or 0;

                items = {};
            }

            flags[cfg.flag] = cfg.default

            local items = cfg.items; do
                items[ "textbox" ] = library:create( "TextButton" , {
                    LayoutOrder = cfg.layout;
                    FontFace = fonts.font;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    Parent = self.items[ "elements" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                items[ "name" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(245, 245, 245);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = items[ "textbox" ];
                    Name = "\0";
                    Position = dim2(0, 5, 0, 0);
                    Size = dim2(1, -10, 0, cfg.tall and 19 or 15);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    TextTruncate = Enum.TextTruncate.AtEnd;
                    BorderSizePixel = 0;
                    TextSize = cfg.tall and 16 or 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                items[ "input" ] = library:create( "TextBox" , {
                    FontFace = fonts.font;
                    Text = "";
                    PlaceholderText = cfg.placeholder;
                    Parent = items[ "textbox" ];
                    Name = "\0";
                    TextTruncate = Enum.TextTruncate.AtEnd;
                    BorderSizePixel = 0;
                    PlaceholderColor3 = rgb(110, 110, 110);
                    CursorPosition = -1;
                    ClearTextOnFocus = false;
                    TextSize = 14;
                    TextColor3 = rgb(72, 72, 72);
                    BorderColor3 = rgb(0, 0, 0);
                    AnchorPoint = vec2(0, 0);
                    Position = dim2(0, 0, 0, cfg.tall and 21 or 16);
                    Size = dim2(1, 0, 0, cfg.tall and 28 or 20);
                    BackgroundColor3 = rgb(33, 33, 35)
                });

                library:create( "UICorner" , {
                    Parent = items[ "input" ];
                    CornerRadius = dim(0, 3)
                });

                library:create( "UIPadding" , {
                    Parent = items[ "input" ];
                    PaddingRight = dim(0, 6);
                    PaddingLeft = dim(0, 6)
                });
            end

            if cfg.seperator then
                library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = self.items[ "elements" ];
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 1, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(36, 36, 37)
                });
            end

            function cfg.set(text)
                flags[cfg.flag] = text

                items[ "input" ].Text = text

                cfg.callback(text)
                keep_identity()
            end

            items[ "input" ]:GetPropertyChangedSignal("Text"):Connect(function()
                cfg.set(items[ "input" ].Text)
            end)

            items[ "input" ].Focused:Connect(function()
                library:tween(items[ "input" ], {TextColor3 = rgb(245, 245, 245)})
            end)

            items[ "input" ].FocusLost:Connect(function()
                library:tween(items[ "input" ], {TextColor3 = rgb(72, 72, 72)})
            end)

            if cfg.default then
                cfg.set(cfg.default)
            end

            config_flags[cfg.flag] = cfg.set

            return setmetatable(cfg, library)
        end

        function library:keybind(options)
            local cfg = {
                flag = options.flag or library:next_flag(),
                callback = options.callback or function() end,
                name = options.name or nil,
                ignore_key = options.ignore or false,
                seperator = options.seperator or false,

                key = options.key or "NONE",
                mode = options.mode or "Always",
                active = options.default or false,
                owner = options.owner or nil,
                attach = options.attach or nil,

                open = false,
                binding = nil,

                hold_instances = {},
                items = {};
            }

            flags[cfg.flag] = {
                mode = cfg.mode,
                key = cfg.key,
                active = cfg.active
            }

            local items = cfg.items; do
                    items[ "keybind_element" ] = library:create( "TextButton" , {
                        FontFace = fonts.font;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        Parent = (cfg.attach and cfg.attach.items and cfg.attach.items[ "toggle" ]) or self.items[ "elements" ];
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Size = dim2(1, 0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.Y;
                        TextSize = 14;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    if cfg.attach then
                        cfg.attach.bound_key = cfg

                        items[ "keybind_element" ].AnchorPoint = vec2(1, 0.5)
                        items[ "keybind_element" ].Position = dim2(1, -46, 0.5, 0)
                        items[ "keybind_element" ].AutomaticSize = Enum.AutomaticSize.None
                        items[ "keybind_element" ].Size = dim2(0, 46, 0, 18)
                    end

                    items[ "name" ] = library:create( "TextLabel" , {
                        FontFace = fonts.font;
                        TextColor3 = rgb(245, 245, 245);
                        BorderColor3 = rgb(0, 0, 0);
                        Visible = not cfg.attach;
                        Text = cfg.name;
                        Parent = items[ "keybind_element" ];
                        Name = "\0";
                        Size = dim2(1, 0, 0, 0);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 16;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    library:create( "UIPadding" , {
                        Parent = items[ "name" ];
                        PaddingRight = dim(0, 5);
                        PaddingLeft = dim(0, 5)
                    });

                    items[ "right_components" ] = library:create( "Frame" , {
                        Parent = items[ "keybind_element" ];
                        Name = "\0";
                        Position = dim2(1, 0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    library:create( "UIListLayout" , {
                        FillDirection = Enum.FillDirection.Horizontal;
                        HorizontalAlignment = Enum.HorizontalAlignment.Right;
                        Parent = items[ "right_components" ];
                        Padding = dim(0, 7);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });

                    items[ "keybind_holder" ] = library:create( "TextButton" , {
                        FontFace = fonts.font;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        Parent = items[ "right_components" ];
                        AutoButtonColor = false;
                        AnchorPoint = vec2(1, 0);
                        Size = dim2(0, 0, 0, 16);
                        Name = "\0";
                        Position = dim2(1, 0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.X;
                        TextSize = 14;
                        BackgroundColor3 = rgb(33, 33, 35)
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "keybind_holder" ];
                        CornerRadius = dim(0, 4)
                    });

                    items[ "key" ] = library:create( "TextLabel" , {
                        FontFace = fonts.font;
                        TextColor3 = rgb(86, 86, 87);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "LSHIFT";
                        Parent = items[ "keybind_holder" ];
                        Name = "\0";
                        Size = dim2(1, -12, 0, 0);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 14;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    library:create( "UIPadding" , {
                        Parent = items[ "key" ];
                        PaddingTop = dim(0, 1);
                        PaddingRight = dim(0, 5);
                        PaddingLeft = dim(0, 5)
                    });

                    items[ "dropdown" ] = library:create( "Frame" , {
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = library.items;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Visible = false;
                        Position = dim2(0, 0, 0, 0);
                        Size = dim2(0, 0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.X;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });

                    items[ "inline" ] = library:create( "Frame" , {
                        Parent = items[ "dropdown" ];
                        Size = dim2(1, 0, 1, 0);
                        Name = "\0";
                        ClipsDescendants = true;
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(22, 22, 24)
                    });

                    library:create( "UIPadding" , {
                        PaddingBottom = dim(0, 6);
                        PaddingTop = dim(0, 3);
                        PaddingLeft = dim(0, 3);
                        Parent = items[ "inline" ]
                    });

                    library:create( "UIListLayout" , {
                        Parent = items[ "inline" ];
                        Padding = dim(0, 5);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "inline" ];
                        CornerRadius = dim(0, 4)
                    });

                    local options = {"Hold", "Toggle", "Always"}

                    cfg.y_size = 20
                    for _, option in options do
                        local name = library:create( "TextButton" , {
                            FontFace = fonts.font;
                            BorderColor3 = rgb(0, 0, 0);
                            Text = option;
                            Parent = items[ "inline" ];
                            Name = "\0";
                            Size = dim2(0, 0, 0, 0);
                            BackgroundTransparency = 1;
                            TextXAlignment = Enum.TextXAlignment.Left;
                            BorderSizePixel = 0;
                            AutomaticSize = Enum.AutomaticSize.XY;
                            TextSize = 14;
                            BackgroundColor3 = rgb(255, 255, 255)
                        }); cfg.hold_instances[option] = name

                        cfg.y_size += name.AbsoluteSize.Y

                        library:create( "UIPadding" , {
                            Parent = name;
                            PaddingTop = dim(0, 1);
                            PaddingRight = dim(0, 5);
                            PaddingLeft = dim(0, 5)
                        });

                        name.MouseButton1Click:Connect(function()
                            cfg.set(option)

                            cfg.set_visible(false)

                            cfg.open = false
                        end)
                    end
            end

            if cfg.seperator then
                library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = self.items[ "elements" ];
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 1, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(36, 36, 37)
                });
            end

            function cfg.modify_mode_color(path)
                for _, v in cfg.hold_instances do
                    v.TextColor3 = themes.preset.inactive or rgb(72, 72, 72)
                end

                local selected = cfg.hold_instances[path] or cfg.hold_instances["Always"]

                if selected then
                    selected.TextColor3 = themes.preset.accent
                end
            end

            if library.on_theme then
                library:on_theme(function()
                    cfg.modify_mode_color(cfg.mode)
                end)
            end

            library.accent_refreshers = library.accent_refreshers or {}

            insert(library.accent_refreshers, function()
                cfg.modify_mode_color(cfg.mode)
            end)

            function cfg.set_mode(mode)
                cfg.mode = mode

                if mode == "Always" then
                    cfg.set(true)
                elseif mode == "Hold" then
                    cfg.set(false)
                end

                local stored = flags[cfg.flag]

                if type(stored) == "table" then
                    stored.mode = mode
                end

                cfg.modify_mode_color(mode)
            end

            function cfg.set(input)
                if type(input) == "boolean" then
                    cfg.active = input

                    if cfg.mode == "Always" then
                        cfg.active = true
                    end
                elseif tostring(input):find("Enum") then
                    input = input.Name == "Escape" and "NONE" or input

                    cfg.key = input or "NONE"
                elseif find({"Toggle", "Hold", "Always"}, input) then
                    if input == "Always" then
                        cfg.active = true
                    end

                    cfg.mode = input
                    cfg.set_mode(cfg.mode)
                elseif type(input) == "table" then
                    input.key = type(input.key) == "string" and input.key ~= "NONE" and library:convert_enum(input.key) or input.key
                    input.key = input.key == Enum.KeyCode.Escape and "NONE" or input.key

                    cfg.key = input.key or "NONE"
                    cfg.mode = input.mode or cfg.mode or "Always"
                    cfg.active = input.active == true

                    cfg.set_mode(cfg.mode)
                end

                if cfg.attach then
                    cfg.apply_owner()
                else
                    cfg.callback(cfg.active)
                    keep_identity()
                end

                local text = tostring(cfg.key) ~= "Enums" and (keys[cfg.key] or tostring(cfg.key):gsub("Enum.", "")) or nil
                local __text = text and (tostring(text):gsub("KeyCode.", ""):gsub("UserInputType.", ""))

                items[ "key" ].Text = __text

                flags[cfg.flag] = {
                    mode = cfg.mode,
                    key = cfg.key,
                    active = cfg.active
                }
            end

            function cfg.apply_owner()
                local toggle = cfg.attach

                if not toggle or not toggle.flag then
                    cfg.callback(cfg.active)
                    keep_identity()

                    return
                end

                local armed = toggle.enabled and true or false
                local live = armed and (cfg.mode == "Always" or cfg.active) or false

                cfg.active = live

                if flags[toggle.flag] == live then
                    cfg.callback(live)
                    keep_identity()

                    return
                end

                flags[toggle.flag] = live

                cfg.callback(live)
                keep_identity()

                local owner_callback = toggle.raw_callback or toggle.callback

                if owner_callback then
                    pcall(owner_callback, live)
                end
            end

            function cfg.set_visible(bool)
                local size = bool and cfg.y_size or 0

                if bool then
                    cfg.modify_mode_color(cfg.mode)
                    items[ "dropdown" ].Visible = true
                end

                library:tween(items[ "dropdown" ], {Size = dim_offset(items[ "keybind_holder" ].AbsoluteSize.X, size)})

                items[ "dropdown" ].Position = dim_offset(items[ "keybind_holder" ].AbsolutePosition.X, items[ "keybind_holder" ].AbsolutePosition.Y + items[ "keybind_holder" ].AbsoluteSize.Y + 60)

                if not bool then
                    items[ "dropdown" ].Visible = false
                end
            end

            library:guard_overlay(cfg, items[ "dropdown" ], items[ "keybind_holder" ])

            items[ "keybind_holder" ].MouseButton1Down:Connect(function()
                if library:overlay_guarding(cfg, items[ "keybind_holder" ]) then return end

                task.wait()
                items[ "key" ].Text = ""

                cfg.binding = library:connection(uis.InputBegan, function(keycode, game_event)
                    cfg.set(keycode.KeyCode ~= Enum.KeyCode.Unknown and keycode.KeyCode or keycode.UserInputType)

                    cfg.binding:Disconnect()
                    cfg.binding = nil
                end)
            end)

            items[ "keybind_holder" ].MouseButton2Down:Connect(function()
                cfg.open = not cfg.open

                cfg.set_visible(cfg.open)
            end)

            library:connection(uis.InputBegan, function(input, game_event)
                if not game_event then
                    local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType

                    if selected_key == cfg.key then
                        if cfg.mode == "Toggle" then
                            cfg.active = not cfg.active
                            cfg.set(cfg.active)
                        elseif cfg.mode == "Hold" then
                            cfg.set(true)
                        end
                    end
                end
            end)

            library:connection(uis.InputEnded, function(input, game_event)
                if game_event then
                    return
                end

                local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType

                if selected_key == cfg.key then
                    if cfg.mode == "Hold" then
                        cfg.set(false)
                    end
                end
            end)

            cfg.set({mode = cfg.mode, active = cfg.active, key = cfg.key})
            config_flags[cfg.flag] = cfg.set

            return setmetatable(cfg, library)
        end

        function library:button(options)
            local host, row

            if self.items and self.items[ "elements" ] then
                host = self.items[ "elements" ]
            else
                host = self.host
                row = self.row
            end

            local cfg = {
                name = options.name or "TextBox",
                callback = options.callback or function() end,
                seperator = options.seperator or options.Seperator or false;
                safemode = options.safemode or options.Safemode or false;
                confirm = options.confirm or "are you sure?";
                confirm_time = options.confirm_time or 3;
                host = host;
                items = {};
            }

            local items = cfg.items; do
                if row then
                    items[ "button_element" ] = row
                else
                    items[ "button_element" ] = library:create( "Frame" , {
                        Parent = host;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Size = dim2(1, 0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.Y;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    library:create( "UIListLayout" , {
                        Parent = items[ "button_element" ];
                        FillDirection = Enum.FillDirection.Horizontal;
                        HorizontalFlex = Enum.UIFlexAlignment.Fill;
                        VerticalAlignment = Enum.VerticalAlignment.Center;
                        Padding = dim(0, 6);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });

                    library:create( "UIPadding" , {
                        Parent = items[ "button_element" ];
                        PaddingRight = dim(0, 4);
                        PaddingLeft = dim(0, 4)
                    });
                end

                items[ "button" ] = library:create( "TextButton" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    AutoButtonColor = false;
                    Parent = items[ "button_element" ];
                    Name = "\0";
                    Size = dim2(0, 0, 0, 24);
                    BorderSizePixel = 0;
                    TextSize = 14;
                    BackgroundColor3 = rgb(33, 33, 35)
                });

                library:create( "UICorner" , {
                    Parent = items[ "button" ];
                    CornerRadius = dim(0, 3)
                });

                items[ "name" ] = library:create( "TextLabel" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(245, 245, 245);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = items[ "button" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 1, 0);
                    TextTruncate = Enum.TextTruncate.AtEnd;
                    BorderSizePixel = 0;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); library:apply_theme(items[ "name" ], "accent", "BackgroundColor3");
            end

            cfg.row = items[ "button_element" ]

            if cfg.seperator then
                library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = host;
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 1, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(36, 36, 37)
                });
            end

            cfg.armed = false
            cfg.arm_generation = 0

            function cfg.disarm()
                cfg.armed = false
                cfg.arm_generation = cfg.arm_generation + 1

                items[ "name" ].Text = cfg.name
            end

            function cfg.press()
                items[ "name" ].TextColor3 = themes.preset.accent
                library:tween(items[ "name" ], {TextColor3 = library:theme_text(1)})

                if cfg.safemode then
                    if not cfg.armed then
                        cfg.armed = true
                        cfg.arm_generation = cfg.arm_generation + 1

                        local generation = cfg.arm_generation

                        items[ "name" ].Text = cfg.confirm

                        task.delay(cfg.confirm_time, function()
                            if cfg.arm_generation == generation then
                                cfg.disarm()
                            end
                        end)

                        return
                    end

                    cfg.disarm()
                end

                cfg.callback()
                keep_identity()
            end

            items[ "button" ].MouseButton1Click:Connect(function()
                if library:overlay_guarding(cfg, items[ "button" ]) then return end

                cfg.press()
            end)

            return setmetatable(cfg, library)
        end

        function library:settings(options)
            local cfg = {
                open = false;
                items = {};
                sanity = true;
            }

            local items = cfg.items; do
                items[ "outline" ] = library:create( "Frame" , {
                    Name = "\0";
                    Visible = true;
                    Parent = library[ "items" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 0, 0, 0);
                    ClipsDescendants = true;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(25, 25, 29)
                });

                items[ "inline" ] = library:create( "Frame" , {
                    Parent = items[ "outline" ];
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(22, 22, 24)
                });

                library:create( "UICorner" , {
                    Parent = items[ "inline" ];
                    CornerRadius = dim(0, 7)
                });

                items[ "elements" ] = library:create( "Frame" , {
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = items[ "inline" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 10, 0, 10);
                    Size = dim2(1, -20, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library:create( "UIListLayout" , {
                    Parent = items[ "elements" ];
                    Padding = dim(0, 6);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });


                library:create( "UICorner" , {
                    Parent = items[ "outline" ];
                    CornerRadius = dim(0, 7)
                });

                library:create( "UICorner" , {
                    Parent = items[ "fade" ];
                    CornerRadius = dim(0, 7)
                });

                items[ "tick" ] = library:create( "ImageButton" , {
                    Image = "rbxassetid://128797200442698";
                    Name = "\0";
                    AutoButtonColor = false;
                    Parent = self.items[ "right_components" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 16, 0, 16);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
            end

            function cfg.set_visible(bool)
                library:tween(items[ "outline" ], {Size = dim_offset(bool and 240 or 0, 0)})
                items[ "outline" ].Position = dim_offset(items[ "tick" ].AbsolutePosition.X, items[ "tick" ].AbsolutePosition.Y + 90)
                library:close_element(cfg)
            end

            items[ "tick" ].MouseButton1Click:Connect(function()
                cfg.open = not cfg.open

                cfg.set_visible(cfg.open)
            end)

            return setmetatable(cfg, library)
        end

        function library:list(properties)
            local cfg = {
                items = {};
                options = properties.options or {"1", "2", "3"};
                flag = properties.flag or library:next_flag();
                callback = properties.callback or function() end;
                data_store = {};
                current_element;
                labels = {};
            }

            local items = cfg.items; do
                items[ "list" ] = library:create( "Frame" , {
                    Parent = self.items[ "elements" ];
                    BackgroundTransparency = 1;
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library:create( "UIListLayout" , {
                    Parent = items[ "list" ];
                    Padding = dim(0, 10);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });

                library:create( "UIPadding" , {
                    Parent = items[ "list" ];
                    PaddingRight = dim(0, 4);
                    PaddingLeft = dim(0, 4)
                });
            end

            function cfg.refresh_options(options_to_refresh)
                local old_selected_value = flags[cfg.flag]
                cfg.current_element = nil
                cfg.labels = {}
                for _, option in cfg.data_store do
                    option:Destroy()
                end
                cfg.data_store = {}

                for _, option_data in options_to_refresh do
                    local button = library:create("TextButton", {
                        FontFace = fonts.small;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        AutoButtonColor = false;
                        AnchorPoint = vec2(1, 0);
                        Parent = items["list"];
                        Name = "\0";
                        Position = dim2(1, 0, 0, 0);
                        Size = dim2(1, 0, 0, 30);
                        BorderSizePixel = 0;
                        TextSize = 14;
                        BackgroundColor3 = rgb(33, 33, 35)
                    }); cfg.data_store[#cfg.data_store + 1] = button;

                    local name = library:create("TextLabel", {
                        FontFace = fonts.font;
                        TextColor3 = library:theme_text(0.29);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = option_data;
                        Parent = button;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 14;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    library:create("UICorner", {
                        Parent = button;
                        CornerRadius = dim(0, 3)
                    });

                    cfg.labels[#cfg.labels + 1] = name

                    if option_data == old_selected_value then
                        library:tween(name, {TextColor3 = library:theme_text(1)})
                        cfg.current_element = name
                    end

                    button.MouseButton1Click:Connect(function()
                        local current = cfg.current_element

                        if current and current ~= name then
                            library:tween(current, {TextColor3 = library:theme_text(0.29)})
                        end

                        flags[cfg.flag] = option_data
                        cfg.callback(option_data)
                        keep_identity()

                        library:tween(name, {TextColor3 = library:theme_text(1)})

                        cfg.current_element = name
                    end)

                    name.MouseEnter:Connect(function()
                        if cfg.current_element == name then return end
                        library:tween(name, {TextColor3 = library:theme_text(0.57)})
                    end)

                    name.MouseLeave:Connect(function()
                        if cfg.current_element == name then return end
                        library:tween(name, {TextColor3 = library:theme_text(0.29)})
                    end)
                end
            end

            library:on_theme(function(key)
                if key ~= "text" then return end

                local idle = library:theme_text(0.29)

                for _, label in cfg.labels do
                    if label.Parent then
                        label.TextColor3 = (label == cfg.current_element) and library:theme_text(1) or idle
                    end
                end
            end)

            cfg.refresh_options(cfg.options)

            return setmetatable(cfg, library)
        end

        function library:init_config(window)
            local game_flags = {}

            for key in library.config_flags do
                game_flags[key] = true
            end

            window:seperator({name = "settings"})
            local main, menu_page = window:tab({name = "settings", tabs = {"configs", "menu"}})

            local column = main:column({})
            local section = column:section({name = "configs", size = 1, default = false, icon = "rbxassetid://139628202576511"})
            config_holder = section:list({options = {"Report", "This", "Error", "To", "Finobe"}, callback = function(option) end, flag = "config_name_list"}); library:update_config_list()

            local community = column:section({name = "community configs", size = 1, default = false, icon = "rbxassetid://139628202576511"})
            local community_list = {}

            for name in pairs(COMMUNITY_CONFIG_DATA) do
                community_list[#community_list + 1] = name
            end

            table.sort(community_list)

            community_holder = community:dropdown({
                name = "config list",
                flag = "community_config_name",
                width = 150,
                items = community_list,
                seperator = false,
                multi = false,
                default = community_list[1] or "None"
            })

            community:button({
                name = "load config",
                callback = function()
                    pcall(function()
                        local name = flags["community_config_name"]

                        if type(name) ~= "string" or name == "" then return end

                        local payload = COMMUNITY_CONFIG_DATA[name]

                        if type(payload) ~= "string" or payload == "" then
                            notifications:create_notification({
                                name = "configs",
                                info = "community config missing:\n" .. name
                            })

                            return
                        end

                        local loaded, message = library:import_config(payload)

                        notifications:create_notification({
                            name = "configs",
                            info = loaded and ("loaded community config:\n" .. name)
                                or ("could not load " .. name .. ":\n" .. tostring(message))
                        })
                    end)
                end
            })

            library.notif_style = library.notif_style or {}

            local notif_style = library.notif_style
            local menu_left = menu_page:column({})
            local menu_right = menu_page:column({})
            local menu_section = menu_left:section({name = "menu", size = 1, default = false, icon = GetImage("Settings.png")})
            local server_section = menu_left:section({name = "server", size = 1, default = false, icon = GetImage("Settings.png")})
            local notif_section = menu_right:section({name = "notifications", size = 1, default = false, icon = GetImage("Settings.png")})
            notif_section:dropdown({name = "position", flag = "notif_position", width = 100, items = {"Center", "Top Center", "Top Left", "Top Right", "Bottom Left", "Bottom Right", "Custom"}, multi = false, default = "Center", callback = function(state)
                library.notif_position = state
                library.notifications:refresh_notifs()
            end})

            local function notif_set(key, value)
                notif_style[key] = value
                notifications:refresh_notifs()
            end

            notif_section:toggle({type = "toggle", name = "clip descendants", flag = "notif_clip", default = true, callback = function(state)
                notif_set("clip", state)
            end})

            notif_section:slider({name = "clip past distance", flag = "notif_clip_distance", min = 100, max = 1000, default = 200, suffix = "px", seperator = true, callback = function(value)
                notif_set("clip_distance", value)
            end})

            local notif_force = notif_section:toggle({type = "toggle", name = "force color", flag = "notif_force_color", default = false, callback = function(state)
                notif_style.force = state
            end})

            local notif_pickers = {}
            local notif_defaults = {main = rgb(14, 14, 16), accent = themes.preset.accent, outline = rgb(23, 23, 29), font = rgb(255, 255, 255)}

            for _, key in ipairs({"main", "accent", "outline", "font"}) do
                notif_style[key] = notif_defaults[key]
                notif_pickers[key] = notif_force:colorpicker({name = key, flag = "notif_color_" .. key, color = notif_defaults[key], no_alpha = true, callback = function(color)
                    notif_style[key] = color
                end})
            end

            notif_section:button({name = "copy colors", seperator = true, callback = function()
                local copy = {main = themes.preset.background, accent = themes.preset.accent, outline = themes.preset.outline, font = themes.preset.text}

                for key, picker in pairs(notif_pickers) do
                    if copy[key] and type(picker) == "table" and picker.set then
                        pcall(picker.set, copy[key], picker.alpha)
                    end
                end
            end})

            notif_section:slider({name = "position x", flag = "notif_position_x", min = 0, max = 100, default = 50, suffix = "%", half = true, callback = function(value)
                notif_set("x", value)
            end})

            notif_section:slider({name = "position y", flag = "notif_position_y", min = 0, max = 100, default = 60, suffix = "%", half = true, callback = function(value)
                notif_set("y", value)
            end})

            notif_section:slider({name = "transparency", flag = "notif_transparency", min = 0, max = 100, default = 0, suffix = "%", callback = function(value)
                notif_style.transparency = value
            end})

            notif_section:dropdown({name = "alignment", flag = "notif_alignment", width = 100, items = {"Left", "Right", "Center"}, multi = false, default = "Left", callback = function(state)
                notif_style.align = state
            end})

            notif_section:dropdown({name = "bar side", flag = "notif_bar_side", width = 100, items = {"Left", "Right", "Top", "Bottom"}, multi = false, default = "Bottom", callback = function(state)
                notif_style.bar = state
            end})

            notif_section:dropdown({name = "sort order", flag = "notif_sort_order", width = 100, items = {"Text Length", "Default"}, multi = false, default = "Default", seperator = true, callback = function(state)
                notif_set("sort", state)
            end})

            notif_section:button({name = "send notification", callback = function()
                notifications:create_notification({name = "sleepy.gg", info = "this is a test notification"})
            end})

            local backdrop = {parts = {}, open = not getgenv().silent_load_active}

            library.backdrop = backdrop

            backdrop.blur = Instance.new("BlurEffect")
            backdrop.blur.Name = "\0"
            backdrop.blur.Enabled = false
            backdrop.color = Instance.new("ColorCorrectionEffect")
            backdrop.color.Name = "\0"
            backdrop.color.Enabled = false

            function backdrop.refresh()
                local active = backdrop.open and flags.menu_bg_enabled and true or false
                local camera = workspace.CurrentCamera

                if camera and backdrop.blur.Parent ~= camera then
                    backdrop.blur.Parent = camera
                    backdrop.color.Parent = camera
                end

                backdrop.blur.Size = tonumber(flags.menu_bg_blur) or 15
                backdrop.blur.Enabled = active and backdrop.blur.Size > 0
                backdrop.color.Contrast = tonumber(flags.menu_bg_contrast) or 0
                backdrop.color.Saturation = tonumber(flags.menu_bg_saturation) or 0
                backdrop.color.Brightness = tonumber(flags.menu_bg_brightness) or 0
                backdrop.color.Enabled = active

                if not backdrop.gui then return end

                local back_color = flags.menu_bg_color
                local item_color = flags.menu_bg_item_color
                local material = Enum.Material[flags.menu_bg_material or "Neon"]

                backdrop.gui.Enabled = active
                backdrop.outer.BackgroundColor3 = type(back_color) == "table" and back_color.Color or rgb(0, 0, 0)
                backdrop.outer.BackgroundTransparency = flags.menu_bg_dim == false and 1 or (tonumber(flags.menu_bg_transparency) or 0.7)
                backdrop.inner.ImageColor3 = type(item_color) == "table" and item_color.Color or rgb(255, 255, 255)

                for _, part in pairs(backdrop.parts) do
                    part.Transparency = tonumber(flags.menu_bg_item_transparency) or 0
                    part.Reflectance = tonumber(flags.menu_bg_item_reflectance) or 0
                    part.Material = material
                end
            end

            local function back_refresh()
                pcall(backdrop.refresh)
            end

            local backdrop_toggle = window.toggle_menu

            if type(backdrop_toggle) == "function" then
                window.toggle_menu = function(bool, ...)
                    backdrop.open = bool and true or false

                    back_refresh()

                    return backdrop_toggle(bool, ...)
                end
            end

            task.spawn(function()
                local ok, gui = pcall(function()
                    return game:GetObjects("rbxassetid://93615626116769")[1]
                end)

                if not ok or typeof(gui) ~= "Instance" then
                    ok, gui = pcall(function()
                        return cloneref(game:GetService("InsertService")):LoadLocalAsset("rbxassetid://93615626116769")
                    end)
                end

                if not ok or typeof(gui) ~= "Instance" then
                    warn("[Sleepy.gg] background items failed to load: " .. tostring(gui))

                    return
                end

                if not gui:IsA("ScreenGui") then
                    gui = gui:FindFirstChildWhichIsA("ScreenGui", true) or gui
                end

                local outer = gui:FindFirstChild("ViewportFrame") or gui:FindFirstChildWhichIsA("ViewportFrame", true)
                local inner = outer and (outer:FindFirstChild("ViewportFrame") or outer:FindFirstChildWhichIsA("ViewportFrame", true))

                if not gui:IsA("ScreenGui") or not inner then
                    warn("[Sleepy.gg] background items asset has an unexpected layout: " .. gui.ClassName .. " / " .. tostring(outer and outer.ClassName) .. " / " .. tostring(inner and inner.ClassName))

                    gui:Destroy()

                    return
                end

                for _, child in ipairs(inner:GetChildren()) do
                    if child.Name == "Overlay V2" then
                        child:Destroy()
                    elseif child:IsA("BasePart") then
                        child.Position = Vector3.new(0, 1000, 0)
                        backdrop.parts[child.Name] = child
                    end
                end

                if next(backdrop.parts) == nil then
                    local found = {}

                    for _, child in ipairs(inner:GetChildren()) do
                        found[#found + 1] = child.Name .. ":" .. child.ClassName
                    end

                    warn("[Sleepy.gg] background items asset has no usable parts: " .. table.concat(found, ", "))
                end

                gui.Name = "\0"
                gui.Enabled = false
                gui.DisplayOrder = (library[ "items" ].DisplayOrder or 0) - 1
                gui.Parent = library[ "items" ].Parent

                backdrop.gui, backdrop.outer, backdrop.inner = gui, outer, inner

                back_refresh()
            end)

            run_service.RenderStepped:Connect(function(dt)
                if not (backdrop.gui and backdrop.gui.Enabled) then return end

                local wanted = backdrop.parts[flags.menu_bg_item or ""]

                if wanted ~= backdrop.current then
                    if backdrop.current then backdrop.current.Position = Vector3.new(0, 1000, 0) end
                    if wanted then wanted.Position = Vector3.new(0, 10, 10) end

                    backdrop.current = wanted
                end

                if wanted then
                    wanted.CFrame = wanted.CFrame * CFrame.Angles(0, (tonumber(flags.menu_bg_speed) or 0.15) / 10 * dt * 60, 0)
                end
            end)

            local back_section = menu_right:section({name = "background", size = 1, default = false, icon = GetImage("Settings.png")})

            local back_toggle = back_section:toggle({type = "toggle", name = "enabled", flag = "menu_bg_enabled", default = false, callback = back_refresh})

            back_toggle:colorpicker({name = "item color", flag = "menu_bg_item_color", color = rgb(255, 255, 255), no_alpha = true, callback = back_refresh})

            back_section:dropdown({name = "item", flag = "menu_bg_item", width = 100, items = {"None", "Sword", "Cross", "Heart", "Catholic Cross", "Orthodox Cross"}, multi = false, default = "Sword"})

            back_section:slider({name = "transparency", flag = "menu_bg_item_transparency", min = 0, max = 1, decimal = 0.01, default = 0, half = true, callback = back_refresh})
            back_section:slider({name = "reflectance", flag = "menu_bg_item_reflectance", min = 0, max = 1, decimal = 0.01, default = 0, half = true, callback = back_refresh})
            back_section:slider({name = "speed", flag = "menu_bg_speed", min = 0.1, max = 1, decimal = 0.01, default = 0.15})

            back_section:dropdown({name = "material", flag = "menu_bg_material", width = 100, items = {"ForceField", "Neon", "Plastic", "SmoothPlastic", "Wood", "WoodPlanks", "Marble", "Slate", "Concrete", "Granite", "Brick", "Pebble", "Cobblestone", "Rock", "Sandstone", "Basalt", "CrackedLava", "Limestone", "Pavement", "CorrodedMetal", "DiamondPlate", "Foil", "Metal", "Grass", "LeafyGrass", "Sand", "Fabric", "Snow", "Mud", "Ground", "Asphalt", "Salt", "Ice", "Glacier", "Glass"}, multi = false, default = "Neon", seperator = true, callback = back_refresh})

            local back_dim = back_section:toggle({type = "toggle", name = "background color", flag = "menu_bg_dim", default = true, callback = back_refresh})

            back_dim:colorpicker({name = "background color", flag = "menu_bg_color", color = rgb(0, 0, 0), no_alpha = true, callback = back_refresh})

            back_section:slider({name = "transparency", flag = "menu_bg_transparency", min = 0, max = 1, decimal = 0.01, default = 0.7, half = true, callback = back_refresh})
            back_section:slider({name = "blur", flag = "menu_bg_blur", min = 0, max = 50, default = 15, half = true, callback = back_refresh})
            back_section:slider({name = "contrast", flag = "menu_bg_contrast", min = -10, max = 10, decimal = 0.1, default = 0, half = true, callback = back_refresh})
            back_section:slider({name = "saturation", flag = "menu_bg_saturation", min = -10, max = 10, decimal = 0.1, default = 0, half = true, callback = back_refresh})
            back_section:slider({name = "brightness", flag = "menu_bg_brightness", min = -1, max = 1, decimal = 0.1, default = 0, callback = back_refresh})

            local column = main:column({})
            local section = column:section({name = "config", side = "right", size = 1, default = false, icon = GetImage("Settings.png")})
            section:textbox({name = "config name:", flag = "config_name_text", tall = true,})
            section:button({
                name = "save",
                callback = function()
                    pcall(function()
                        local config_name = (flags["config_name_text"])

                        writefile(library:config_path(config_name), library:get_config())
                        library:touch_config(config_name)
                        library:update_config_list()
                        notifications:create_notification({
                            name = "configs",
                            info = "saved config to:\n" .. config_name
                        })
                    end)
                end
            })

            section:button({
                name = "overwrite",
                safemode = true,
                callback = function()
                    pcall(function()
                        local config_name = (flags["config_name_list"])
                        local previous, extension = library:find_config(config_name)

                        writefile(library:config_path(config_name), library:get_config())

                        if previous and extension ~= CONFIG_WRITE_EXTENSION then
                            pcall(delfile, previous)
                        end

                        library:touch_config(config_name)
                        library:update_config_list()
                        notifications:create_notification({
                            name = "configs",
                            info = "overwrote config :\n" .. config_name
                        })
                    end)
                end
            })

            section:button({
                name = "load",
                callback = function()
                    pcall(function()
                        local config_name = flags["config_name_list"]
                        local path = library:find_config(config_name)

                        if not path then
                            notifications:create_notification({
                                name = "configs",
                                info = "no config found named:\n" .. tostring(config_name)
                            })

                            return
                        end

                        library:load_config(readfile(path))
                        library:touch_config(config_name)
                        library:update_config_list()
                        notifications:create_notification({
                            name = "configs",
                            info = "loaded config:\n" .. config_name
                        })
                    end)
                end
            })

            section:button({
                name = "delete",
                safemode = true,
                callback = function()
                pcall(function()
                        local config_name = flags["config_name_list"]

                        for _, extension in CONFIG_EXTENSIONS do
                            local path = library:config_path(config_name, extension)

                            if isfile(path) then
                                pcall(delfile, path)
                            end
                        end

                        library:touch_config(config_name, true)
                        library:update_config_list()
                        notifications:create_notification({
                            name = "configs",
                            info = "deleted config:\n" .. config_name
                        })
                    end)
                end
            })

            section:button({
                name = "refresh config list",
                callback = function()
                    local ok, err = pcall(function()
                        library:update_config_list()
                    end)

                    notifications:create_notification({
                        name = "configs",
                        info = ok and "config list refreshed" or ("refresh failed:\n" .. tostring(err))
                    })
                end
            })

            local import_box
            local import_generation = 0
            local import_running = false

            import_box = section:textbox({
                tall = true,
                layout = -1,
                name = "import from clipboard:",
                flag = "config_import_text",
                placeholder = "paste config here...",
                callback = function(text)
                    if import_running then return end

                    import_generation += 1

                    if (text or "") == "" then return end

                    local generation = import_generation

                    task.delay(0.35, function()
                        if generation ~= import_generation or import_running then return end

                        import_running = true

                        local ok, info = library:import_config(text)

                        notifications:create_notification({
                            name = "configs",
                            info = ok and ("config loaded, " .. info)
                                or ("oops! something went wrong while trying to load the config.\nerror: " .. info),
                            lifetime = ok and 5 or 9
                        })

                        if ok then
                            import_box.set("")
                        end

                        import_running = false
                    end)
                end
            })

            section:button({
                name = "copy config to clipboard",
                seperator = true,
                callback = function()
                    local ok, info = library:export_config()

                    notifications:create_notification({
                        name = "configs",
                        info = ok and ("config copied, " .. info)
                            or ("oops! something went wrong while trying to copy the config.\nerror: " .. info),
                        lifetime = ok and 5 or 9
                    })
                end
            })

            local autoload_label = section:label({
                name = "auto load: none"
            })

            if isfile(AUTOLOAD_PATH) then
                local name = readfile(AUTOLOAD_PATH)
                autoload_label.set("auto load: " .. name)
                AUTOLOAD_ENABLED = true
            else
                autoload_label.set("auto load: none")
                AUTOLOAD_ENABLED = false
            end

            local startup_data = read_startup_data()

            section:toggle({
                type = "toggle",
                name = "auto load config",
                flag = "autoload_config",
                default = startup_data.autoload_config and isfile(AUTOLOAD_PATH),
                callback = function(state)
                    AUTOLOAD_ENABLED = state
                    write_startup_data("autoload_config", state)

                    if state then
                        local name = flags["config_name_list"]
                        if name and name ~= "" then
                            writefile(AUTOLOAD_PATH, name)
                            autoload_label.set("auto load: " .. name)
                        end
                    else
                        if isfile(AUTOLOAD_PATH) then
                            delfile(AUTOLOAD_PATH)
                        end
                        autoload_label.set("auto load: none")
                    end
                end
            })

            section:toggle({type="toggle",name="auto load script",flag="autoload_enabled",default=startup_data.autoload_enabled, callback = function(state)
                write_startup_data("autoload_enabled", state)

                if not state then
                    queue_on_teleport("")

                    return
                end

                local paid = getgenv().Build == "Paid"
                local loader = paid
                    and "4d0c67e660690a3ca0ab38048bc35041"

                if paid and not script_key then return end

                local source = "repeat task.wait() until game:IsLoaded()\n"

                if paid then
                    source = source .. 'script_key = "' .. script_key .. '"\n'
                end

                source = source .. 'loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/' .. loader .. '.lua"))()'

                queue_on_teleport(source)
            end})

            section:toggle({type = "toggle", name = "silent load", flag = "silent_load", default = startup_data.silent_load, seperator = true, callback = function(state)
                getgenv().silent_load_active = state
                write_startup_data("silent_load", state)
            end})

            menu_section:textbox({name = "menu size %", flag = "menu_size", default = "100", placeholder = "100", callback = function(text)
                local value = tonumber(text)
                if not value or not library.ui_scale then return end
                library.ui_scale.Scale = math.clamp(value, 50, 150) / 100
            end})

            library.theme_pickers = library.theme_pickers or {}

            library.theme_pickers.accent = menu_section:colorpicker({name = "menu accent", flag = "menu_accent_color", callback = function(color, alpha) library:update_theme("accent", color) end, color = themes.preset.accent})
            library.theme_pickers.background = menu_section:colorpicker({name = "background", flag = "menu_background_color", callback = function(color) library:paint_theme("background", color) end, color = themes.preset.background})
            library.theme_pickers.element = menu_section:colorpicker({name = "elements", flag = "menu_element_color", callback = function(color) library:paint_theme("element", color) end, color = themes.preset.element})
            library.theme_pickers.outline = menu_section:colorpicker({name = "outlines", flag = "menu_outline_color", callback = function(color) library:paint_theme("outline", color) end, color = themes.preset.outline})
            library.theme_pickers.text = menu_section:colorpicker({name = "text", flag = "menu_text_color", callback = function(color) library:paint_theme("text", color) end, color = themes.preset.text})
            library.theme_pickers.inactive = menu_section:colorpicker({name = "inactive", flag = "menu_inactive_color", callback = function(color) library:paint_theme("inactive", color) end, color = themes.preset.inactive})

            menu_section:dropdown({name = "theme preset", flag = "menu_theme_preset", width = 100, items = THEME_PRESET_NAMES, multi = false, default = "Sleepy", seperator = true, callback = function(state)
                library:apply_theme_preset(state)
            end})
            menu_section:toggle({
                type = "toggle",
                name = "card outlines",
                flag = "menu_edge_enabled",
                default = false,
                callback = function()
                    library:refresh_edges()
                end
            })

            menu_section:slider({
                name = "outline opacity",
                flag = "menu_edge_opacity",
                min = 0,
                max = 100,
                default = 100,
                suffix = "%",
                seperator = true,
                callback = function()
                    library:refresh_edges()
                end
            })

            library:refresh_edges()

            library.menu_bind = menu_section:keybind({name = "menu bind", flag = "menu_bind", key = Enum.KeyCode.Insert, mode = "Toggle", callback = function(bool) window.toggle_menu(bool) end, seperator = true, default = true})

            persist_menu_bind(library.menu_bind)

            local _request = (http_request and http_request) or (request and request) or (http and http.request)

            server_section:button({name = "join lowest server", callback = function()
                local Servers = string.format("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100", tostring(game.PlaceId))

                local ListServers = function(cursor)
                    local Raw = game:HttpGet(Servers .. ((cursor and "&cursor="..cursor) or ""))
                    return cloneref(game:GetService("HttpService")):JSONDecode(Raw)
                end

                local Server, Next; repeat
                    local Servers = ListServers(Next)
                    Server = Servers.data[1]
                    Next = Servers.nextPageCursor
                until Server

                if Server.id == game.JobId then
                    library.notifications:create_notification({
                        name = "sleepy.gg",
                        info = `you are currently in the smallest server!`,
                        lifetime = 10
                    })
                    return
                end

                cloneref(game:GetService("TeleportService")):TeleportToPlaceInstance(game.PlaceId, Server.id)
            end})

            server_section:button({name = "server hop", callback = function()
                local Servers = {}
                local Request = _request({Url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true", tostring(game.PlaceId))})
                local Body = cloneref(game:GetService("HttpService")):JSONDecode(Request.Body)

                if Body and Body.data then
                    for _, Value in next, Body.data do
                        if type(Value) == "table" and tonumber(Value.playing) and tonumber(Value.maxPlayers) and Value.playing < Value.maxPlayers and Value.id ~= game.JobId then
                            table.insert(Servers, 1, Value.id)
                        end
                    end
                end

                cloneref(game:GetService("TeleportService")):TeleportToPlaceInstance(
                    game.PlaceId,
                    Servers[math.random(1, #Servers)]
                )
                    end})

            server_section:button({name = "rejoin", callback = function()
            cloneref(game:GetService("TeleportService")):TeleportToPlaceInstance(
                game.PlaceId,
                game.JobId
            )
            end})

            server_section:button({name = "panic", callback = function()
                if not library.default_config then return end

                notifications:create_notification({
                    name = "sleepy.gg",
                    info = "everything reset to default"
                })

                library:load_config(library.default_config)
            end})

            library.menu_flags = {}

            for key in library.config_flags do
                if not game_flags[key] then
                    library.menu_flags[key] = true
                end
            end

            library.setup_complete = true
        end

        function notifications:anchor_for(mode)
            if mode == "Custom" then
                local style = library.notif_style or {}
                local x = math.clamp((tonumber(style.x) or 50) / 100, 0, 1)
                local y = math.clamp((tonumber(style.y) or 60) / 100, 0, 1)

                return vec2(x, y), 0, 0, y > 0.5 and -1 or 1
            end

            if mode == "Top Left" then return vec2(0, 0), 20, 20, 1 end
            if mode == "Top Right" then return vec2(1, 0), -20, 20, 1 end
            if mode == "Bottom Left" then return vec2(0, 1), 20, -20, -1 end
            if mode == "Bottom Right" then return vec2(1, 1), -20, -20, -1 end
            if mode == "Top Center" then return vec2(0.5, 0), 0, 20, 1 end

            return vec2(0.5, 1), 0, -20, -1
        end

        function notifications:refresh_notifs(instant)
            local mode = library.notif_position or "Center"
            local style = library.notif_style or {}
            local anchor, pad_x, pad_y, direction = notifications:anchor_for(mode)
            local offset = pad_y
            local ordered = {}

            for index, v in notifications.notifs do
                ordered[#ordered + 1] = {v, index}
            end

            if style.sort == "Text Length" then
                table.sort(ordered, function(a, b) return a[1].AbsoluteSize.X > b[1].AbsoluteSize.X end)
            else
                table.sort(ordered, function(a, b) return a[2] < b[2] end)
            end

            for _, entry in ordered do
                local v = entry[1]
                local goal = dim2(anchor.X, pad_x, anchor.Y, offset)

                v.AnchorPoint = anchor
                v.Visible = not (style.clip ~= false and math.abs(offset - pad_y) > (tonumber(style.clip_distance) or 200))

                if v == instant then
                    v.Position = goal
                else
                    library:tween(v, {Position = goal}, Enum.EasingStyle.Quad, 0.22)
                end

                offset += direction * (v.AbsoluteSize.Y + 8)
            end

            return offset
        end

        function notifications:fade(path, is_fading, instant)
            local fading = is_fading and 1 or math.clamp((tonumber((library.notif_style or {}).transparency) or 0) / 100, 0, 1)

            if instant then
                path.BackgroundTransparency = fading
            else
                library:tween(path, {BackgroundTransparency = fading}, Enum.EasingStyle.Quad, 1)
            end

            for _, instance in path:GetDescendants() do
                if not instance:IsA("GuiObject") then
                    if instance:IsA("UIStroke") then
                        if instant then
                            instance.Transparency = fading
                        else
                            library:tween(instance, {Transparency = fading}, Enum.EasingStyle.Quad, 1)
                        end
                    end

                    continue
                end

                if instance:IsA("TextLabel") then
                    if instant then
                        instance.TextTransparency = fading
                    else
                        library:tween(instance, {TextTransparency = fading})
                    end
                elseif instance:IsA("Frame") and not instance:GetAttribute("fade_skip") then
                    local target = is_fading and 1 or 0.6

                    if instant then
                        instance.BackgroundTransparency = target
                    else
                        library:tween(instance, {BackgroundTransparency = target}, Enum.EasingStyle.Quad, 1)
                    end
                end
            end
        end

        function notifications:create_notification(options)
            if not notifications_allowed() then return end

            local cfg = {
                name = options.name or "this is a title!";
                info = options.info or "this is extra info!";
                lifetime = options.lifetime or 3;
                items = {};
                outline;
            }

            local items = cfg.items; do
                items[ "notification" ] = library:create( "Frame" , {
                    Parent = library[ "notifs" ] or library[ "items" ];
                    Size = dim2(0, 0, 0, 0);
                    Name = "\0";
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    BackgroundTransparency = 1;
                    AnchorPoint = vec2(0.5, 1);
                    AutomaticSize = Enum.AutomaticSize.XY;
                    BackgroundColor3 = rgb(14, 14, 16)
                });

                items[ "content" ] = library:create( "Frame" , {
                    Parent = items[ "notification" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    Size = dim2(0, 0, 0, 0)
                });

                items[ "content" ]:SetAttribute("fade_skip", true)

                library:create( "UIListLayout" , {
                    Parent = items[ "content" ];
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    HorizontalAlignment = Enum.HorizontalAlignment[(library.notif_style or {}).align or "Left"] or Enum.HorizontalAlignment.Left
                });

                items[ "stroke" ] = library:create( "UIStroke" , {
                    Color = rgb(23, 23, 29);
                    Parent = items[ "notification" ];
                    Transparency = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                });

                items[ "title" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(255, 255, 255);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = items[ "content" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library:create( "UICorner" , {
                    Parent = items[ "notification" ];
                    CornerRadius = dim(0, 3)
                });

                items[ "info" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(145, 145, 145);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.info;
                    Parent = items[ "content" ];
                    Name = "\0";
                    Position = dim2(0, 0, 0, 15);
                    BorderSizePixel = 0;
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    TextWrapped = false;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 13;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library:create( "UIPadding" , {
                    PaddingBottom = dim(0, 3);
                    Parent = items[ "info" ]
                });

                items[ "bar" ] = library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = items[ "notification" ];
                    Name = "\0";
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 0, 0, 2);
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.accent
                });

                library:create( "UICorner" , {
                    Parent = items[ "bar" ];
                    CornerRadius = dim(0, 999)
                });

                library:create( "UIPadding" , {
                    PaddingTop = dim(0, 4);
                    PaddingBottom = dim(0, 5);
                    PaddingLeft = dim(0, 22);
                    PaddingRight = dim(0, 24);
                    Parent = items[ "notification" ]
                });
            end

            local style = library.notif_style or {}
            local align = Enum.TextXAlignment[style.align or "Left"] or Enum.TextXAlignment.Left
            local bar_goal = dim2(1, 0, 0, 2)

            items[ "title" ].LayoutOrder = 1
            items[ "info" ].LayoutOrder = 2
            items[ "title" ].TextXAlignment = align
            items[ "info" ].TextXAlignment = align

            if style.force then
                items[ "notification" ].BackgroundColor3 = style.main or items[ "notification" ].BackgroundColor3
                items[ "stroke" ].Color = style.outline or items[ "stroke" ].Color
                items[ "title" ].TextColor3 = style.font or items[ "title" ].TextColor3
                items[ "bar" ].BackgroundColor3 = style.accent or items[ "bar" ].BackgroundColor3
            end

            if style.bar == "Top" then
                items[ "bar" ].AnchorPoint = vec2(0, 0)
                items[ "bar" ].Position = dim2(0, 0, 0, 0)
            elseif style.bar == "Left" or style.bar == "Right" then
                local right = style.bar == "Right"

                items[ "bar" ].AnchorPoint = vec2(right and 1 or 0, 1)
                items[ "bar" ].Position = dim2(right and 1 or 0, right and 12 or -12, 1, 0)
                items[ "bar" ].Size = dim2(0, 2, 0, 0)
                bar_goal = dim2(0, 2, 1, 0)
            end

            local index = #notifications.notifs + 1
            notifications.notifs[index] = items[ "notification" ]

            notifications:fade(items[ "notification" ], false, true)

            task.defer(function()
                notifications:refresh_notifs(items[ "notification" ])
            end)
            library:tween(items[ "bar" ], {Size = bar_goal}, Enum.EasingStyle.Quad, cfg.lifetime)

            task.spawn(LPH_NO_VIRTUALIZE(function()
                task.wait(cfg.lifetime)

                notifications.notifs[index] = nil

                notifications:fade(items[ "notification" ], true)
                notifications:refresh_notifs()

                task.wait(1)

                items[ "notification" ]:Destroy()
            end))
        end
    else

    local scale = 0.5
    local uis           = cloneref(game:GetService("UserInputService"))
    local players       = cloneref(game:GetService("Players"))
    local ws            = cloneref(game:GetService("Workspace"))
    local rs            = cloneref(game:GetService("ReplicatedStorage"))
    local http_service  = cloneref(game:GetService("HttpService"))
    local gui_service   = cloneref(game:GetService("GuiService"))
    local lighting      = cloneref(game:GetService("Lighting"))
    local run           = cloneref(game:GetService("RunService"))
    local stats         = cloneref(game:GetService("Stats"))
    local coregui       = cloneref(game:GetService("CoreGui"))
    local debris        = cloneref(game:GetService("Debris"))
    local tween_service = cloneref(game:GetService("TweenService"))
    local sound_service = cloneref(game:GetService("SoundService"))
    local run_service   = cloneref(game:GetService("RunService"))

    local vec2 = Vector2.new
    local vec3 = Vector3.new
    local dim2 = UDim2.new
    local dim = UDim.new
    local rect = Rect.new
    local cfr = CFrame.new
    local empty_cfr = cfr()
    local point_object_space = empty_cfr.PointToObjectSpace
    local angle = CFrame.Angles
    local dim_offset = UDim2.fromOffset

    local color = Color3.new
    local rgb = Color3.fromRGB
    local hex = Color3.fromHex
    local hsv = Color3.fromHSV
    local rgbseq = ColorSequence.new
    local rgbkey = ColorSequenceKeypoint.new
    local numseq = NumberSequence.new
    local numkey = NumberSequenceKeypoint.new

    local camera = ws.CurrentCamera
    local lp = players.LocalPlayer
    local gui_offset = gui_service:GetGuiInset().Y

    local max = math.max
    local floor = math.floor
    local min = math.min
    local abs = math.abs
    local noise = math.noise
    local rad = math.rad
    local random = math.random
    local pow = math.pow
    local sin = math.sin
    local pi = math.pi
    local tan = math.tan
    local atan2 = math.atan2
    local clamp = math.clamp

    local insert = table.insert
    local find = table.find
    local remove = table.remove
    local concat = table.concat

    local themes = {
        preset = {
            accent = rgb(0, 162, 255),
            background = rgb(14, 14, 16),
            element = rgb(25, 25, 29),
            outline = rgb(36, 36, 37),
            text = rgb(245, 245, 245),
            inactive = rgb(72, 72, 73),
        },

        utility = {
            accent = {
                BackgroundColor3 = {},
                TextColor3 = {},
                ImageColor3 = {},
                ScrollBarImageColor3 = {},
                Color = {}
            },
        }
    }

    local keys = {
        ["NONE"] = "...",
        [Enum.KeyCode.LeftShift] = "LS",
        [Enum.KeyCode.RightShift] = "RS",
        [Enum.KeyCode.LeftControl] = "LC",
        [Enum.KeyCode.RightControl] = "RC",
        [Enum.KeyCode.Insert] = "INS",
        [Enum.KeyCode.Backspace] = "BS",
        [Enum.KeyCode.Return] = "Ent",
        [Enum.KeyCode.LeftAlt] = "LA",
        [Enum.KeyCode.RightAlt] = "RA",
        [Enum.KeyCode.CapsLock] = "CAPS",
        [Enum.KeyCode.One] = "1",
        [Enum.KeyCode.Two] = "2",
        [Enum.KeyCode.Three] = "3",
        [Enum.KeyCode.Four] = "4",
        [Enum.KeyCode.Five] = "5",
        [Enum.KeyCode.Six] = "6",
        [Enum.KeyCode.Seven] = "7",
        [Enum.KeyCode.Eight] = "8",
        [Enum.KeyCode.Nine] = "9",
        [Enum.KeyCode.Zero] = "0",
        [Enum.KeyCode.KeypadOne] = "Num1",
        [Enum.KeyCode.KeypadTwo] = "Num2",
        [Enum.KeyCode.KeypadThree] = "Num3",
        [Enum.KeyCode.KeypadFour] = "Num4",
        [Enum.KeyCode.KeypadFive] = "Num5",
        [Enum.KeyCode.KeypadSix] = "Num6",
        [Enum.KeyCode.KeypadSeven] = "Num7",
        [Enum.KeyCode.KeypadEight] = "Num8",
        [Enum.KeyCode.KeypadNine] = "Num9",
        [Enum.KeyCode.KeypadZero] = "Num0",
        [Enum.KeyCode.Minus] = "-",
        [Enum.KeyCode.Equals] = "=",
        [Enum.KeyCode.Tilde] = "~",
        [Enum.KeyCode.LeftBracket] = "[",
        [Enum.KeyCode.RightBracket] = "]",
        [Enum.KeyCode.RightParenthesis] = ")",
        [Enum.KeyCode.LeftParenthesis] = "(",
        [Enum.KeyCode.Semicolon] = ",",
        [Enum.KeyCode.Quote] = "'",
        [Enum.KeyCode.BackSlash] = "\\",
        [Enum.KeyCode.Comma] = ",",
        [Enum.KeyCode.Period] = ".",
        [Enum.KeyCode.Slash] = "/",
        [Enum.KeyCode.Asterisk] = "*",
        [Enum.KeyCode.Plus] = "+",
        [Enum.KeyCode.Period] = ".",
        [Enum.KeyCode.Backquote] = "`",
        [Enum.UserInputType.MouseButton1] = "MB1",
        [Enum.UserInputType.MouseButton2] = "MB2",
        [Enum.UserInputType.MouseButton3] = "MB3",
        [Enum.KeyCode.Escape] = "ESC",
        [Enum.KeyCode.Space] = "SPC",
    }

    library.__index = library

    for _, path in next, library.folders do
        makefolder(library.directory .. path)
    end

    local flags = library.flags
    local config_flags = library.config_flags
    local notifications = library.notifications

    local fonts = {}; do
        function Register_Font(Name, Weight, Style, Asset)
            local AssetPath = library.directory .. "/fonts/" .. Asset.Id
            local FontPath = library.directory .. "/fonts/" .. Name .. ".font"

            if not isfile(AssetPath) then
                local ok, data = pcall(game.HttpGet, game, Asset.Url)

                if not ok or not data or #data == 0 then return end

                writefile(AssetPath, data)
            end

            if isfile(FontPath) then
                delfile(FontPath)
            end

            local Data = {
                name = Name,
                faces = {
                    {
                        name = "Normal",
                        weight = Weight,
                        style = Style,
                        assetId = getcustomasset(AssetPath),
                    },
                },
            }

            writefile(FontPath, http_service:JSONEncode(Data))

            return getcustomasset(FontPath);
        end

        local Medium = Register_Font("Meawdawdawddium", 200, "Normal", {
            Id = "Mediumawdwad.ttf",
            Url = "https://github.com/SleepyScriptsHolderAntiSkids/storage/raw/refs/heads/main/fonts/Inter_28pt-Medium.ttf",
        })

        local SemiBold = Register_Font("SeawdawdawdawdmiBold", 200, "Normal", {
            Id = "SemiBoldawdawdwad.ttf",
            Url = "https://github.com/SleepyScriptsHolderAntiSkids/storage/raw/refs/heads/main/fonts/Inter_28pt-SemiBold.ttf",
        })

        fonts = {
            small = Font.new(Medium, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
            font = Font.new(SemiBold, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
        }
    end

        function library:tween(obj, properties, easing_style, time)
            local tween = tween_service:Create(obj, TweenInfo.new(time or 0.25, easing_style or Enum.EasingStyle.Quint, Enum.EasingDirection.InOut, 0, false, 0), properties):Play()

            return tween
        end

        function library:resizify(frame)
            local Frame = Instance.new("TextButton")
            Frame.Position = dim2(1, -10, 1, -10)
            Frame.BorderColor3 = rgb(0, 0, 0)
            Frame.Size = dim2(0, 10, 0, 10)
            Frame.BorderSizePixel = 0
            Frame.BackgroundColor3 = rgb(255, 255, 255)
            Frame.Parent = frame
            Frame.BackgroundTransparency = 1
            Frame.Text = ""

            local resizing = false
            local start_size
            local start
            local og_size = frame.Size

            Frame.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    resizing = true
                    start = input.Position
                    start_size = frame.Size
                end
            end))

            Frame.InputEnded:Connect(LPH_NO_VIRTUALIZE(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    resizing = false
                end
            end))

            library:connection(uis.InputChanged, function(input, game_event)
                if resizing and input.UserInputType == Enum.UserInputType.Touch then
                    local viewport_x = camera.ViewportSize.X
                    local viewport_y = camera.ViewportSize.Y

                    local current_size = dim2(
                        start_size.X.Scale,
                        math.clamp(
                            start_size.X.Offset + (input.Position.X - start.X),
                            og_size.X.Offset,
                            viewport_x
                        ),
                        start_size.Y.Scale,
                        math.clamp(
                            start_size.Y.Offset + (input.Position.Y - start.Y),
                            og_size.Y.Offset,
                            viewport_y
                        )
                    )

                    library:tween(frame, {Size = current_size}, Enum.EasingStyle.Linear, 0.05)
                end
            end)
        end

        function fag(tbl)
            local Size = 0

            for _ in tbl do
                Size = Size + 1
            end

            return Size
        end

        function library:next_flag()
            local index = fag(library.flags) + 1;
            local str = string.format("flagnumber%s", index)

            return str;
        end

        function library:mouse_in_frame(uiobject)
            local y_cond = uiobject.AbsolutePosition.Y <= Mouse.Y and Mouse.Y <= uiobject.AbsolutePosition.Y + uiobject.AbsoluteSize.Y
            local x_cond = uiobject.AbsolutePosition.X <= Mouse.X and Mouse.X <= uiobject.AbsolutePosition.X + uiobject.AbsoluteSize.X

            return (y_cond and x_cond)
        end

        function library:draggify(frame)
            local dragging = false
            local start_size = frame.Position
            local start

            frame.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    start = input.Position
                    start_size = frame.Position
                end
            end))

            frame.InputEnded:Connect(LPH_NO_VIRTUALIZE(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end))

            library:connection(uis.InputChanged, function(input, game_event)
                if dragging and input.UserInputType == Enum.UserInputType.Touch then
                    local viewport_x = camera.ViewportSize.X
                    local viewport_y = camera.ViewportSize.Y

                    local current_position = dim2(
                        0,
                        start_size.X.Offset + (input.Position.X - start.X),
                        0,
                        start_size.Y.Offset + (input.Position.Y - start.Y)
                    )

                    library:tween(frame, {Position = current_position}, Enum.EasingStyle.Linear, 0.05)
                    library:close_element()
                end
            end)
        end

        function library:convert(str)
            local values = {}

            for value in string.gmatch(str, "[^,]+") do
                insert(values, tonumber(value))
            end

            if #values == 4 then
                return unpack(values)
            else
                return
            end
        end

        function library:convert_enum(enum)
            local enum_parts = {}

            for part in string.gmatch(enum, "[%w_]+") do
                insert(enum_parts, part)
            end

            local enum_table = Enum
            for i = 2, #enum_parts do
                local enum_item = enum_table[enum_parts[i]]

                enum_table = enum_item
            end

            return enum_table
        end

        local CONFIG_WRITE_EXTENSION = ".txt"
        local CONFIG_EXTENSIONS = {".txt", ".cfg"}

        function library:config_path(name, extension)
            return library.directory .. "/configs/" .. name .. (extension or CONFIG_WRITE_EXTENSION)
        end

        function library:find_config(name)
            if type(name) ~= "string" or name == "" then
                return nil
            end

            for _, extension in CONFIG_EXTENSIONS do
                local path = library:config_path(name, extension)

                if isfile(path) then
                    return path, extension
                end
            end

            return nil
        end

        function library:recent_configs()
            local ok, list = pcall(function()
                return http_service:JSONDecode(readfile(library.directory .. "/recent_configs.json"))
            end)

            return ok and type(list) == "table" and list or {}
        end

        function library:touch_config(name, removed)
            if type(name) ~= "string" or name == "" then return end

            local list = library:recent_configs()

            for i = #list, 1, -1 do
                if list[i] == name then
                    table.remove(list, i)
                end
            end

            if not removed then
                table.insert(list, 1, name)
            end

            pcall(writefile, library.directory .. "/recent_configs.json", http_service:JSONEncode(list))
        end

        local config_holder;
        function library:update_config_list()
            if not config_holder then
                return
            end

            local list, seen = {}, {}

            for _, file in listfiles(library.directory .. "/configs") do
                local leaf = file:match("[^/\\]+$") or file
                local name = leaf:match("^(.*)%.txt$") or leaf:match("^(.*)%.cfg$")

                if name and name ~= "" and not seen[name] then
                    seen[name] = true

                    list[#list + 1] = name
                end
            end

            local order = {}

            for index, name in library:recent_configs() do
                if order[name] == nil then
                    order[name] = index
                end
            end

            table.sort(list, function(a, b)
                local rank_a, rank_b = order[a], order[b]

                if rank_a and rank_b then return rank_a < rank_b end
                if rank_a or rank_b then return rank_a ~= nil end

                return a:lower() < b:lower()
            end)

            config_holder.refresh_options(list)
        end

        function library:get_config()
            local Config = {}

            for _, v in next, flags do
                if CONFIG_EXCLUDED[_] then
                    continue
                elseif library.armed[_] ~= nil then
                    Config[_] = library.armed[_]
                elseif type(v) == "table" and v.key then
                    Config[_] = {active = v.active, mode = v.mode, key = tostring(v.key)}
                elseif type(v) == "table" and v["Transparency"] and v["Color"] then
                    Config[_] = {Transparency = v["Transparency"], Color = v["Color"]:ToHex()}
                else
                    Config[_] = v
                end
            end

            return http_service:JSONEncode(Config)
        end

        function library:load_config(config_json)
            local config = http_service:JSONDecode(config_json)

            if type(config) == "table" and type(library.default_config) == "string" and config_json ~= library.default_config then
                local decoded, defaults = pcall(http_service.JSONDecode, http_service, library.default_config)

                if decoded and type(defaults) == "table" then
                    local menu = library.menu_flags or {}

                    for key, value in defaults do
                        if config[key] == nil and not menu[key] and not (type(value) == "table" and value["key"] ~= nil) then
                            config[key] = value
                        end
                    end
                end
            end

            local applied = 0

            for _, v in config do
                local function_set = library.config_flags[_]

                if CONFIG_EXCLUDED[_] then
                    continue
                end

                if function_set then
                    applied = applied + 1

                    if applied % 20 == 0 then
                        task.wait()
                    end

                    pcall(function()
                        if type(v) == "table" and v["Transparency"] and v["Color"] then
                            function_set(hex(v["Color"]), v["Transparency"])
                        elseif type(v) == "table" and v["active"] then
                            function_set(v)
                        else
                            function_set(v)
                        end
                    end)
                end
            end

        end

        local IMPORT_BYTE_LIMIT = 512 * 1024

        local function tidy_error(err)
            local text = tostring(err)
            local stripped = text:gsub("^.-:%d+:%s*", "")

            return stripped ~= "" and stripped or text
        end

        function library:validate_config(text)
            if type(text) ~= "string" then
                return nil, "nothing was pasted"
            end

            local payload = text:match("^%s*(.-)%s*$") or ""

            if payload == "" then
                return nil, "the box is empty"
            end

            if #payload > IMPORT_BYTE_LIMIT then
                return nil, ("that is %d kb, the limit is %d kb"):format(#payload // 1024, IMPORT_BYTE_LIMIT // 1024)
            end

            if payload:sub(1, 1) ~= "{" or payload:sub(-1) ~= "}" then
                return nil, "that is not a config, it has to start with { and end with }"
            end

            local decoded_ok, decoded = pcall(function()
                return http_service:JSONDecode(payload)
            end)

            if not decoded_ok then
                return nil, "the json is malformed, " .. tidy_error(decoded)
            end

            if type(decoded) ~= "table" then
                return nil, ("that decoded to a %s, expected a config"):format(type(decoded))
            end

            local total, known, unknown = 0, 0, 0

            for key, value in pairs(decoded) do
                if type(key) ~= "string" then
                    return nil, ("setting names have to be text, found a %s"):format(type(key))
                end

                local kind = type(value)

                if kind ~= "boolean" and kind ~= "number" and kind ~= "string" and kind ~= "table" then
                    return nil, ("setting '%s' holds a %s, which cannot be applied"):format(key, kind)
                end

                total += 1

                if CONFIG_EXCLUDED[key] then
                elseif library.config_flags[key] then
                    known += 1
                else
                    unknown += 1
                end
            end

            if total == 0 then
                return nil, "the config is empty"
            end

            if known == 0 then
                return nil, ("none of the %d setting(s) belong to this build"):format(total)
            end

            return payload, nil, known, unknown
        end

        function library:import_config(text)
            local payload, reason, known, unknown = library:validate_config(text)

            if not payload then
                return false, reason
            end

            local applied, err = pcall(function()
                library:load_config(payload)
            end)

            if not applied then
                return false, "the config could not be applied, " .. tidy_error(err)
            end

            return true, ("loaded %d setting(s)%s"):format(known,
                unknown > 0 and (", ignored " .. unknown .. " unknown") or "")
        end

        function library:export_config()
            if type(setclipboard) ~= "function" then
                return false, "your executor has no clipboard support"
            end

            local built, payload = pcall(function()
                return library:get_config()
            end)

            if not built then
                return false, "the config could not be built, " .. tidy_error(payload)
            end

            if type(payload) ~= "string" or payload == "" then
                return false, "the config came back empty"
            end

            local copied, err = pcall(setclipboard, payload)

            if not copied then
                return false, "the clipboard write failed, " .. tidy_error(err)
            end

            return true, ("%d characters copied"):format(#payload)
        end

        local AUTOLOAD_PATH = library.directory .. "/autoload/autoload.cfg"

        task.spawn(LPH_NO_VIRTUALIZE(function()
            local deadline = os.clock() + 30

            repeat task.wait() until library.setup_complete or os.clock() > deadline

            if not library.setup_complete then
                local last = -1

                repeat
                    local count = 0
                    for _ in next, library.config_flags do count += 1 end

                    if count > 0 and count == last then break end

                    last = count
                    task.wait(0.5)
                until os.clock() > deadline + 10
            end

            if getgenv().silent_load_active then
                silent_hide_menu()
            end

            library.default_config = library:get_config()

            if isfile(AUTOLOAD_PATH) then
                local name = readfile(AUTOLOAD_PATH)
                local path = library:find_config(name)

                if path then
                    local loaded = pcall(function()
                        library:load_config(readfile(path))
                    end)

                    if loaded then
                        library:touch_config(name)
                    end

                    if getgenv().silent_load_active then
                        silent_hide_menu()
                    end

                    pcall(function()
                        library.notifications:create_notification({
                            name = "configs",
                            info = loaded and ("auto load config: " .. name) or ("auto load failed: " .. name),
                            lifetime = 5
                        })
                    end)
                end
            end

            if getgenv().silent_load_active then
                silent_hide_menu()
            end

            if getgenv().silent_load_active and library.menu_bind then
                local bind = library.menu_bind

                bind.active = false

                local mirror = bind.flag and library.flags and library.flags[bind.flag]

                if type(mirror) == "table" then mirror.active = false end

                silent_hide_menu()
            end

            getgenv().silent_load_block = false
        end))

        user_input_service.InputChanged:Connect(LPH_NO_VIRTUALIZE(function(input)
            local origin = library.tap_origin

            if not origin or library.tap_moved then return end

            if input.UserInputType ~= Enum.UserInputType.Touch
                and input.UserInputType ~= Enum.UserInputType.MouseMovement then
                return
            end

            local delta = input.Position - origin

            if math.abs(delta.X) > 8 or math.abs(delta.Y) > 8 then
                library.tap_moved = true
            end
        end))

        function library:on_tap(instance, callback)
            local tracked = nil

            instance.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(input)
                if input.UserInputType ~= Enum.UserInputType.Touch
                    and input.UserInputType ~= Enum.UserInputType.MouseButton1 then
                    return
                end

                if library:overlay_guarding(nil, instance) then return end

                tracked = input
                library.tap_origin = input.Position
                library.tap_moved = false
            end))

            instance.InputEnded:Connect(LPH_NO_VIRTUALIZE(function(input)
                if input ~= tracked then return end

                local was_tap = not library.tap_moved

                tracked = nil
                library.tap_origin = nil
                library.tap_moved = false

                if was_tap then callback(input) end
            end))
        end

        function library:relayout_sections()
            local refreshers = library.autosize_refresh
            if not refreshers then return end

            if library._relayout_queued then return end
            library._relayout_queued = true

            task.defer(function()
                library._relayout_queued = false

                for i = 1, #refreshers do
                    pcall(refreshers[i])
                end
            end)
        end

        function library:depends(parent, children, invert)
            local roots = {"toggle", "slider_object", "dropdown_object", "textbox", "keybind_element", "button_element", "list", "label"}

            local function apply(state)
                local shown = state and true or false
                if invert then shown = not shown end

                for i = 1, #children do
                    local child = children[i]
                    local items = child and child.items

                    if items then
                        for r = 1, #roots do
                            local element = items[roots[r]]

                            if typeof(element) == "Instance" then
                                element.Visible = shown
                            end
                        end

                        if not shown and child.set_visible then pcall(child.set_visible, false) end
                    end

                end

                library:relayout_sections()
            end

            local previous = parent.callback

            parent.raw_callback = parent.raw_callback or previous

            parent.callback = function(state, ...)
                if previous then previous(state, ...) end
                apply(state)
            end

            apply(parent.enabled)

            return parent
        end

        function library:round(number, float)
            local multiplier = 1 / (float or 1)

            return floor(number * multiplier + 0.5) / multiplier
        end

        local THEME_BASES = {
            background = rgb(14, 14, 16),
            element    = rgb(25, 25, 29),
            outline    = rgb(36, 36, 37),
            text       = rgb(245, 245, 245),
            inactive   = rgb(72, 72, 73)
        }

        local THEME_LOOKUP = {
            ["14,14,16"]    = "background",
            ["23,23,29"]    = "background",
            ["18,18,20"]    = "background",
            ["25,25,29"]    = "element",
            ["33,33,35"]    = "element",
            ["28,28,32"]    = "element",
            ["36,36,37"]    = "outline",
            ["22,22,24"]    = "outline",
            ["50,50,50"]    = "outline",
            ["245,245,245"] = "text",
            ["211,211,211"] = "text",
            ["72,72,73"]    = "inactive",
            ["72,72,72"]    = "inactive",
            ["130,130,130"] = "inactive",
            ["58,58,62"]    = "inactive",
            ["67,67,68"]    = "inactive",
            ["86,86,88"]    = "inactive",
            ["86,86,87"]    = "inactive"
        }

        local THEME_PROPERTIES = { "BackgroundColor3", "TextColor3", "ImageColor3", "ScrollBarImageColor3" }

        local theme_tracked = {}

        local function theme_key_of(color)
            if typeof(color) ~= "Color3" then return nil end

            local id = math.floor(color.R * 255 + 0.5) .. "," .. math.floor(color.G * 255 + 0.5) .. "," .. math.floor(color.B * 255 + 0.5)

            return THEME_LOOKUP[id]
        end

        local function theme_shade(base, original, target)
            local base_level = (base.R + base.G + base.B) / 3
            local original_level = (original.R + original.G + original.B) / 3
            local ratio = base_level > 0.004 and (original_level / base_level) or 1

            return Color3.new(
                math.clamp(target.R * ratio, 0, 1),
                math.clamp(target.G * ratio, 0, 1),
                math.clamp(target.B * ratio, 0, 1)
            )
        end

        function library:track_theme(instance, options)
            for _, property in THEME_PROPERTIES do
                local value = options[property]
                local key = theme_key_of(value)

                if key then
                    insert(theme_tracked, {
                        instance = instance,
                        property = property,
                        original = value,
                        key = key
                    })

                    local current = themes.preset[key]
                    local base = THEME_BASES[key]

                    if current and base and current ~= base then
                        instance[property] = theme_shade(base, value, current)
                    end
                end
            end
        end

        function library:paint_theme(key, color)
            themes.preset[key] = color

            for i = #theme_tracked, 1, -1 do
                local entry = theme_tracked[i]

                if not entry.instance or not entry.instance.Parent then
                    remove(theme_tracked, i)
                elseif entry.key == key then
                    entry.instance[entry.property] = theme_shade(THEME_BASES[key], entry.original, color)
                end
            end

            if library.theme_listeners then
                for _, fn in library.theme_listeners do
                    pcall(fn, key, color)
                end
            end
        end

        function library:theme_text(level)
            local base = themes.preset.text

            return Color3.new(base.R * level, base.G * level, base.B * level)
        end

        library.theme_listeners = {}

        function library:on_theme(fn)
            insert(library.theme_listeners, fn)
        end

        library.edge_strokes = {}

        function library:track_edge(stroke, base)
            insert(library.edge_strokes, {stroke = stroke, base = base})
        end

        function library:refresh_edges()
            local on = flags.menu_edge_enabled

            if on == nil then on = true end

            local scale = (tonumber(flags.menu_edge_opacity) or 100) / 100

            for i = #library.edge_strokes, 1, -1 do
                local entry = library.edge_strokes[i]

                if not entry.stroke or not entry.stroke.Parent then
                    remove(library.edge_strokes, i)
                else
                    entry.stroke.Transparency = on and (1 - (1 - entry.base) * scale) or 1
                end
            end
        end

        function library:track_theme_as(instance, property, original, key)
            local entry = {
                instance = instance,
                property = property,
                original = original,
                key = key
            }

            insert(theme_tracked, entry)

            return entry
        end

        THEME_PRESETS = {
            ["Sleepy"]     = { accent = rgb(0, 162, 255),   background = rgb(14, 14, 16),  element = rgb(25, 25, 29),  outline = rgb(36, 36, 37),  text = rgb(245, 245, 245), inactive = rgb(72, 72, 73) },
            ["Midnight"]   = { accent = rgb(120, 120, 255), background = rgb(10, 10, 18),  element = rgb(20, 20, 34),  outline = rgb(34, 34, 52),  text = rgb(238, 238, 255), inactive = rgb(76, 76, 100) },
            ["Crimson"]    = { accent = rgb(230, 45, 60),   background = rgb(16, 10, 11),  element = rgb(28, 18, 20),  outline = rgb(48, 30, 32),  text = rgb(250, 238, 238), inactive = rgb(92, 66, 68) },
            ["Emerald"]    = { accent = rgb(40, 210, 130),  background = rgb(10, 16, 14),  element = rgb(18, 28, 24),  outline = rgb(30, 46, 40),  text = rgb(236, 250, 244), inactive = rgb(66, 92, 82) },
            ["Amber"]      = { accent = rgb(255, 176, 32),  background = rgb(16, 14, 10),  element = rgb(28, 24, 18),  outline = rgb(48, 42, 30),  text = rgb(250, 246, 236), inactive = rgb(96, 88, 68) },
            ["Ultraviolet"]= { accent = rgb(190, 90, 255),  background = rgb(14, 10, 18),  element = rgb(26, 20, 34),  outline = rgb(44, 34, 56),  text = rgb(244, 238, 252), inactive = rgb(88, 72, 104) },
            ["Monochrome"] = { accent = rgb(225, 225, 225), background = rgb(12, 12, 12),  element = rgb(24, 24, 24),  outline = rgb(42, 42, 42),  text = rgb(245, 245, 245), inactive = rgb(96, 96, 96) },
            ["Ocean"]      = { accent = rgb(0, 200, 220),   background = rgb(8, 14, 18),   element = rgb(16, 26, 32),  outline = rgb(28, 44, 54),  text = rgb(234, 248, 252), inactive = rgb(64, 92, 104) },
            ["Rose"]       = { accent = rgb(255, 105, 170), background = rgb(18, 12, 15),  element = rgb(30, 20, 26),  outline = rgb(50, 34, 42),  text = rgb(252, 240, 246), inactive = rgb(100, 74, 86) },
            ["Halloween"]  = { accent = rgb(255, 117, 24),  background = rgb(13, 9, 15),   element = rgb(26, 17, 28),  outline = rgb(52, 30, 48),  text = rgb(255, 236, 214), inactive = rgb(110, 78, 96) }
        }

        THEME_PRESET_NAMES = { "Sleepy", "Midnight", "Crimson", "Emerald", "Amber", "Ultraviolet", "Monochrome", "Ocean", "Rose", "Halloween" }

        function library:apply_theme_preset(name)
            local preset = THEME_PRESETS[name]

            if not preset then return end

            library:update_theme("accent", preset.accent)

            for key in THEME_BASES do
                if preset[key] then
                    library:paint_theme(key, preset[key])
                end
            end

            if library.theme_pickers then
                for key, picker in library.theme_pickers do
                    local color = key == "accent" and preset.accent or preset[key]

                    if color and picker and picker.set then
                        pcall(picker.set, color, 0)
                    end
                end
            end
        end

        function library:apply_theme(instance, theme, property)
            insert(themes.utility[theme][property], instance)
        end

        function library:update_theme(theme, color)
            for _, property in themes.utility[theme] do

                for m, object in property do
                    if object[_] == themes.preset[theme] then
                        object[_] = color
                    end
                end
            end

            themes.preset[theme] = color

            if theme == "accent" and library.accent_refreshers then
                for _, refresh in library.accent_refreshers do
                    pcall(refresh)
                end
            end
        end

        function library:connection(signal, callback)
            local connection = signal:Connect(callback)

            insert(library.connections, connection)

            return connection
        end

        library.overlays = {}
        library.armed = {}

        function library:guard_overlay(cfg, instance, anchor)
            library.overlays[#library.overlays + 1] = {cfg = cfg, frame = instance, anchor = anchor}

            local inside = {}

            local function watch(element)
                element.MouseEnter:Connect(function()
                    inside[element] = true
                    library.overlay_inside = instance
                end)

                element.MouseLeave:Connect(function()
                    inside[element] = nil

                    if next(inside) == nil and library.overlay_inside == instance then
                        library.overlay_inside = nil
                    end
                end)
            end

            local function stamp(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then
                    library.overlay_pressed = instance
                    library.overlay_pressed_at = os.clock()
                end
            end

            watch(instance)
            instance.InputBegan:Connect(stamp)

            if anchor then
                watch(anchor)
                anchor.InputBegan:Connect(stamp)
            end

            local function bind(descendant)
                if descendant:IsA("ScrollingFrame") then
                    watch(descendant)
                end

                if descendant:IsA("GuiObject") then
                    descendant.InputBegan:Connect(stamp)
                end
            end

            for _, descendant in instance:GetDescendants() do
                bind(descendant)
            end

            instance.DescendantAdded:Connect(bind)
        end

        function library:open_overlay()
            local list = library.overlays

            for index = #list, 1, -1 do
                local entry = list[index]

                if not entry.frame.Parent then
                    remove(list, index)
                elseif entry.frame.Parent == library[ "items" ] and entry.frame.Visible then
                    return entry
                end
            end
        end

        function library:overlay_holding(frame)
            if library.overlay_inside == frame then return true end

            return library.overlay_pressed == frame
                and os.clock() - (library.overlay_pressed_at or 0) < 0.2
        end

        library:connection(uis.InputBegan, function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1
                and input.UserInputType ~= Enum.UserInputType.Touch then
                return
            end

            local entry = library:open_overlay()

            if not entry then return end
            if library:overlay_holding(entry.frame) then return end

            entry.cfg.open = false
            entry.cfg.set_visible(false)
        end)

        function library:overlay_guarding(cfg, instance)
            local entry = library:open_overlay()

            if not entry then return false end

            if cfg and entry.cfg == cfg then return false end
            if instance and instance == entry.anchor then return false end

            return not (instance and instance:IsDescendantOf(entry.frame))
        end

        function library:close_element(new_path)
            local open_element = library.current_open

            if open_element and new_path ~= open_element then
                open_element.set_visible(false)
                open_element.open = false;
            end

            if new_path ~= open_element then
                library.current_open = new_path or nil;
            end
        end

        function library:create(instance, options)
            local ins = Instance.new(instance)

            for prop, value in options do
                ins[prop] = value
            end

            library:track_theme(ins, options)

            return ins
        end

        function library:unload_menu()
            if library[ "items" ] then
                library[ "items" ]:Destroy()
            end

            if library[ "other" ] then
                library[ "other" ]:Destroy()
            end

            for index, connection in library.connections do
                connection:Disconnect()
                connection = nil
            end

            library = nil
        end

        function library:window(properties)
            local cfg = {
                suffix = properties.suffix or properties.Suffix or "tech";
                name = properties.name or properties.Name or "nebula";
                game_name = properties.gameInfo or properties.game_info or properties.GameInfo or "milenium for counter-strike: global offensive";
                size = properties.size or properties.Size or dim2(0, 700, 0, 565);
                selected_tab;
                items = {};

                tween;
            }

            library[ "items" ] = library:create( "ScreenGui" , {
                Parent = gethui();
                Name = "\0";
                Enabled = true;
                ZIndexBehavior = Enum.ZIndexBehavior.Global;
                IgnoreGuiInset = true;
            });

            library[ "notifs" ] = library:create( "ScreenGui" , {
                Parent = gethui();
                Name = "\0";
                Enabled = true;
                DisplayOrder = 2147483646;
                ZIndexBehavior = Enum.ZIndexBehavior.Global;
                IgnoreGuiInset = true;
            });

            library[ "other" ] = library:create( "ScreenGui" , {
                Parent = gethui();
                Name = "\0";
                Enabled = false;
                ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
                IgnoreGuiInset = true;
            });

            local items = cfg.items; do
                items[ "main" ] = library:create( "Frame" , {
                    Parent = library[ "items" ];
                    Size = cfg.size;
                    Name = "\0";
                    Position = dim2(0.5, -cfg.size.X.Offset / 2, 0.5, -cfg.size.Y.Offset / 2);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(14, 14, 16);
                    Visible = not getgenv().silent_load_active
                }); items[ "main" ].Position = dim2(0, items[ "main" ].AbsolutePosition.X, 0, items[ "main" ].AbsolutePosition.Y)

                library.ui_scale = library:create( "UIScale" , {
                    Parent = items[ "main" ];
                    Scale = scale;
                });

                library:create( "UICorner" , {
                    Parent = items[ "main" ];
                    CornerRadius = dim(0, 10)
                });

                library:create( "UIStroke" , {
                    Color = rgb(23, 23, 29);
                    Parent = items[ "main" ];
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                });

                items[ "side_frame" ] = library:create( "Frame" , {
                    Parent = items[ "main" ];
                    BackgroundTransparency = 1;
                    Name = "\0";
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 196, 1, -25);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(14, 14, 16)
                });

                library:create( "Frame" , {
                    AnchorPoint = vec2(1, 0);
                    Parent = items[ "side_frame" ];
                    Position = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 1, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(21, 21, 23)
                });

                items[ "button_holder" ] = library:create( "Frame" , {
                    Parent = items[ "side_frame" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 0, 0, 60);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 1, -60);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); cfg.button_holder = items[ "button_holder" ];

                library:create( "UIListLayout" , {
                    Parent = items[ "button_holder" ];
                    Padding = dim(0, 5);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });

                library:create( "UIPadding" , {
                    PaddingTop = dim(0, 16);
                    PaddingBottom = dim(0, 36);
                    Parent = items[ "button_holder" ];
                    PaddingRight = dim(0, 11);
                    PaddingLeft = dim(0, 10)
                });

                local accent = themes.preset.accent
                items[ "title" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    BorderColor3 = rgb(0, 0, 0);
                    Text = name;
                    Parent = items[ "side_frame" ];
                    Name = "\0";
                    Text = string.format('<u>%s</u><font color = "rgb(255, 255, 255)">%s</font>', cfg.name, cfg.suffix);
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 70);
                    TextColor3 = themes.preset.accent;
                    BorderSizePixel = 0;
                    RichText = true;
                    TextSize = 30;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); library:apply_theme(items[ "title" ], "accent", "TextColor3");

                items[ "multi_holder" ] = library:create( "Frame" , {
                    Parent = items[ "main" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 196, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -196, 0, 56);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); cfg.multi_holder = items[ "multi_holder" ];

                library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = items[ "multi_holder" ];
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(21, 21, 23)
                });

                items[ "shadow" ] = library:create( "ImageLabel" , {
                    ImageColor3 = rgb(0, 0, 0);
                    ScaleType = Enum.ScaleType.Slice;
                    Parent = items[ "main" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Name = "\0";
                    BackgroundColor3 = rgb(255, 255, 255);
                    Size = dim2(1, 75, 1, 75);
                    AnchorPoint = vec2(0.5, 0.5);
                    Image = "rbxassetid://112971167999062";
                    BackgroundTransparency = 1;
                    Position = dim2(0.5, 0, 0.5, 0);
                    SliceScale = 0.75;
                    ZIndex = -100;
                    BorderSizePixel = 0;
                    SliceCenter = rect(vec2(112, 112), vec2(147, 147))
                });

                items[ "global_fade" ] = library:create( "Frame" , {
                    Parent = items[ "main" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 196, 0, 56);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -196, 1, -81);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(14, 14, 16);
                    ZIndex = 2;
                });

                library:create( "UICorner" , {
                    Parent = items[ "shadow" ];
                    CornerRadius = dim(0, 5)
                });

                items[ "info" ] = library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = items[ "main" ];
                    Name = "\0";
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 25);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(23, 23, 25)
                });

                library:create( "UICorner" , {
                    Parent = items[ "info" ];
                    CornerRadius = dim(0, 10)
                });

                items[ "grey_fill" ] = library:create( "Frame" , {
                    Name = "\0";
                    Parent = items[ "info" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 6);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(23, 23, 25)
                });

                items[ "game" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    Parent = items[ "info" ];
                    TextColor3 = rgb(72, 72, 73);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.game_name;
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    AnchorPoint = vec2(0, 0.5);
                    Position = dim2(0, 10, 0.5, -1);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                if not LRM_SecondsLeft then
                    LRM_SecondsLeft = math.huge
                end

                local time_left = tostring((LRM_SecondsLeft < math.huge and ""..tostring(math.floor(((LRM_SecondsLeft / 60) / 60) / 24)).." days" or LRM_SecondsLeft == math.huge and "lifetime"))

                items[ "other_info" ] = library:create( "TextLabel" , {
                    Parent = items[ "info" ];
                    RichText = true;
                    Name = "\0";
                    TextColor3 = themes.preset.accent;
                    BorderColor3 = rgb(0, 0, 0);
                    Text = '<font color="rgb(72, 72, 73)">'..time_left..', </font>' .. cfg.name:lower() .. cfg.suffix:lower();
                    Size = dim2(1, 0, 0, 0);
                    Position = dim2(0, -10, 0.5, -1);
                    AnchorPoint = vec2(0, 0.5);
                    BorderSizePixel = 0;
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Right;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    FontFace = fonts.font;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); library:apply_theme(items[ "other_info" ], "accent", "TextColor3");
            end

            do
                library:draggify(items[ "main" ])
                library:resizify(items[ "main" ])
            end

            function cfg.toggle_menu(bool)

                if bool and getgenv().silent_load_block then return end

                items[ "main" ].Visible = bool
            end

            library.set_menu_visible = cfg.toggle_menu

            items[ "close button" ] = library:create( "TextButton" , {
                Parent = library[ "items" ];
                Name = "\0";
                Position = dim2(0, 20, 1, -20);
                AnchorPoint = vec2(0, 1);
                BorderColor3 = rgb(0, 0, 0);
                Size = dim2(0, 75, 0, 50);
                BorderSizePixel = 0;
                Text = "";
                AutoButtonColor = false;
                Visible = true;
                BackgroundColor3 = rgb(25, 25, 29)
            });

            items[ "other_info" ] = library:create( "TextLabel" , {
                Parent = items[ "close button" ];
                RichText = true;
                Name = "\0";
                TextColor3 = rgb(245, 245, 245);
                BorderColor3 = rgb(0, 0, 0);
                Text = "toggle ui";
                Size = dim2(1, 0, 1, 0);
                BorderSizePixel = 0;
                BackgroundTransparency = 1;
                TextXAlignment = Enum.TextXAlignment.Center;
                FontFace = fonts.font;
                ZIndex = 2;
                TextSize = 14;
                BackgroundColor3 = rgb(255, 255, 255)
            });

            library:create( "UICorner" , {
                Parent = items[ "close button" ];
                CornerRadius = dim(0, 10)
            });

            local btn_stroke = library:create( "UIStroke" , {
                Color = rgb(23, 23, 29);
                Parent = items[ "close button" ];
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            });

            local open = not getgenv().silent_load_active
            local btn = items[ "close button" ]
            local btn_input, btn_start, btn_origin, btn_moved

            if getgenv().silent_load_active then
                apply_recording_style(btn, items[ "other_info" ], btn_stroke)
            end

            btn.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(input)
                if input.UserInputType ~= Enum.UserInputType.Touch then return end

                btn_input = input
                btn_start = input.Position
                btn_origin = btn.Position
                btn_moved = false
            end))

            uis.InputChanged:Connect(LPH_NO_VIRTUALIZE(function(input)
                if btn_input ~= input then return end

                local dx = input.Position.X - btn_start.X
                local dy = input.Position.Y - btn_start.Y

                if not btn_moved and (dx * dx + dy * dy) > 100 then
                    btn_moved = true
                end

                if btn_moved then
                    btn.Position = dim2(btn_origin.X.Scale, btn_origin.X.Offset + dx, btn_origin.Y.Scale, btn_origin.Y.Offset + dy)
                end
            end))

            uis.InputEnded:Connect(LPH_NO_VIRTUALIZE(function(input)
                if btn_input ~= input then return end

                btn_input = nil

                if not btn_moved then
                    open = not open
                    cfg.toggle_menu(open)
                end
            end))

            return setmetatable(cfg, library)
        end

        function library:tab(properties)
            local cfg = {
                name = properties.name or properties.Name or "visuals";
                icon = properties.icon or properties.Icon or "http://www.roblox.com/asset/?id=6034767608";

                tabs = properties.tabs or properties.Tabs or {"Main", "Misc.", "Settings"};
                pages = {};
                current_multi;

                items = {};
            }

            local items = cfg.items; do
                items[ "tab_holder" ] = library:create( "Frame" , {
                    Parent = library.cache;
                    Name = "\0";
                    Visible = false;
                    BackgroundTransparency = 1;
                    Position = dim2(0, 196, 0, 56);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -216, 1, -101);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                    items[ "button" ] = library:create( "TextButton" , {
                        FontFace = fonts.font;
                        TextColor3 = rgb(255, 255, 255);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        Parent = self.items[ "button_holder" ];
                        AutoButtonColor = false;
                        BackgroundTransparency = 1;
                        Name = "\0";
                        Size = dim2(1, 0, 0, 35);
                        BorderSizePixel = 0;
                        TextSize = 16;
                        BackgroundColor3 = rgb(29, 29, 29)
                    });

                    items[ "icon" ] = library:create( "ImageLabel" , {
                        ImageColor3 = rgb(72, 72, 73);
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = items[ "button" ];
                        AnchorPoint = vec2(0, 0.5);
                        Image = cfg.icon;
                        BackgroundTransparency = 1;
                        Position = dim2(0, 10, 0.5, 0);
                        Name = "\0";
                        Size = dim2(0, 22, 0, 22);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    }); library:apply_theme(items[ "icon" ], "accent", "ImageColor3");

                    items[ "name" ] = library:create( "TextLabel" , {
                        FontFace = fonts.font;
                        TextColor3 = rgb(72, 72, 73);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = cfg.name;
                        Parent = items[ "button" ];
                        Name = "\0";
                        Size = dim2(0, 0, 1, 0);
                        Position = dim2(0, 40, 0, 0);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.X;
                        TextSize = 16;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    library:create( "UIPadding" , {
                        Parent = items[ "name" ];
                        PaddingRight = dim(0, 5);
                        PaddingLeft = dim(0, 5)
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "button" ];
                        CornerRadius = dim(0, 7)
                    });

                    library:create( "UIStroke" , {
                        Color = rgb(23, 23, 29);
                        Parent = items[ "button" ];
                        Enabled = false;
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    });

                    items[ "multi_section_button_holder" ] = library:create( "Frame" , {
                        Parent = library.cache;
                        BackgroundTransparency = 1;
                        Name = "\0";
                        Visible = false;
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    library:create( "UIListLayout" , {
                        Parent = items[ "multi_section_button_holder" ];
                        Padding = dim(0, 7);
                        SortOrder = Enum.SortOrder.LayoutOrder;
                        FillDirection = Enum.FillDirection.Horizontal
                    });

                    library:create( "UIPadding" , {
                        PaddingTop = dim(0, 8);
                        PaddingBottom = dim(0, 7);
                        Parent = items[ "multi_section_button_holder" ];
                        PaddingRight = dim(0, 7);
                        PaddingLeft = dim(0, 7)
                    });

                    for _, section in cfg.tabs do
                        local data = {items = {}}

                        local multi_items = data.items; do
                                multi_items[ "button" ] = library:create( "TextButton" , {
                                    FontFace = fonts.font;
                                    TextColor3 = rgb(255, 255, 255);
                                    BorderColor3 = rgb(0, 0, 0);
                                    AutoButtonColor = false;
                                    Text = "";
                                    Parent = items[ "multi_section_button_holder" ];
                                    Name = "\0";
                                    Size = dim2(0, 0, 0, 39);
                                    BackgroundTransparency = 1;
                                    ClipsDescendants = true;
                                    BorderSizePixel = 0;
                                    AutomaticSize = Enum.AutomaticSize.X;
                                    TextSize = 16;
                                    BackgroundColor3 = rgb(25, 25, 29)
                                });

                                multi_items[ "name" ] = library:create( "TextLabel" , {
                                    FontFace = fonts.font;
                                    TextColor3 = rgb(62, 62, 63);
                                    BorderColor3 = rgb(0, 0, 0);
                                    Text = section;
                                    Parent = multi_items[ "button" ];
                                    Name = "\0";
                                    Size = dim2(0, 0, 1, 0);
                                    BackgroundTransparency = 1;
                                    TextXAlignment = Enum.TextXAlignment.Left;
                                    BorderSizePixel = 0;
                                    AutomaticSize = Enum.AutomaticSize.XY;
                                    TextSize = 16;
                                    BackgroundColor3 = rgb(255, 255, 255)
                                });

                                library:create( "UIPadding" , {
                                    Parent = multi_items[ "name" ];
                                    PaddingRight = dim(0, 5);
                                    PaddingLeft = dim(0, 5)
                                });

                                multi_items[ "accent" ] = library:create( "Frame" , {
                                    BorderColor3 = rgb(0, 0, 0);
                                    AnchorPoint = vec2(0, 1);
                                    Parent = multi_items[ "button" ];
                                    BackgroundTransparency = 1;
                                    Position = dim2(0, 10, 1, 4);
                                    Name = "\0";
                                    Size = dim2(1, -20, 0, 6);
                                    BorderSizePixel = 0;
                                    BackgroundColor3 = themes.preset.accent
                                }); library:apply_theme(multi_items[ "accent" ], "accent", "BackgroundColor3");

                                library:create( "UICorner" , {
                                    Parent = multi_items[ "accent" ];
                                    CornerRadius = dim(0, 999)
                                });

                                library:create( "UIPadding" , {
                                    Parent = multi_items[ "button" ];
                                    PaddingRight = dim(0, 10);
                                    PaddingLeft = dim(0, 10)
                                });

                                library:create( "UICorner" , {
                                    Parent = multi_items[ "button" ];
                                    CornerRadius = dim(0, 7)
                                });

                                multi_items[ "tab" ] = library:create( "Frame" , {
                                    Parent = library.cache;
                                    BackgroundTransparency = 1;
                                    Name = "\0";
                                    BorderColor3 = rgb(0, 0, 0);
                                    Size = dim2(1, -20, 1, -20);
                                    BorderSizePixel = 0;
                                    Visible = false;
                                    BackgroundColor3 = rgb(255, 255, 255)
                                });

                                library:create( "UIListLayout" , {
                                    FillDirection = Enum.FillDirection.Vertical;
                                    HorizontalFlex = Enum.UIFlexAlignment.Fill;
                                    Parent = multi_items[ "tab" ];
                                    Padding = dim(0, 7);
                                    SortOrder = Enum.SortOrder.LayoutOrder;
                                    VerticalFlex = Enum.UIFlexAlignment.Fill
                                });

                                library:create( "UIPadding" , {
                                    PaddingTop = dim(0, 7);
                                    PaddingBottom = dim(0, 7);
                                    Parent = multi_items[ "tab" ];
                                    PaddingRight = dim(0, 7);
                                    PaddingLeft = dim(0, 7)
                                });
                        end

                        data.text = multi_items[ "name" ]
                        data.accent = multi_items[ "accent" ]
                        data.button = multi_items[ "button" ]
                        data.page = multi_items[ "tab" ]
                        data.parent = setmetatable(data, library):sub_tab({}).items[ "tab_parent" ]

						function data.open_page()
							local page = cfg.current_multi;

                            if page and page.text ~= data.text then
                                self.items[ "global_fade" ].BackgroundTransparency = 0
                                library:tween(self.items[ "global_fade" ], {BackgroundTransparency = 1}, Enum.EasingStyle.Quad, 0.4)

                                local old_size = page.page.Size
                                page.page.Size = dim2(1, -20, 1, -20)
                            end

                            if page then
                                library:tween(page.text, {TextColor3 = rgb(62, 62, 63)})
                                library:tween(page.accent, {BackgroundTransparency = 1})
                                library:tween(page.button, {BackgroundTransparency = 1})

                                page.page.Visible = false
                                page.page.Parent = library[ "cache" ]
                            end

                            library:tween(data.text, {TextColor3 = rgb(255, 255, 255)})
                            library:tween(data.accent, {BackgroundTransparency = 0})
                            library:tween(data.button, {BackgroundTransparency = 0})
                            library:tween(data.page, {Size = dim2(1, 0, 1, 0)}, Enum.EasingStyle.Quad, 0.4)

                            data.page.Visible = true
                            data.page.Parent = items["tab_holder"]

                            cfg.current_multi = data

                            library:close_element()
						end

						multi_items[ "button" ].InputBegan:Connect(LPH_NO_VIRTUALIZE(function(Input)
                            if Input.UserInputType ~= Enum.UserInputType.Touch then return end
							data.open_page()
						end))

						cfg.pages[#cfg.pages + 1] = setmetatable(data, library)
                    end

                    cfg.pages[1].open_page()
            end

            cfg.fit_tabs = function()
                if cfg.fitted then return end

                local holder = items[ "multi_section_button_holder" ]
                local layout = holder:FindFirstChildOfClass("UIListLayout")

                if not layout then return end

                cfg.fitted = true

                task.defer(function()
                    task.wait()

                    local size = 16
                    local pad = 7

                    for _ = 1, 8 do
                        local available = holder.AbsoluteSize.X - 16

                        if available <= 0 then
                            cfg.fitted = false
                            return
                        end

                        if layout.AbsoluteContentSize.X <= available then break end
                        if size <= 10 then break end

                        size -= 1
                        pad = math.max(2, pad - 1)

                        for _, page in cfg.pages do
                            if page.text then page.text.TextSize = size end
                        end

                        layout.Padding = dim(0, pad)

                        task.wait()
                    end
                end)
            end

            function cfg.open_tab()
                local selected_tab = self.selected_tab

                if selected_tab then
                    if selected_tab[ 4 ] ~= items[ "tab_holder" ] then
                        self.items[ "global_fade" ].BackgroundTransparency = 0

                        library:tween(self.items[ "global_fade" ], {BackgroundTransparency = 1}, Enum.EasingStyle.Quad, 0.4)
                        selected_tab[ 4 ].Size = dim2(1, -216, 1, -101)
                    end

                    library:tween(selected_tab[ 1 ], {BackgroundTransparency = 1})
                    library:tween(selected_tab[ 2 ], {ImageColor3 = rgb(72, 72, 73)})
                    library:tween(selected_tab[ 3 ], {TextColor3 = rgb(72, 72, 73)})

                    selected_tab[ 4 ].Visible = false
                    selected_tab[ 4 ].Parent = library[ "cache" ]
                    selected_tab[ 5 ].Visible = false
                    selected_tab[ 5 ].Parent = library[ "cache" ]
                end

                library:tween(items[ "button" ], {BackgroundTransparency = 0})
                library:tween(items[ "icon" ], {ImageColor3 = themes.preset.accent})
                library:tween(items[ "name" ], {TextColor3 = rgb(255, 255, 255)})
                library:tween(items[ "tab_holder" ], {Size = dim2(1, -196, 1, -81)}, Enum.EasingStyle.Quad, 0.4)

                items[ "tab_holder" ].Visible = true
                items[ "tab_holder" ].Parent = self.items[ "main" ]
                items[ "multi_section_button_holder" ].Visible = true
                items[ "multi_section_button_holder" ].Parent = self.items[ "multi_holder" ]

                cfg.fit_tabs()

                self.selected_tab = {
                    items[ "button" ];
                    items[ "icon" ];
                    items[ "name" ];
                    items[ "tab_holder" ];
                    items[ "multi_section_button_holder" ];
                }

                library:close_element()
            end

            items[ "button" ].InputBegan:Connect(LPH_NO_VIRTUALIZE(function(Input)
                            if Input.UserInputType ~= Enum.UserInputType.Touch then return end
                cfg.open_tab()
            end))

            if not self.selected_tab then
                cfg.open_tab(true)
                library.first_tab = cfg.open_tab
            end

            return unpack(cfg.pages)
        end

        function library:open_first_tab()
            if library.first_tab then library.first_tab() end
        end

        function library:seperator(properties)
            local cfg = {items = {}, name = properties.Name or properties.name or "General"}

            local items = cfg.items do
                items[ "name" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(72, 72, 73);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = self.items[ "button_holder" ];
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    Position = dim2(0, 40, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 16;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library:create( "UIPadding" , {
                    Parent = items[ "name" ];
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });
            end;

            return setmetatable(cfg, library)
        end

            function library:column(properties)
                local cfg = {items = {}, size = properties.size or 1}

                local items = cfg.items; do
                    items[ "column" ] = library:create( "Frame" , {
                        Parent = self[ "parent" ] or self.items["tab_parent"];
                        BackgroundTransparency = 1;
                        Name = "\0";
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 0, cfg.size, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    library:create( "UIListLayout" , {
                        Parent = items[ "column" ];
                        HorizontalFlex = Enum.UIFlexAlignment.Fill;
                        Padding = dim(0, 6);
                        FillDirection = Enum.FillDirection.Vertical;
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });
                end

                return setmetatable(cfg, library)
            end

            function library:sub_tab(properties)
                local cfg = {items = {}, order = properties.order or 0; size = properties.size or 1}

                local items = cfg.items; do
                    items[ "tab_parent" ] = library:create( "Frame" , {
                        Parent = self.items[ "tab" ];
                        BackgroundTransparency = 1;
                        Name = "\0";
                        Size = dim2(0,0,cfg.size,0);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        Visible = true;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    library:create( "UIListLayout" , {
                        FillDirection = Enum.FillDirection.Horizontal;
                        HorizontalFlex = Enum.UIFlexAlignment.Fill;
                        VerticalFlex = Enum.UIFlexAlignment.Fill;
                        Parent = items[ "tab_parent" ];
                        Padding = dim(0, 7);
                        SortOrder = Enum.SortOrder.LayoutOrder;
                    });
                end

                return setmetatable(cfg, library)
            end

        function library:section(properties)
            local cfg = {
                name = properties.name or properties.Name or "section";
                side = properties.side or properties.Side or "left";
                default = properties.default or properties.Default or false;
                size = properties.size or properties.Size or self.size or 0.5;
                autosize = (properties.autosize ~= false and properties.AutoSize ~= false);
                icon = properties.icon or properties.Icon or "http://www.roblox.com/asset/?id=6022668898";
                fading_toggle = properties.fading or properties.Fading or false;
                items = {};
            };

            local items = cfg.items; do
                items[ "outline" ] = library:create( "Frame" , {
                    Name = "\0";
                    Parent = self.items[ "column" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 0, cfg.size, -3);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(25, 25, 29)
                });

                library:create( "UICorner" , {
                    Parent = items[ "outline" ];
                    CornerRadius = dim(0, 7)
                });

                do
                    local edge = library:create( "UIStroke" , {
                        Parent = items[ "outline" ];
                        Thickness = 1;
                        Transparency = 1;
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                        Color = themes.preset.accent
                    })

                    library:apply_theme(edge, "accent", "Color")
                    library:track_edge(edge, 0.82)
                end

                items[ "inline" ] = library:create( "Frame" , {
                    Parent = items[ "outline" ];
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(22, 22, 24)
                });

                library:create( "UICorner" , {
                    Parent = items[ "inline" ];
                    CornerRadius = dim(0, 7)
                });

                items[ "scrolling" ] = library:create( "ScrollingFrame" , {
                    ScrollBarImageColor3 = rgb(44, 44, 46);
                    Active = true;
                    AutomaticCanvasSize = Enum.AutomaticSize.Y;
                    ScrollBarThickness = 2;
                    Parent = items[ "inline" ];
                    Name = "\0";
                    Size = dim2(1, 0, 1, -33);
                    BackgroundTransparency = 1;
                    Position = dim2(0, 0, 0, 28);
                    BackgroundColor3 = rgb(255, 255, 255);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    CanvasSize = dim2(0, 0, 0, 0)
                });

                items[ "elements" ] = library:create( "Frame" , {
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = items[ "scrolling" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 10, 0, 10);
                    Size = dim2(1, -20, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library:create( "UIListLayout" , {
                    Parent = items[ "elements" ];
                    Padding = dim(0, 6);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });


                if cfg.autosize then
                    local layout = child_of_class(items[ "elements" ], "UIListLayout")

                    local fit_retry = 0

                    local function fit()
                        local column = self.items[ "column" ]
                        if not (layout and column) then return end

                        local available = column.AbsoluteSize.Y

                        if available <= 0 then
                            if fit_retry < 12 then
                                fit_retry = fit_retry + 1
                                task.delay(0.1, function() fit() end)
                            end

                            return
                        end

                        fit_retry = 0

                        items[ "outline" ]:SetAttribute("FitScale", ((cfg.active_layout or layout).AbsoluteContentSize.Y + 50) / available)

                        local frames = {}

                        for _, child in column:GetChildren() do
                            local wanted = child:IsA("GuiObject") and child:GetAttribute("FitScale")

                            if wanted and wanted > 0 then
                                frames[#frames + 1] = { frame = child, need = wanted }
                            end
                        end

                        local count = #frames
                        if count == 0 then return end

                        local budget = 0.98

                        table.sort(frames, function(a, b) return a.need < b.need end)

                        local remaining = budget
                        local unassigned = count

                        for i = 1, count do
                            local share = remaining / unassigned
                            local grant = math.min(frames[i].need, share)

                            frames[i].frame.Size = dim2(0, 0, grant, -3)

                            remaining = remaining - grant
                            unassigned = unassigned - 1
                        end
                    end

                    local fit_queued = false

                    local function queue_fit()
                        if fit_queued then return end
                        fit_queued = true

                        task.defer(function()
                            fit_queued = false
                            fit()
                        end)
                    end

                    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(queue_fit)
                    items[ "elements" ].ChildAdded:Connect(queue_fit)
                    self.items[ "column" ]:GetPropertyChangedSignal("AbsoluteSize"):Connect(queue_fit)

                    library.autosize_refresh = library.autosize_refresh or {}
                    library.autosize_refresh[#library.autosize_refresh + 1] = queue_fit

                    cfg.queue_fit = queue_fit

                    queue_fit()
                end

                items[ "button" ] = library:create( "TextButton" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(255, 255, 255);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    AutoButtonColor = false;
                    Parent = items[ "outline" ];
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    Size = dim2(1, -2, 0, 28);
                    BorderSizePixel = 0;
                    TextSize = 16;
                    BackgroundColor3 = rgb(19, 19, 21)
                });

                library:create( "UIStroke" , {
                    Color = rgb(23, 23, 29);
                    Parent = items[ "button" ];
                    Enabled = false;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                });

                library:create( "UICorner" , {
                    Parent = items[ "button" ];
                    CornerRadius = dim(0, 7)
                });

                items[ "Icon" ] = library:create( "ImageLabel" , {
                    ImageColor3 = themes.preset.accent;
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = items[ "button" ];
                    AnchorPoint = vec2(0, 0.5);
                    Image = cfg.icon;
                    BackgroundTransparency = 1;
                    Position = dim2(0, 10, 0.5, 0);
                    Name = "\0";
                    Size = dim2(0, 22, 0, 22);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); library:apply_theme(items[ "Icon" ], "accent", "ImageColor3");

                items[ "section_title" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(255, 255, 255);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = items[ "button" ];
                    Name = "\0";
                    Size = dim2(0, 0, 1, 0);
                    Position = dim2(0, 40, 0, -1);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.X;
                    TextSize = 16;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = items[ "button" ];
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(36, 36, 37)
                });

                if cfg.fading_toggle then
                    items[ "toggle" ] = library:create( "TextButton" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        AutoButtonColor = false;
                        Text = "";
                        AnchorPoint = vec2(1, 0.5);
                        Parent = items[ "button" ];
                        Name = "\0";
                        Position = dim2(1, -9, 0.5, 0);
                        Size = dim2(0, 36, 0, 18);
                        BorderSizePixel = 0;
                        TextSize = 14;
                        BackgroundColor3 = rgb(58, 58, 62)
                    });  library:apply_theme(items[ "toggle" ], "accent", "BackgroundColor3");

                    library:create( "UICorner" , {
                        Parent = items[ "toggle" ];
                        CornerRadius = dim(0, 999)
                    });

                    items[ "toggle_outline" ] = library:create( "Frame" , {
                        Parent = items[ "toggle" ];
                        Size = dim2(1, -2, 1, -2);
                        Name = "\0";
                        BorderMode = Enum.BorderMode.Inset;
                        BorderColor3 = rgb(0, 0, 0);
                        Position = dim2(0, 1, 0, 1);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(50, 50, 50)
                    });  library:apply_theme(items[ "toggle_outline" ], "accent", "BackgroundColor3");

                    library:create( "UICorner" , {
                        Parent = items[ "toggle_outline" ];
                        CornerRadius = dim(0, 999)
                    });

                    library:create( "UIGradient" , {
                        Color = rgbseq{rgbkey(0, rgb(211, 211, 211)), rgbkey(1, rgb(211, 211, 211))};
                        Parent = items[ "toggle_outline" ]
                    });

                    items[ "toggle_circle" ] = library:create( "Frame" , {
                        Parent = items[ "toggle_outline" ];
                        Name = "\0";
                        Position = dim2(0, 2, 0, 2);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 12, 0, 12);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(86, 86, 88)
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "toggle_circle" ];
                        CornerRadius = dim(0, 999)
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "outline" ];
                        CornerRadius = dim(0, 7)
                    });

                    items[ "fade" ] = library:create( "Frame" , {
                        Parent = items[ "outline" ];
                        BackgroundTransparency = 0.800000011920929;
                        Name = "\0";
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "fade" ];
                        CornerRadius = dim(0, 7)
                    });
                end
            end;

            if cfg.fading_toggle then
                library:on_tap(items[ "button" ], LPH_NO_VIRTUALIZE(function(input)
                    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.Touch then
                        cfg.default = not cfg.default
                        cfg.toggle_section(cfg.default)
                    end
                end))

                function cfg.toggle_section(bool)
                    library:tween(items[ "toggle" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(58, 58, 62)}, Enum.EasingStyle.Quad)
                    library:tween(items[ "toggle_outline" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(50, 50, 50)}, Enum.EasingStyle.Quad)
                    library:tween(items[ "toggle_circle" ], {BackgroundColor3 = bool and rgb(255, 255, 255) or rgb(86, 86, 88), Position = bool and dim2(1, -14, 0, 2) or dim2(0, 2, 0, 2)}, Enum.EasingStyle.Quad)
                    library:tween(items[ "fade" ], {BackgroundTransparency = bool and 1 or 0.8}, Enum.EasingStyle.Quad)
                end
            end

            local tab_names = properties.tabs or properties.Tabs

            if type(tab_names) == "table" and #tab_names > 0 then
                local pages, layouts, buttons, accents, proxies, paddings = {}, {}, {}, {}, {}, {}
                local tab_pad, tab_gap, tab_fit_queued = 9, 4, false

                items[ "section_title" ].Visible = false

                items[ "tab_holder" ] = library:create( "Frame" , {
                    Parent = items[ "button" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 36, 0, 0);
                    Size = dim2(1, -44, 1, -1);
                    BorderSizePixel = 0;
                    ClipsDescendants = true;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library:create( "UIListLayout" , {
                    Parent = items[ "tab_holder" ];
                    FillDirection = Enum.FillDirection.Horizontal;
                    VerticalAlignment = Enum.VerticalAlignment.Center;
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    Padding = dim(0, tab_gap)
                });

                items[ "tab_fade" ] = library:create( "Frame" , {
                    Parent = items[ "inline" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 0, 0, 28);
                    Size = dim2(1, 0, 1, -28);
                    BorderSizePixel = 0;
                    ZIndex = 2;
                    BackgroundColor3 = rgb(22, 22, 24)
                });

                library:create( "UICorner" , {
                    Parent = items[ "tab_fade" ];
                    CornerRadius = dim(0, 7)
                });

                local function fit_tabs()
                    tab_fit_queued = false

                    local holder = items[ "tab_holder" ]
                    local unit = (holder.AbsolutePosition.X - items[ "button" ].AbsolutePosition.X) / 36
                    local available = holder.AbsoluteSize.X

                    if unit <= 0 or available <= 0 or #buttons == 0 then return end

                    local text = 0

                    for i = 1, #buttons do
                        text = text + buttons[i].AbsoluteSize.X / unit - tab_pad * 2
                    end

                    local pad = math.clamp(math.floor((available / unit - text - tab_gap * (#buttons - 1)) / (#buttons * 2)), 3, 9)

                    if pad == tab_pad then return end

                    tab_pad = pad

                    for i = 1, #paddings do
                        paddings[i].PaddingLeft = dim(0, pad)
                        paddings[i].PaddingRight = dim(0, pad)
                    end
                end

                local function queue_tabs()
                    if tab_fit_queued then return end

                    tab_fit_queued = true

                    task.defer(fit_tabs)
                end

                local function paint(index)
                    for i = 1, #pages do
                        local active = i == index

                        library:tween(buttons[i], {TextColor3 = library:theme_text(active and 1 or 0.29)})
                        library:tween(accents[i], {BackgroundTransparency = active and 0 or 1})
                    end
                end

                function cfg.select_tab(index)
                    if not pages[index] then return end

                    local switching = cfg.active_tab ~= nil and cfg.active_tab ~= index

                    cfg.active_tab = index
                    cfg.active_layout = layouts[index]

                    for i = 1, #pages do
                        pages[i].Visible = i == index
                    end

                    items[ "scrolling" ].CanvasPosition = vec2(0, 0)

                    paint(index)

                    if switching then
                        items[ "tab_fade" ].BackgroundTransparency = 0
                        library:tween(items[ "tab_fade" ], {BackgroundTransparency = 1}, Enum.EasingStyle.Quad, 0.4)

                        library:close_element()
                    end

                    if cfg.queue_fit then cfg.queue_fit() end

                    library:relayout_sections()
                end

                for index, tab_name in ipairs(tab_names) do
                    local page = items[ "elements" ]
                    local layout

                    if index == 1 then
                        layout = child_of_class(page, "UIListLayout")
                    else
                        page = library:create( "Frame" , {
                            BorderColor3 = rgb(0, 0, 0);
                            Parent = items[ "scrolling" ];
                            Name = "\0";
                            BackgroundTransparency = 1;
                            Position = dim2(0, 10, 0, 10);
                            Size = dim2(1, -20, 0, 0);
                            BorderSizePixel = 0;
                            AutomaticSize = Enum.AutomaticSize.Y;
                            Visible = false;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });

                        layout = library:create( "UIListLayout" , {
                            Parent = page;
                            Padding = dim(0, 6);
                            SortOrder = Enum.SortOrder.LayoutOrder
                        });

                        if cfg.queue_fit then
                            layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(cfg.queue_fit)
                            page.ChildAdded:Connect(cfg.queue_fit)
                        end
                    end

                    local button = library:create( "TextButton" , {
                        FontFace = fonts.font;
                        Text = tostring(tab_name);
                        TextColor3 = library:theme_text(index == 1 and 1 or 0.29);
                        AutoButtonColor = false;
                        Parent = items[ "tab_holder" ];
                        Name = "\0";
                        LayoutOrder = index;
                        AutomaticSize = Enum.AutomaticSize.X;
                        Size = dim2(0, 0, 1, 0);
                        BackgroundTransparency = 1;
                        BorderSizePixel = 0;
                        TextSize = 16;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    paddings[index] = library:create( "UIPadding" , {
                        Parent = button;
                        PaddingLeft = dim(0, tab_pad);
                        PaddingRight = dim(0, tab_pad)
                    });

                    button:GetPropertyChangedSignal("TextBounds"):Connect(queue_tabs)

                    local accent = library:create( "Frame" , {
                        Parent = button;
                        Name = "\0";
                        AnchorPoint = vec2(0, 1);
                        Position = dim2(0, 0, 1, 0);
                        Size = dim2(1, 0, 0, 2);
                        BorderSizePixel = 0;
                        BackgroundTransparency = index == 1 and 0 or 1;
                        BackgroundColor3 = themes.preset.accent
                    }); library:apply_theme(accent, "accent", "BackgroundColor3");

                    library:create( "UICorner" , {
                        Parent = accent;
                        CornerRadius = dim(0, 999)
                    });

                    pages[index], layouts[index], buttons[index], accents[index] = page, layout, button, accent

                    if library.on_tap then
                        library:on_tap(button, function()
                            cfg.select_tab(index)
                        end)
                    else
                        button.MouseButton1Click:Connect(function()
                            cfg.select_tab(index)
                        end)
                    end

                    if index > 1 then
                        proxies[#proxies + 1] = setmetatable({
                            name = tostring(tab_name);
                            parent_section = cfg;
                            items = {
                                elements = page;
                                outline = items[ "outline" ];
                                inline = items[ "inline" ];
                                scrolling = items[ "scrolling" ];
                                button = items[ "button" ]
                            }
                        }, library)
                    end
                end

                items[ "tab_holder" ]:GetPropertyChangedSignal("AbsoluteSize"):Connect(queue_tabs)
                queue_tabs()

                cfg.tab_pages = pages
                cfg.active_tab = 1
                cfg.active_layout = layouts[1]

                library:on_theme(function(key)
                    if key == "text" then paint(cfg.active_tab or 1) end
                end)

                return setmetatable(cfg, library), table.unpack(proxies)
            end

            return setmetatable(cfg, library)
        end

        function library:toggle(options)
            local rand = math.random(1, 2)
            local cfg = {
                enabled = options.default or false,
                name = options.name or "Toggle",
                info = options.info or nil,
                flag = options.flag or library:next_flag(),

                type = options.type and string.lower(options.type) or rand == 1 and "toggle" or "checkbox";

                default = options.default or false,
                folding = options.folding or false,
                callback = options.callback or function() end,

                items = {};
                seperator = options.seperator or options.Seperator or false;
            }

            flags[cfg.flag] = cfg.default

            local items = cfg.items; do
                items[ "toggle" ] = library:create( "TextButton" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    Parent = self.items[ "elements" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                items[ "name" ] = library:create( "TextLabel" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(245, 245, 245);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = items[ "toggle" ];
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 16;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                if cfg.info then
                    items[ "info" ] = library:create( "TextLabel" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(130, 130, 130);
                        BorderColor3 = rgb(0, 0, 0);
                        TextWrapped = true;
                        Text = cfg.info;
                        Parent = items[ "toggle" ];
                        Name = "\0";
                        Position = dim2(0, 5, 0, 17);
                        Size = dim2(1, -10, 0, 0);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 16;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                end

                library:create( "UIPadding" , {
                    Parent = items[ "name" ];
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });

                items[ "right_components" ] = library:create( "Frame" , {
                    Parent = items[ "toggle" ];
                    Name = "\0";
                    Position = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 0, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library:create( "UIListLayout" , {
                    FillDirection = Enum.FillDirection.Horizontal;
                    HorizontalAlignment = Enum.HorizontalAlignment.Right;
                    Parent = items[ "right_components" ];
                    Padding = dim(0, 9);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });

                    if cfg.type == "checkbox" then
                        items[ "toggle_button" ] = library:create( "TextButton" , {
                            FontFace = fonts.small;
                            TextColor3 = rgb(0, 0, 0);
                            BorderColor3 = rgb(0, 0, 0);
                            Text = "";
                            LayoutOrder = 2;
                            AutoButtonColor = false;
                            AnchorPoint = vec2(1, 0);
                            Parent = items[ "right_components" ];
                            Name = "\0";
                            Position = dim2(1, 0, 0, 0);
                            Size = dim2(0, 16, 0, 16);
                            BorderSizePixel = 0;
                            TextSize = 14;
                            BackgroundColor3 = rgb(67, 67, 68)
                        }); library:apply_theme(items[ "toggle_button" ], "accent", "BackgroundColor3");

                        library:create( "UICorner" , {
                            Parent = items[ "toggle_button" ];
                            CornerRadius = dim(0, 4)
                        });

                        items[ "outline" ] = library:create( "Frame" , {
                            Parent = items[ "toggle_button" ];
                            Size = dim2(1, -2, 1, -2);
                            Name = "\0";
                            BorderMode = Enum.BorderMode.Inset;
                            BorderColor3 = rgb(0, 0, 0);
                            Position = dim2(0, 1, 0, 1);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(22, 22, 24)
                        }); library:apply_theme(items[ "outline" ], "accent", "BackgroundColor3");

                        items[ "tick" ] = library:create( "ImageLabel" , {
                            ImageTransparency = 1;
                            BorderColor3 = rgb(0, 0, 0);
                            Image = "rbxassetid://111862698467575";
                            BackgroundTransparency = 1;
                            Position = dim2(0, -1, 0, 0);
                            Parent = items[ "outline" ];
                            Size = dim2(1, 2, 1, 2);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(255, 255, 255);
                            ZIndex = 1;
                        });

                        library:create( "UICorner" , {
                            Parent = items[ "outline" ];
                            CornerRadius = dim(0, 4)
                        });

                        library:create( "UIGradient" , {
                            Enabled = false;
                            Parent = items[ "outline" ];
                            Color = rgbseq{rgbkey(0, rgb(211, 211, 211)), rgbkey(1, rgb(211, 211, 211))}
                        });
                    else
                        items[ "toggle_button" ] = library:create( "TextButton" , {
                            FontFace = fonts.font;
                            TextColor3 = rgb(0, 0, 0);
                            BorderColor3 = rgb(0, 0, 0);
                            Text = "";
                            LayoutOrder = 2;
                            AnchorPoint = vec2(1, 0.5);
                            Parent = items[ "right_components" ];
                            Name = "\0";
                            Position = dim2(1, -9, 0.5, 0);
                            Size = dim2(0, 36, 0, 18);
                            BorderSizePixel = 0;
                            TextSize = 14;
                            BackgroundColor3 = themes.preset.accent
                        }); library:apply_theme(items[ "toggle_button" ], "accent", "BackgroundColor3");

                        library:create( "UICorner" , {
                            Parent = items[ "toggle_button" ];
                            CornerRadius = dim(0, 999)
                        });

                        do
                            local edge = library:create( "UIStroke" , {
                                Parent = items[ "toggle_button" ];
                                Thickness = 1;
                                Transparency = 1;
                                ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                                Color = themes.preset.accent
                            })

                            library:apply_theme(edge, "accent", "Color")
                            library:track_edge(edge, 0.6)
                        end

                        items[ "inline" ] = library:create( "Frame" , {
                            Parent = items[ "toggle_button" ];
                            Size = dim2(1, -2, 1, -2);
                            Name = "\0";
                            BorderMode = Enum.BorderMode.Inset;
                            BorderColor3 = rgb(0, 0, 0);
                            Position = dim2(0, 1, 0, 1);
                            BorderSizePixel = 0;
                            BackgroundColor3 = themes.preset.accent
                        }); library:apply_theme(items[ "inline" ], "accent", "BackgroundColor3");

                        library:create( "UICorner" , {
                            Parent = items[ "inline" ];
                            CornerRadius = dim(0, 999)
                        });

                        library:create( "UIGradient" , {
                            Color = rgbseq{rgbkey(0, rgb(211, 211, 211)), rgbkey(1, rgb(211, 211, 211))};
                            Parent = items[ "inline" ]
                        });

                        items[ "circle" ] = library:create( "Frame" , {
                            Parent = items[ "inline" ];
                            Name = "\0";
                            Position = dim2(1, -14, 0, 2);
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(0, 12, 0, 12);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });

                        library:create( "UICorner" , {
                            Parent = items[ "circle" ];
                            CornerRadius = dim(0, 999)
                        });
                    end
            end;

            library.accent_refreshers = library.accent_refreshers or {}

            insert(library.accent_refreshers, function()
                if not cfg.enabled or not items[ "toggle_button" ] or not items[ "toggle_button" ].Parent then return end

                library:tween(items[ "toggle_button" ], {BackgroundColor3 = themes.preset.accent}, Enum.EasingStyle.Quad, 0.15)

                if cfg.type == "checkbox" and items[ "outline" ] then
                    library:tween(items[ "outline" ], {BackgroundColor3 = themes.preset.accent}, Enum.EasingStyle.Quad, 0.15)
                elseif items[ "inline" ] then
                    library:tween(items[ "inline" ], {BackgroundColor3 = themes.preset.accent}, Enum.EasingStyle.Quad, 0.15)
                end
            end)

            function cfg.set(bool)
                cfg.enabled = bool
                flags[cfg.flag] = bool
                library.armed[cfg.flag] = bool

                cfg.callback(bool)
                keep_identity()

                if cfg.bound_key then
                    cfg.bound_key.apply_owner()
                end

                if cfg.folding then
                    elements.Visible = bool
                end

                if cfg.type == "checkbox" then
                    library:tween(items[ "tick" ], {Rotation = bool and 0 or 45, ImageTransparency = bool and 0 or 1})
                    library:tween(items[ "toggle_button" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(67, 67, 68)})
                    library:tween(items[ "outline" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(22, 22, 24)})
                else
                    library:tween(items[ "toggle_button" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(58, 58, 62)}, Enum.EasingStyle.Quad)
                    library:tween(items[ "inline" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(50, 50, 50)}, Enum.EasingStyle.Quad)
                    library:tween(items[ "circle" ], {BackgroundColor3 = bool and rgb(255, 255, 255) or rgb(86, 86, 88), Position = bool and dim2(1, -14, 0, 2) or dim2(0, 2, 0, 2)}, Enum.EasingStyle.Quad)
                end
            end

            local function flip_toggle()
                cfg.enabled = not cfg.enabled
                cfg.set(cfg.enabled)
            end

            library:on_tap(items[ "toggle_button" ], flip_toggle)

            if cfg.seperator then
                library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = self.items[ "elements" ];
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 1, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(36, 36, 37)
                });
            end

            cfg.set(cfg.default)

            config_flags[cfg.flag] = cfg.set

            return setmetatable(cfg, library)
        end

        function library:slider(options)
            local cfg = {
                name = options.name or nil,
                suffix = options.suffix or "",
                flag = options.flag or library:next_flag(),
                callback = options.callback or function() end,
                info = options.info or nil;

                min = options.min or options.minimum or 0,
                max = options.max or options.maximum or 100,
                intervals = options.interval or options.decimal or 1,
                default = options.default or 10,
                value = options.default or 10,
                seperator = options.seperator or options.Seperator or false;
                half = options.half or false;

                dragging = false,
                items = {}
            }

            flags[cfg.flag] = cfg.default

            local row, side

            if cfg.half and self.items and self.items[ "elements" ] then
                if self.half_row and self.half_row.Parent then
                    row = self.half_row
                    side = 1

                    self.half_row = nil
                else
                    row = library:create( "Frame" , {
                        Parent = self.items[ "elements" ];
                        Name = "\0";
                        BackgroundTransparency = 1;
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 0, 16);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    })

                    side = 0
                    self.half_row = row
                end
            end

            local items = cfg.items; do
                items[ "slider_object" ] = library:create( "TextButton" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    Parent = row or self.items[ "elements" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                if row then
                    items[ "slider_object" ].AutomaticSize = Enum.AutomaticSize.None
                    items[ "slider_object" ].Size = dim2(0.5, -3, 1, 0)
                    items[ "slider_object" ].Position = side == 0 and dim2(0, 0, 0, 0) or dim2(0.5, 3, 0, 0)
                end

                items[ "slider" ] = library:create( "TextButton" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    AutoButtonColor = false;
                    Parent = items[ "slider_object" ];
                    Name = "\0";
                    Position = dim2(0, 0, 0, 0);
                    Size = dim2(1, 0, 0, 16);
                    BorderSizePixel = 0;
                    TextSize = 14;
                    BackgroundColor3 = rgb(33, 33, 35)
                });

                library:create( "UICorner" , {
                    Parent = items[ "slider" ];
                    CornerRadius = dim(0, 3)
                });

                items[ "fill" ] = library:create( "Frame" , {
                    Name = "\0";
                    Parent = items[ "slider" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0.5, 0, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.accent
                });  library:apply_theme(items[ "fill" ], "accent", "BackgroundColor3");

                library:create( "UICorner" , {
                    Parent = items[ "fill" ];
                    CornerRadius = dim(0, 3)
                });

                items[ "value" ] = library:create( "TextLabel" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(235, 235, 235);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    Parent = items[ "slider" ];
                    Name = "\0";
                    Position = dim2(0, 6, 0, 0);
                    Size = dim2(1, -12, 1, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Center;
                    TextYAlignment = Enum.TextYAlignment.Center;
                    TextTruncate = Enum.TextTruncate.AtEnd;
                    BorderSizePixel = 0;
                    ZIndex = 3;
                    TextSize = 13;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library:create( "UIStroke" , {
                    Parent = items[ "value" ];
                    Thickness = 1;
                    Transparency = 0.25;
                    Color = rgb(0, 0, 0)
                });

                items[ "name" ] = items[ "value" ]

                if cfg.info then
                    items[ "info" ] = library:create( "TextLabel" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(130, 130, 130);
                        BorderColor3 = rgb(0, 0, 0);
                        TextWrapped = true;
                        Text = cfg.info;
                        Parent = items[ "slider_object" ];
                        Name = "\0";
                        Position = dim2(0, 5, 0, 23);
                        Size = dim2(1, -10, 0, 0);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 16;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                end
            end

            local function render_value()
                local text = tostring(cfg.value) .. cfg.suffix

                items[ "value" ].Text = cfg.name and (cfg.name .. ": " .. text) or text
            end

            function cfg.changetext(text)
                cfg.name = text

                render_value()
            end

            function cfg.set(value)
                cfg.value = clamp(library:round(value, cfg.intervals), cfg.min, cfg.max)

                flags[cfg.flag] = cfg.value
                cfg.callback(flags[cfg.flag])
                keep_identity()

                library:tween(items[ "fill" ], {Size = dim2((cfg.value - cfg.min) / (cfg.max - cfg.min), 0, 1, 0)}, Enum.EasingStyle.Linear, 0.05)

                render_value()
            end

            local slide_input = nil

            local function slide_to(position)
                local track = items[ "slider" ]
                local size_x = (position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X

                cfg.set(((cfg.max - cfg.min) * math.clamp(size_x, 0, 1)) + cfg.min)
            end

            local function begin_slide(input)
                if input.UserInputType ~= Enum.UserInputType.Touch and input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end

                if library:overlay_guarding(cfg, items[ "slider" ]) then return end

                slide_input = input
                cfg.dragging = true
                library:tween(items[ "value" ], {TextColor3 = rgb(255, 255, 255)}, Enum.EasingStyle.Quad, 0.2)
                slide_to(input.Position)
            end

            items[ "slider" ].InputBegan:Connect(LPH_NO_VIRTUALIZE(begin_slide))
            items[ "slider_object" ].InputBegan:Connect(LPH_NO_VIRTUALIZE(begin_slide))

            library:connection(uis.InputChanged, function(input)
                if cfg.dragging and input == slide_input then
                    slide_to(input.Position)
                end
            end)

            library:connection(uis.InputEnded, function(input)
                if input == slide_input then
                    slide_input = nil
                    cfg.dragging = false
                    library:tween(items[ "value" ], {TextColor3 = rgb(235, 235, 235)}, Enum.EasingStyle.Quad, 0.2)
                end
            end)

            if cfg.seperator then
                library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = self.items[ "elements" ];
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 1, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(36, 36, 37)
                });
            end

            cfg.set(cfg.default)
            config_flags[cfg.flag] = cfg.set

            return setmetatable(cfg, library)
        end

        function library:dropdown(options)
            local cfg = {
                name = options.name or nil;
                info = options.info or nil;
                flag = options.flag or library:next_flag();
                options = options.items or {""};
                callback = options.callback or function() end;
                multi = options.multi or false;
                scrolling = options.scrolling or false;

                width = options.width or 130;

                open = false;
                option_instances = {};
                multi_items = {};
                ignore = options.ignore or false;
                items = {};
                y_size;
                seperator = options.seperator or options.Seperator or false;
            }

            cfg.default = options.default or (cfg.multi and {cfg.items[1]}) or cfg.items[1] or "None"
            flags[cfg.flag] = cfg.default

            local items = cfg.items; do
                    items[ "dropdown_object" ] = library:create( "TextButton" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        Parent = self.items[ "elements" ];
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Size = dim2(1, 0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.Y;
                        TextSize = 14;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    items[ "name" ] = library:create( "TextLabel" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(245, 245, 245);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = cfg.name;
                        Parent = items[ "dropdown_object" ];
                        Name = "\0";
                        Size = dim2(1, 0, 0, 0);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 16;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    if cfg.info then
                        items[ "info" ] = library:create( "TextLabel" , {
                            FontFace = fonts.small;
                            TextColor3 = rgb(130, 130, 130);
                            BorderColor3 = rgb(0, 0, 0);
                            TextWrapped = true;
                            Text = cfg.info;
                            Parent = items[ "dropdown_object" ];
                            Name = "\0";
                            Position = dim2(0, 5, 0, 17);
                            Size = dim2(1, -10, 0, 0);
                            BackgroundTransparency = 1;
                            TextXAlignment = Enum.TextXAlignment.Left;
                            BorderSizePixel = 0;
                            AutomaticSize = Enum.AutomaticSize.XY;
                            TextSize = 16;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });
                    end

                    library:create( "UIPadding" , {
                        Parent = items[ "name" ];
                        PaddingRight = dim(0, 5);
                        PaddingLeft = dim(0, 5)
                    });

                    items[ "right_components" ] = library:create( "Frame" , {
                        Parent = items[ "dropdown_object" ];
                        Name = "\0";
                        Position = dim2(1, 0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    library:create( "UIListLayout" , {
                        FillDirection = Enum.FillDirection.Horizontal;
                        HorizontalAlignment = Enum.HorizontalAlignment.Right;
                        Parent = items[ "right_components" ];
                        Padding = dim(0, 7);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });

                    items[ "dropdown" ] = library:create( "TextButton" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        AutoButtonColor = false;
                        AnchorPoint = vec2(1, 0);
                        Parent = items[ "right_components" ];
                        Name = "\0";
                        Position = dim2(1, 0, 0, 0);
                        Size = dim2(0, cfg.width, 0, 16);
                        BorderSizePixel = 0;
                        TextSize = 14;
                        BackgroundColor3 = rgb(33, 33, 35)
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "dropdown" ];
                        CornerRadius = dim(0, 6)
                    });

                    do
                        local edge = library:create( "UIStroke" , {
                            Parent = items[ "dropdown" ];
                            Thickness = 1;
                            Transparency = 1;
                            ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                            Color = themes.preset.accent
                        })

                        library:apply_theme(edge, "accent", "Color")
                        library:track_edge(edge, 0.72)
                    end

                    items[ "sub_text" ] = library:create( "TextLabel" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(86, 86, 87);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "awdawdawdawdawdawdawdaw";
                        Parent = items[ "dropdown" ];
                        Name = "\0";
                        Size = dim2(1, -12, 0, 0);
                        BorderSizePixel = 0;
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        TextTruncate = Enum.TextTruncate.AtEnd;
                        AutomaticSize = Enum.AutomaticSize.Y;
                        TextSize = 14;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    library:create( "UIPadding" , {
                        Parent = items[ "sub_text" ];
                        PaddingTop = dim(0, 1);
                        PaddingRight = dim(0, 5);
                        PaddingLeft = dim(0, 5)
                    });

                    items[ "indicator" ] = library:create( "Frame" , {
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = items[ "dropdown" ];
                        AnchorPoint = vec2(1, 0.5);
                        BackgroundTransparency = 1;
                        Position = dim2(1, -6, 0.5, 0);
                        Name = "\0";
                        Size = dim2(0, 10, 0, 10);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    for _, arm in {{-2, 38}, {2, -38}} do
                        local bar = library:create( "Frame" , {
                            Parent = items[ "indicator" ];
                            Name = "\0";
                            AnchorPoint = vec2(0.5, 0.5);
                            Position = dim2(0.5, arm[1], 0.5, -1);
                            Size = dim2(0, 7, 0, 1);
                            Rotation = arm[2];
                            BorderSizePixel = 0;
                            BorderColor3 = rgb(0, 0, 0);
                            BackgroundColor3 = rgb(120, 120, 122)
                        });

                        library:create( "UICorner" , {
                            Parent = bar;
                            CornerRadius = dim(0, 1)
                        });
                    end

                    items[ "dropdown_holder" ] = library:create( "Frame" , {
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = library[ "items" ];
                        Name = "\0";
                        Visible = false;
                        BackgroundTransparency = 1;
                        Size = dim2(0, 0, 0, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0);
                        ZIndex = 10;
                    });

                    items[ "outline" ] = library:create( "ScrollingFrame" , {
                        Parent = items[ "dropdown_holder" ];
                        Size = dim2(1, 0, 1, 0);
                        ClipsDescendants = true;
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(33, 33, 35);
                        ZIndex = 10;
                        CanvasSize = dim2(0, 0, 0, 0);
                        AutomaticCanvasSize = Enum.AutomaticSize.Y;
                        ScrollBarThickness = 0;
                        Visible = false;
                        ScrollBarImageColor3 = themes.preset.accent;
                        ScrollBarImageTransparency = 0.2;
                        ScrollingDirection = Enum.ScrollingDirection.Y;
                        ElasticBehavior = Enum.ElasticBehavior.Never;
                        VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar;
                    });

                    library:create( "UIPadding" , {
                        PaddingBottom = dim(0, 6);
                        PaddingTop = dim(0, 3);
                        PaddingLeft = dim(0, 3);
                        Parent = items[ "outline" ]
                    });

                    items[ "outline_layout" ] = library:create( "UIListLayout" , {
                        Parent = items[ "outline" ];
                        Padding = dim(0, 5);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "outline" ];
                        CornerRadius = dim(0, 4)
                    });
            end

            function cfg.max_height()
                local top = items[ "dropdown" ].AbsolutePosition.Y + 80
                local viewport = camera and camera.ViewportSize

                if not viewport then return 220 end

                return math.clamp(viewport.Y - top - 24, 160, 460)
            end

            function cfg.measure()
                local count = #cfg.option_instances

                if count == 0 then
                    cfg.y_size, cfg.overflow, cfg.x_size = 0, false, nil
                    cfg.measured = false

                    return
                end

                if not cfg.measured then
                    local layout = items[ "outline_layout" ]
                    local content = layout and layout.AbsoluteContentSize.Y or 0
                    local settled = content > 0

                    if not settled then
                        content = (count - 1) * 5

                        for _, option in cfg.option_instances do
                            content += option.AbsoluteSize.Y > 0 and option.AbsoluteSize.Y or 19
                        end
                    end

                    cfg.y_size = content + 9

                    local widest = 0
                    local guessed = false

                    for _, option in cfg.option_instances do
                        local bounds = option.TextBounds.X

                        if bounds <= 0 then
                            bounds = #option.Text * option.TextSize * 0.55
                            guessed = true
                        end

                        if bounds > widest then widest = bounds end
                    end

                    cfg.widest = widest

                    cfg.measured = settled and not guessed
                end

                cfg.overflow = cfg.y_size > cfg.max_height()

                cfg.x_size = math.ceil((cfg.widest or 0) + 25 + (cfg.overflow and 6 or 0))
            end

            function cfg.render_option(text)
                local button = library:create( "TextButton" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(72, 72, 73);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = text;
                    Parent = items[ "outline" ];
                    Name = "\0";
                    Size = dim2(1, -12, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255);
                    ZIndex = 10;
                }); library:apply_theme(button, "accent", "TextColor3");

                library:create( "UIPadding" , {
                    Parent = button;
                    PaddingTop = dim(0, 1);
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });

                return button
            end

             function cfg.changetext(text)
                 items[ "name" ].Text = text
             end

            function cfg.set_visible(bool)
                if bool then cfg.measure() end

                if items[ "indicator" ] then
                    library:tween(items[ "indicator" ], {Rotation = bool and 90 or 0})
                end

                local a = bool and math.min(cfg.y_size, cfg.max_height()) or 0
                local holder = items[ "dropdown_holder" ]
                local outline = items[ "outline" ]

                cfg._visible_token = (cfg._visible_token or 0) + 1

                local token = cfg._visible_token

                if bool then
                    holder.Visible = true

                    if outline then
                        outline.Visible = true
                        outline.ScrollBarThickness = cfg.overflow and 6 or 0
                    end
                elseif outline then
                    outline.ScrollBarThickness = 0
                    outline.ScrollingEnabled = false
                    outline.Visible = false
                end

                local anchor = items[ "dropdown" ]
                local base = anchor.AbsoluteSize.X
                local viewport = camera and camera.ViewportSize
                local width = base
                local x = anchor.AbsolutePosition.X

                if bool then
                    width = math.max(base, cfg.x_size or base)

                    if viewport then
                        width = math.min(width, math.max(base, viewport.X - 16))

                        if x + width > viewport.X - 8 then
                            x = math.max(8, viewport.X - 8 - width)
                        end
                    end
                end

                library:tween(holder, {Size = dim_offset(width, a)})

                holder.Position = dim2(0, x, 0, anchor.AbsolutePosition.Y + 80)

                if bool and outline then
                    outline.ScrollingEnabled = cfg.overflow
                end

                if not bool then
                    holder.Visible = false
                end

                if not (self.sanity and library.current_open == self) then
                    library:close_element(cfg)
                end
            end

            function cfg.set(value)
                local selected = {}
                local isTable = type(value) == "table"

                for _, option in cfg.option_instances do
                    if option.Text == value or (isTable and find(value, option.Text)) then
                        insert(selected, option.Text)
                        cfg.multi_items = selected
                        option.TextColor3 = themes.preset.accent
                    else
                        option.TextColor3 = rgb(72, 72, 73)
                    end
                end

                items[ "sub_text" ].Text = isTable and concat(selected, ", ") or selected[1] or ""
                flags[cfg.flag] = isTable and selected or selected[1]

                cfg.callback(flags[cfg.flag])
                keep_identity()
            end

            function cfg.refresh_options(list)
                cfg.y_size = 0
                cfg.measured = false

                for _, option in cfg.option_instances do
                    option:Destroy()
                end

                cfg.option_instances = {}

                for _, option in list do
                    local button = cfg.render_option(option)
                    insert(cfg.option_instances, button)

                    library:on_tap(button, LPH_NO_VIRTUALIZE(function(Input)
                        if cfg.multi then
                            local selected_index = find(cfg.multi_items, button.Text)

                            if selected_index then
                                remove(cfg.multi_items, selected_index)
                            else
                                insert(cfg.multi_items, button.Text)
                            end

                            cfg.set(cfg.multi_items)
                        else
                            cfg.set_visible(false)
                            cfg.open = false

                            cfg.set(button.Text)
                        end
                    end))
                end
            end

            library:guard_overlay(cfg, items[ "dropdown_holder" ], items[ "dropdown" ])

            library:on_tap(items[ "dropdown" ], LPH_NO_VIRTUALIZE(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.Touch then
                    cfg.open = not cfg.open
                    cfg.set_visible(cfg.open)
                end
            end))

            if cfg.seperator then
                library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = self.items[ "elements" ];
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 1, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(36, 36, 37)
                });
            end

            flags[cfg.flag] = {}
            config_flags[cfg.flag] = cfg.set

            cfg.refresh_options(cfg.options)
            cfg.set(cfg.default)

            library:on_theme(function()
                local current = flags[cfg.flag]
                local idle = library:theme_text(0.29)

                for _, option in cfg.option_instances do
                    if option.Parent then
                        local chosen

                        if cfg.multi then
                            chosen = find(cfg.multi_items, option.Text) ~= nil
                        else
                            chosen = option.Text == current
                        end

                        option.TextColor3 = chosen and themes.preset.accent or idle
                    end
                end
            end)

            return setmetatable(cfg, library)
        end

        function library:label(options)
            local cfg = {
                enabled = options.enabled or nil,
                name = options.name or "Toggle",
                wrapped = options.wrapped or false,
                seperator = options.seperator or options.Seperator or false;
                info = options.info or nil;

                items = {};
            }

            local items = cfg.items; do
                items[ "label" ] = library:create( "TextButton" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    Parent = self.items[ "elements" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                items[ "name" ] = library:create( "TextLabel" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(245, 245, 245);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    TextWrapped = cfg.wrapped,
                    Parent = items[ "label" ];
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 16;
                    RichText = true,
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                if cfg.info then
                    items[ "info" ] = library:create( "TextLabel" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(130, 130, 130);
                        BorderColor3 = rgb(0, 0, 0);
                        TextWrapped = true;
                        Text = cfg.info;
                        Parent = items[ "label" ];
                        Name = "\0";
                        Position = dim2(0, 5, 0, 17);
                        Size = dim2(1, -10, 0, 0);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 16;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                end

                library:create( "UIPadding" , {
                    Parent = items[ "name" ];
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });

                items[ "right_components" ] = library:create( "Frame" , {
                    Parent = items[ "label" ];
                    Name = "\0";
                    Position = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 0, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library:create( "UIListLayout" , {
                    FillDirection = Enum.FillDirection.Horizontal;
                    HorizontalAlignment = Enum.HorizontalAlignment.Right;
                    Parent = items[ "right_components" ];
                    Padding = dim(0, 9);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });
            end

            if cfg.seperator then
                library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = self.items[ "elements" ];
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 1, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(36, 36, 37)
                });
            end
            function cfg.set(text)
                cfg.items[ "name" ].Text = text
            end

            return setmetatable(cfg, library)
        end

        function library:colorpicker(options)
            local cfg = {
                name = options.name or "Color",
                flag = options.flag or library:next_flag(),

                color = options.color or color(1, 1, 1),
                alpha = options.alpha and 1 - options.alpha or 0,

                no_alpha = options.no_alpha or false,

                open = false,
                callback = options.callback or function() end,
                items = {};

                seperator = options.seperator or options.Seperator or false;
            }

            local dragging_sat = false
            local dragging_hue = false
            local dragging_alpha = false

            local h, s, v = cfg.color:ToHSV()
            local a = cfg.alpha

            flags[cfg.flag] = {Color = cfg.color, Transparency = cfg.alpha}

            local label;
            if not self.items.right_components then
                label = self:label({name = cfg.name, seperator = cfg.seperator})
            end

            local items = cfg.items; do
                    items[ "colorpicker" ] = library:create( "TextButton" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        AutoButtonColor = false;
                        AnchorPoint = vec2(1, 0);
                        Parent = label and label.items.right_components or self.items[ "right_components" ];
                        Name = "\0";
                        Position = dim2(1, 0, 0, 0);
                        Size = dim2(0, 16, 0, 16);
                        BorderSizePixel = 0;
                        TextSize = 14;
                        BackgroundColor3 = rgb(54, 31, 184)
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "colorpicker" ];
                        CornerRadius = dim(0, 4)
                    });

                    items[ "colorpicker_inline" ] = library:create( "Frame" , {
                        Parent = items[ "colorpicker" ];
                        Size = dim2(1, -2, 1, -2);
                        Name = "\0";
                        BorderMode = Enum.BorderMode.Inset;
                        BorderColor3 = rgb(0, 0, 0);
                        Position = dim2(0, 1, 0, 1);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(54, 31, 184)
                    });

                                    library:create( "UIScale" , {
                    Parent = items[ "colorpicker_inline" ];
                    Scale = scale;
                });

                    library:create( "UICorner" , {
                        Parent = items[ "colorpicker_inline" ];
                        CornerRadius = dim(0, 4)
                    });

                    library:create( "UIGradient" , {
                        Color = rgbseq{rgbkey(0, rgb(211, 211, 211)), rgbkey(1, rgb(211, 211, 211))};
                        Parent = items[ "colorpicker_inline" ]
                    });

                    items[ "colorpicker_holder" ] = library:create( "Frame" , {
                        Parent = library[ "other" ];
                        Name = "\0";
                        Position = dim2(0.20000000298023224, 20, 0.296999990940094, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 166, 0, 197);
                        BorderSizePixel = 0;
                        Visible = true;

                        Active = true;

                        BackgroundColor3 = rgb(25, 25, 29)
                    });

                    items[ "colorpicker_fade" ] = library:create( "Frame" , {
                        Parent = items[ "colorpicker_holder" ];
                        Name = "\0";
                        BackgroundTransparency = 0;
                        Position = dim2(0, 0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        ZIndex = 100;
                        BackgroundColor3 = rgb(25, 25, 29)
                    });

                    items[ "colorpicker_components" ] = library:create( "Frame" , {
                        Parent = items[ "colorpicker_holder" ];
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(22, 22, 24)
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "colorpicker_components" ];
                        CornerRadius = dim(0, 6)
                    });

                    items[ "saturation_holder" ] = library:create( "Frame" , {
                        Parent = items[ "colorpicker_components" ];
                        Name = "\0";
                        Position = dim2(0, 7, 0, 7);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -14, 1, -80);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 39, 39)
                    });

                    items[ "sat" ] = library:create( "TextButton" , {
                        Parent = items[ "saturation_holder" ];
                        Name = "\0";
                        Size = dim2(1, 0, 1, 0);
                        Text = "";
                        AutoButtonColor = false;
                        BorderColor3 = rgb(0, 0, 0);
                        ZIndex = 2;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "sat" ];
                        CornerRadius = dim(0, 4)
                    });

                    library:create( "UIGradient" , {
                        Rotation = 270;
                        Transparency = numseq{numkey(0, 0), numkey(1, 1)};
                        Parent = items[ "sat" ];
                        Color = rgbseq{rgbkey(0, rgb(0, 0, 0)), rgbkey(1, rgb(0, 0, 0))}
                    });

                    items[ "val" ] = library:create( "Frame" , {
                        Name = "\0";
                        Parent = items[ "saturation_holder" ];
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    library:create( "UIGradient" , {
                        Parent = items[ "val" ];
                        Transparency = numseq{numkey(0, 0), numkey(1, 1)}
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "val" ];
                        CornerRadius = dim(0, 4)
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "saturation_holder" ];
                        CornerRadius = dim(0, 4)
                    });

                    items[ "satvalpicker" ] = library:create( "TextButton" , {
                        BorderColor3 = rgb(0, 0, 0);
                        AutoButtonColor = false;
                        Text = "";
                        AnchorPoint = vec2(0, 1);
                        Parent = items[ "saturation_holder" ];
                        Name = "\0";
                        Position = dim2(0, 0, 4, 0);
                        Size = dim2(0, 8, 0, 8);
                        ZIndex = 5;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 0, 0)
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "satvalpicker" ];
                        CornerRadius = dim(0, 9999)
                    });

                    library:create( "UIStroke" , {
                        Color = rgb(255, 255, 255);
                        Parent = items[ "satvalpicker" ];
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    });

                    items[ "hue_gradient" ] = library:create( "TextButton" , {
                        Parent = items[ "colorpicker_components" ];
                        Name = "\0";
                        Position = dim2(0, 10, 1, -64);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -20, 0, 8);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255);
                        AutoButtonColor = false;
                        Text = "";
                    });

                    library:create( "UIGradient" , {
                        Color = rgbseq{rgbkey(0, rgb(255, 0, 0)), rgbkey(0.17, rgb(255, 255, 0)), rgbkey(0.33, rgb(0, 255, 0)), rgbkey(0.5, rgb(0, 255, 255)), rgbkey(0.67, rgb(0, 0, 255)), rgbkey(0.83, rgb(255, 0, 255)), rgbkey(1, rgb(255, 0, 0))};
                        Parent = items[ "hue_gradient" ]
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "hue_gradient" ];
                        CornerRadius = dim(0, 6)
                    });

                    items[ "hue_picker" ] = library:create( "TextButton" , {
                        BorderColor3 = rgb(0, 0, 0);
                        AutoButtonColor = false;
                        Text = "";
                        AnchorPoint = vec2(0, 0.5);
                        Parent = items[ "hue_gradient" ];
                        Name = "\0";
                        Position = dim2(0, 0, 0.5, 0);
                        Size = dim2(0, 8, 0, 8);
                        ZIndex = 5;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 0, 0)
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "hue_picker" ];
                        CornerRadius = dim(0, 9999)
                    });

                    library:create( "UIStroke" , {
                        Color = rgb(255, 255, 255);
                        Parent = items[ "hue_picker" ];
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    });

                    items[ "alpha_gradient" ] = library:create( "TextButton" , {
                        Parent = items[ "colorpicker_components" ];
                        Name = "\0";
                        Position = dim2(0, 10, 1, -46);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -20, 0, 8);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(25, 25, 29);
                        AutoButtonColor = false;
                        Text = "";
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "alpha_gradient" ];
                        CornerRadius = dim(0, 6)
                    });

                    items[ "alpha_picker" ] = library:create( "TextButton" , {
                        BorderColor3 = rgb(0, 0, 0);
                        AutoButtonColor = false;
                        Text = "";
                        AnchorPoint = vec2(0, 0.5);
                        Parent = items[ "alpha_gradient" ];
                        Name = "\0";
                        Position = dim2(1, 0, 0.5, 0);
                        Size = dim2(0, 8, 0, 8);
                        ZIndex = 5;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 0, 0)
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "alpha_picker" ];
                        CornerRadius = dim(0, 9999)
                    });

                    library:create( "UIStroke" , {
                        Color = rgb(255, 255, 255);
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                        Parent = items[ "alpha_picker" ]
                    });

                    library:create( "UIGradient" , {
                        Color = rgbseq{rgbkey(0, rgb(0, 0, 0)), rgbkey(1, rgb(255, 255, 255))};
                        Parent = items[ "alpha_gradient" ]
                    });

                    items[ "alpha_indicator" ] = library:create( "ImageLabel" , {
                        ScaleType = Enum.ScaleType.Tile;
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = items[ "alpha_gradient" ];
                        Image = "rbxassetid://18274452449";
                        BackgroundTransparency = 1;
                        Name = "\0";
                        Size = dim2(1, 0, 1, 0);
                        TileSize = dim2(0, 6, 0, 6);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });

                    library:create( "UIGradient" , {
                        Color = rgbseq{rgbkey(0, rgb(112, 112, 112)), rgbkey(1, rgb(255, 0, 0))};
                        Transparency = numseq{numkey(0, 0.8062499761581421), numkey(1, 0)};
                        Parent = items[ "alpha_indicator" ]
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "alpha_indicator" ];
                        CornerRadius = dim(0, 6)
                    });

                    library:create( "UIGradient" , {
                        Rotation = 90;
                        Parent = items[ "colorpicker_components" ];
                        Color = rgbseq{rgbkey(0, rgb(255, 255, 255)), rgbkey(1, rgb(66, 66, 66))}
                    });

                    items[ "input" ] = library:create( "TextBox" , {
                        FontFace = fonts.font;
                        AnchorPoint = vec2(1, 1);
                        Text = "";
                        Parent = items[ "colorpicker_components" ];
                        Name = "\0";
                        TextTruncate = Enum.TextTruncate.AtEnd;
                        BorderSizePixel = 0;
                        PlaceholderColor3 = rgb(255, 255, 255);
                        CursorPosition = -1;
                        ClearTextOnFocus = false;
                        TextSize = 14;
                        BackgroundColor3 = rgb(255, 255, 255);
                        TextColor3 = rgb(72, 72, 72);
                        BorderColor3 = rgb(0, 0, 0);
                        Position = dim2(1, -8, 1, -11);
                        Size = dim2(1, -16, 0, 18);
                        BackgroundColor3 = rgb(33, 33, 35)
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "input" ];
                        CornerRadius = dim(0, 3)
                    });

                    items[ "UICorenr" ] = library:create( "UICorner" , {
                        Parent = items[ "colorpicker_holder" ];
                        Name = "\0";
                        CornerRadius = dim(0, 4)
                    });
            end;

            for _, object in items[ "colorpicker_holder" ]:GetDescendants() do
                if object:IsA("GuiObject") then
                    object.ZIndex += 200
                end
            end

            items[ "colorpicker_holder" ].ZIndex += 200

            function cfg.set_visible(bool)
                items[ "colorpicker_fade" ].BackgroundTransparency = 0
                items[ "colorpicker_holder" ].Parent = bool and library[ "items" ] or library[ "other" ]
                items[ "colorpicker_holder" ].Position = dim_offset(items[ "colorpicker" ].AbsolutePosition.X, items[ "colorpicker" ].AbsolutePosition.Y + items[ "colorpicker" ].AbsoluteSize.Y + 45)

                library:tween(items[ "colorpicker_fade" ], {BackgroundTransparency = 1}, Enum.EasingStyle.Quad, 0.4)
                library:tween(items[ "colorpicker_holder" ], {Position = items[ "colorpicker_holder" ].Position + dim_offset(0, 20)})

                if not (self.sanity and library.current_open == self and self.open) then
                    library:close_element(cfg)
                end
            end

            function cfg.set(color, alpha)
                if type(color) == "boolean" then
                    return
                end

                if color then
                    h, s, v = color:ToHSV()
                end

                if alpha then
                    a = alpha
                end

                local Color = hsv(h, s, v)

                library:tween(items[ "hue_picker" ], {Position = dim2(0, (items[ "hue_gradient" ].AbsoluteSize.X - items[ "hue_picker" ].AbsoluteSize.X) * h, 0.5, 0)}, Enum.EasingStyle.Linear, 0.05)
                library:tween(items[ "alpha_picker" ], {Position = dim2(0, (items[ "alpha_gradient" ].AbsoluteSize.X - items[ "alpha_picker" ].AbsoluteSize.X) * (1 - a), 0.5, 0)}, Enum.EasingStyle.Linear, 0.05)
                library:tween(items[ "satvalpicker" ], {Position = dim2(0, s * (items[ "saturation_holder" ].AbsoluteSize.X - items[ "satvalpicker" ].AbsoluteSize.X), 1, 1 - v * (items[ "saturation_holder" ].AbsoluteSize.Y - items[ "satvalpicker" ].AbsoluteSize.Y))}, Enum.EasingStyle.Linear, 0.05)

                child_of_class(items[ "alpha_indicator" ], "UIGradient").Color = rgbseq{rgbkey(0, rgb(112, 112, 112)), rgbkey(1, hsv(h, 1, 1))};

                items[ "colorpicker" ].BackgroundColor3 = Color
                items[ "colorpicker_inline" ].BackgroundColor3 = Color
                items[ "saturation_holder" ].BackgroundColor3 = hsv(h, 1, 1)

                items[ "hue_picker" ].BackgroundColor3 = hsv(h, 1, 1)
                items[ "alpha_picker" ].BackgroundColor3 = hsv(h, 1, 1 - a)
                items[ "satvalpicker" ].BackgroundColor3 = hsv(h, s, v)

                flags[cfg.flag] = {
                    Color = Color;
                    Transparency = a
                }

                local color = items[ "colorpicker" ].BackgroundColor3
                items[ "input" ].Text = string.format("%s, %s, %s, ", library:round(color.R * 255), library:round(color.G * 255), library:round(color.B * 255))
                items[ "input" ].Text ..= library:round(1 - a, 0.01)

                cfg.callback(Color, a)
                keep_identity()
            end

            function cfg.update_color()
                local offset = vec2(Mouse.X, Mouse.Y - gui_offset)

                if dragging_sat then
                    s = math.clamp((offset - items["sat"].AbsolutePosition).X / items["sat"].AbsoluteSize.X, 0, 1)
                    v = 1 - math.clamp((offset - items["sat"].AbsolutePosition).Y / items["sat"].AbsoluteSize.Y, 0, 1)
                elseif dragging_hue then
                    h = math.clamp((offset - items[ "hue_gradient" ].AbsolutePosition).X / items[ "hue_gradient" ].AbsoluteSize.X, 0, 1)
                elseif dragging_alpha then
                    a = 1 - math.clamp((offset - items[ "alpha_gradient" ].AbsolutePosition).X / items[ "alpha_gradient" ].AbsoluteSize.X, 0, 1)
                end

                cfg.set()
            end

            library:guard_overlay(cfg, items[ "colorpicker_holder" ], items[ "colorpicker" ])

            library:on_tap(items[ "colorpicker" ], LPH_NO_VIRTUALIZE(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.Touch then
                    cfg.open = not cfg.open

                    cfg.set_visible(cfg.open)
                end
            end))

            uis.InputChanged:Connect(LPH_NO_VIRTUALIZE(function(input)
                if (dragging_sat or dragging_hue or dragging_alpha) and input.UserInputType == Enum.UserInputType.Touch then
                    cfg.update_color()
                end
            end))

            library:connection(uis.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    dragging_sat = false
                    dragging_hue = false
                    dragging_alpha = false
                end
            end)

            items[ "alpha_gradient" ].InputBegan:Connect(LPH_NO_VIRTUALIZE(function(Input)
                            if Input.UserInputType ~= Enum.UserInputType.Touch then return end
                dragging_alpha = true
            end))

            items[ "hue_gradient" ].InputBegan:Connect(LPH_NO_VIRTUALIZE(function(Input)
                            if Input.UserInputType ~= Enum.UserInputType.Touch then return end
                dragging_hue = true
            end))

            items[ "sat" ].InputBegan:Connect(LPH_NO_VIRTUALIZE(function(Input)
                            if Input.UserInputType ~= Enum.UserInputType.Touch then return end
                dragging_sat = true
            end))

            items[ "input" ].FocusLost:Connect(LPH_NO_VIRTUALIZE(function()
                local text = items[ "input" ].Text
                local r, g, b, a = library:convert(text)

                if r and g and b and a then
                    cfg.set(rgb(r, g, b), 1 - a)
                end
            end))

            items[ "input" ].Focused:Connect(LPH_NO_VIRTUALIZE(function()
                library:tween(items[ "input" ], {TextColor3 = rgb(245, 245, 245)})
            end))

            items[ "input" ].FocusLost:Connect(LPH_NO_VIRTUALIZE(function()
                library:tween(items[ "input" ], {TextColor3 = rgb(72, 72, 72)})
            end))

            if cfg.no_alpha then
                items[ "alpha_gradient" ].Visible = false
                items[ "colorpicker_holder" ].Size = dim2(0, 166, 0, 179)
                cfg.alpha = 0
            end

            cfg.set(cfg.color, cfg.alpha)
            config_flags[cfg.flag] = cfg.set

            return setmetatable(cfg, library)
        end

        function library:textbox(options)
            local cfg = {
                name = options.name or "TextBox",
                placeholder = options.placeholder or options.placeholdertext or options.holder or options.holdertext or "type here...",
                default = options.default or "",
                flag = options.flag or library:next_flag(),
                callback = options.callback or function() end,
                visible = options.visible or true,

                tall = options.tall or options.Tall or false;
                seperator = options.seperator or options.Seperator or false;

                layout = options.layout or options.LayoutOrder or 0;

                items = {};
            }

            flags[cfg.flag] = cfg.default

            local items = cfg.items; do
                items[ "textbox" ] = library:create( "TextButton" , {
                    LayoutOrder = cfg.layout;
                    FontFace = fonts.font;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    Parent = self.items[ "elements" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                items[ "name" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(245, 245, 245);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = items[ "textbox" ];
                    Name = "\0";
                    Position = dim2(0, 5, 0, 0);
                    Size = dim2(1, -10, 0, cfg.tall and 19 or 15);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    TextTruncate = Enum.TextTruncate.AtEnd;
                    BorderSizePixel = 0;
                    TextSize = cfg.tall and 16 or 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                items[ "input" ] = library:create( "TextBox" , {
                    FontFace = fonts.font;
                    Text = "";
                    PlaceholderText = cfg.placeholder;
                    Parent = items[ "textbox" ];
                    Name = "\0";
                    TextTruncate = Enum.TextTruncate.AtEnd;
                    BorderSizePixel = 0;
                    PlaceholderColor3 = rgb(110, 110, 110);
                    CursorPosition = -1;
                    ClearTextOnFocus = false;
                    TextSize = 14;
                    TextColor3 = rgb(72, 72, 72);
                    BorderColor3 = rgb(0, 0, 0);
                    AnchorPoint = vec2(0, 0);
                    Position = dim2(0, 0, 0, cfg.tall and 21 or 16);
                    Size = dim2(1, 0, 0, cfg.tall and 28 or 20);
                    BackgroundColor3 = rgb(33, 33, 35)
                });

                library:create( "UICorner" , {
                    Parent = items[ "input" ];
                    CornerRadius = dim(0, 3)
                });

                library:create( "UIPadding" , {
                    Parent = items[ "input" ];
                    PaddingRight = dim(0, 6);
                    PaddingLeft = dim(0, 6)
                });
            end

            if cfg.seperator then
                library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = self.items[ "elements" ];
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 1, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(36, 36, 37)
                });
            end

            function cfg.set(text)
                flags[cfg.flag] = text

                items[ "input" ].Text = text

                cfg.callback(text)
                keep_identity()
            end

            items[ "input" ]:GetPropertyChangedSignal("Text"):Connect(LPH_NO_VIRTUALIZE(function()
                cfg.set(items[ "input" ].Text)
            end))

            items[ "input" ].Focused:Connect(LPH_NO_VIRTUALIZE(function()
                library:tween(items[ "input" ], {TextColor3 = rgb(245, 245, 245)})
            end))

            items[ "input" ].FocusLost:Connect(LPH_NO_VIRTUALIZE(function()
                library:tween(items[ "input" ], {TextColor3 = rgb(72, 72, 72)})
            end))

            if cfg.default then
                cfg.set(cfg.default)
            end

            config_flags[cfg.flag] = cfg.set

            return setmetatable(cfg, library)
        end

        function library:keybind(options)
            local cfg = {
                flag = options.flag or library:next_flag(),
                callback = options.callback or function() end,
                name = options.name or nil,
                ignore_key = options.ignore or false,
                seperator = options.seperator or false,

                key = options.key or "NONE",
                mode = options.mode or "Always",
                active = options.default or false,
                owner = options.owner or nil,
                attach = options.attach or nil,

                open = false,
                binding = nil,

                hold_instances = {},
                items = {};
            }

            flags[cfg.flag] = {
                mode = cfg.mode,
                key = cfg.key,
                active = cfg.active
            }

            local items = cfg.items; do
                    items[ "keybind_element" ] = library:create( "TextButton" , {
                        FontFace = fonts.font;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        Parent = (cfg.attach and cfg.attach.items and cfg.attach.items[ "toggle" ]) or self.items[ "elements" ];
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Size = dim2(1, 0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.Y;
                        TextSize = 14;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    if cfg.attach then
                        cfg.attach.bound_key = cfg

                        items[ "keybind_element" ].AnchorPoint = vec2(1, 0.5)
                        items[ "keybind_element" ].Position = dim2(1, -46, 0.5, 0)
                        items[ "keybind_element" ].AutomaticSize = Enum.AutomaticSize.None
                        items[ "keybind_element" ].Size = dim2(0, 46, 0, 18)
                    end

                    items[ "name" ] = library:create( "TextLabel" , {
                        FontFace = fonts.font;
                        TextColor3 = rgb(245, 245, 245);
                        BorderColor3 = rgb(0, 0, 0);
                        Visible = not cfg.attach;
                        Text = cfg.name;
                        Parent = items[ "keybind_element" ];
                        Name = "\0";
                        Size = dim2(1, 0, 0, 0);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 16;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    library:create( "UIPadding" , {
                        Parent = items[ "name" ];
                        PaddingRight = dim(0, 5);
                        PaddingLeft = dim(0, 5)
                    });

                    items[ "right_components" ] = library:create( "Frame" , {
                        Parent = items[ "keybind_element" ];
                        Name = "\0";
                        Position = dim2(1, 0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    library:create( "UIListLayout" , {
                        FillDirection = Enum.FillDirection.Horizontal;
                        HorizontalAlignment = Enum.HorizontalAlignment.Right;
                        Parent = items[ "right_components" ];
                        Padding = dim(0, 7);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });

                    items[ "keybind_holder" ] = library:create( "TextButton" , {
                        FontFace = fonts.font;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        Parent = items[ "right_components" ];
                        AutoButtonColor = false;
                        AnchorPoint = vec2(1, 0);
                        Size = dim2(0, 0, 0, 16);
                        Name = "\0";
                        Position = dim2(1, 0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.X;
                        TextSize = 14;
                        BackgroundColor3 = rgb(33, 33, 35)
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "keybind_holder" ];
                        CornerRadius = dim(0, 4)
                    });

                    items[ "key" ] = library:create( "TextLabel" , {
                        FontFace = fonts.font;
                        TextColor3 = rgb(86, 86, 87);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "LSHIFT";
                        Parent = items[ "keybind_holder" ];
                        Name = "\0";
                        Size = dim2(1, -12, 0, 0);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 14;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    library:create( "UIPadding" , {
                        Parent = items[ "key" ];
                        PaddingTop = dim(0, 1);
                        PaddingRight = dim(0, 5);
                        PaddingLeft = dim(0, 5)
                    });

                    items[ "dropdown" ] = library:create( "Frame" , {
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = library.items;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Visible = false;
                        Position = dim2(0, 0, 0, 0);
                        Size = dim2(0, 0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.X;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });

                    items[ "inline" ] = library:create( "Frame" , {
                        Parent = items[ "dropdown" ];
                        Size = dim2(1, 0, 1, 0);
                        Name = "\0";
                        ClipsDescendants = true;
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(22, 22, 24)
                    });

                    library:create( "UIPadding" , {
                        PaddingBottom = dim(0, 6);
                        PaddingTop = dim(0, 3);
                        PaddingLeft = dim(0, 3);
                        Parent = items[ "inline" ]
                    });

                    library:create( "UIListLayout" , {
                        Parent = items[ "inline" ];
                        Padding = dim(0, 5);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });

                    library:create( "UICorner" , {
                        Parent = items[ "inline" ];
                        CornerRadius = dim(0, 4)
                    });

                    local options = {"Hold", "Toggle", "Always"}

                    cfg.y_size = 20
                    for _, option in options do
                        local name = library:create( "TextButton" , {
                            FontFace = fonts.font;
                            BorderColor3 = rgb(0, 0, 0);
                            Text = option;
                            Parent = items[ "inline" ];
                            Name = "\0";
                            Size = dim2(0, 0, 0, 0);
                            BackgroundTransparency = 1;
                            TextXAlignment = Enum.TextXAlignment.Left;
                            BorderSizePixel = 0;
                            AutomaticSize = Enum.AutomaticSize.XY;
                            TextSize = 14;
                            BackgroundColor3 = rgb(255, 255, 255)
                        }); cfg.hold_instances[option] = name

                        cfg.y_size += name.AbsoluteSize.Y

                        library:create( "UIPadding" , {
                            Parent = name;
                            PaddingTop = dim(0, 1);
                            PaddingRight = dim(0, 5);
                            PaddingLeft = dim(0, 5)
                        });

                        library:on_tap(name, LPH_NO_VIRTUALIZE(function(input)
                            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.Touch then
                                cfg.set(option)
                                cfg.set_visible(false)
                                cfg.open = false
                            end
                        end))
                    end
            end

            if cfg.seperator then
                library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = self.items[ "elements" ];
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 1, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(36, 36, 37)
                });
            end

            function cfg.modify_mode_color(path)
                for _, v in cfg.hold_instances do
                    v.TextColor3 = themes.preset.inactive or rgb(72, 72, 72)
                end

                local selected = cfg.hold_instances[path] or cfg.hold_instances["Always"]

                if selected then
                    selected.TextColor3 = themes.preset.accent
                end
            end

            if library.on_theme then
                library:on_theme(function()
                    cfg.modify_mode_color(cfg.mode)
                end)
            end

            library.accent_refreshers = library.accent_refreshers or {}

            insert(library.accent_refreshers, function()
                cfg.modify_mode_color(cfg.mode)
            end)

            function cfg.set_mode(mode)
                cfg.mode = mode

                if mode == "Always" then
                    cfg.set(true)
                elseif mode == "Hold" then
                    cfg.set(false)
                end

                local stored = flags[cfg.flag]

                if type(stored) == "table" then
                    stored.mode = mode
                end

                cfg.modify_mode_color(mode)
            end

            function cfg.set(input)
                if type(input) == "boolean" then
                    cfg.active = input

                    if cfg.mode == "Always" then
                        cfg.active = true
                    end
                elseif tostring(input):find("Enum") then
                    input = input.Name == "Escape" and "NONE" or input

                    cfg.key = input or "NONE"
                elseif find({"Toggle", "Hold", "Always"}, input) then
                    if input == "Always" then
                        cfg.active = true
                    end

                    cfg.mode = input
                    cfg.set_mode(cfg.mode)
                elseif type(input) == "table" then
                    input.key = type(input.key) == "string" and input.key ~= "NONE" and library:convert_enum(input.key) or input.key
                    input.key = input.key == Enum.KeyCode.Escape and "NONE" or input.key

                    cfg.key = input.key or "NONE"
                    cfg.mode = input.mode or cfg.mode or "Always"
                    cfg.active = input.active == true

                    cfg.set_mode(cfg.mode)
                end

                if cfg.attach then
                    cfg.apply_owner()
                else
                    cfg.callback(cfg.active)
                    keep_identity()
                end

                local text = tostring(cfg.key) ~= "Enums" and (keys[cfg.key] or tostring(cfg.key):gsub("Enum.", "")) or nil
                local __text = text and (tostring(text):gsub("KeyCode.", ""):gsub("UserInputType.", ""))

                items[ "key" ].Text = __text

                flags[cfg.flag] = {
                    mode = cfg.mode,
                    key = cfg.key,
                    active = cfg.active
                }
            end

            function cfg.apply_owner()
                local toggle = cfg.attach

                if not toggle or not toggle.flag then
                    cfg.callback(cfg.active)
                    keep_identity()

                    return
                end

                local armed = toggle.enabled and true or false
                local live = armed and (cfg.mode == "Always" or cfg.active) or false

                cfg.active = live

                if flags[toggle.flag] == live then
                    cfg.callback(live)
                    keep_identity()

                    return
                end

                flags[toggle.flag] = live

                cfg.callback(live)
                keep_identity()

                local owner_callback = toggle.raw_callback or toggle.callback

                if owner_callback then
                    pcall(owner_callback, live)
                end
            end

            function cfg.set_visible(bool)
                local size = bool and cfg.y_size or 0

                if bool then
                    cfg.modify_mode_color(cfg.mode)
                    items[ "dropdown" ].Visible = true
                end

                library:tween(items[ "dropdown" ], {Size = dim_offset(items[ "keybind_holder" ].AbsoluteSize.X, size)})

                items[ "dropdown" ].Position = dim_offset(items[ "keybind_holder" ].AbsolutePosition.X, items[ "keybind_holder" ].AbsolutePosition.Y + items[ "keybind_holder" ].AbsoluteSize.Y + 60)

                if not bool then
                    items[ "dropdown" ].Visible = false
                end
            end

            library:guard_overlay(cfg, items[ "dropdown" ], items[ "keybind_holder" ])

            library:on_tap(items[ "keybind_holder" ], LPH_NO_VIRTUALIZE(function(Input)
                task.wait()
                items[ "key" ].Text = ""

                cfg.binding = library:connection(uis.InputBegan, function(keycode, game_event)
                    cfg.set(keycode.KeyCode ~= Enum.KeyCode.Unknown and keycode.KeyCode or keycode.UserInputType)

                    cfg.binding:Disconnect()
                    cfg.binding = nil
                end)
            end))

            items[ "keybind_holder" ].MouseButton2Down:Connect(LPH_NO_VIRTUALIZE(function()
                cfg.open = not cfg.open

                cfg.set_visible(cfg.open)
            end))

            library:connection(uis.InputBegan, function(input, game_event)
                if not game_event then
                    local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType

                    if selected_key == cfg.key then
                        if cfg.mode == "Toggle" then
                            cfg.active = not cfg.active
                            cfg.set(cfg.active)
                        elseif cfg.mode == "Hold" then
                            cfg.set(true)
                        end
                    end
                end
            end)

            library:connection(uis.InputEnded, function(input, game_event)
                if game_event then
                    return
                end

                local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType

                if selected_key == cfg.key then
                    if cfg.mode == "Hold" then
                        cfg.set(false)
                    end
                end
            end)

            cfg.set({mode = cfg.mode, active = cfg.active, key = cfg.key})
            config_flags[cfg.flag] = cfg.set

            return setmetatable(cfg, library)
        end

        function library:button(options)
            local host, row

            if self.items and self.items[ "elements" ] then
                host = self.items[ "elements" ]
            else
                host = self.host
                row = self.row
            end

            local cfg = {
                name = options.name or "TextBox",
                callback = options.callback or function() end,
                seperator = options.seperator or options.Seperator or false;
                safemode = options.safemode or options.Safemode or false;
                confirm = options.confirm or "are you sure?";
                confirm_time = options.confirm_time or 3;
                host = host;
                items = {};
            }

            local items = cfg.items; do
                if row then
                    items[ "button_element" ] = row
                else
                    items[ "button_element" ] = library:create( "Frame" , {
                        Parent = host;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Size = dim2(1, 0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.Y;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    library:create( "UIListLayout" , {
                        Parent = items[ "button_element" ];
                        FillDirection = Enum.FillDirection.Horizontal;
                        HorizontalFlex = Enum.UIFlexAlignment.Fill;
                        VerticalAlignment = Enum.VerticalAlignment.Center;
                        Padding = dim(0, 6);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });

                    library:create( "UIPadding" , {
                        Parent = items[ "button_element" ];
                        PaddingRight = dim(0, 4);
                        PaddingLeft = dim(0, 4)
                    });
                end

                items[ "button" ] = library:create( "TextButton" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    AutoButtonColor = false;
                    Parent = items[ "button_element" ];
                    Name = "\0";
                    Size = dim2(0, 0, 0, 24);
                    BorderSizePixel = 0;
                    TextSize = 14;
                    BackgroundColor3 = rgb(33, 33, 35)
                });

                library:create( "UICorner" , {
                    Parent = items[ "button" ];
                    CornerRadius = dim(0, 3)
                });

                items[ "name" ] = library:create( "TextLabel" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(245, 245, 245);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = items[ "button" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 1, 0);
                    TextTruncate = Enum.TextTruncate.AtEnd;
                    BorderSizePixel = 0;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); library:apply_theme(items[ "name" ], "accent", "BackgroundColor3");
            end

            cfg.row = items[ "button_element" ]

            if cfg.seperator then
                library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = host;
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 1, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(36, 36, 37)
                });
            end

            cfg.armed = false
            cfg.arm_generation = 0

            function cfg.disarm()
                cfg.armed = false
                cfg.arm_generation = cfg.arm_generation + 1

                items[ "name" ].Text = cfg.name
            end

            function cfg.press()
                items[ "name" ].TextColor3 = themes.preset.accent
                library:tween(items[ "name" ], {TextColor3 = library:theme_text(1)})

                if cfg.safemode then
                    if not cfg.armed then
                        cfg.armed = true
                        cfg.arm_generation = cfg.arm_generation + 1

                        local generation = cfg.arm_generation

                        items[ "name" ].Text = cfg.confirm

                        task.delay(cfg.confirm_time, function()
                            if cfg.arm_generation == generation then
                                cfg.disarm()
                            end
                        end)

                        return
                    end

                    cfg.disarm()
                end

                cfg.callback()
                keep_identity()
            end

            library:on_tap(items[ "button" ], LPH_NO_VIRTUALIZE(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.Touch then
                    cfg.press()
                end
            end))

            return setmetatable(cfg, library)
        end

        function library:settings(options)
            local cfg = {
                open = false;
                items = {};
                sanity = true;
            }

            local items = cfg.items; do
                items[ "outline" ] = library:create( "Frame" , {
                    Name = "\0";
                    Visible = true;
                    Parent = library[ "items" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 0, 0, 0);
                    ClipsDescendants = true;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(25, 25, 29)
                });

                library:create( "UIScale" , {
                    Parent = items[ "outline" ];
                    Scale = scale;
                });

                items[ "inline" ] = library:create( "Frame" , {
                    Parent = items[ "outline" ];
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(22, 22, 24)
                });

                library:create( "UICorner" , {
                    Parent = items[ "inline" ];
                    CornerRadius = dim(0, 7)
                });

                items[ "elements" ] = library:create( "Frame" , {
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = items[ "inline" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 10, 0, 10);
                    Size = dim2(1, -20, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library:create( "UIListLayout" , {
                    Parent = items[ "elements" ];
                    Padding = dim(0, 6);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });


                library:create( "UICorner" , {
                    Parent = items[ "outline" ];
                    CornerRadius = dim(0, 7)
                });

                library:create( "UICorner" , {
                    Parent = items[ "fade" ];
                    CornerRadius = dim(0, 7)
                });

                items[ "tick" ] = library:create( "ImageButton" , {
                    Image = "rbxassetid://128797200442698";
                    Name = "\0";
                    AutoButtonColor = false;
                    Parent = self.items[ "right_components" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 16, 0, 16);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
            end

            function cfg.set_visible(bool)
                library:tween(items[ "outline" ], {Size = dim_offset(bool and 240 or 0, 0)})
                items[ "outline" ].Position = dim_offset(items[ "tick" ].AbsolutePosition.X, items[ "tick" ].AbsolutePosition.Y + 90)
                library:close_element(cfg)
            end

            library:on_tap(items[ "tick" ], LPH_NO_VIRTUALIZE(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.Touch then
                    cfg.open = not cfg.open
                    cfg.set_visible(cfg.open)
                end
            end))

            return setmetatable(cfg, library)
        end

        function library:list(properties)
            local cfg = {
                items = {};
                options = properties.options or {"1", "2", "3"};
                flag = properties.flag or library:next_flag();
                callback = properties.callback or function() end;
                data_store = {};
                current_element;
                labels = {};
            }

            local items = cfg.items; do
                items[ "list" ] = library:create( "Frame" , {
                    Parent = self.items[ "elements" ];
                    BackgroundTransparency = 1;
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library:create( "UIListLayout" , {
                    Parent = items[ "list" ];
                    Padding = dim(0, 10);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });

                library:create( "UIPadding" , {
                    Parent = items[ "list" ];
                    PaddingRight = dim(0, 4);
                    PaddingLeft = dim(0, 4)
                });
            end

            function cfg.refresh_options(options_to_refresh)
                local old_selected_value = flags[cfg.flag]

                cfg.current_element = nil
                cfg.labels = {}

                for _,option in cfg.data_store do
                    option:Destroy()
                end

                cfg.data_store = {}

                for _, option_data in options_to_refresh do
                    local button = library:create( "TextButton" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        AutoButtonColor = false;
                        AnchorPoint = vec2(1, 0);
                        Parent = items[ "list" ];
                        Name = "\0";
                        Position = dim2(1, 0, 0, 0);
                        Size = dim2(1, 0, 0, 30);
                        BorderSizePixel = 0;
                        TextSize = 14;
                        BackgroundColor3 = rgb(33, 33, 35)
                    }); cfg.data_store[#cfg.data_store + 1] = button;

                    local name = library:create( "TextLabel" , {
                        FontFace = fonts.font;
                        TextColor3 = library:theme_text(0.29);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = option_data;
                        Parent = button;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        TextTruncate = Enum.TextTruncate.AtEnd;
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        TextSize = 14;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    library:create( "UICorner" , {
                        Parent = button;
                        CornerRadius = dim(0, 3)
                    });

                    cfg.labels[#cfg.labels + 1] = name

                    if option_data == old_selected_value then
                        library:tween(name, {TextColor3 = library:theme_text(1)})
                        cfg.current_element = name
                    end

                    library:on_tap(button, LPH_NO_VIRTUALIZE(function(input)
                        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.Touch then
                            local current = cfg.current_element

                            if current and current ~= name then
                                library:tween(current, {TextColor3 = library:theme_text(0.29)})
                            end

                            flags[cfg.flag] = option_data
                            cfg.callback(option_data)
                            keep_identity()

                            library:tween(name, {TextColor3 = library:theme_text(1)})

                            cfg.current_element = name
                        end
                    end))

                    name.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
                        if cfg.current_element == name then
                            return
                        end

                        library:tween(name, {TextColor3 = library:theme_text(0.57)})
                    end))

                    name.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
                        if cfg.current_element == name then
                            return
                        end

                        library:tween(name, {TextColor3 = library:theme_text(0.29)})
                    end))
                end
            end

            library:on_theme(function(key)
                if key ~= "text" then return end

                local idle = library:theme_text(0.29)

                for _, label in cfg.labels do
                    if label.Parent then
                        label.TextColor3 = (label == cfg.current_element) and library:theme_text(1) or idle
                    end
                end
            end)

            cfg.refresh_options(cfg.options)

            return setmetatable(cfg, library)
        end

        function library:init_config(window)
            local game_flags = {}

            for key in library.config_flags do
                game_flags[key] = true
            end

            local text;
            window:seperator({name = "settings"})
            local main, menu_page = window:tab({name = "settings", tabs = {"configs", "menu"}})

            local column = main:column({})
            local section = column:section({name = "configs", size = 1, default = true, icon = "rbxassetid://139628202576511"})
            config_holder = section:list({options = {"Report", "This", "Error", "To", "Finobe"}, callback = function(option)
                if text then
                    text.set(option)
                end
            end, flag = "config_name_list"}); library:update_config_list()

            local community = column:section({name = "community configs", size = 1, default = false, icon = "rbxassetid://139628202576511"})
            local community_list = {}

            for name in pairs(COMMUNITY_CONFIG_DATA) do
                community_list[#community_list + 1] = name
            end

            table.sort(community_list)

            community_holder = community:dropdown({
                name = "config list",
                flag = "community_config_name",
                width = 150,
                items = community_list,
                seperator = false,
                multi = false,
                default = community_list[1] or "None"
            })

            community:button({
                name = "load config",
                callback = function()
                    pcall(function()
                        local name = flags["community_config_name"]

                        if type(name) ~= "string" or name == "" then return end

                        local payload = COMMUNITY_CONFIG_DATA[name]

                        if type(payload) ~= "string" or payload == "" then
                            notifications:create_notification({
                                name = "configs",
                                info = "community config missing:\n" .. name
                            })

                            return
                        end

                        local loaded, message = library:import_config(payload)

                        notifications:create_notification({
                            name = "configs",
                            info = loaded and ("loaded community config:\n" .. name)
                                or ("could not load " .. name .. ":\n" .. tostring(message))
                        })
                    end)
                end
            })

            library.notif_style = library.notif_style or {}

            local notif_style = library.notif_style
            local menu_left = menu_page:column({})
            local menu_right = menu_page:column({})
            local menu_section = menu_left:section({name = "menu", size = 1, default = false, icon = GetImage("Settings.png")})
            local server_section = menu_left:section({name = "server", size = 1, default = false, icon = GetImage("Settings.png")})
            local notif_section = menu_right:section({name = "notifications", size = 1, default = false, icon = GetImage("Settings.png")})
            notif_section:dropdown({name = "position", flag = "notif_position", width = 100, items = {"Center", "Top Center", "Top Left", "Top Right", "Bottom Left", "Bottom Right", "Custom"}, multi = false, default = "Center", callback = function(state)
                library.notif_position = state
                library.notifications:refresh_notifs()
            end})

            local function notif_set(key, value)
                notif_style[key] = value
                notifications:refresh_notifs()
            end

            notif_section:toggle({type = "toggle", name = "clip descendants", flag = "notif_clip", default = true, callback = function(state)
                notif_set("clip", state)
            end})

            notif_section:slider({name = "clip past distance", flag = "notif_clip_distance", min = 100, max = 1000, default = 200, suffix = "px", seperator = true, callback = function(value)
                notif_set("clip_distance", value)
            end})

            local notif_force = notif_section:toggle({type = "toggle", name = "force color", flag = "notif_force_color", default = false, callback = function(state)
                notif_style.force = state
            end})

            local notif_pickers = {}
            local notif_defaults = {main = rgb(14, 14, 16), accent = themes.preset.accent, outline = rgb(23, 23, 29), font = rgb(255, 255, 255)}

            for _, key in ipairs({"main", "accent", "outline", "font"}) do
                notif_style[key] = notif_defaults[key]
                notif_pickers[key] = notif_force:colorpicker({name = key, flag = "notif_color_" .. key, color = notif_defaults[key], no_alpha = true, callback = function(color)
                    notif_style[key] = color
                end})
            end

            notif_section:button({name = "copy colors", seperator = true, callback = function()
                local copy = {main = themes.preset.background, accent = themes.preset.accent, outline = themes.preset.outline, font = themes.preset.text}

                for key, picker in pairs(notif_pickers) do
                    if copy[key] and type(picker) == "table" and picker.set then
                        pcall(picker.set, copy[key], picker.alpha)
                    end
                end
            end})

            notif_section:slider({name = "position x", flag = "notif_position_x", min = 0, max = 100, default = 50, suffix = "%", half = true, callback = function(value)
                notif_set("x", value)
            end})

            notif_section:slider({name = "position y", flag = "notif_position_y", min = 0, max = 100, default = 60, suffix = "%", half = true, callback = function(value)
                notif_set("y", value)
            end})

            notif_section:slider({name = "transparency", flag = "notif_transparency", min = 0, max = 100, default = 0, suffix = "%", callback = function(value)
                notif_style.transparency = value
            end})

            notif_section:dropdown({name = "alignment", flag = "notif_alignment", width = 100, items = {"Left", "Right", "Center"}, multi = false, default = "Left", callback = function(state)
                notif_style.align = state
            end})

            notif_section:dropdown({name = "bar side", flag = "notif_bar_side", width = 100, items = {"Left", "Right", "Top", "Bottom"}, multi = false, default = "Bottom", callback = function(state)
                notif_style.bar = state
            end})

            notif_section:dropdown({name = "sort order", flag = "notif_sort_order", width = 100, items = {"Text Length", "Default"}, multi = false, default = "Default", seperator = true, callback = function(state)
                notif_set("sort", state)
            end})

            notif_section:button({name = "send notification", callback = function()
                notifications:create_notification({name = "sleepy.gg", info = "this is a test notification"})
            end})

            local backdrop = {parts = {}, open = not getgenv().silent_load_active}

            library.backdrop = backdrop

            backdrop.blur = Instance.new("BlurEffect")
            backdrop.blur.Name = "\0"
            backdrop.blur.Enabled = false
            backdrop.color = Instance.new("ColorCorrectionEffect")
            backdrop.color.Name = "\0"
            backdrop.color.Enabled = false

            function backdrop.refresh()
                local active = backdrop.open and flags.menu_bg_enabled and true or false
                local camera = workspace.CurrentCamera

                if camera and backdrop.blur.Parent ~= camera then
                    backdrop.blur.Parent = camera
                    backdrop.color.Parent = camera
                end

                backdrop.blur.Size = tonumber(flags.menu_bg_blur) or 15
                backdrop.blur.Enabled = active and backdrop.blur.Size > 0
                backdrop.color.Contrast = tonumber(flags.menu_bg_contrast) or 0
                backdrop.color.Saturation = tonumber(flags.menu_bg_saturation) or 0
                backdrop.color.Brightness = tonumber(flags.menu_bg_brightness) or 0
                backdrop.color.Enabled = active

                if not backdrop.gui then return end

                local back_color = flags.menu_bg_color
                local item_color = flags.menu_bg_item_color
                local material = Enum.Material[flags.menu_bg_material or "Neon"]

                backdrop.gui.Enabled = active
                backdrop.outer.BackgroundColor3 = type(back_color) == "table" and back_color.Color or rgb(0, 0, 0)
                backdrop.outer.BackgroundTransparency = flags.menu_bg_dim == false and 1 or (tonumber(flags.menu_bg_transparency) or 0.7)
                backdrop.inner.ImageColor3 = type(item_color) == "table" and item_color.Color or rgb(255, 255, 255)

                for _, part in pairs(backdrop.parts) do
                    part.Transparency = tonumber(flags.menu_bg_item_transparency) or 0
                    part.Reflectance = tonumber(flags.menu_bg_item_reflectance) or 0
                    part.Material = material
                end
            end

            local function back_refresh()
                pcall(backdrop.refresh)
            end

            local backdrop_toggle = window.toggle_menu

            if type(backdrop_toggle) == "function" then
                window.toggle_menu = function(bool, ...)
                    backdrop.open = bool and true or false

                    back_refresh()

                    return backdrop_toggle(bool, ...)
                end
            end

            task.spawn(function()
                local ok, gui = pcall(function()
                    return game:GetObjects("rbxassetid://93615626116769")[1]
                end)

                if not ok or typeof(gui) ~= "Instance" then
                    ok, gui = pcall(function()
                        return cloneref(game:GetService("InsertService")):LoadLocalAsset("rbxassetid://93615626116769")
                    end)
                end

                if not ok or typeof(gui) ~= "Instance" then
                    warn("[Sleepy.gg] background items failed to load: " .. tostring(gui))

                    return
                end

                if not gui:IsA("ScreenGui") then
                    gui = gui:FindFirstChildWhichIsA("ScreenGui", true) or gui
                end

                local outer = gui:FindFirstChild("ViewportFrame") or gui:FindFirstChildWhichIsA("ViewportFrame", true)
                local inner = outer and (outer:FindFirstChild("ViewportFrame") or outer:FindFirstChildWhichIsA("ViewportFrame", true))

                if not gui:IsA("ScreenGui") or not inner then
                    warn("[Sleepy.gg] background items asset has an unexpected layout: " .. gui.ClassName .. " / " .. tostring(outer and outer.ClassName) .. " / " .. tostring(inner and inner.ClassName))

                    gui:Destroy()

                    return
                end

                for _, child in ipairs(inner:GetChildren()) do
                    if child.Name == "Overlay V2" then
                        child:Destroy()
                    elseif child:IsA("BasePart") then
                        child.Position = Vector3.new(0, 1000, 0)
                        backdrop.parts[child.Name] = child
                    end
                end

                if next(backdrop.parts) == nil then
                    local found = {}

                    for _, child in ipairs(inner:GetChildren()) do
                        found[#found + 1] = child.Name .. ":" .. child.ClassName
                    end

                    warn("[Sleepy.gg] background items asset has no usable parts: " .. table.concat(found, ", "))
                end

                gui.Name = "\0"
                gui.Enabled = false
                gui.DisplayOrder = (library[ "items" ].DisplayOrder or 0) - 1
                gui.Parent = library[ "items" ].Parent

                backdrop.gui, backdrop.outer, backdrop.inner = gui, outer, inner

                back_refresh()
            end)

            run_service.RenderStepped:Connect(function(dt)
                if not (backdrop.gui and backdrop.gui.Enabled) then return end

                local wanted = backdrop.parts[flags.menu_bg_item or ""]

                if wanted ~= backdrop.current then
                    if backdrop.current then backdrop.current.Position = Vector3.new(0, 1000, 0) end
                    if wanted then wanted.Position = Vector3.new(0, 10, 10) end

                    backdrop.current = wanted
                end

                if wanted then
                    wanted.CFrame = wanted.CFrame * CFrame.Angles(0, (tonumber(flags.menu_bg_speed) or 0.15) / 10 * dt * 60, 0)
                end
            end)

            local back_section = menu_right:section({name = "background", size = 1, default = false, icon = GetImage("Settings.png")})

            local back_toggle = back_section:toggle({type = "toggle", name = "enabled", flag = "menu_bg_enabled", default = false, callback = back_refresh})

            back_toggle:colorpicker({name = "item color", flag = "menu_bg_item_color", color = rgb(255, 255, 255), no_alpha = true, callback = back_refresh})

            back_section:dropdown({name = "item", flag = "menu_bg_item", width = 100, items = {"None", "Sword", "Cross", "Heart", "Catholic Cross", "Orthodox Cross"}, multi = false, default = "Sword"})

            back_section:slider({name = "transparency", flag = "menu_bg_item_transparency", min = 0, max = 1, decimal = 0.01, default = 0, half = true, callback = back_refresh})
            back_section:slider({name = "reflectance", flag = "menu_bg_item_reflectance", min = 0, max = 1, decimal = 0.01, default = 0, half = true, callback = back_refresh})
            back_section:slider({name = "speed", flag = "menu_bg_speed", min = 0.1, max = 1, decimal = 0.01, default = 0.15})

            back_section:dropdown({name = "material", flag = "menu_bg_material", width = 100, items = {"ForceField", "Neon", "Plastic", "SmoothPlastic", "Wood", "WoodPlanks", "Marble", "Slate", "Concrete", "Granite", "Brick", "Pebble", "Cobblestone", "Rock", "Sandstone", "Basalt", "CrackedLava", "Limestone", "Pavement", "CorrodedMetal", "DiamondPlate", "Foil", "Metal", "Grass", "LeafyGrass", "Sand", "Fabric", "Snow", "Mud", "Ground", "Asphalt", "Salt", "Ice", "Glacier", "Glass"}, multi = false, default = "Neon", seperator = true, callback = back_refresh})

            local back_dim = back_section:toggle({type = "toggle", name = "background color", flag = "menu_bg_dim", default = true, callback = back_refresh})

            back_dim:colorpicker({name = "background color", flag = "menu_bg_color", color = rgb(0, 0, 0), no_alpha = true, callback = back_refresh})

            back_section:slider({name = "transparency", flag = "menu_bg_transparency", min = 0, max = 1, decimal = 0.01, default = 0.7, half = true, callback = back_refresh})
            back_section:slider({name = "blur", flag = "menu_bg_blur", min = 0, max = 50, default = 15, half = true, callback = back_refresh})
            back_section:slider({name = "contrast", flag = "menu_bg_contrast", min = -10, max = 10, decimal = 0.1, default = 0, half = true, callback = back_refresh})
            back_section:slider({name = "saturation", flag = "menu_bg_saturation", min = -10, max = 10, decimal = 0.1, default = 0, half = true, callback = back_refresh})
            back_section:slider({name = "brightness", flag = "menu_bg_brightness", min = -1, max = 1, decimal = 0.1, default = 0, callback = back_refresh})

            local column = main:column({})
            local section = column:section({name = "config", side = "right", size = 1, default = true, icon = GetImage("Settings.png")})
            text = section:textbox({name = "config name:", flag = "config_name_text", tall = true,})
            section:button({name = "save", callback = function()
                pcall(function()
                    local config_name = (flags["config_name_text"])

                    writefile(library:config_path(config_name), library:get_config())
                    library:touch_config(config_name)
                    library:update_config_list()
                    notifications:create_notification({name = "configs", info = "saved config to:\n" .. config_name})
                end)
            end})
            section:button({name = "overwrite", safemode = true, callback = function()
                pcall(function()
                    local config_name = flags["config_name_list"]
                    local previous, extension = library:find_config(config_name)

                    writefile(library:config_path(config_name), library:get_config())

                    if previous and extension ~= CONFIG_WRITE_EXTENSION then
                        pcall(delfile, previous)
                    end

                    library:touch_config(config_name)
                    library:update_config_list()
                    notifications:create_notification({name = "configs", info = "overwrote config :\n" .. config_name})
                end)
            end})

            section:button({name = "load", callback = function()
                pcall(function()
                    local config_name = flags["config_name_list"]
                    local path = library:find_config(config_name)

                    if not path then
                        notifications:create_notification({name = "configs", info = "no config found named:\n" .. tostring(config_name)})

                        return
                    end

                    library:load_config(readfile(path))
                    library:touch_config(config_name)
                    library:update_config_list()
                    notifications:create_notification({name = "configs", info = "loaded config:\n" .. config_name})
                end)
            end})

            section:button({name = "delete", safemode = true, callback = function()
                pcall(function()
                    local config_name = flags["config_name_list"]

                    for _, extension in CONFIG_EXTENSIONS do
                        local path = library:config_path(config_name, extension)

                        if isfile(path) then
                            pcall(delfile, path)
                        end
                    end

                    library:touch_config(config_name, true)
                    library:update_config_list()
                    notifications:create_notification({name = "configs", info = "deleted config:\n" .. config_name})
                end)
            end})

            section:button({name = "refresh config list", callback = function()
                local ok, err = pcall(function()
                    library:update_config_list()
                end)

                notifications:create_notification({
                    name = "configs",
                    info = ok and "config list refreshed" or ("refresh failed:\n" .. tostring(err))
                })
            end})

            local import_box
            local import_generation = 0
            local import_running = false

            import_box = section:textbox({
                tall = true,
                layout = -1,
                name = "import from clipboard:",
                flag = "config_import_text",
                placeholder = "paste config here...",
                callback = function(text)
                    if import_running then return end

                    import_generation += 1

                    if (text or "") == "" then return end

                    local generation = import_generation

                    task.delay(0.35, function()
                        if generation ~= import_generation or import_running then return end

                        import_running = true

                        local ok, info = library:import_config(text)

                        notifications:create_notification({
                            name = "configs",
                            info = ok and ("config loaded, " .. info)
                                or ("oops! something went wrong while trying to load the config.\nerror: " .. info),
                            lifetime = ok and 5 or 9
                        })

                        if ok then
                            import_box.set("")
                        end

                        import_running = false
                    end)
                end
            })

            section:button({
                name = "copy config to clipboard",
                seperator = true,
                callback = function()
                    local ok, info = library:export_config()

                    notifications:create_notification({
                        name = "configs",
                        info = ok and ("config copied, " .. info)
                            or ("oops! something went wrong while trying to copy the config.\nerror: " .. info),
                        lifetime = ok and 5 or 9
                    })
                end
            })

            local autoload_label = section:label({name = "auto load: none"})

            if isfile(AUTOLOAD_PATH) then
                local name = readfile(AUTOLOAD_PATH)
                autoload_label.set("auto load: " .. name)
                AUTOLOAD_ENABLED = true
            else
                autoload_label.set("auto load: none")
                AUTOLOAD_ENABLED = false
            end

            local startup_data = read_startup_data()

            section:toggle({
                type = "toggle",
                name = "auto load config",
                flag = "autoload_config",
                default = startup_data.autoload_config and isfile(AUTOLOAD_PATH),
                seperator = true,
                callback = function(state)
                    AUTOLOAD_ENABLED = state
                    write_startup_data("autoload_config", state)

                    if state then
                        local name = flags["config_name_list"]
                        if name and name ~= "" then
                            writefile(AUTOLOAD_PATH, name)
                            autoload_label.set("auto load: " .. name)
                        end
                    else
                        if isfile(AUTOLOAD_PATH) then
                            delfile(AUTOLOAD_PATH)
                        end
                        autoload_label.set("auto load: none")
                    end
                end
            })

            section:toggle({type="toggle",name="auto load script",flag="autoload_enabled",default=startup_data.autoload_enabled, callback = function(state)
                write_startup_data("autoload_enabled", state)

                if not state then
                    queue_on_teleport("")

                    return
                end

                local paid = getgenv().Build == "Paid"
                local loader = paid
                    and "4d0c67e660690a3ca0ab38048bc35041"

                if paid and not script_key then return end

                local source = "repeat task.wait() until game:IsLoaded()\n"

                if paid then
                    source = source .. 'script_key = "' .. script_key .. '"\n'
                end

                source = source .. 'loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/' .. loader .. '.lua"))()'

                queue_on_teleport(source)
            end})

            section:toggle({type = "toggle", name = "silent load", flag = "silent_load", default = startup_data.silent_load, seperator = true, callback = function(state)
                getgenv().silent_load_active = state
                write_startup_data("silent_load", state)
            end})

            menu_section:textbox({name = "menu size %", flag = "menu_size", default = "50", placeholder = "50", callback = function(text)
                local value = tonumber(text)
                if not value or not library.ui_scale then return end
                library.ui_scale.Scale = math.clamp(value, 25, 100) / 100
            end})

            library.theme_pickers = library.theme_pickers or {}

            library.theme_pickers.accent = menu_section:colorpicker({name = "menu accent", flag = "menu_accent_color", callback = function(color, alpha) library:update_theme("accent", color) end, color = themes.preset.accent})
            library.theme_pickers.background = menu_section:colorpicker({name = "background", flag = "menu_background_color", callback = function(color) library:paint_theme("background", color) end, color = themes.preset.background})
            library.theme_pickers.element = menu_section:colorpicker({name = "elements", flag = "menu_element_color", callback = function(color) library:paint_theme("element", color) end, color = themes.preset.element})
            library.theme_pickers.outline = menu_section:colorpicker({name = "outlines", flag = "menu_outline_color", callback = function(color) library:paint_theme("outline", color) end, color = themes.preset.outline})
            library.theme_pickers.text = menu_section:colorpicker({name = "text", flag = "menu_text_color", callback = function(color) library:paint_theme("text", color) end, color = themes.preset.text})
            library.theme_pickers.inactive = menu_section:colorpicker({name = "inactive", flag = "menu_inactive_color", callback = function(color) library:paint_theme("inactive", color) end, color = themes.preset.inactive})

            menu_section:dropdown({name = "theme preset", flag = "menu_theme_preset", width = 100, items = THEME_PRESET_NAMES, multi = false, default = "Sleepy", seperator = true, callback = function(state)
                library:apply_theme_preset(state)
            end})
            menu_section:toggle({
                type = "toggle",
                name = "card outlines",
                flag = "menu_edge_enabled",
                default = false,
                callback = function()
                    library:refresh_edges()
                end
            })

            menu_section:slider({
                name = "outline opacity",
                flag = "menu_edge_opacity",
                min = 0,
                max = 100,
                default = 100,
                suffix = "%",
                seperator = true,
                callback = function()
                    library:refresh_edges()
                end
            })

            library:refresh_edges()

            library.menu_bind = menu_section:keybind({name = "menu bind", flag = "menu_bind", mode = "Toggle", callback = function(bool) window.toggle_menu(bool) end, seperator = true, default = true})

            persist_menu_bind(library.menu_bind)

            local _request = (http_request and http_request) or (request and request) or (http and http.request)

            server_section:button({name = "join lowest server", callback = function()
                local Servers = string.format("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100", tostring(game.PlaceId))

                local ListServers = function(cursor)
                    local Raw = game:HttpGet(Servers .. ((cursor and "&cursor="..cursor) or ""))
                    return cloneref(game:GetService("HttpService")):JSONDecode(Raw)
                end

                local Server, Next; repeat
                    local Servers = ListServers(Next)
                    Server = Servers.data[1]
                    Next = Servers.nextPageCursor
                until Server

                if Server.id == game.JobId then
                    library.notifications:create_notification({
                        name = "sleepy.gg",
                        info = `you are currently in the smallest server!`,
                        lifetime = 10
                    })
                    return
                end

                cloneref(game:GetService("TeleportService")):TeleportToPlaceInstance(game.PlaceId, Server.id)
            end})

            server_section:button({name = "server hop", callback = function()
                local Servers = {}
                local Request = _request({Url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true", tostring(game.PlaceId))})
                local Body = cloneref(game:GetService("HttpService")):JSONDecode(Request.Body)

                if Body and Body.data then
                    for _, Value in next, Body.data do
                        if type(Value) == "table" and tonumber(Value.playing) and tonumber(Value.maxPlayers) and Value.playing < Value.maxPlayers and Value.id ~= game.JobId then
                            table.insert(Servers, 1, Value.id)
                        end
                    end
                end

                cloneref(game:GetService("TeleportService")):TeleportToPlaceInstance(
                    game.PlaceId,
                    Servers[math.random(1, #Servers)]
                )
            end})

            server_section:button({name = "rejoin", callback = function()
                cloneref(game:GetService("TeleportService")):TeleportToPlaceInstance(
                    game.PlaceId,
                    game.JobId
                )
            end})

            server_section:button({name = "panic", callback = function()
                if not library.default_config then return end

                notifications:create_notification({
                    name = "sleepy.gg",
                    info = "everything reset to default"
                })

                library:load_config(library.default_config)
            end})

            library.menu_flags = {}

            for key in library.config_flags do
                if not game_flags[key] then
                    library.menu_flags[key] = true
                end
            end

            library.setup_complete = true
        end

        function notifications:anchor_for(mode)
            if mode == "Custom" then
                local style = library.notif_style or {}
                local x = math.clamp((tonumber(style.x) or 50) / 100, 0, 1)
                local y = math.clamp((tonumber(style.y) or 60) / 100, 0, 1)

                return vec2(x, y), 0, 0, y > 0.5 and -1 or 1
            end

            if mode == "Top Left" then return vec2(0, 0), 20, 20, 1 end
            if mode == "Top Right" then return vec2(1, 0), -20, 20, 1 end
            if mode == "Bottom Left" then return vec2(0, 1), 20, -20, -1 end
            if mode == "Bottom Right" then return vec2(1, 1), -20, -20, -1 end
            if mode == "Top Center" then return vec2(0.5, 0), 0, 20, 1 end

            return vec2(0.5, 1), 0, -20, -1
        end

        function notifications:refresh_notifs(instant)
            local mode = library.notif_position or "Center"
            local style = library.notif_style or {}
            local anchor, pad_x, pad_y, direction = notifications:anchor_for(mode)
            local offset = pad_y
            local ordered = {}

            for index, v in notifications.notifs do
                ordered[#ordered + 1] = {v, index}
            end

            if style.sort == "Text Length" then
                table.sort(ordered, function(a, b) return a[1].AbsoluteSize.X > b[1].AbsoluteSize.X end)
            else
                table.sort(ordered, function(a, b) return a[2] < b[2] end)
            end

            for _, entry in ordered do
                local v = entry[1]
                local goal = dim2(anchor.X, pad_x, anchor.Y, offset)

                v.AnchorPoint = anchor
                v.Visible = not (style.clip ~= false and math.abs(offset - pad_y) > (tonumber(style.clip_distance) or 200))

                if v == instant then
                    v.Position = goal
                else
                    library:tween(v, {Position = goal}, Enum.EasingStyle.Quad, 0.22)
                end

                offset += direction * (v.AbsoluteSize.Y + 8)
            end

            return offset
        end

        function notifications:fade(path, is_fading, instant)
            local fading = is_fading and 1 or math.clamp((tonumber((library.notif_style or {}).transparency) or 0) / 100, 0, 1)

            if instant then
                path.BackgroundTransparency = fading
            else
                library:tween(path, {BackgroundTransparency = fading}, Enum.EasingStyle.Quad, 1)
            end

            for _, instance in path:GetDescendants() do
                if not instance:IsA("GuiObject") then
                    if instance:IsA("UIStroke") then
                        if instant then
                            instance.Transparency = fading
                        else
                            library:tween(instance, {Transparency = fading}, Enum.EasingStyle.Quad, 1)
                        end
                    end

                    continue
                end

                if instance:IsA("TextLabel") then
                    if instant then
                        instance.TextTransparency = fading
                    else
                        library:tween(instance, {TextTransparency = fading})
                    end
                elseif instance:IsA("Frame") and not instance:GetAttribute("fade_skip") then
                    local target = is_fading and 1 or 0.6

                    if instant then
                        instance.BackgroundTransparency = target
                    else
                        library:tween(instance, {BackgroundTransparency = target}, Enum.EasingStyle.Quad, 1)
                    end
                end
            end
        end

        function notifications:create_notification(options)
            if not notifications_allowed() then return end

            local cfg = {
                name = options.name or "this is a title!";
                info = options.info or "this is extra info!";
                lifetime = options.lifetime or 3;
                items = {};
                outline;
            }

            local items = cfg.items; do
                items[ "notification" ] = library:create( "Frame" , {
                    Parent = library[ "notifs" ] or library[ "items" ];
                    Size = dim2(0, 0, 0, 0);
                    Name = "\0";
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    BackgroundTransparency = 1;
                    AnchorPoint = vec2(0.5, 1);
                    AutomaticSize = Enum.AutomaticSize.XY;
                    BackgroundColor3 = rgb(14, 14, 16)
                });

                library:create( "UIScale" , {
                    Parent = items[ "notification" ];
                    Scale = scale;
                });

                items[ "content" ] = library:create( "Frame" , {
                    Parent = items[ "notification" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    Size = dim2(0, 0, 0, 0)
                });

                items[ "content" ]:SetAttribute("fade_skip", true)

                library:create( "UIListLayout" , {
                    Parent = items[ "content" ];
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    HorizontalAlignment = Enum.HorizontalAlignment[(library.notif_style or {}).align or "Left"] or Enum.HorizontalAlignment.Left
                });

                items[ "stroke" ] = library:create( "UIStroke" , {
                    Color = rgb(23, 23, 29);
                    Parent = items[ "notification" ];
                    Transparency = 1;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                });

                items[ "title" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(255, 255, 255);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = items[ "content" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library:create( "UICorner" , {
                    Parent = items[ "notification" ];
                    CornerRadius = dim(0, 3)
                });

                items[ "info" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(145, 145, 145);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.info;
                    Parent = items[ "content" ];
                    Name = "\0";
                    Position = dim2(0, 0, 0, 15);
                    BorderSizePixel = 0;
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    TextWrapped = false;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 13;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                library:create( "UIPadding" , {
                    PaddingBottom = dim(0, 3);
                    Parent = items[ "info" ]
                });

                items[ "bar" ] = library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = items[ "notification" ];
                    Name = "\0";
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 0, 0, 2);
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.accent
                });

                library:create( "UICorner" , {
                    Parent = items[ "bar" ];
                    CornerRadius = dim(0, 999)
                });

                library:create( "UIPadding" , {
                    PaddingTop = dim(0, 4);
                    PaddingBottom = dim(0, 5);
                    PaddingLeft = dim(0, 22);
                    PaddingRight = dim(0, 24);
                    Parent = items[ "notification" ]
                });
            end

            local style = library.notif_style or {}
            local align = Enum.TextXAlignment[style.align or "Left"] or Enum.TextXAlignment.Left
            local bar_goal = dim2(1, 0, 0, 2)

            items[ "title" ].LayoutOrder = 1
            items[ "info" ].LayoutOrder = 2
            items[ "title" ].TextXAlignment = align
            items[ "info" ].TextXAlignment = align

            if style.force then
                items[ "notification" ].BackgroundColor3 = style.main or items[ "notification" ].BackgroundColor3
                items[ "stroke" ].Color = style.outline or items[ "stroke" ].Color
                items[ "title" ].TextColor3 = style.font or items[ "title" ].TextColor3
                items[ "bar" ].BackgroundColor3 = style.accent or items[ "bar" ].BackgroundColor3
            end

            if style.bar == "Top" then
                items[ "bar" ].AnchorPoint = vec2(0, 0)
                items[ "bar" ].Position = dim2(0, 0, 0, 0)
            elseif style.bar == "Left" or style.bar == "Right" then
                local right = style.bar == "Right"

                items[ "bar" ].AnchorPoint = vec2(right and 1 or 0, 1)
                items[ "bar" ].Position = dim2(right and 1 or 0, right and 12 or -12, 1, 0)
                items[ "bar" ].Size = dim2(0, 2, 0, 0)
                bar_goal = dim2(0, 2, 1, 0)
            end

            local index = #notifications.notifs + 1
            notifications.notifs[index] = items[ "notification" ]

            notifications:fade(items[ "notification" ], false, true)

            task.defer(function()
                notifications:refresh_notifs(items[ "notification" ])
            end)
            library:tween(items[ "bar" ], {Size = bar_goal}, Enum.EasingStyle.Quad, cfg.lifetime)

            task.spawn(function()
                task.wait(cfg.lifetime)

                notifications.notifs[index] = nil

                notifications:fade(items[ "notification" ], true)
                notifications:refresh_notifs()

                task.wait(1)

                items[ "notification" ]:Destroy()
            end)
        end
    end

    return library
