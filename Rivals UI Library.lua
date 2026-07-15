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

getgenv().library = {
    directory = "volt.gg",
    folders = {
        "/fonts",
        "/configs",
        "/assets",
        "/autoload",
        "/unlockall"
    },
    priority = {},
    whitelist = {},
    flags = {},
    config_flags = {},
    connections = {},   
    notifications = {notifs = {}},
    current_open; 
}

local Images = {"Rust.mp3", "TF2.mp3", "Quake.mp3", "Dyssodia.mp3", "Bubble.mp3", "MW2019.mp3", "WhiteBeam.png", "ESP.png", "World.png", "Wrench.png", "Settings.png", "Node.png", "cursor.png", "Bullet.png", "Snapline.png", "Pistol.png", "folder.png", "UZI.png", "FieldOfView2.png", "Lock.png", "Aimlock.png", "Cash.png", "Wheatt.png", "Pickkaxe.png", "unlocked.png"}

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

GetImage = LPH_JIT_MAX(function(Name)
    local Location = library.directory.."/assets/"..Name
    if isfile(Location) then
        return getcustomasset(Location)
    end
end)


HideUI = LPH_JIT_MAX(function(Title, Timing)
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
    textLabel.Name = "\nhideuivoltgg"
    textLabel.Size = UDim2.new(0, 400, 0, 100)
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.RichText = true
    textLabel.Text = '<font color="rgb(0,163,224)">volt.</font>gg\n' .. Title
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
                    '<font color="rgb(0,163,224)">volt.</font>gg\n%s\nplease wait : <font color="rgb(0,163,224)">%.2f</font> seconds',
                    Title, math.max(timeLeft, 0)
                )

                task.wait()
            end
        end))
    end

    return textLabel
end) 

DeleteSecretUI = LPH_JIT_MAX(function(Title)
    if getgenv().HideScreenGUI then
        getgenv().HideScreenGUI:Destroy()
        getgenv().HideScreenGUI = nil
    end
end)


