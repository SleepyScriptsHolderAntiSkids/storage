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

local DuelLibrary = require(replicated_storage:FindFirstChild("DuelLibrary", true))


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





local GetPlayerWeaponName = function(player)
    if not fighter_controller then
        return "None"
    end

    local fighter = fighter_controller:GetFighter(player)
    if not fighter then
        return "None"
    end

    local item = fighter.EquippedItem
    if item and item.Name then
        return item.Name
    end

    return "None"
end


getgenv().Players_ESP = {}

getgenv().RefreshAllElements = LPH_NO_VIRTUALIZE(function()
    for i,v in Players_ESP do
        if v and v.RefreshElements then
            v.RefreshElements()
        end
    end 
end)

do
    local Workspace = cloneref(game:GetService("Workspace"))
    local RunService = cloneref(game:GetService("RunService"))
    local Players = cloneref(game:GetService("Players"))
    local CoreGui = cloneref(game:GetService("CoreGui"))

    -- Def & Vars
    local Euphoria = Config.ESP.Connections;
    local lplayer = Players.LocalPlayer;
    local Cam = Workspace.CurrentCamera;
    local RotationAngle, Tick = -45, tick();

    -- Single shared render loop for ALL entities (replaces one RenderStepped
    -- connection per player). Each entity registers its updater by name; the
    -- loop iterates them once per frame. pcall keeps one bad entity from
    -- killing ESP for the rest, matching the old per-connection isolation.
    local ESP_UPDATERS = {}
    Euphoria.RunService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function()
        for _, updater in pairs(ESP_UPDATERS) do
            pcall(updater)
        end
    end))

    local Functions = {}
    do
        function Functions:Create(Class, Properties)
            local _Instance = typeof(Class) == 'string' and Instance.new(Class) or Class
            for Property, Value in pairs(Properties) do
                _Instance[Property] = Value
            end
            return _Instance;
        end
        --
        Functions.FadeOutOnDist = LPH_NO_VIRTUALIZE(function(element, distance)
            local transparency = math.max(0.1, 1 - (distance / Config.ESP.MaxDistance))
            if element:IsA("TextLabel") then
                element.TextTransparency = 1 - transparency
            elseif element:IsA("ImageLabel") then
                element.ImageTransparency = 1 - transparency
            elseif element:IsA("UIStroke") then
                element.Transparency = 1 - transparency
            elseif element:IsA("Frame") and (element == Healthbar or element == BehindHealthbar) then
                element.BackgroundTransparency = 1 - transparency
            elseif element:IsA("Frame") then
                element.BackgroundTransparency = 1 - transparency
            elseif element:IsA("Highlight") then
                element.FillTransparency = 1 - transparency
                element.OutlineTransparency = 1 - transparency
            end;
        end);  

        Functions.AddOutline = LPH_NO_VIRTUALIZE(function(Frame, Thickness)     
            Functions:Create("Frame", {
                Parent = Frame,
                BorderSizePixel = 0,
                BackgroundColor3 = Color3.new(0, 0, 0),
                Position = UDim2.new(0, -Thickness, 0, -Thickness),
                Size = UDim2.new(1, Thickness * 2, 0, Thickness),
                ZIndex = Frame.ZIndex - 1
            })
        
            Functions:Create("Frame", {
                Parent = Frame,
                BorderSizePixel = 0,
                BackgroundColor3 = Color3.new(0, 0, 0),
                Position = UDim2.new(0, -Thickness, 1, 0),
                Size = UDim2.new(1, Thickness * 2, 0, Thickness),
                ZIndex = Frame.ZIndex - 1
            })
        
            Functions:Create("Frame", {
                Parent = Frame,
                BorderSizePixel = 0,

                BackgroundColor3 = Color3.new(0, 0, 0),
                Position = UDim2.new(0, -Thickness, 0, 0),
                Size = UDim2.new(0, Thickness, 1, 0),
                ZIndex = Frame.ZIndex - 1
            })
        
            Functions:Create("Frame", {
                Parent = Frame,
                BorderSizePixel = 0,

                BackgroundColor3 = Color3.new(0, 0, 0),
                Position = UDim2.new(1, 0, 0, 0),
                Size = UDim2.new(0, Thickness, 1, 0),
                ZIndex = Frame.ZIndex - 1
            })
        end)
    end;

    do -- Initalize
        local ScreenGui = Functions:Create("ScreenGui", {
            Parent = CoreGui,
            Name = "ESPHolder",
            ResetOnSpawn = false,
        });

        local DupeCheck = LPH_NO_VIRTUALIZE(function(plr)
            if ScreenGui:FindFirstChild(plr.Name) then
                ScreenGui[plr.Name]:Destroy()
            end
        end)

        local getHealthColor = LPH_NO_VIRTUALIZE(function(currentHealth, maxHealth)    
            return Config.ESP.Drawing.Healthbar.GradientRGB1:Lerp(Config.ESP.Drawing.Healthbar.GradientRGB2, (currentHealth / maxHealth))
        end)

        local ESP = function(plr)
            task.spawn(LPH_JIT_MAX(function()
            if plr == lplayer then return end

            coroutine.wrap(DupeCheck)(plr)
            local Name = Functions:Create("TextLabel", {Visible = false,Parent = ScreenGui, Position = UDim2.new(0.5, 0, 0, -11), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = Config.ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0), RichText = true})
            local Distance = Functions:Create("TextLabel", {Visible = false,Parent = ScreenGui, Position = UDim2.new(0.5, 0, 0, 11), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = Config.ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0), RichText = true})
            local Weapon = Functions:Create("TextLabel", {Visible = false,Parent = ScreenGui, Position = UDim2.new(0.5, 0, 0, 31), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = Config.ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0), RichText = true, Text = "None"})
            local Box = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 0.75, BorderSizePixel = 0})
            local Gradient1 = Functions:Create("UIGradient", {Parent = Box, Enabled = Config.ESP.Drawing.Boxes.GradientFill, Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Config.ESP.Drawing.Boxes.GradientFillRGB1), ColorSequenceKeypoint.new(1, Config.ESP.Drawing.Boxes.GradientFillRGB2)}})
            local Outline = Functions:Create("UIStroke", {Parent = Box, Enabled = Config.ESP.Drawing.Boxes.Gradient, Transparency = 0, Color = Color3.fromRGB(255, 255, 255), LineJoinMode = Enum.LineJoinMode.Miter})
            local Gradient2 = Functions:Create("UIGradient", {Parent = Outline, Enabled = Config.ESP.Drawing.Boxes.Gradient, Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Config.ESP.Drawing.Boxes.GradientRGB1), ColorSequenceKeypoint.new(1, Config.ESP.Drawing.Boxes.GradientRGB2)}})
            local Healthbar = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0})
            local BehindHealthbar = Functions:Create("Frame", {BorderColor3 = Color3.fromRGB(0, 0, 0), Parent = ScreenGui, ZIndex = -1, BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 0})
            local HealthbarGradient = Functions:Create("UIGradient", {Parent = Healthbar, Enabled = Config.ESP.Drawing.Healthbar.Gradient, Rotation = -90, Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Config.ESP.Drawing.Healthbar.GradientRGB1), ColorSequenceKeypoint.new(1, Config.ESP.Drawing.Healthbar.GradientRGB2)}})
            local HealthText = Functions:Create("TextLabel", {Visible = false,Parent = ScreenGui, Position = UDim2.new(0.5, 0, 0, 31), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = Config.ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0), ZIndex = 500})
            local Chams = Functions:Create("Highlight", {Parent = ScreenGui, FillTransparency = 1, OutlineTransparency = 0, OutlineColor = Color3.fromRGB(119, 120, 255), DepthMode = "AlwaysOnTop"})
            local WeaponIcon = Functions:Create("ImageLabel", {Parent = ScreenGui, BackgroundTransparency = 1, BorderColor3 = Color3.fromRGB(0, 0, 0), BorderSizePixel = 0, Size = UDim2.new(0, 40, 0, 40)})
            local Gradient3 = Functions:Create("UIGradient", {Parent = WeaponIcon, Rotation = -90, Enabled = Config.ESP.Drawing.Weapons.Gradient, Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Config.ESP.Drawing.Weapons.GradientRGB1), ColorSequenceKeypoint.new(1, Config.ESP.Drawing.Weapons.GradientRGB2)}})
            local LeftTop = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = Config.ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0), BorderSizePixel = 0, BorderColor3 = Color3.new(0,0,0)})
            local LeftSide = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = Config.ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0), BorderSizePixel = 0, BorderColor3 = Color3.new(0,0,0)})
            local RightTop = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = Config.ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0), BorderSizePixel = 0, BorderColor3 = Color3.new(0,0,0)})
            local RightSide = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = Config.ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0), BorderSizePixel = 0, BorderColor3 = Color3.new(0,0,0)})
            local BottomSide = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = Config.ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0), BorderSizePixel = 0, BorderColor3 = Color3.new(0,0,0)})
            local BottomDown = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = Config.ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0), BorderSizePixel = 0, BorderColor3 = Color3.new(0,0,0)})
            local BottomRightSide = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = Config.ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0), BorderSizePixel = 0, BorderColor3 = Color3.new(0,0,0)})
            local BottomRightDown = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = Config.ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0), BorderSizePixel = 0, BorderColor3 = Color3.new(0,0,0)})
            local Flag1 = Functions:Create("TextLabel", {Visible = false,Parent = ScreenGui, Position = UDim2.new(1, 0, 0, 0), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = Config.ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0)})
            local Flag2 = Functions:Create("TextLabel", {Visible = false,Parent = ScreenGui, Position = UDim2.new(1, 0, 0, 0), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = Config.ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0)})
            --local DroppedItems = Functions:Create("TextLabel", {Visible = false,Parent = ScreenGui, AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = Config.ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0)})
            --
            Functions.AddOutline(LeftTop, 1); Functions.AddOutline(LeftSide, 1); Functions.AddOutline(LeftSide, 1); Functions.AddOutline(RightTop, 1); Functions.AddOutline(RightSide, 1); Functions.AddOutline(BottomSide, 1); Functions.AddOutline(BottomDown, 1); Functions.AddOutline(BottomRightSide, 1); Functions.AddOutline(BottomRightDown, 1); 
            local character = plr.Character or plr.CharacterAdded:Wait()
            if not character then return end

            local Humanoid = character:WaitForChild("Humanoid", 5)
            local HRP = character:WaitForChild("HumanoidRootPart", 5)

            if not Humanoid or not HRP then return end

            local Pos, OnScreen = Cam:WorldToScreenPoint(HRP.Position)
            local Dist = (Cam.CFrame.Position - HRP.Position).Magnitude
                            
            local Size = HRP.Size.Y

            if DefaultPlayerSettings[plr.Name] and DefaultPlayerSettings[plr.Name].RootSettings and DefaultPlayerSettings[plr.Name].RootSettings.Size then
                Size = DefaultPlayerSettings[plr.Name].RootSettings.Size.Y
            end

            local health_clamped = math.clamp(Humanoid.Health, 0, Humanoid.MaxHealth)
            local health = health_clamped / Humanoid.MaxHealth;
            
            local scaleFactor = (Size * Cam.ViewportSize.Y) / (Pos.Z * 2)
            
            local w, h = 3 * scaleFactor, 4.5 * scaleFactor

            if not Players_ESP[plr.Name] then
                -- ERROR BECAUSE LEAVE + JOIN NEW PLAYER CHARACTER NEW ESP ELEMTNS

                Players_ESP[plr.Name] = {}
                Players_ESP[plr.Name].RefreshElements = LPH_JIT_MAX(function()
                    task.spawn(LPH_NO_VIRTUALIZE(function()
                        if Config.ESP.Font == Fonts["Plex"] or Config.ESP.Font == Fonts["Pixel"] or Config.ESP.Font == Fonts["Minecraftia"] or Config.ESP.Font == Fonts["Verdana"] then
                            HealthText.FontFace = Config.ESP.Font
                            Name.FontFace = Config.ESP.Font
                            Distance.FontFace = Config.ESP.Font
                            Weapon.FontFace = Config.ESP.Font
                        else
                            HealthText.Font = Config.ESP.Font
                            Name.Font = Config.ESP.Font
                            Distance.Font = Config.ESP.Font
                            Weapon.Font = Config.ESP.Font
                        end

                        do -- \\ Boxes
                            Box.Visible = Config.ESP.Drawing.Boxes.Full.Enabled
                            if Config.ESP.Drawing.Boxes.Filled.Enabled then
                                Box.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                                if Config.ESP.Drawing.Boxes.GradientFill then
                                    Box.BackgroundTransparency = Config.ESP.Drawing.Boxes.Filled.Transparency;
                                else
                                    Box.BackgroundTransparency = 1
                                end
                                Box.BorderSizePixel = 1
                            else
                                Box.BackgroundTransparency = 1
                            end

                            if not Config.ESP.Drawing.Boxes.Bounding.Enabled or (Config.ESP.Drawing.Boxes.Corner.Enabled and Config.ESP.Drawing.Boxes.Bounding.Enabled) then
                                LeftTop.Transparency = Config.ESP.Drawing.Boxes.Corner.Transparency
                                LeftTop.BackgroundColor3 = Config.ESP.Drawing.Boxes.Corner.RGB

                                LeftSide.Transparency = Config.ESP.Drawing.Boxes.Corner.Transparency
                                LeftSide.BackgroundColor3 = Config.ESP.Drawing.Boxes.Corner.RGB

                                BottomSide.Transparency = Config.ESP.Drawing.Boxes.Corner.Transparency
                                BottomSide.BackgroundColor3 = Config.ESP.Drawing.Boxes.Corner.RGB

                                BottomDown.Transparency = Config.ESP.Drawing.Boxes.Corner.Transparency
                                BottomDown.BackgroundColor3 = Config.ESP.Drawing.Boxes.Corner.RGB

                                RightTop.Transparency = Config.ESP.Drawing.Boxes.Corner.Transparency
                                RightTop.BackgroundColor3 = Config.ESP.Drawing.Boxes.Corner.RGB

                                RightSide.Transparency = Config.ESP.Drawing.Boxes.Corner.Transparency
                                RightSide.BackgroundColor3 = Config.ESP.Drawing.Boxes.Corner.RGB

                                BottomRightSide.Transparency = Config.ESP.Drawing.Boxes.Corner.Transparency
                                BottomRightSide.BackgroundColor3 = Config.ESP.Drawing.Boxes.Corner.RGB

                                BottomRightDown.Transparency = Config.ESP.Drawing.Boxes.Corner.Transparency
                                BottomRightDown.BackgroundColor3 = Config.ESP.Drawing.Boxes.Corner.RGB
                            end

                            if not Config.ESP.Drawing.Boxes.Corner.Enabled then
                                LeftTop.Transparency = Config.ESP.Drawing.Boxes.Bounding.Transparency
                                LeftSide.Transparency = Config.ESP.Drawing.Boxes.Bounding.Transparency
                                BottomSide.Transparency = Config.ESP.Drawing.Boxes.Bounding.Transparency
                                RightSide.Transparency = Config.ESP.Drawing.Boxes.Bounding.Transparency

                                LeftTop.BackgroundColor3 = Config.ESP.Drawing.Boxes.Bounding.RGB
                                LeftSide.BackgroundColor3 = Config.ESP.Drawing.Boxes.Bounding.RGB
                                BottomSide.BackgroundColor3 = Config.ESP.Drawing.Boxes.Bounding.RGB
                                RightSide.BackgroundColor3 = Config.ESP.Drawing.Boxes.Bounding.RGB
                            end

                            BottomSide.AnchorPoint = Vector2.new(0, 5)
                            BottomDown.AnchorPoint = Vector2.new(0, 1)
                            RightTop.AnchorPoint = Vector2.new(1, 0)
                            RightSide.AnchorPoint = Vector2.new(0, 0)
                            BottomRightSide.AnchorPoint = Vector2.new(1, 1)
                            BottomRightDown.AnchorPoint = Vector2.new(1, 1)

                            if not Config.ESP.Drawing.Boxes.Animate then
                                Gradient1.Rotation = -45
                                Gradient2.Rotation = -45
                            end

                            Gradient1.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Config.ESP.Drawing.Boxes.GradientFillRGB1), ColorSequenceKeypoint.new(1, Config.ESP.Drawing.Boxes.GradientFillRGB2)}
                            Gradient2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Config.ESP.Drawing.Boxes.GradientRGB1), ColorSequenceKeypoint.new(1, Config.ESP.Drawing.Boxes.GradientRGB2)}
                        end
                        
                        do -- \\ Names
                            Name.TextSize = Config.ESP.FontSize
                            --Name.Font = Config.ESP.Font
                            Name.TextColor3 = Config.ESP.Drawing.Names.RGB
                            Name.TextStrokeTransparency = Config.ESP.Drawing.Names.Transparency
                        end

                        do -- \\ Chams
                            if Config.ESP.Drawing.Chams.VisibleCheck then
                                Chams.DepthMode = "Occluded"
                            else
                                Chams.DepthMode = "AlwaysOnTop"
                            end

                            Chams.FillColor = Config.ESP.Drawing.Chams.FillRGB
                            Chams.OutlineColor = Config.ESP.Drawing.Chams.OutlineRGB

                            if not Config.ESP.Drawing.Chams.Thermal then 
                                Chams.OutlineTransparency = Config.ESP.Drawing.Chams.Outline_Transparency / 100
                                Chams.FillTransparency = Config.ESP.Drawing.Chams.Fill_Transparency / 100
                            end
                        end

                        do -- \\ Rest im lazy cuzzy bro
                            Distance.TextStrokeTransparency = Config.ESP.Drawing.Distances.Transparency
                            Distance.TextSize = Config.ESP.FontSize
                            Distance.TextColor3 = Config.ESP.Drawing.Distances.RGB
                            Weapon.TextStrokeTransparency = Config.ESP.Drawing.Weapons.Transparency
                            Weapon.TextSize = Config.ESP.FontSize
                            Weapon.TextColor3 = Config.ESP.Drawing.Weapons.WeaponTextRGB
                        end
                    end))
                end)

                Players_ESP[plr.Name].Health_Changed = LPH_NO_VIRTUALIZE(function()
                    health_clamped = math.clamp(Humanoid.Health, 0, Humanoid.MaxHealth)
                    health = health_clamped / Humanoid.MaxHealth;
                end)

                Players_ESP[plr.Name].Health_Changed()

                Players_ESP[plr.Name].Child_Added = LPH_NO_VIRTUALIZE(function()
                    Weapon.Text = GetPlayerWeaponName(plr)
                end)


                Players_ESP[plr.Name].ToolConnection_Added = plr.Character.ChildAdded:Connect(Players_ESP[plr.Name].Child_Added)
                Players_ESP[plr.Name].ToolConnection_Removed = plr.Character.ChildRemoved:Connect(Players_ESP[plr.Name].Child_Added)

                Players_ESP[plr.Name].HumanoidConnection = Humanoid.HealthChanged:Connect(Players_ESP[plr.Name].Health_Changed)

                Players_ESP[plr.Name].CharacterAdded = plr.CharacterAdded:Connect(LPH_JIT_MAX(function(Character)
                    Humanoid = Character:WaitForChild("Humanoid")
                    HRP = Character:WaitForChild("HumanoidRootPart")
                    if Players_ESP[plr.Name] and Players_ESP[plr.Name].ToolConnection_Added then
                        SafeDisconnect(Players_ESP[plr.Name].ToolConnection_Added)
                    end


                    if Players_ESP[plr.Name] and Players_ESP[plr.Name].ToolConnection_Removed then
                        SafeDisconnect(Players_ESP[plr.Name].ToolConnection_Removed)
                    end


                    Players_ESP[plr.Name].ToolConnection_Removed = nil
                    Players_ESP[plr.Name].ToolConnection_Added = nil

                    Players_ESP[plr.Name].ToolConnection_Added = plr.Character.ChildAdded:Connect(Players_ESP[plr.Name].Child_Added)
                    Players_ESP[plr.Name].ToolConnection_Removed = plr.Character.ChildRemoved:Connect(Players_ESP[plr.Name].Child_Added)

                    SafeDisconnect(Players_ESP[plr.Name].HumanoidConnection)
                    Players_ESP[plr.Name].HumanoidConnection = Humanoid.HealthChanged:Connect(Players_ESP[plr.Name].Health_Changed)
                    Players_ESP[plr.Name].Health_Changed()
                    Players_ESP[plr.Name].RefreshElements()
                end))

                Players_ESP[plr.Name].RefreshElements()
            end

            local Updater = function()
                local esp_key = plr.Name;
                local hb_c1, hb_c2;
                local HideESP = LPH_NO_VIRTUALIZE(function()
                    Box.Visible = false;
                    Name.Visible = false;
                    Distance.Visible = false;
                    Weapon.Visible = false;
                    Healthbar.Visible = false;
                    BehindHealthbar.Visible = false;
                    HealthText.Visible = false;
                    WeaponIcon.Visible = false;
                    LeftTop.Visible = false;
                    LeftSide.Visible = false;
                    BottomSide.Visible = false;
                    BottomDown.Visible = false;
                    RightTop.Visible = false;
                    RightSide.Visible = false;
                    BottomRightSide.Visible = false;
                    BottomRightDown.Visible = false;
                    Flag1.Visible = false;
                    Chams.Enabled = false;
                    Flag2.Visible = false;
                    if not plr then
                        ScreenGui:Destroy();
                        ESP_UPDATERS[esp_key] = nil;
                    end
                end)
                --
                ESP_UPDATERS[esp_key] = LPH_NO_VIRTUALIZE(function()
                    -- Player gone: hide everything FIRST, then remove self. This
                    -- guarantees no box can ever be left frozen on screen.
                    if not plr or not plr.Parent then
                        HideESP()
                        ESP_UPDATERS[esp_key] = nil
                        return
                    end
                    if plr.Character and lplayer.Character and Config.ESP.Enabled then
                        if Humanoid and HRP then
                            Pos, OnScreen = Cam:WorldToScreenPoint(HRP.Position)
                            Dist = (Cam.CFrame.Position - HRP.Position).Magnitude
                            
                            if OnScreen and Dist <= Config.ESP.MaxDistance then
                                -- Accurate, monitor-independent box: project the character's
                                -- head-top and feet-bottom to the screen and size the box from
                                -- those real world points. WorldToViewportPoint handles FOV/
                                -- aspect/resolution, so the box always hugs the body the same
                                -- on any monitor. Tune the 2.9 half-height / 0.5 width ratio.
                                local root_pos = HRP.Position
                                local top_screen = Cam:WorldToViewportPoint(root_pos + Vector3.new(0, 2.9, 0))
                                local bottom_screen = Cam:WorldToViewportPoint(root_pos - Vector3.new(0, 2.9, 0))
                                h = math.abs(top_screen.Y - bottom_screen.Y)
                                w = h * 0.5

                                -- Fade-out effect --
                                if Config.ESP.FadeOut.OnDistance then
                                    Functions.FadeOutOnDist(Box, Dist)
                                    Functions.FadeOutOnDist(Outline, Dist)
                                    Functions.FadeOutOnDist(Name, Dist)
                                    Functions.FadeOutOnDist(Distance, Dist)
                                    Functions.FadeOutOnDist(Weapon, Dist)
                                    Functions.FadeOutOnDist(Healthbar, Dist)
                                    Functions.FadeOutOnDist(BehindHealthbar, Dist)
                                    Functions.FadeOutOnDist(HealthText, Dist)
                                    Functions.FadeOutOnDist(WeaponIcon, Dist)
                                    Functions.FadeOutOnDist(LeftTop, Dist)
                                    Functions.FadeOutOnDist(LeftSide, Dist)
                                    Functions.FadeOutOnDist(BottomSide, Dist)
                                    Functions.FadeOutOnDist(BottomDown, Dist)
                                    Functions.FadeOutOnDist(RightTop, Dist)
                                    Functions.FadeOutOnDist(RightSide, Dist)
                                    Functions.FadeOutOnDist(BottomRightSide, Dist)
                                    Functions.FadeOutOnDist(BottomRightDown, Dist)
                                    Functions.FadeOutOnDist(Chams, Dist)
                                    Functions.FadeOutOnDist(Flag1, Dist)
                                    Functions.FadeOutOnDist(Flag2, Dist)
                                end
                                
                                -- Teamcheck
                                local hideForTeam = false

                                if Config.ESP.TeamCheck then
                                    local local_team_id = lplayer:GetAttribute("TeamID")
                                    local target_team_id = plr:GetAttribute("TeamID")

                                    if local_team_id and target_team_id then
                                        local local_team_color = DuelLibrary:GetTeamColor(local_team_id)
                                        local target_team_color = DuelLibrary:GetTeamColor(target_team_id)

                                        if local_team_color and target_team_color and local_team_color == target_team_color then
                                            hideForTeam = true
                                        end
                                    end
                                end

                                if hideForTeam then
                                    HideESP()
                                elseif HRP and Humanoid then
                                    do -- Chams
                                        Chams.Adornee = plr.Character
                                        Chams.Enabled = Config.ESP.Drawing.Chams.Enabled
                                        do -- Breathe
                                            if Config.ESP.Drawing.Chams.Thermal then
                                                local breathe_effect = math.atan(math.sin(tick() * 2)) * 2 / math.pi
                                                Chams.FillTransparency = Config.ESP.Drawing.Chams.Fill_Transparency * breathe_effect * 0.01
                                                Chams.OutlineTransparency = Config.ESP.Drawing.Chams.Outline_Transparency * breathe_effect * 0.01
                                            end
                                        end
                                    end;

                                    do -- Corner Boxes
                                        if not Config.ESP.Drawing.Boxes.Bounding.Enabled or (Config.ESP.Drawing.Boxes.Corner.Enabled and Config.ESP.Drawing.Boxes.Bounding.Enabled) then
                                            LeftTop.Visible = Config.ESP.Drawing.Boxes.Corner.Enabled
                                            LeftTop.Position = UDim2.new(0, Pos.X - w / 2, 0, Pos.Y - h / 2)
                                            LeftTop.Size = UDim2.new(0, w / 5, 0, 1)

                                            LeftSide.Visible = Config.ESP.Drawing.Boxes.Corner.Enabled
                                            LeftSide.Position = UDim2.new(0, Pos.X - w / 2, 0, Pos.Y - h / 2)
                                            LeftSide.Size = UDim2.new(0, 1, 0, h / 5)

                                            BottomSide.Visible = Config.ESP.Drawing.Boxes.Corner.Enabled
                                            BottomSide.Position = UDim2.new(0, Pos.X - w / 2, 0, Pos.Y + h / 2)
                                            BottomSide.Size = UDim2.new(0, 1, 0, h / 5)

                                            BottomDown.Visible = Config.ESP.Drawing.Boxes.Corner.Enabled
                                            BottomDown.Position = UDim2.new(0, Pos.X - w / 2, 0, Pos.Y + h / 2)
                                            BottomDown.Size = UDim2.new(0, w / 5, 0, 1)


                                            RightTop.Visible = Config.ESP.Drawing.Boxes.Corner.Enabled
                                            RightTop.Position = UDim2.new(0, Pos.X + w / 2, 0, Pos.Y - h / 2)
                                            RightTop.Size = UDim2.new(0, w / 5, 0, 1)

                                            RightSide.Visible = Config.ESP.Drawing.Boxes.Corner.Enabled
                                            RightSide.Position = UDim2.new(0, Pos.X + w / 2 - 1, 0, Pos.Y - h / 2)
                                            RightSide.Size = UDim2.new(0, 1, 0, h / 5)

                                            BottomRightSide.Visible = Config.ESP.Drawing.Boxes.Corner.Enabled
                                            BottomRightSide.Position = UDim2.new(0, Pos.X + w / 2, 0, Pos.Y + h / 2)
                                            BottomRightSide.Size = UDim2.new(0, 1, 0, h / 5)

                                            BottomRightDown.Visible = Config.ESP.Drawing.Boxes.Corner.Enabled
                                            BottomRightDown.Position = UDim2.new(0, Pos.X + w / 2, 0, Pos.Y + h / 2)
                                            BottomRightDown.Size = UDim2.new(0, w / 5, 0, 1)
                                        end
                                    end

                                    do -- // Bounding Boxes
                                        if not Config.ESP.Drawing.Boxes.Corner.Enabled then
                                            LeftTop.Visible = Config.ESP.Drawing.Boxes.Bounding.Enabled
                                            LeftTop.Position = UDim2.new(0, Pos.X - w / 2, 0, Pos.Y - h / 2)
                                            LeftTop.Size = UDim2.new(0, w, 0, 1)


                                            LeftSide.Visible = Config.ESP.Drawing.Boxes.Bounding.Enabled
                                            LeftSide.Position = UDim2.new(0, Pos.X - w / 2, 0, Pos.Y - h / 2)
                                            LeftSide.Size = UDim2.new(0, 1, 0, h)


                                            BottomSide.Visible = Config.ESP.Drawing.Boxes.Bounding.Enabled
                                            BottomSide.Position = UDim2.new(0, Pos.X - w / 2, 0, Pos.Y + h / 2)
                                            BottomSide.Size = UDim2.new(0, w, 0, 1) 


                                            RightSide.Visible = Config.ESP.Drawing.Boxes.Bounding.Enabled 
                                            RightSide.Position = UDim2.new(0, Pos.X + w / 2 - 1, 0, Pos.Y - h / 2)
                                            RightSide.Size = UDim2.new(0, 1, 0, h) 

                                            BottomRightSide.Visible = false
                                            BottomRightDown.Visible = false
                                            BottomDown.Visible = false
                                            RightTop.Visible = false
                                        end
                                    end

                                    do -- Boxes
                                        Box.Position = UDim2.new(0, Pos.X - w / 2, 0, Pos.Y - h / 2)
                                        Box.Size = UDim2.new(0, w, 0, h)
                                        Box.Visible = Config.ESP.Drawing.Boxes.Full.Enabled

                                        -- Animation
                                        if Config.ESP.Drawing.Boxes.Animate then
                                            RotationAngle = RotationAngle + (tick() - Tick) * Config.ESP.Drawing.Boxes.RotationSpeed * math.cos(math.pi / 4 * tick() - math.pi / 2)
                                            Gradient1.Rotation = RotationAngle
                                            Gradient2.Rotation = RotationAngle
                                        end

                                        
                                        Tick = tick()
                                    end

                                    -- Healthbar
                                    do  
                                        

                                            local is_inf = false

                                            if Humanoid.Health ~= Humanoid.Health then
                                                health = 1;
                                                is_inf = true;
                                            end

                                            Healthbar.Position = UDim2.new(0, Pos.X - w / 2 - 6, 0, Pos.Y - h / 2 + h * (1 - health))
                                            Healthbar.Size = UDim2.new(0, Config.ESP.Drawing.Healthbar.Width, 0, h * health)

                                            Healthbar.BackgroundTransparency = Config.ESP.Drawing.Healthbar.Transparency

                                            BehindHealthbar.Position = UDim2.new(0, Pos.X - w / 2 - 6, 0, Pos.Y - h / 2) 
                                            BehindHealthbar.Size = UDim2.new(0, Config.ESP.Drawing.Healthbar.Width, 0, h) 
                                            BehindHealthbar.BackgroundTransparency = Config.ESP.Drawing.Healthbar.Transparency


                                            HealthbarGradient.Enabled = Config.ESP.Drawing.Healthbar.Gradient
                                            local _hbc1 = Config.ESP.Drawing.Healthbar.GradientRGB1
                                            local _hbc2 = Config.ESP.Drawing.Healthbar.GradientRGB2
                                            if _hbc1 ~= hb_c1 or _hbc2 ~= hb_c2 then
                                                hb_c1, hb_c2 = _hbc1, _hbc2
                                                HealthbarGradient.Color = ColorSequence.new{
                                                    ColorSequenceKeypoint.new(0, _hbc1),
                                                    ColorSequenceKeypoint.new(1, _hbc2)
                                                }
                                            end

                                            HealthbarGradient.Offset = Vector2.new(0, health - 1)

                                            local color = getHealthColor(health_clamped , Humanoid.MaxHealth)
                                            local healthtexttext = tostring(math.floor(health_clamped))

                                            if is_inf then
                                                healthtexttext = "inf"

                                                color = getHealthColor(Humanoid.MaxHealth, Humanoid.MaxHealth)
                                            end

                                            Healthbar.BackgroundColor3 = not Config.ESP.Drawing.Healthbar.Gradient and color or Color3.new(1,1,1)
                                            -- Health Text

                                            Healthbar.Visible = Config.ESP.Drawing.Healthbar.Enabled
                                            BehindHealthbar.Visible = Config.ESP.Drawing.Healthbar.Enabled

                                            do
                                                if Config.ESP.Drawing.Healthbar.HealthText then
                                                    local healthPercentage = math.floor(health_clamped / Humanoid.MaxHealth * 100)

                                                    if is_inf then
                                                        healthPercentage = 100
                                                    end

                                                    HealthText.Position = UDim2.new(0, Pos.X - w / 2 - 18 --[[6]], 0, Pos.Y - h / 2 + h * (1 - healthPercentage / 100) + 3)
                                                    HealthText.Text = healthtexttext
                                                    HealthText.TextSize = Config.ESP.FontSize
                                                    --HealthText.Font = Config.ESP.Font
                                                    HealthText.Visible = Config.ESP.Drawing.Healthbar.HealthText
                                                    HealthText.TextStrokeTransparency = Config.ESP.Drawing.Healthbar.HealthTextTransparency
                                                    if Config.ESP.Drawing.Healthbar.Lerp then
                                                        HealthText.TextColor3 = color
                                                    else
                                                        HealthText.TextColor3 = Config.ESP.Drawing.Healthbar.HealthTextRGB
                                                    end
                                                else
                                                    HealthText.Visible = false
                                                end
                                            end
                                    end

                                    do -- Names
                                            Name.Visible = Config.ESP.Drawing.Names.Enabled
                                            Name.Text = plr.Name
                                            if Config.ESP.Options.Friendcheck and lplayer:IsFriendsWith(plr.UserId) then
                                                Name.Text = string.format('(<font color="rgb(%d, %d, %d)">F</font>) %s', Config.ESP.Options.FriendcheckRGB.R * 255, Config.ESP.Options.FriendcheckRGB.G * 255, Config.ESP.Options.FriendcheckRGB.B * 255, plr.Name)
                                            end
                                            Name.Position = UDim2.new(0, Pos.X, 0, Pos.Y - h / 2 - 9)
                                    end
                                    
                                    do -- Distance
                                            if Config.ESP.Drawing.Distances.Enabled then
                                                Weapon.Position = UDim2.new(0, Pos.X, 0, Pos.Y + h / 2 + 7)

                                                --WeaponIcon.Position = UDim2.new(0, Pos.X - 21, 0, Pos.Y + h / 2 + 15);
                                                Distance.Position = UDim2.new(0, Pos.X, 0, Pos.Y + h / 2 + (Weapon.Visible and 18 or 7))
                                                Distance.Text = string.format("%d Studs", math.floor(Dist))

                                                Distance.Visible = true
                                                --Distance.Font = Config.ESP.Font
                                            else
                                                Weapon.Position = UDim2.new(0, Pos.X, 0, Pos.Y + h / 2 + 8)
                                                Distance.Visible = false;
                                            end
                                    end

                                    do -- Weapons
                                        Weapon.Visible = Config.ESP.Drawing.Weapons.Enabled
                                        if Weapon.Visible then
                                            Weapon.Text = GetPlayerWeaponName(plr)
                                        end
                                    end
                                else
                                    HideESP();
                                end
                            else
                                HideESP();
                            end
                        else
                            HideESP();
                        end
                    else
                        HideESP();
                    end
                end)
            end
            coroutine.wrap(Updater)();
            end))
        end
        do -- Update ESP
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= lplayer then
                    coroutine.wrap(ESP)(v)
                end
            end
            --
            Players.PlayerAdded:Connect(function(v)
                coroutine.wrap(ESP)(v)
            end);

            Players.PlayerRemoving:Connect(function(v)
                if Players_ESP[v.Name] then
                    Players_ESP[v.Name].RefreshElements = nil
                    Players_ESP[v.Name].CharacterAdded:Disconnect()
                    Players_ESP[v.Name].CharacterAdded = nil
                    Players_ESP[v.Name].ToolConnection_Added:Disconnect()
                    Players_ESP[v.Name].ToolConnection_Removed:Disconnect()
                    Players_ESP[v.Name].ToolConnection_Removed = nil
                    Players_ESP[v.Name].ToolConnection_Added = nil
                    Players_ESP[v.Name] = nil
                end
            end)
        end;
    end;
end
