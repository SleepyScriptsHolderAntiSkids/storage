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

loadstring(game:HttpGet("https://raw.githubusercontent.com/SleepyScriptsHolderAntiSkids/storage/refs/heads/main/luraphsdk"))();






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
    LocalPlayer.CharacterAdded:Wait()
    task.wait(1)
end
print("Character Loaded")

------------------------------------------------------

getgenv().LIB_BUILD = "depends-v1"

getgenv().library = {
    directory = "Sleepy.gg",
    folders = {
        "/fonts",
        "/configs",
        "/assets",
        "/autoload",
        "/unlockall"
    },
    flags = {},
    config_flags = {},
    connections = {},   
    notifications = {notifs = {}},
    current_open; 
}

getgenv().Images = {"Rust.mp3", "TF2.mp3", "Quake.mp3", "Dyssodia.mp3", "Bubble.mp3", "MW2019.mp3", "Sparkle.mp3", "Impact.mp3","WhiteBeam.png", "ESP.png", "World.png", "Wrench.png", "Settings.png", "Node.png", "cursor.png", "Bullet.png", "Snapline.png", "Pistol.png", "folder.png", "UZI.png", "FieldOfView2.png", "Lock.png", "Aimlock.png", "Cash.png", "Wheatt.png", "Pickkaxe.png", "unlocked.png"}

for _, path in next, library.folders do 
    makefolder(library.directory .. path)
end

for Index, Value in Images do
    local Location = library.directory.."/assets/"..Value
    if not isfile(Location) then
        local ImageDiddyAhhBlud = game:HttpGet("https://raw.githubusercontent.com/SleepyScriptsHolderAntiSkids/Images/main/"..Value)
        repeat wait() until ImageDiddyAhhBlud ~= nil
        writefile(Location, ImageDiddyAhhBlud)
    end
end