local Fonts = {}; do
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
    
    local Tahoma = RegisterFont("Tahoma", 400, "Normal", {
        Id = "Tahoma.ttf",
        Font = game:HttpGet("https://github.com/SleepyScriptsHolderAntiSkids/OctoHook-UI/raw/refs/heads/main/fs-tahoma-8px%20(3).ttf"),
    })

    local Pixel = RegisterFont("Pixel", 400, "Normal", {
        Id = "Pixel.ttf",
        Font = game:HttpGet("https://github.com/SleepyScriptsHolderAntiSkids/vaderpaste.luau/raw/refs/heads/main/Pixel.ttf"),
    })

    local Minecraftia = RegisterFont("Minecraftia", 400, "Normal", {
        Id = "Minecraftia.ttf",
        Font = game:HttpGet("https://github.com/SleepyScriptsHolderAntiSkids/storage/raw/refs/heads/main/fonts/Minecraftia-Regular.ttf"),
    }) 

    local Verdana = RegisterFont("Verdana", 400, "Normal", {
        Id = "Verdana.ttf",
        Font = game:HttpGet("https://github.com/SleepyScriptsHolderAntiSkids/storage/raw/refs/heads/main/fonts/Verdana-Font.ttf"),
    })

    Fonts["Plex"] = Font.new(Tahoma, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
    Fonts["Pixel"] = Font.new(Pixel, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
    Fonts["Minecraftia"] = Font.new(Minecraftia, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
    Fonts["Verdana"] = Font.new(Verdana, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
end


local SafeDisconnect = LPH_JIT_MAX(function(conn)
    if conn and typeof(conn) == "RBXScriptConnection" then
        conn:Disconnect()
    end
end)


-- Config
local DefaultPlayerSettings = {}

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
        ["Weather"] = {
            ["Mode"] = "Snow";
        };
        ["Ambience"] = {
            ["Mode"] = "Rain";
            ["Volume"] = 5;
        };
        ["DarkMode"] = {
            ["Color"] = Color3.fromRGB(30, 30, 40);
        };
},

    ESP = {
    Enabled = false,
    TeamCheck = false,
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
            GradientRGB1 = Color3.fromRGB(255, 255, 255), GradientRGB2 = Color3.fromRGB(119, 120, 255),
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

    text = "volt.gg",
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

    local fonts = {}; do
        local Register_Font = LPH_JIT_MAX(function(Name, Weight, Style, Asset)
            if not isfile(Asset.Id) then
                writefile(Asset.Id, Asset.Font)
            end

            if isfile(Name .. ".font") then
                delfile(Name .. ".font")
            end

            local Data = {
                name = Name,
                faces = {
                    {
                        name = "Normal",
                        weight = Weight,
                        style = Style,
                        assetId = getcustomasset(Asset.Id),
                    },
                },
            }

            writefile(Name .. ".font", http_service:JSONEncode(Data))

            return getcustomasset(Name .. ".font");
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
                local name = file:gsub(library.directory .. "/configs\\", ""):gsub(".cfg", ""):gsub(library.directory .. "\\configs\\", "")
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
            
            for _, v in config do 
                local function_set = library.config_flags[_]
                
                if _ == "config_name_list" then 
                    continue 
                end

                if function_set then 
                    if type(v) == "table" and v["Transparency"] and v["Color"] then
                        function_set(hex(v["Color"]), v["Transparency"])
                    elseif type(v) == "table" and v["active"] then 
                        function_set(v)
                    else
                        function_set(v)
                    end
                end 
            end 
        end 


        local AUTOLOAD_PATH = library.directory .. "/autoload/autoload.cfg"

        local AUTOLOAD_ENABLED = false


        task.defer(LPH_NO_VIRTUALIZE(function()
            if not AUTOLOAD_ENABLED then
                return
            end

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
            
            library[ "other" ] = library:create( "ScreenGui" , {
                Parent = gethui();
                Name = "\0";
                Enabled = false;
                ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
                IgnoreGuiInset = true;
            }); 

            -- IF SHIT HAPPEN REMVOE ZINDEX

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

            do -- Other
                library:draggify(items[ "main" ])
                library:resizify(items[ "main" ])
            end 

             cfg.toggle_menu = LPH_NO_VIRTUALIZE(function(bool) 
                -- WIP 
                -- if cfg.tween then 
                --     cfg.tween:Cancel()
                -- end 

                -- items[ "main" ].Size = dim2(items[ "main" ].Size.Scale.X, items[ "main" ].Size.Offset.X - 20, items[ "main" ].Size.Scale.Y, items[ "main" ].Size.Offset.Y - 20)
                -- library:tween(items[ "tab_holder" ], {Size = dim2(1, -196, 1, -81)}, Enum.EasingStyle.Quad, 0.4)
                -- cfg.tween = 
                --cursor_image.Visible = bool
                --uis.MouseIconEnabled = not bool
                library[ "items" ].Enabled = bool
            end)

            RunService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function()
                if library[ "items" ].Enabled then
                    uis.MouseBehavior = Enum.MouseBehavior.Default
                    uis.MouseIconEnabled = true
                end
            end))
                
            return setmetatable(cfg, library)
        end 

        function library:tab(properties)
            local cfg = {
                name = properties.name or properties.Name or "visuals"; 
                icon = properties.icon or properties.Icon or "http://www.roblox.com/asset/?id=6034767608";
                
                -- multi 
                tabs = properties.tabs or properties.Tabs or {"Main", "Misc.", "Settings"};
                pages = {}; -- data store for multi sections
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
                
                -- Tab buttons 
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
                -- 

                -- Multi Sections
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
                            -- Button
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
                            --

                            -- Tab 
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
                            --
                        end

                        data.text = multi_items[ "name" ]
                        data.accent = multi_items[ "accent" ]
                        data.button = multi_items[ "button" ]
                        data.page = multi_items[ "tab" ]
                        data.parent = setmetatable(data, library):sub_tab({}).items[ "tab_parent" ]
                        
                        -- Old column code
                        -- data.left = multi_items[ "left" ]
                        -- data.right = multi_items[ "right" ]

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
                --
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
            end

            return unpack(cfg.pages)
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

        -- Miscellaneous 
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
                    
                    library:create( "UIPadding" , {
                        PaddingBottom = dim(0, 10);
                        Parent = items[ "column" ]
                    });
                    
                    library:create( "UIListLayout" , {
                        Parent = items[ "column" ];
                        HorizontalFlex = Enum.UIFlexAlignment.Fill;
                        Padding = dim(0, 10);
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
        --

        function library:section(properties)
            local cfg = {
                name = properties.name or properties.Name or "section"; 
                side = properties.side or properties.Side or "left";
                default = properties.default or properties.Default or false;
                size = properties.size or properties.Size or self.size or 0.5; 
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
                    Size = dim2(1, 0, 1, -40);
                    BackgroundTransparency = 1;
                    Position = dim2(0, 0, 0, 35);
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
                    Padding = dim(0, 10);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });
                
                library:create( "UIPadding" , {
                    PaddingBottom = dim(0, 15);
                    Parent = items[ "elements" ]
                });
                
                items[ "button" ] = library:create( "TextButton" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(255, 255, 255);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    AutoButtonColor = false;
                    Parent = items[ "outline" ];
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    Size = dim2(1, -2, 0, 35);
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

            return setmetatable(cfg, library)
        end  

        function library:toggle(options) 
            local rand = math.random(1, 2) 
            local cfg = {
                enabled = options.default or false,
                name = options.name or "Toggle",
                info = options.info or nil,
                flag = options.flag or library:next_flag(),
                
                type = options.type and string.lower(options.type) or rand == 1 and "toggle" or "checkbox"; -- "toggle", "checkbox"

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
                
                -- Toggle
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
                --                
            end;
            
             cfg.set = LPH_NO_VIRTUALIZE(function(bool)
                if cfg.type == "checkbox" then 
                    library:tween(items[ "tick" ], {Rotation = bool and 0 or 45, ImageTransparency = bool and 0 or 1})
                    library:tween(items[ "toggle_button" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(67, 67, 68)})
                    library:tween(items[ "outline" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(22, 22, 24)})
                else
                    library:tween(items[ "toggle_button" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(58, 58, 62)}, Enum.EasingStyle.Quad)
                    library:tween(items[ "inline" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(50, 50, 50)}, Enum.EasingStyle.Quad)
                    library:tween(items[ "circle" ], {BackgroundColor3 = bool and rgb(255, 255, 255) or rgb(86, 86, 88), Position = bool and dim2(1, -14, 0, 2) or dim2(0, 2, 0, 2)}, Enum.EasingStyle.Quad)
                end

                cfg.enabled = bool
                cfg.callback(bool)

                if cfg.folding then 
                    elements.Visible = bool
                end

                flags[cfg.flag] = bool
            end)
            
            items[ "toggle" ].MouseButton1Click:Connect(LPH_NO_VIRTUALIZE(function()
                cfg.enabled = not cfg.enabled 
                cfg.set(cfg.enabled)
            end))

            items[ "toggle_button" ].MouseButton1Click:Connect(LPH_NO_VIRTUALIZE(function()
                cfg.enabled = not cfg.enabled 
                cfg.set(cfg.enabled)
            end))
            
            if cfg.seperator then -- ok bro my lua either sucks or this was a pain in the ass to make (simple if statement aswell 💔)
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

                -- value settings
                min = options.min or options.minimum or 0,
                max = options.max or options.maximum or 100,
                intervals = options.interval or options.decimal or 1,
                default = options.default or 10,
                value = options.default or 10, 
                seperator = options.seperator or options.Seperator or false;

                dragging = false,
                items = {}
            } 

            flags[cfg.flag] = cfg.default

            local items = cfg.items; do
                items[ "slider_object" ] = library:create( "TextButton" , {
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
                    Parent = items[ "slider_object" ];
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
                        Parent = items[ "slider_object" ];
                        Name = "\0";
                        Position = dim2(0, 5, 0, 37);
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
                    Parent = items[ "slider_object" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 4, 0, 23);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 12);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIListLayout" , {
                    Parent = items[ "right_components" ];
                    Padding = dim(0, 7);
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    FillDirection = Enum.FillDirection.Horizontal
                });
                
                items[ "slider" ] = library:create( "TextButton" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    AutoButtonColor = false;
                    AnchorPoint = vec2(1, 0);
                    Parent = items[ "right_components" ];
                    Name = "\0";
                    Position = dim2(1, 0, 0, 0);
                    Size = dim2(1, -4, 0, 4);
                    BorderSizePixel = 0;
                    TextSize = 14;
                    BackgroundColor3 = rgb(33, 33, 35)
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "slider" ];
                    CornerRadius = dim(0, 999)
                });
                
                items[ "fill" ] = library:create( "Frame" , {
                    Name = "\0";
                    Parent = items[ "slider" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0.5, 0, 0, 4);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.accent
                });  library:apply_theme(items[ "fill" ], "accent", "BackgroundColor3");
                
                library:create( "UICorner" , {
                    Parent = items[ "fill" ];
                    CornerRadius = dim(0, 999)
                });
                
                items[ "circle" ] = library:create( "Frame" , {
                    AnchorPoint = vec2(0.5, 0.5);
                    Parent = items[ "fill" ];
                    Name = "\0";
                    Position = dim2(1, 0, 0.5, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 12, 0, 12);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(244, 244, 244)
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "circle" ];
                    CornerRadius = dim(0, 999)
                });
                
                library:create( "UIPadding" , {
                    Parent = items[ "right_components" ];
                    PaddingTop = dim(0, 4)
                });
                
                items[ "value" ] = library:create( "TextLabel" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(72, 72, 73);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "50%";
                    Parent = items[ "slider_object" ];
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    Position = dim2(0, 6, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Right;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 16;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIPadding" , {
                    Parent = items[ "value" ];
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });                
            end 

             cfg.changetext = LPH_NO_VIRTUALIZE(function(text)
                items['name'].Text = text
            end)

             cfg.set = LPH_NO_VIRTUALIZE(function(value)
                cfg.value = clamp(library:round(value, cfg.intervals), cfg.min, cfg.max)

                library:tween(items[ "fill" ], {Size = dim2((cfg.value - cfg.min) / (cfg.max - cfg.min), cfg.value == cfg.min and 0 or -4, 0, 2)}, Enum.EasingStyle.Linear, 0.05)
                items[ "value" ].Text = tostring(cfg.value) .. cfg.suffix

                flags[cfg.flag] = cfg.value
                cfg.callback(flags[cfg.flag])
            end)

            items[ "slider" ].MouseButton1Down:Connect(LPH_NO_VIRTUALIZE(function()
                cfg.dragging = true 
                library:tween(items[ "value" ], {TextColor3 = rgb(255, 255, 255)}, Enum.EasingStyle.Quad, 0.2)
            end))

            library:connection(uis.InputChanged, function(input)
                if cfg.dragging and input.UserInputType == Enum.UserInputType.MouseMovement then 
                    local size_x = (input.Position.X - items[ "slider" ].AbsolutePosition.X) / items[ "slider" ].AbsoluteSize.X
                    local value = ((cfg.max - cfg.min) * size_x) + cfg.min
                    cfg.set(value)
                end
            end)

            library:connection(uis.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    cfg.dragging = false
                    library:tween(items[ "value" ], {TextColor3 = rgb(72, 72, 73)}, Enum.EasingStyle.Quad, 0.2) 
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

                -- Ignore these 
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
                -- Element
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
                        CornerRadius = dim(0, 4)
                    });
                    
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
                    
                    items[ "indicator" ] = library:create( "ImageLabel" , {
                        ImageColor3 = rgb(86, 86, 87);
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = items[ "dropdown" ];
                        AnchorPoint = vec2(1, 0.5);
                        Image = "rbxassetid://101025591575185";
                        BackgroundTransparency = 1;
                        Position = dim2(1, -5, 0.5, 0);
                        Name = "\0";
                        Size = dim2(0, 12, 0, 12);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                -- 

                -- Element Holder
                    items[ "dropdown_holder" ] = library:create( "Frame" , {
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = library[ "items" ];
                        Name = "\0";
                        Visible = true;
                        BackgroundTransparency = 1;
                        Size = dim2(0, 0, 0, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0);
                        ZIndex = 10;
                    });
                    
                    items[ "outline" ] = library:create( "Frame" , {
                        Parent = items[ "dropdown_holder" ];
                        Size = dim2(1, 0, 1, 0);
                        ClipsDescendants = true;
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(33, 33, 35);
                        ZIndex = 10;
                    });
                    
                    library:create( "UIPadding" , {
                        PaddingBottom = dim(0, 6);
                        PaddingTop = dim(0, 3);
                        PaddingLeft = dim(0, 3);
                        Parent = items[ "outline" ]
                    });
                    
                    library:create( "UIListLayout" , {
                        Parent = items[ "outline" ];
                        Padding = dim(0, 5);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "outline" ];
                        CornerRadius = dim(0, 4)
                    });
                -- 
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
            
            function cfg.set_visible(bool)
                local a = bool and cfg.y_size or 0
                library:tween(items[ "dropdown_holder" ], {Size = dim_offset(items[ "dropdown" ].AbsoluteSize.X, a)})

                items[ "dropdown_holder" ].Position = dim2(0, items[ "dropdown" ].AbsolutePosition.X, 0, items[ "dropdown" ].AbsolutePosition.Y + 80)
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
            end

            function cfg.changetext(text)
                items[ "name" ].Text = text
            end
            
            function cfg.refresh_options(list) 
                cfg.y_size = 0

                for _, option in cfg.option_instances do 
                    option:Destroy() 
                end
                
                cfg.option_instances = {} 

                for _, option in list do 
                    local button = cfg.render_option(option)
                    cfg.y_size += button.AbsoluteSize.Y + 6 -- super annoying manual sizing but oh well
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

            items[ "dropdown" ].MouseButton1Click:Connect(LPH_NO_VIRTUALIZE(function()
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

                color = options.color or color(1, 1, 1), -- Default to white color if not provided
                alpha = options.alpha and 1 - options.alpha or 0,
                
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
                -- Component
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
                --
                
                -- Colorpicker
                    items[ "colorpicker_holder" ] = library:create( "Frame" , {
                        Parent = library[ "other" ];
                        Name = "\0";
                        Position = dim2(0.20000000298023224, 20, 0.296999990940094, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 166, 0, 197);
                        BorderSizePixel = 0;
                        Visible = true;
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
                    
                    items[ "UICorenr" ] = library:create( "UICorner" , { -- fire misstypo (im not fixing this RAWR)
                        Parent = items[ "colorpicker_holder" ];
                        Name = "\0";
                        CornerRadius = dim(0, 4)
                    });
                --                  
            end;

            function cfg.set_visible(bool)
                items[ "colorpicker_fade" ].BackgroundTransparency = 0
                items[ "colorpicker_holder" ].Parent = bool and library[ "items" ] or library[ "other" ]
                items[ "colorpicker_holder" ].Position = dim_offset(items[ "colorpicker" ].AbsolutePosition.X, items[ "colorpicker" ].AbsolutePosition.Y + items[ "colorpicker" ].AbsoluteSize.Y + 45)

                library:tween(items[ "colorpicker_fade" ], {BackgroundTransparency = 1}, Enum.EasingStyle.Quad, 0.4)
                library:tween(items[ "colorpicker_holder" ], {Position = items[ "colorpicker_holder" ].Position + dim_offset(0, 20)}) -- p100 check
                
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

                -- Ok so quick story, should I cache any of this? no...?? anyways I know this code is very bad but its your fault for buying a ui with animations (on a serious note im too lazy to make this look nice)
                -- Also further note, yeah I kind of did this scale_factor * size-valuesize.plane because then I would have to do tomfoolery to make it clip properly.
                library:tween(items[ "hue_picker" ], {Position = dim2(0, (items[ "hue_gradient" ].AbsoluteSize.X - items[ "hue_picker" ].AbsoluteSize.X) * h, 0.5, 0)}, Enum.EasingStyle.Linear, 0.05)
                library:tween(items[ "alpha_picker" ], {Position = dim2(0, (items[ "alpha_gradient" ].AbsoluteSize.X - items[ "alpha_picker" ].AbsoluteSize.X) * (1 - a), 0.5, 0)}, Enum.EasingStyle.Linear, 0.05)
                library:tween(items[ "satvalpicker" ], {Position = dim2(0, s * (items[ "saturation_holder" ].AbsoluteSize.X - items[ "satvalpicker" ].AbsoluteSize.X), 1, 1 - v * (items[ "saturation_holder" ].AbsoluteSize.Y - items[ "satvalpicker" ].AbsoluteSize.Y))}, Enum.EasingStyle.Linear, 0.05)

                items[ "alpha_indicator" ]:FindFirstChildOfClass("UIGradient").Color = rgbseq{rgbkey(0, rgb(112, 112, 112)), rgbkey(1, hsv(h, 1, 1))}; -- shit code
                
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

            items[ "colorpicker" ].MouseButton1Click:Connect(function()
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
                items = {};
            }

            flags[cfg.flag] = cfg.default

            local items = cfg.items; do 
                items[ "textbox" ] = library:create( "TextButton" , {
                    LayoutOrder = -1;
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
                    Parent = items[ "textbox" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 4, 0, 19);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 12);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIListLayout" , {
                    Parent = items[ "right_components" ];
                    Padding = dim(0, 7);
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    FillDirection = Enum.FillDirection.Horizontal
                });
                
                items[ "input" ] = library:create( "TextBox" , {
                    FontFace = fonts.font;
                    Text = "";
                    Parent = items[ "right_components" ];
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
                    Position = dim2(1, 0, 0, 0);
                    Size = dim2(1, -4, 0, 30);
                    BackgroundColor3 = rgb(33, 33, 35)
                }); 

                library:create( "UICorner" , {
                    Parent = items[ "input" ];
                    CornerRadius = dim(0, 3)
                });                
                
                library:create( "UIPadding" , {
                    Parent = items[ "right_components" ];
                    PaddingTop = dim(0, 4);
                    PaddingRight = dim(0, 4)
                });
            end 
            
            function cfg.set(text) 
                flags[cfg.flag] = text

                items[ "input" ].Text = text

                cfg.callback(text)
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

                key = options.key or nil, 
                mode = options.mode or "Toggle",
                active = options.default or false, 

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
                -- Component
                    items[ "keybind_element" ] = library:create( "TextButton" , {
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
                -- 
                
                -- Mode Holder
                    items[ "dropdown" ] = library:create( "Frame" , {
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = library.items;
                        Name = "\0";
                        BackgroundTransparency = 1;
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
                            TextColor3 = rgb(72, 72, 73);
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
                        library:apply_theme(name, "accent", "TextColor3")
                        
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
                -- 
            end 

            if cfg.seperator then -- ok bro my lua either sucks or this was a pain in the ass to make (simple if statement aswell 💔)
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
            
            function cfg.modify_mode_color(path) -- ts so frikin tuff 💀
                for _, v in cfg.hold_instances do 
                    v.TextColor3 = rgb(72, 72, 72)
                end 

                cfg.hold_instances[path].TextColor3 = themes.preset.accent
            end

            function cfg.set_mode(mode) 
                cfg.mode = mode 

                if mode == "Always" then
                    cfg.set(true)
                elseif mode == "Hold" then
                    cfg.set(false)
                end

                flags[cfg.flag]["mode"] = mode
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
                    cfg.mode = input.mode or "Toggle"

                    if input.active then
                        cfg.active = input.active
                    end

                    cfg.set_mode(cfg.mode) 
                end 

                cfg.callback(cfg.active)

                local text = tostring(cfg.key) ~= "Enums" and (keys[cfg.key] or tostring(cfg.key):gsub("Enum.", "")) or nil
                local __text = text and (tostring(text):gsub("KeyCode.", ""):gsub("UserInputType.", ""))
                
                items[ "key" ].Text = __text

                flags[cfg.flag] = {
                    mode = cfg.mode,
                    key = cfg.key, 
                    active = cfg.active
                }
            end

            function cfg.set_visible(bool)
                local size = bool and cfg.y_size or 0
                library:tween(items[ "dropdown" ], {Size = dim_offset(items[ "keybind_holder" ].AbsoluteSize.X, size)})

                items[ "dropdown" ].Position = dim_offset(items[ "keybind_holder" ].AbsolutePosition.X, items[ "keybind_holder" ].AbsolutePosition.Y + items[ "keybind_holder" ].AbsoluteSize.Y + 60)
            end
        
            items[ "keybind_holder" ].MouseButton1Down:Connect(function()
                task.wait()
                items[ "key" ].Text = "..."	

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
            local cfg = {
                name = options.name or "TextBox",
                callback = options.callback or function() end,
                items = {};
            }
            
            local items = cfg.items; do 
                items[ "button_element" ] = library:create( "Frame" , {
                    Parent = self.items[ "elements" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                items[ "button" ] = library:create( "TextButton" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    AutoButtonColor = false;
                    AnchorPoint = vec2(1, 0);
                    Parent = items[ "button_element" ];
                    Name = "\0";
                    Position = dim2(1, -4, 0, 0);
                    Size = dim2(1, -8, 0, 30);
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
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); library:apply_theme(items[ "name" ], "accent", "BackgroundColor3");                            
            end 

            items[ "button" ].MouseButton1Click:Connect(function()
                cfg.callback()

                items[ "name" ].TextColor3 = themes.preset.accent 
                library:tween(items[ "name" ], {TextColor3 = rgb(245, 245, 245)})
            end)
            
            return setmetatable(cfg, library)
        end 

        function library:settings(options)  
            local cfg = {
                open = false; 
                items = {}; 
                sanity = true; -- made this for my own sanity.
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
                    Padding = dim(0, 10);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });
                
                library:create( "UIPadding" , {
                    PaddingBottom = dim(0, 15);
                    Parent = items[ "elements" ]
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
                local old_selected_value = flags[cfg.flag] -- store current selected option string
                cfg.current_element = nil -- reset current UI element
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
                        TextColor3 = rgb(72, 72, 73);
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

                    -- Apply selection highlight if this is the old selected option
                    if option_data == old_selected_value then
                        library:tween(name, {TextColor3 = rgb(245, 245, 245)})
                        cfg.current_element = name
                    end

                    button.MouseButton1Click:Connect(function()
                        local current = cfg.current_element 
                        if current and current ~= name then 
                            library:tween(current, {TextColor3 = rgb(72, 72, 72)})
                        end

                        flags[cfg.flag] = option_data
                        cfg.callback(option_data)
                        library:tween(name, {TextColor3 = rgb(245, 245, 245)})
                        cfg.current_element = name
                    end)

                    name.MouseEnter:Connect(function()
                        if cfg.current_element == name then return end
                        library:tween(name, {TextColor3 = rgb(140, 140, 140)})
                    end)

                    name.MouseLeave:Connect(function()
                        if cfg.current_element == name then return end
                        library:tween(name, {TextColor3 = rgb(72, 72, 72)})
                    end)
                end
            end


            cfg.refresh_options(cfg.options)

            return setmetatable(cfg, library)
        end 

        function library:init_config(window) 
            window:seperator({name = "Settings"})
            local main, playerlist = window:tab({name = "Configs", tabs = {"Main", "Playerlist"}})
            
            local column = main:column({})
            local section = column:section({name = "Configs", size = 1, default = false, icon = "rbxassetid://139628202576511"})
            config_holder = section:list({options = {"Report", "This", "Error", "To", "Finobe"}, callback = function(option) end, flag = "config_name_list"}); library:update_config_list()
            
            local column = main:column({})
            local section = column:section({name = "Settings", side = "right", size = 1, default = false, icon = GetImage("Settings.png")})
            section:textbox({name = "Config name:", flag = "config_name_text"})
            section:button({
                name = "Save",
                callback = function()
                    pcall(function()
                        local config_name = (flags["config_name_text"])
                        writefile(library.directory .. "/configs/" .. config_name .. ".cfg", library:get_config())
                        library:update_config_list()
                        notifications:create_notification({
                            name = "Configs",
                            info = "Saved config to:\n" .. config_name
                        })
                    end)
                end
            })

            section:button({
                name = "Overwrite",
                callback = function()
                    pcall(function()
                        local config_name = (flags["config_name_list"])
                        writefile(library.directory .. "/configs/" .. config_name .. ".cfg", library:get_config())
                        library:update_config_list()
                        notifications:create_notification({
                            name = "Configs",
                            info = "Overwrote config :\n" .. config_name
                        })
                    end)
                end
            })

            section:button({
                name = "Load",
                callback = function()
                    pcall(function()
                        local config_name = flags["config_name_list"]
                        library:load_config(readfile(library.directory .. "/configs/" .. config_name .. ".cfg"))
                        library:update_config_list()
                        notifications:create_notification({
                            name = "Configs",
                            info = "Loaded config:\n" .. config_name
                        })
                    end)
                end
            })

            section:button({
                name = "Delete",
                callback = function()
                pcall(function()
                        local config_name = flags["config_name_list"]
                        delfile(library.directory .. "/configs/" .. config_name .. ".cfg")
                        library:update_config_list()
                        notifications:create_notification({
                            name = "Configs",
                            info = "Deleted config:\n" .. config_name
                        })
                    end)
                end
            })

            local autoload_label = section:label({
                name = "Auto Load: None"
            })

            if isfile(AUTOLOAD_PATH) then
                local name = readfile(AUTOLOAD_PATH)
                autoload_label.set("Auto Load: " .. name)
                AUTOLOAD_ENABLED = true
            else
                autoload_label.set("Auto Load: None")
                AUTOLOAD_ENABLED = false
            end

            section:toggle({
                name = "Auto Load Config",
                flag = "autoload_config",
                default = isfile(AUTOLOAD_PATH),
                callback = function(state)
                    AUTOLOAD_ENABLED = state

                    if state then
                        local name = flags["config_name_list"]
                        if name and name ~= "" then
                            writefile(AUTOLOAD_PATH, name)
                            autoload_label.set("Auto Load: " .. name)
                        end
                    else
                        if isfile(AUTOLOAD_PATH) then
                            delfile(AUTOLOAD_PATH)
                        end
                        autoload_label.set("Auto Load: None")
                    end
                end
            })

            section:toggle({type="toggle",name="Auto Load Script",flag="autoload_enabled",default=false, callback = function(state)
                if state then
                    if script_key then
                        queue_on_teleport([[
                            repeat task.wait() until game:IsLoaded()
                            script_key = "]] .. script_key .. [["
                            loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/73799b33c8b595a10c49253c9e03a221.lua"))()
                        ]])
                    end
                else
                    queue_on_teleport("") --skid behaviour
                end
            end})


             

            section:colorpicker({name = "Menu Accent", callback = function(color, alpha) library:update_theme("accent", color) end, color = themes.preset.accent})
            section:keybind({name = "Menu Bind", key = Enum.KeyCode.Insert, callback = function(bool) window.toggle_menu(bool) end, seperator = true, default = true})

            local _request = (http_request and http_request) or (request and request) or (http and http.request)

            section:button({name = "Join Lowest Server", callback = function()
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
                        name = "volt.gg",
                        info = `You are currently in the smallest server!`,
                        lifetime = 10
                    })
                    return  
                end 
                
                cloneref(game:GetService("TeleportService")):TeleportToPlaceInstance(game.PlaceId, Server.id)
            end})

            section:button({name = "Server Hop", callback = function()
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

            section:button({name = "Rejoin", callback = function()
            cloneref(game:GetService("TeleportService")):TeleportToPlaceInstance(
                game.PlaceId,
                game.JobId
            )         
            end})
                        
            local _column = playerlist:column({})
            local _section = _column:section({name = "Players", size = 1, default = false})

            local plr_list = _section:list({options = {}, flag = "player_list"});

            _column = playerlist:column({})

            _section = _column:section({name = "Player Options", size = 1, default = false, side = 'right'})

            local _playerlabel = _section:label({name = "Selected Player : None"})

            task.spawn(LPH_NO_VIRTUALIZE(function()
                while task.wait(0.5) do
                    _playerlabel.set(string.format("Selected Player : %s", library.flags["player_list"] or "None"))
                end
            end))

            local _statuslabel = _section:label({name = "Status : None"})

            task.spawn(LPH_NO_VIRTUALIZE(function()
                while task.wait(0.5) do
                    local playervalue = library.flags["player_list"]
                    local status

                    if playervalue ~= nil then
                        if table.find(library.priority, playervalue) then
                            status = "<font color='rgb(255,0,0)'>Priority</font>"
                        elseif table.find(library.whitelist, playervalue) then
                            status = "<font color='rgb(0,255,0)'>Whitelisted</font>"
                        else
                            status = "None"
                        end
                    else
                        status = "None"
                    end

                    _statuslabel.set(string.format("Status : %s", status))
                end
            end))

            _section:button({name = "Prioritise", callback = function()
                if not library.flags["player_list"] then return end
                if table.find(library.whitelist, library.flags["player_list"]) then
                    table.remove(library.whitelist, table.find(library.whitelist, library.flags["player_list"]))
                end

                if table.find(library.priority, library.flags["player_list"]) then
                    table.remove(library.priority, table.find(library.priority, library.flags["player_list"]))

                    return
                end

                if not table.find(library.priority, library.flags["player_list"]) then
                    table.insert(library.priority, library.flags["player_list"])
                end
            end})

            _section:button({name = "Whitelist", callback = function()
                if not library.flags["player_list"] then return end
                if table.find(library.priority, library.flags["player_list"]) then
                    table.remove(library.priority, table.find(library.priority, library.flags["player_list"]))
                end

                if table.find(library.whitelist, library.flags["player_list"]) then
                    table.remove(library.whitelist, table.find(library.whitelist, library.flags["player_list"]))

                    return
                end

                if not table.find(library.whitelist, library.flags["player_list"]) then
                    table.insert(library.whitelist, library.flags["player_list"])
                end
            end})

            local refreshplrs = LPH_NO_VIRTUALIZE(function()
                local cache = {}

                for i,v in players:GetPlayers() do
                    if v==lp then continue end

                    table.insert(cache, v.Name)
                end

                table.sort(cache)

                plr_list.refresh_options(cache)
            end)

            task.spawn(refreshplrs)

            players.PlayerAdded:Connect(refreshplrs)

            players.PlayerRemoving:Connect(refreshplrs)
        end
    --

    -- Notification Library
        function notifications:refresh_notifs() 
            local offset = 50

            for i, v in notifications.notifs do
                local Position = vec2(20, offset)
                library:tween(v, {Position = dim_offset(Position.X, Position.Y)}, Enum.EasingStyle.Quad, 0.4)
                offset += (v.AbsoluteSize.Y + 10)
            end

            return offset
        end
        
        function notifications:fade(path, is_fading)
            local fading = is_fading and 1 or 0 
            
            library:tween(path, {BackgroundTransparency = fading}, Enum.EasingStyle.Quad, 1)

            for _, instance in path:GetDescendants() do 
                if not instance:IsA("GuiObject") then 
                    if instance:IsA("UIStroke") then
                        library:tween(instance, {Transparency = fading}, Enum.EasingStyle.Quad, 1)
                    end
        
                    continue
                end 
        
                if instance:IsA("TextLabel") then
                    library:tween(instance, {TextTransparency = fading})
                elseif instance:IsA("Frame") then
                    library:tween(instance, {BackgroundTransparency = instance.Transparency and 0.6 and is_fading and 1 or 0.6}, Enum.EasingStyle.Quad, 1)
                end
            end
        end 
        
        function notifications:create_notification(options)
            local cfg = {
                name = options.name or "This is a title!";
                info = options.info or "This is extra info!";
                lifetime = options.lifetime or 3;
                items = {};
                outline;
            }

            local items = cfg.items; do 
                items[ "notification" ] = library:create( "Frame" , {
                    Parent = library[ "items" ];
                    Size = dim2(0, 210, 0, 53);
                    Name = "\0";
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    BackgroundTransparency = 1;
                    AnchorPoint = vec2(1, 0);
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(14, 14, 16)
                });
                
                library:create( "UIStroke" , {
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
                    Parent = items[ "notification" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 7, 0, 6);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
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
                    Parent = items[ "notification" ];
                    Name = "\0";
                    Position = dim2(0, 9, 0, 22);
                    BorderSizePixel = 0;
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    TextWrapped = true;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIPadding" , {
                    PaddingBottom = dim(0, 17);
                    PaddingRight = dim(0, 8);
                    Parent = items[ "info" ]
                });
                
                items[ "bar" ] = library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = items[ "notification" ];
                    Name = "\0";
                    Position = dim2(0, 8, 1, -6);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 0, 0, 5);
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.accent
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "bar" ];
                    CornerRadius = dim(0, 999)
                });
                
                library:create( "UIPadding" , {
                    PaddingRight = dim(0, 8);
                    Parent = items[ "notification" ]
                });
            end
            
            local index = #notifications.notifs + 1
            notifications.notifs[index] = items[ "notification" ]

            notifications:fade(items[ "notification" ], false)
            
            local offset = notifications:refresh_notifs()

            items[ "notification" ].Position = dim_offset(20, offset)

            library:tween(items[ "notification" ], {AnchorPoint = vec2(0, 0)}, Enum.EasingStyle.Quad, 1)
            library:tween(items[ "bar" ], {Size = dim2(1, -8, 0, 5)}, Enum.EasingStyle.Quad, cfg.lifetime)

            task.spawn(LPH_NO_VIRTUALIZE(function()
                task.wait(cfg.lifetime)
                
                notifications.notifs[index] = nil
                
                notifications:fade(items[ "notification" ], true)
                
                library:tween(items[ "notification" ], {AnchorPoint = vec2(1, 0)}, Enum.EasingStyle.Quad, 1)

                task.wait(1)
        
                items[ "notification" ]:Destroy() 
            end))
        end
    --end)()
    else
            --LPH_JIT_MAX(function()

-- Variables
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
-- 

-- Library ini

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
            if not isfile(Asset.Id) then
                writefile(Asset.Id, Asset.Font)
            end

            if isfile(Name .. ".font") then
                delfile(Name .. ".font")
            end

            local Data = {
                name = Name,
                faces = {
                    {
                        name = "Normal",
                        weight = Weight,
                        style = Style,
                        assetId = getcustomasset(Asset.Id),
                    },
                },
            }

            writefile(Name .. ".font", http_service:JSONEncode(Data))

            return getcustomasset(Name .. ".font");
        end
        
        local Medium = Register_Font("Meawdawdawddium", 200, "Normal", {
            Id = "Mediumawdwad.ttf",
            Font = game:HttpGet("https://github.com/SleepyScriptsHolderAntiSkids/storage/raw/refs/heads/main/fonts/Inter_28pt-Medium.ttf"),
        })

        local SemiBold = Register_Font("SeawdawdawdawdmiBold", 200, "Normal", {
            Id = "SemiBoldawdawdwad.ttf",
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

        local config_holder;
        function library:update_config_list() 
            if not config_holder then 
                return 
            end
            
            local list = {}
            
            for idx, file in listfiles(library.directory .. "/configs") do
                local name = file:gsub(library.directory .. "/configs\\", ""):gsub(".cfg", ""):gsub(library.directory .. "\\configs\\", "")
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
            
            for _, v in config do 
                local function_set = library.config_flags[_]
                
                if _ == "config_name_list" then 
                    continue 
                end

                if function_set then 
                    if type(v) == "table" and v["Transparency"] and v["Color"] then
                        function_set(hex(v["Color"]), v["Transparency"])
                    elseif type(v) == "table" and v["active"] then 
                        function_set(v)
                    else
                        function_set(v)
                    end
                end 
            end 
        end 


          local AUTOLOAD_PATH = library.directory .. "/autoload/autoload.cfg"

          local AUTOLOAD_ENABLED = false


        task.defer(function()
            if not AUTOLOAD_ENABLED then
                return
            end

            if isfile(AUTOLOAD_PATH) then
                local name = readfile(AUTOLOAD_PATH)
                local path = library.directory .. "/configs/" .. name .. ".cfg"

                if isfile(path) then
                    pcall(function()
                        library:load_config(readfile(path))
                    end)
                end
            end
        end)

        
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
                Parent = coregui;
                Name = "\0";
                Enabled = true;
                ZIndexBehavior = Enum.ZIndexBehavior.Global;
                IgnoreGuiInset = true;
            });

            library[ "other" ] = library:create( "ScreenGui" , {
                Parent = coregui;
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
                    BackgroundColor3 = rgb(14, 14, 16)
                }); items[ "main" ].Position = dim2(0, items[ "main" ].AbsolutePosition.X, 0, items[ "main" ].AbsolutePosition.Y)

                library:create( "UIScale" , {
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

            do -- Other
                library:draggify(items[ "main" ])
                library:resizify(items[ "main" ])
            end 

            function cfg.toggle_menu(bool) 
                -- WIP 
                -- if cfg.tween then 
                --     cfg.tween:Cancel()
                -- end 

                -- items[ "main" ].Size = dim2(items[ "main" ].Size.Scale.X, items[ "main" ].Size.Offset.X - 20, items[ "main" ].Size.Scale.Y, items[ "main" ].Size.Offset.Y - 20)
                -- library:tween(items[ "tab_holder" ], {Size = dim2(1, -196, 1, -81)}, Enum.EasingStyle.Quad, 0.4)
                -- cfg.tween = 
                
                items[ "main" ].Visible = bool
            end 

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
            
            library:create( "UIStroke" , {
                Color = rgb(23, 23, 29);
                Parent = items[ "close button" ];
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            });

            local open = true 
            items[ "close button" ].InputBegan:Connect(LPH_NO_VIRTUALIZE(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.Touch then
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
                
                -- multi 
                tabs = properties.tabs or properties.Tabs or {"Main", "Misc.", "Settings"};
                pages = {}; -- data store for multi sections
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
                
                -- Tab buttons 
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
                -- 

                -- Multi Sections
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
                            -- Button
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
                            --

                            -- Tab 
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
                            --
                        end
                        
                        data.text = multi_items[ "name" ]
                        data.accent = multi_items[ "accent" ]
                        data.button = multi_items[ "button" ]
                        data.page = multi_items[ "tab" ]
                        data.parent = setmetatable(data, library):sub_tab({}).items[ "tab_parent" ]
                        
                        -- Old column code
                        -- data.left = multi_items[ "left" ]
                        -- data.right = multi_items[ "right" ]

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
                --
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
            end

            return unpack(cfg.pages)
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

        -- Miscellaneous 
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
                    
                    library:create( "UIPadding" , {
                        PaddingBottom = dim(0, 10);
                        Parent = items[ "column" ]
                    });
                    
                    library:create( "UIListLayout" , {
                        Parent = items[ "column" ];
                        HorizontalFlex = Enum.UIFlexAlignment.Fill;
                        Padding = dim(0, 10);
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
        --

        function library:section(properties)
            local cfg = {
                name = properties.name or properties.Name or "section"; 
                side = properties.side or properties.Side or "left";
                default = properties.default or properties.Default or false;
                size = properties.size or properties.Size or self.size or 0.5; 
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
                    Size = dim2(1, 0, 1, -40);
                    BackgroundTransparency = 1;
                    Position = dim2(0, 0, 0, 35);
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
                    Padding = dim(0, 10);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });
                
                library:create( "UIPadding" , {
                    PaddingBottom = dim(0, 15);
                    Parent = items[ "elements" ]
                });
                
                items[ "button" ] = library:create( "TextButton" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(255, 255, 255);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    AutoButtonColor = false;
                    Parent = items[ "outline" ];
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    Size = dim2(1, -2, 0, 35);
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
                items[ "button" ].InputBegan:Connect(LPH_NO_VIRTUALIZE(function(input)
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

            return setmetatable(cfg, library)
        end  

        function library:toggle(options) 
            local rand = math.random(1, 2) 
            local cfg = {
                enabled = options.default or false,
                name = options.name or "Toggle",
                info = options.info or nil,
                flag = options.flag or library:next_flag(),
                
                type = options.type and string.lower(options.type) or rand == 1 and "toggle" or "checkbox"; -- "toggle", "checkbox"

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
                
                -- Toggle
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
                --                
            end;
            
            function cfg.set(bool)
                if cfg.type == "checkbox" then 
                    library:tween(items[ "tick" ], {Rotation = bool and 0 or 45, ImageTransparency = bool and 0 or 1})
                    library:tween(items[ "toggle_button" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(67, 67, 68)})
                    library:tween(items[ "outline" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(22, 22, 24)})
                else
                    library:tween(items[ "toggle_button" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(58, 58, 62)}, Enum.EasingStyle.Quad)
                    library:tween(items[ "inline" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(50, 50, 50)}, Enum.EasingStyle.Quad)
                    library:tween(items[ "circle" ], {BackgroundColor3 = bool and rgb(255, 255, 255) or rgb(86, 86, 88), Position = bool and dim2(1, -14, 0, 2) or dim2(0, 2, 0, 2)}, Enum.EasingStyle.Quad)
                end

                cfg.enabled = bool
                cfg.callback(bool)

                if cfg.folding then 
                    elements.Visible = bool
                end

                flags[cfg.flag] = bool
            end 
            
            items[ "toggle" ].InputBegan:Connect(LPH_NO_VIRTUALIZE(function(Input)
                if Input.UserInputType ~= Enum.UserInputType.Touch then return end
                cfg.enabled = not cfg.enabled 
                cfg.set(cfg.enabled)
            end))

            items[ "toggle_button" ].InputBegan:Connect(LPH_NO_VIRTUALIZE(function(Input)
                if Input.UserInputType ~= Enum.UserInputType.Touch then return end
                cfg.enabled = not cfg.enabled 
                cfg.set(cfg.enabled)
            end))
            
            if cfg.seperator then -- ok bro my lua either sucks or this was a pain in the ass to make (simple if statement aswell 💔)
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

                -- value settings
                min = options.min or options.minimum or 0,
                max = options.max or options.maximum or 100,
                intervals = options.interval or options.decimal or 1,
                default = options.default or 10,
                value = options.default or 10, 
                seperator = options.seperator or options.Seperator or false;

                dragging = false,
                items = {}
            } 

            flags[cfg.flag] = cfg.default

            local items = cfg.items; do
                items[ "slider_object" ] = library:create( "TextButton" , {
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
                    Parent = items[ "slider_object" ];
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
                        Parent = items[ "slider_object" ];
                        Name = "\0";
                        Position = dim2(0, 5, 0, 37);
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
                    Parent = items[ "slider_object" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 4, 0, 23);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 12);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIListLayout" , {
                    Parent = items[ "right_components" ];
                    Padding = dim(0, 7);
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    FillDirection = Enum.FillDirection.Horizontal
                });
                
                items[ "slider" ] = library:create( "TextButton" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    AutoButtonColor = false;
                    AnchorPoint = vec2(1, 0);
                    Parent = items[ "right_components" ];
                    Name = "\0";
                    Position = dim2(1, 0, 0, 0);
                    Size = dim2(1, -4, 0, 4);
                    BorderSizePixel = 0;
                    TextSize = 14;
                    BackgroundColor3 = rgb(33, 33, 35)
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "slider" ];
                    CornerRadius = dim(0, 999)
                });
                
                items[ "fill" ] = library:create( "Frame" , {
                    Name = "\0";
                    Parent = items[ "slider" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0.5, 0, 0, 4);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.accent
                });  library:apply_theme(items[ "fill" ], "accent", "BackgroundColor3");
                
                library:create( "UICorner" , {
                    Parent = items[ "fill" ];
                    CornerRadius = dim(0, 999)
                });
                
                items[ "circle" ] = library:create( "Frame" , {
                    AnchorPoint = vec2(0.5, 0.5);
                    Parent = items[ "fill" ];
                    Name = "\0";
                    Position = dim2(1, 0, 0.5, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 12, 0, 12);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(244, 244, 244)
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "circle" ];
                    CornerRadius = dim(0, 999)
                });
                
                library:create( "UIPadding" , {
                    Parent = items[ "right_components" ];
                    PaddingTop = dim(0, 4)
                });
                
                items[ "value" ] = library:create( "TextLabel" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(72, 72, 73);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "50%";
                    Parent = items[ "slider_object" ];
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    Position = dim2(0, 6, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Right;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 16;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIPadding" , {
                    Parent = items[ "value" ];
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });                
            end 

            function cfg.changetext(text)
                items['name'].Text = text
            end 

            function cfg.set(value)
                cfg.value = clamp(library:round(value, cfg.intervals), cfg.min, cfg.max)

                library:tween(items[ "fill" ], {Size = dim2((cfg.value - cfg.min) / (cfg.max - cfg.min), cfg.value == cfg.min and 0 or -4, 0, 2)}, Enum.EasingStyle.Linear, 0.05)
                items[ "value" ].Text = tostring(cfg.value) .. cfg.suffix

                flags[cfg.flag] = cfg.value
                cfg.callback(flags[cfg.flag])
            end

            items[ "slider" ].InputBegan:Connect(LPH_NO_VIRTUALIZE(function(Input)
                            if Input.UserInputType ~= Enum.UserInputType.Touch then return end
                cfg.dragging = true 
                library:tween(items[ "value" ], {TextColor3 = rgb(255, 255, 255)}, Enum.EasingStyle.Quad, 0.2)
            end))

            library:connection(uis.InputChanged, function(input)
                if cfg.dragging and input.UserInputType == Enum.UserInputType.Touch then 
                    local size_x = (input.Position.X - items[ "slider" ].AbsolutePosition.X) / items[ "slider" ].AbsoluteSize.X
                    local value = ((cfg.max - cfg.min) * size_x) + cfg.min
                    cfg.set(value)
                end
            end)

            library:connection(uis.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    cfg.dragging = false
                    library:tween(items[ "value" ], {TextColor3 = rgb(72, 72, 73)}, Enum.EasingStyle.Quad, 0.2) 
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

                -- Ignore these 
                open = false;
                option_instances = {};
                multi_items = {};
                ignore = options.ignore or false;
                items = {};
                y_size;
                seperator = options.seperator or options.Seperator or true;
            }   

            cfg.default = options.default or (cfg.multi and {cfg.items[1]}) or cfg.items[1] or "None"
            flags[cfg.flag] = cfg.default

            local items = cfg.items; do 
                -- Element
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
                        Text = "Dropdown";
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
                        CornerRadius = dim(0, 4)
                    });
                    
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
                    
                    items[ "indicator" ] = library:create( "ImageLabel" , {
                        ImageColor3 = rgb(86, 86, 87);
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = items[ "dropdown" ];
                        AnchorPoint = vec2(1, 0.5);
                        Image = "rbxassetid://101025591575185";
                        BackgroundTransparency = 1;
                        Position = dim2(1, -5, 0.5, 0);
                        Name = "\0";
                        Size = dim2(0, 12, 0, 12);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                -- 

                -- Element Holder
                    items[ "dropdown_holder" ] = library:create( "Frame" , {
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = library[ "items" ];
                        Name = "\0";
                        Visible = true;
                        BackgroundTransparency = 1;
                        Size = dim2(0, 0, 0, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0);
                        ZIndex = 10;
                    });
                    
                    items[ "outline" ] = library:create( "Frame" , {
                        Parent = items[ "dropdown_holder" ];
                        Size = dim2(1, 0, 1, 0);
                        ClipsDescendants = true;
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(33, 33, 35);
                        ZIndex = 10;
                    });
                    
                    library:create( "UIPadding" , {
                        PaddingBottom = dim(0, 6);
                        PaddingTop = dim(0, 3);
                        PaddingLeft = dim(0, 3);
                        Parent = items[ "outline" ]
                    });
                    
                    library:create( "UIListLayout" , {
                        Parent = items[ "outline" ];
                        Padding = dim(0, 5);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "outline" ];
                        CornerRadius = dim(0, 4)
                    });
                -- 
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
            
            function cfg.set_visible(bool)
                local a = bool and cfg.y_size or 0
                library:tween(items[ "dropdown_holder" ], {Size = dim_offset(items[ "dropdown" ].AbsoluteSize.X, a)})

                items[ "dropdown_holder" ].Position = dim2(0, items[ "dropdown" ].AbsolutePosition.X, 0, items[ "dropdown" ].AbsolutePosition.Y + 80)
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
            end
            
            function cfg.refresh_options(list) 
                cfg.y_size = 0

                for _, option in cfg.option_instances do 
                    option:Destroy() 
                end
                
                cfg.option_instances = {} 

                for _, option in list do 
                    local button = cfg.render_option(option)
                    cfg.y_size += button.AbsoluteSize.Y + 6 -- super annoying manual sizing but oh well
                    insert(cfg.option_instances, button)
                    
                    button.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(Input)
                            if Input.UserInputType ~= Enum.UserInputType.Touch then return end
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

            items[ "dropdown" ].InputBegan:Connect(LPH_NO_VIRTUALIZE(function(input)
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
                
            return setmetatable(cfg, library)
        end

        function library:label(options)
            local cfg = {
                enabled = options.enabled or nil,
                name = options.name or "Toggle",
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
                    Parent = items[ "label" ];
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

            return setmetatable(cfg, library)
        end 
        
        function library:colorpicker(options) 
            local cfg = {
                name = options.name or "Color", 
                flag = options.flag or library:next_flag(),

                color = options.color or color(1, 1, 1), -- Default to white color if not provided
                alpha = options.alpha and 1 - options.alpha or 0,
                
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
                -- Component
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
                --
                
                -- Colorpicker
                    items[ "colorpicker_holder" ] = library:create( "Frame" , {
                        Parent = library[ "other" ];
                        Name = "\0";
                        Position = dim2(0.20000000298023224, 20, 0.296999990940094, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 166, 0, 197);
                        BorderSizePixel = 0;
                        Visible = true;
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
                    
                    items[ "UICorenr" ] = library:create( "UICorner" , { -- fire misstypo (im not fixing this RAWR)
                        Parent = items[ "colorpicker_holder" ];
                        Name = "\0";
                        CornerRadius = dim(0, 4)
                    });
                --                  
            end;

            function cfg.set_visible(bool)
                items[ "colorpicker_fade" ].BackgroundTransparency = 0
                items[ "colorpicker_holder" ].Parent = bool and library[ "items" ] or library[ "other" ]
                items[ "colorpicker_holder" ].Position = dim_offset(items[ "colorpicker" ].AbsolutePosition.X, items[ "colorpicker" ].AbsolutePosition.Y + items[ "colorpicker" ].AbsoluteSize.Y + 45)

                library:tween(items[ "colorpicker_fade" ], {BackgroundTransparency = 1}, Enum.EasingStyle.Quad, 0.4)
                library:tween(items[ "colorpicker_holder" ], {Position = items[ "colorpicker_holder" ].Position + dim_offset(0, 20)}) -- p100 check
                
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

                -- Ok so quick story, should I cache any of this? no...?? anyways I know this code is very bad but its your fault for buying a ui with animations (on a serious note im too lazy to make this look nice)
                -- Also further note, yeah I kind of did this scale_factor * size-valuesize.plane because then I would have to do tomfoolery to make it clip properly.
                library:tween(items[ "hue_picker" ], {Position = dim2(0, (items[ "hue_gradient" ].AbsoluteSize.X - items[ "hue_picker" ].AbsoluteSize.X) * h, 0.5, 0)}, Enum.EasingStyle.Linear, 0.05)
                library:tween(items[ "alpha_picker" ], {Position = dim2(0, (items[ "alpha_gradient" ].AbsoluteSize.X - items[ "alpha_picker" ].AbsoluteSize.X) * (1 - a), 0.5, 0)}, Enum.EasingStyle.Linear, 0.05)
                library:tween(items[ "satvalpicker" ], {Position = dim2(0, s * (items[ "saturation_holder" ].AbsoluteSize.X - items[ "satvalpicker" ].AbsoluteSize.X), 1, 1 - v * (items[ "saturation_holder" ].AbsoluteSize.Y - items[ "satvalpicker" ].AbsoluteSize.Y))}, Enum.EasingStyle.Linear, 0.05)

                items[ "alpha_indicator" ]:FindFirstChildOfClass("UIGradient").Color = rgbseq{rgbkey(0, rgb(112, 112, 112)), rgbkey(1, hsv(h, 1, 1))}; -- shit code
                
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

            items[ "colorpicker" ].InputBegan:Connect(LPH_NO_VIRTUALIZE(function(input)
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
                items = {};
            }

            flags[cfg.flag] = cfg.default

            local items = cfg.items; do 
                items[ "textbox" ] = library:create( "TextButton" , {
                    LayoutOrder = -1;
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
                    Parent = items[ "textbox" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 4, 0, 19);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 12);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIListLayout" , {
                    Parent = items[ "right_components" ];
                    Padding = dim(0, 7);
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    FillDirection = Enum.FillDirection.Horizontal
                });
                
                items[ "input" ] = library:create( "TextBox" , {
                    FontFace = fonts.font;
                    Text = "";
                    Parent = items[ "right_components" ];
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
                    Position = dim2(1, 0, 0, 0);
                    Size = dim2(1, -4, 0, 30);
                    BackgroundColor3 = rgb(33, 33, 35)
                }); 

                library:create( "UICorner" , {
                    Parent = items[ "input" ];
                    CornerRadius = dim(0, 3)
                });                
                
                library:create( "UIPadding" , {
                    Parent = items[ "right_components" ];
                    PaddingTop = dim(0, 4);
                    PaddingRight = dim(0, 4)
                });
            end 
            
            function cfg.set(text) 
                flags[cfg.flag] = text

                items[ "input" ].Text = text

                cfg.callback(text)
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

                key = options.key or nil, 
                mode = options.mode or "Toggle",
                active = options.default or false, 

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
                -- Component
                    items[ "keybind_element" ] = library:create( "TextButton" , {
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
                -- 
                
                -- Mode Holder
                    items[ "dropdown" ] = library:create( "Frame" , {
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = library.items;
                        Name = "\0";
                        BackgroundTransparency = 1;
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
                            TextColor3 = rgb(72, 72, 73);
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
                        library:apply_theme(name, "accent", "TextColor3")
                        
                        cfg.y_size += name.AbsoluteSize.Y

                        library:create( "UIPadding" , {
                            Parent = name;
                            PaddingTop = dim(0, 1);
                            PaddingRight = dim(0, 5);
                            PaddingLeft = dim(0, 5)
                        });

                        name.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(input)
                            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.Touch then
                                cfg.set(option)
                                cfg.set_visible(false)
                                cfg.open = false
                            end 
                        end))
                    end
                -- 
            end 
            
            function cfg.modify_mode_color(path) -- ts so frikin tuff 💀
                for _, v in cfg.hold_instances do 
                    v.TextColor3 = rgb(72, 72, 72)
                end 

                cfg.hold_instances[path].TextColor3 = themes.preset.accent
            end

            function cfg.set_mode(mode) 
                cfg.mode = mode 

                if mode == "Always" then
                    cfg.set(true)
                elseif mode == "Hold" then
                    cfg.set(false)
                end

                flags[cfg.flag]["mode"] = mode
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
                    cfg.mode = input.mode or "Toggle"

                    if input.active then
                        cfg.active = input.active
                    end

                    cfg.set_mode(cfg.mode) 
                end 

                cfg.callback(cfg.active)

                local text = tostring(cfg.key) ~= "Enums" and (keys[cfg.key] or tostring(cfg.key):gsub("Enum.", "")) or nil
                local __text = text and (tostring(text):gsub("KeyCode.", ""):gsub("UserInputType.", ""))
                
                items[ "key" ].Text = __text

                flags[cfg.flag] = {
                    mode = cfg.mode,
                    key = cfg.key, 
                    active = cfg.active
                }
            end

            function cfg.set_visible(bool)
                local size = bool and cfg.y_size or 0
                library:tween(items[ "dropdown" ], {Size = dim_offset(items[ "keybind_holder" ].AbsoluteSize.X, size)})

                items[ "dropdown" ].Position = dim_offset(items[ "keybind_holder" ].AbsolutePosition.X, items[ "keybind_holder" ].AbsolutePosition.Y + items[ "keybind_holder" ].AbsoluteSize.Y + 60)
            end
        
            items[ "keybind_holder" ].InputBegan:Connect(LPH_NO_VIRTUALIZE(function(Input)
                            if Input.UserInputType ~= Enum.UserInputType.Touch then return end
                task.wait()
                items[ "key" ].Text = "..."	

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
            local cfg = {
                name = options.name or "TextBox",
                callback = options.callback or function() end,
                items = {};
            }
            
            local items = cfg.items; do 
                items[ "button_element" ] = library:create( "Frame" , {
                    Parent = self.items[ "elements" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                items[ "button" ] = library:create( "TextButton" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    AutoButtonColor = false;
                    AnchorPoint = vec2(1, 0);
                    Parent = items[ "button_element" ];
                    Name = "\0";
                    Position = dim2(1, -4, 0, 0);
                    Size = dim2(1, -8, 0, 30);
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
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); library:apply_theme(items[ "name" ], "accent", "BackgroundColor3");                            
            end 

            items[ "button" ].InputBegan:Connect(LPH_NO_VIRTUALIZE(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.Touch then
                    cfg.callback()

                    items[ "name" ].TextColor3 = themes.preset.accent 
                    library:tween(items[ "name" ], {TextColor3 = rgb(245, 245, 245)})
                end
            end))
            
            return setmetatable(cfg, library)
        end 

        function library:settings(options)  
            local cfg = {
                open = false; 
                items = {}; 
                sanity = true; -- made this for my own sanity.
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
                    Padding = dim(0, 10);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });
                
                library:create( "UIPadding" , {
                    PaddingBottom = dim(0, 15);
                    Parent = items[ "elements" ]
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
            
            items[ "tick" ].InputBegan:Connect(LPH_NO_VIRTUALIZE(function(input)
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
                for _,option in cfg.data_store do 
                    option:Destroy()
                end

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
                        TextColor3 = rgb(72, 72, 73);
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

                    button.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(input)
                        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.Touch then
                            local current = cfg.current_element 

                            if current and current ~= name then 
                                library:tween(current, {TextColor3 = rgb(72, 72, 72)})
                            end
                            
                            flags[cfg.flag] = option_data
                            cfg.callback(option_data)
                            library:tween(name, {TextColor3 = rgb(245, 245, 245)})
                            cfg.current_element = name
                        end 
                    end))

                    name.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
                        if cfg.current_element == name then 
                            return 
                        end 

                        library:tween(name, {TextColor3 = rgb(140, 140, 140)})
                    end))

                    name.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
                        if cfg.current_element == name then 
                            return 
                        end 

                        library:tween(name, {TextColor3 = rgb(72, 72, 72)})
                    end))
                end
            end

            cfg.refresh_options(cfg.options)

            return setmetatable(cfg, library)
        end 

        function library:init_config(window) 
            local text;
            window:seperator({name = "Settings"})
            local main = window:tab({name = "Configs", tabs = {"Main"}})
            
            local column = main:column({})
            local section = column:section({name = "Configs", size = 1, default = true, icon = "rbxassetid://139628202576511"})
            config_holder = section:list({options = {"Report", "This", "Error", "To", "Finobe"}, callback = function(option)
                if text then 
                    text.set(option)
                end 
            end, flag = "config_name_list"}); library:update_config_list()
            
            local column = main:column({})
            local section = column:section({name = "Settings", side = "right", size = 1, default = true, icon = "rbxassetid://129380150574313"})
            text = section:textbox({name = "Config name:", flag = "config_name_text"})
            section:button({name = "Save", callback = function() writefile(library.directory .. "/configs/" .. flags["config_name_text"] .. ".cfg", library:get_config()) library:update_config_list() notifications:create_notification({name = "Configs", info = "Saved config to:\n" .. flags["config_name_text"] or flags["config_name_text"]}) end}) 
            section:button({name = "Load", callback = function() library:load_config(readfile(library.directory .. "/configs/" .. flags["config_name_text"] .. ".cfg"))  library:update_config_list() notifications:create_notification({name = "Configs", info = "Loaded config:\n" .. flags["config_name_text"]}) end})
            section:button({name = "Delete", callback = function() delfile(library.directory .. "/configs/" .. flags["config_name_text"] .. ".cfg")  library:update_config_list() notifications:create_notification({name = "Configs", info = "Deleted config:\n" .. flags["config_name_text"]}) end})
            section:colorpicker({name = "Menu Accent", callback = function(color, alpha) library:update_theme("accent", color) end, color = themes.preset.accent})
            section:keybind({name = "Menu Bind", callback = function(bool) window.toggle_menu(bool) end, default = true})
        end
    --

    -- Notification Library
        function notifications:refresh_notifs() 
            local offset = 50

            for i, v in notifications.notifs do
                local Position = vec2(20, offset)
                library:tween(v, {Position = dim_offset(Position.X, Position.Y)}, Enum.EasingStyle.Quad, 0.4)
                offset += (v.AbsoluteSize.Y + 10)
            end

            return offset
        end
        
        function notifications:fade(path, is_fading)
            local fading = is_fading and 1 or 0 
            
            library:tween(path, {BackgroundTransparency = fading}, Enum.EasingStyle.Quad, 1)

            for _, instance in path:GetDescendants() do 
                if not instance:IsA("GuiObject") then 
                    if instance:IsA("UIStroke") then
                        library:tween(instance, {Transparency = fading}, Enum.EasingStyle.Quad, 1)
                    end
        
                    continue
                end 
        
                if instance:IsA("TextLabel") then
                    library:tween(instance, {TextTransparency = fading})
                elseif instance:IsA("Frame") then
                    library:tween(instance, {BackgroundTransparency = instance.Transparency and 0.6 and is_fading and 1 or 0.6}, Enum.EasingStyle.Quad, 1)
                end
            end
        end 
        
        function notifications:create_notification(options)
            local cfg = {
                name = options.name or "This is a title!";
                info = options.info or "This is extra info!";
                lifetime = options.lifetime or 3;
                items = {};
                outline;
            }

            local items = cfg.items; do 
                items[ "notification" ] = library:create( "Frame" , {
                    Parent = library[ "items" ];
                    Size = dim2(0, 210, 0, 53);
                    Name = "\0";
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    BackgroundTransparency = 1;
                    AnchorPoint = vec2(1, 0);
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(14, 14, 16)
                });

                library:create( "UIScale" , {
                    Parent = items[ "notification" ];
                    Scale = scale;
                });
                
                library:create( "UIStroke" , {
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
                    Parent = items[ "notification" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 7, 0, 6);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
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
                    Parent = items[ "notification" ];
                    Name = "\0";
                    Position = dim2(0, 9, 0, 22);
                    BorderSizePixel = 0;
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    TextWrapped = true;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIPadding" , {
                    PaddingBottom = dim(0, 17);
                    PaddingRight = dim(0, 8);
                    Parent = items[ "info" ]
                });
                
                items[ "bar" ] = library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = items[ "notification" ];
                    Name = "\0";
                    Position = dim2(0, 8, 1, -6);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 0, 0, 5);
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.accent
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "bar" ];
                    CornerRadius = dim(0, 999)
                });
                
                library:create( "UIPadding" , {
                    PaddingRight = dim(0, 8);
                    Parent = items[ "notification" ]
                });
            end
            
            local index = #notifications.notifs + 1
            notifications.notifs[index] = items[ "notification" ]

            notifications:fade(items[ "notification" ], false)
            
            local offset = notifications:refresh_notifs()

            items[ "notification" ].Position = dim_offset(20, offset)

            library:tween(items[ "notification" ], {AnchorPoint = vec2(0, 0)}, Enum.EasingStyle.Quad, 1)
            library:tween(items[ "bar" ], {Size = dim2(1, -8, 0, 5)}, Enum.EasingStyle.Quad, cfg.lifetime)

            task.spawn(function()
                task.wait(cfg.lifetime)
                
                notifications.notifs[index] = nil
                
                notifications:fade(items[ "notification" ], true)
                
                library:tween(items[ "notification" ], {AnchorPoint = vec2(1, 0)}, Enum.EasingStyle.Quad, 1)

                task.wait(1)
        
                items[ "notification" ]:Destroy() 
            end)
        end
    --end)()


    return library
 