getgenv().GetImage = LPH_JIT_MAX(function(Name)
    local Location = library.directory.."/assets/"..Name
    if isfile(Location) then
        return getcustomasset(Location)
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
        if isfile(library.directory.."/assets/"..Asset.Id) then
            delfile(library.directory.."/assets/"..Asset.Id)
        end

        writefile(library.directory.."/assets/"..Asset.Id, Asset.Font)

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
        Font = game:HttpGet("https://github.com/SleepyScriptsHolderAntiSkids/OctoHook-UI/raw/refs/heads/main/fs-tahoma-8px%20(3).ttf"),
    })

    getgenv().Pixel = RegisterFont("Pixel", 400, "Normal", {
        Id = "Pixel.ttf",
        Font = game:HttpGet("https://github.com/SleepyScriptsHolderAntiSkids/vaderpaste.luau/raw/refs/heads/main/Pixel.ttf"),
    })

    getgenv().Minecraftia = RegisterFont("Minecraftia", 400, "Normal", {
        Id = "Minecraftia.ttf",
        Font = game:HttpGet("https://github.com/SleepyScriptsHolderAntiSkids/storage/raw/refs/heads/main/fonts/Minecraftia-Regular.ttf"),
    }) 

    getgenv().Verdana = RegisterFont("Verdana", 400, "Normal", {
        Id = "Verdana.ttf",
        Font = game:HttpGet("https://github.com/SleepyScriptsHolderAntiSkids/storage/raw/refs/heads/main/fonts/Verdana-Font.ttf"),
    })

    Fonts["Plex"] = Font.new(Tahoma, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
    Fonts["Pixel"] = Font.new(Pixel, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
    Fonts["Minecraftia"] = Font.new(Minecraftia, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
    Fonts["Verdana"] = Font.new(Verdana, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
end


getgenv().SafeDisconnect = LPH_JIT_MAX(function(conn)
    if conn and typeof(conn) == "RBXScriptConnection" then
        conn:Disconnect()
    end
end)


-- Config
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
        ["FilledFOVAlpha"] = 0.25; -- NEW
        ["FilledFOVAlpha2"] = 0.25; -- NEW
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

    color1 = Color3.fromRGB(0, 163, 224),
    color2 = Color3.fromRGB(0, 163, 224),
    color3 = Color3.fromRGB(0, 163, 224),
    gradient_rotation = 0,

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


-- Ui Library Part --


if Mobile == (Enum.PreferredInput.Gamepad) then 
    return Players.LocalPlayer:Kick("Gamepad Device is not supported by the script")
end

if Mobile == (Enum.PreferredInput.KeyboardAndMouse) then
    print("Keyboard & Mouse")
--LPH_JIT_MAX(function()
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
-- 

-- Library init
    local themes = {
        preset = {
            accent = rgb(0, 162, 255),
        }, 

        utility = {
            accent = {
                BackgroundColor3 = {}, 	
                TextColor3 = {}, 
                ImageColor3 = {}, 
                ScrollBarImageColor3 = {} 
            },
        }
    }

    local keys = {
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
                writefile(AssetPath, Asset.Font)
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
            Font = game:HttpGet("https://github.com/SleepyScriptsHolderAntiSkids/storage/raw/refs/heads/main/fonts/Inter_28pt-Medium.ttf"),
        })

        local SemiBold = Register_Font("SemiBold", 200, "Normal", {
            Id = "SemiBold.ttf",
            Font = game:HttpGet("https://github.com/SleepyScriptsHolderAntiSkids/storage/raw/refs/heads/main/fonts/Inter_28pt-SemiBold.ttf"),
        })

        fonts = {
            small = Font.new(Medium, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
            font = Font.new(SemiBold, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
        }
    end
--

-- Library functions 
    -- Misc functions
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

        local config_holder;
        function library:update_config_list() 
            if not config_holder then 
                return 
            end
            
            local list = {}
            
            for idx, file in listfiles(library.directory .. "/configs") do
                local name = (file:match("[^/\\]+$") or file):gsub("%.cfg$", "")
                list[#list + 1] = name
            end

            config_holder.refresh_options(list)
        end 

        function library:get_config()
            local Config = {}
            
            for _, v in next, flags do
                if type(v) == "table" and v.key then
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
            local applied = 0

            for _, v in config do 
                local function_set = library.config_flags[_]
                
                if _ == "config_name_list" then 
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


        local AUTOLOAD_PATH = library.directory .. "/autoload/autoload.cfg"

        local AUTOLOAD_ENABLED = false


        task.spawn(LPH_NO_VIRTUALIZE(function()
            local last = -1
            while true do
                task.wait(0.5)
                local count = 0
                for _ in next, library.config_flags do count += 1 end
                if count > 0 and count == last then break end
                last = count
            end

            -- Every control has written its default into flags by now, so this snapshot is
            -- the untouched state. Taken before autoload so a saved config can't poison it.
            -- Panic replays it through load_config, which already knows how to feed every
            -- control type back through its own setter.
            library.default_config = library:get_config()

            if isfile(AUTOLOAD_PATH) then
                local name = readfile(AUTOLOAD_PATH)
                local path = library.directory .. "/configs/" .. name .. ".cfg"

                if isfile(path) then
                    pcall(function()
                        library:load_config(readfile(path))
                    end)
                end
            end
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

                task.delay(0.12, function()
                    for i = 1, #refreshers do
                        pcall(refreshers[i])
                    end
                end)
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

                                break
                            end
                        end

                        if not shown and child.set_visible then pcall(child.set_visible, false) end
                    end

                end

                library:relayout_sections()
            end

            local previous = parent.callback

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
        end 

        function library:connection(signal, callback)
            local connection = signal:Connect(callback)
            
            insert(library.connections, connection)

            return connection 
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
    --
        --[[local cursor_screengui = library:create("ScreenGui", {
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Global,
            Name = "error - stack",
            IgnoreGuiInset = true,
            DisplayOrder = 9999,
            Parent = gethui()
        })

        local cursor_image = library:create("ImageLabel", {
            Name = "Cursor",
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 34, 0, 34),
            Image = GetImage('cursor.png'),
            ZIndex = 6969,
            Parent = cursor_screengui
        })

        run_service.PreRender:Connect(LPH_NO_VIRTUALIZE(function()
            local mouseloc = uis:GetMouseLocation()
            cursor_image.Position = UDim2.new(0, mouseloc.X , 0, mouseloc.Y)
        end))]]
    
    -- Library element functions
        function library:window(properties)
            local cfg = { 
                suffix = properties.suffix or properties.Suffix or "tech";
                name = properties.name or properties.Name or "nebula";
                game_name = properties.gameInfo or properties.game_info or properties.GameInfo or "Milenium for Counter-Strike: Global Offensive";
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
                Name = "
