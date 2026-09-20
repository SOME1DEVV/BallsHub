local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Camera = Workspace.CurrentCamera

local State = {
    E = false,
    We = false,
    Af = false,
    As = false,
    He = false,
    Hv = 2,
    Rw = false
}

local MenuKey = Enum.KeyCode.RightControl
local MenuKeyConn = nil

local Keybinds = {
    ESP = Enum.KeyCode.None,
    WeaponESP = Enum.KeyCode.None,
    AntiFlash = Enum.KeyCode.None,
    AntiSmoke = Enum.KeyCode.None,
    BigHead = Enum.KeyCode.None,
    RemoveWalls = Enum.KeyCode.None
}

local PlayerToggles = {}
local PlayerList = {}
local Exiting = false
local IntroDone = false
local ExitStarted = false

local KeybindConnections = {}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BallsHub"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0,450,0,470)
MainFrame.Position = UDim2.new(0.5,-225,0.5,-235)
MainFrame.BackgroundColor3 = Color3.fromRGB(60,60,60)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(150,150,150)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local IntroFrame = Instance.new("Frame")
IntroFrame.Size = UDim2.new(1,0,1,0)
IntroFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
IntroFrame.BackgroundTransparency = 1
IntroFrame.ZIndex = 1000
IntroFrame.Parent = ScreenGui

local IntroLogo = Instance.new("ImageLabel")
IntroLogo.Size = UDim2.new(0,1,0,1)
IntroLogo.Position = UDim2.new(0.5,-0.5,0.5,-0.5)
IntroLogo.BackgroundTransparency = 1
IntroLogo.Image = "rbxassetid://91426913908147"
IntroLogo.ZIndex = 1001
IntroLogo.Parent = IntroFrame

local IntroText = Instance.new("TextLabel")
IntroText.Size = UDim2.new(0,400,0,60)
IntroText.Position = UDim2.new(0.5,-200,0.5,100)
IntroText.BackgroundTransparency = 1
IntroText.Text = "MARGOSHA Team"
IntroText.TextColor3 = Color3.fromRGB(255,255,255)
IntroText.Font = Enum.Font.Legacy
IntroText.TextSize = 35
IntroText.TextTransparency = 1
IntroText.ZIndex = 1001
IntroText.Parent = IntroFrame

task.spawn(function()
    task.wait(2)
    IntroLogo.Rotation = 90
    TweenService:Create(IntroLogo, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0,250,0,250),
        Position = UDim2.new(0.5,-125,0.5,-125),
        Rotation = 0
    }):Play()
    task.wait(1.8)
    TweenService:Create(IntroText, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
    task.wait(2)
    TweenService:Create(IntroText, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
    task.wait(0.3)
    TweenService:Create(IntroLogo, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0,3000,0,3000),
        Position = UDim2.new(0.5,-1500,0.5,-1500),
        ImageTransparency = 1
    }):Play()
    task.wait(1)
    IntroFrame:Destroy()
    IntroDone = true
    MainFrame.Visible = true
end)

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1,-2,0,35)
TitleBar.Position = UDim2.new(0,1,0,1)
TitleBar.BackgroundColor3 = Color3.fromRGB(35,35,35)
TitleBar.BorderSizePixel = 1
TitleBar.BorderColor3 = Color3.fromRGB(100,100,100)
TitleBar.ZIndex = 2
TitleBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0,150,1,0)
TitleLabel.Position = UDim2.new(0,10,0,0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "BallsHub"
TitleLabel.TextColor3 = Color3.fromRGB(255,255,255)
TitleLabel.Font = Enum.Font.Legacy
TitleLabel.TextSize = 20
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 3
TitleLabel.Parent = TitleBar

local VersionLabel = Instance.new("TextLabel")
VersionLabel.Size = UDim2.new(0,200,1,0)
VersionLabel.Position = UDim2.new(0,160,0,0)
VersionLabel.BackgroundTransparency = 1
VersionLabel.Text = "v2.0 Premium"
VersionLabel.TextColor3 = Color3.fromRGB(255,215,0)
VersionLabel.Font = Enum.Font.Legacy
VersionLabel.TextSize = 10
VersionLabel.TextXAlignment = Enum.TextXAlignment.Left
VersionLabel.ZIndex = 3
VersionLabel.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0,30,0,30)
CloseButton.Position = UDim2.new(1,-32,0,2)
CloseButton.BackgroundColor3 = Color3.fromRGB(180,40,40)
CloseButton.BorderSizePixel = 1
CloseButton.BorderColor3 = Color3.fromRGB(100,100,100)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255,255,255)
CloseButton.Font = Enum.Font.Legacy
CloseButton.TextSize = 16
CloseButton.ZIndex = 3
CloseButton.Parent = TitleBar

local Dragging = false
local DragStart = nil
local StartPos = nil

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = true
        DragStart = input.Position
        StartPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and Dragging then
        local delta = input.Position - DragStart
        MainFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + delta.X, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y)
    end
end)

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1,-2,1,-37)
ContentFrame.Position = UDim2.new(0,1,0,36)
ContentFrame.BackgroundColor3 = Color3.fromRGB(45,45,45)
ContentFrame.BorderSizePixel = 1
ContentFrame.BorderColor3 = Color3.fromRGB(100,100,100)
ContentFrame.ZIndex = 2
ContentFrame.Parent = MainFrame

local function CancelKeybind(name)
    if KeybindConnections[name] then
        KeybindConnections[name]:Disconnect()
        KeybindConnections[name] = nil
    end
end

local function CreateFeatureButton(name, text, y, key)
    local button = Instance.new("TextButton")
    button.Name = name .. "Button"
    button.Size = UDim2.new(0,215,0,35)
    button.Position = UDim2.new(0,15,0,y)
    button.BackgroundColor3 = Color3.fromRGB(80,80,80)
    button.BorderSizePixel = 1
    button.BorderColor3 = Color3.fromRGB(100,100,100)
    button.Text = text .. ": OFF"
    button.TextColor3 = Color3.fromRGB(255,255,255)
    button.Font = Enum.Font.Legacy
    button.TextSize = 14
    button.ZIndex = 3
    button.Parent = ContentFrame

    local keybindButton = Instance.new("TextButton")
    keybindButton.Name = name .. "Keybind"
    keybindButton.Size = UDim2.new(0,155,0,35)
    keybindButton.Position = UDim2.new(0,240,0,y)
    keybindButton.BackgroundColor3 = Color3.fromRGB(80,80,80)
    keybindButton.BorderSizePixel = 1
    keybindButton.BorderColor3 = Color3.fromRGB(100,100,100)
    keybindButton.Text = "Key: None"
    keybindButton.TextColor3 = Color3.fromRGB(255,255,255)
    keybindButton.Font = Enum.Font.Legacy
    keybindButton.TextSize = 12
    keybindButton.ZIndex = 3
    keybindButton.Parent = ContentFrame

    local resetButton = Instance.new("TextButton")
    resetButton.Name = name .. "ResetKey"
    resetButton.Size = UDim2.new(0,35,0,35)
    resetButton.Position = UDim2.new(0,400,0,y)
    resetButton.BackgroundColor3 = Color3.fromRGB(120,40,40)
    resetButton.BorderSizePixel = 1
    resetButton.BorderColor3 = Color3.fromRGB(100,100,100)
    resetButton.Text = "X"
    resetButton.TextColor3 = Color3.fromRGB(255,255,255)
    resetButton.Font = Enum.Font.Legacy
    resetButton.TextSize = 14
    resetButton.ZIndex = 3
    resetButton.Parent = ContentFrame

    keybindButton.MouseButton1Click:Connect(function()
        CancelKeybind(name)
        keybindButton.Text = "Press key..."
        keybindButton.BackgroundColor3 = Color3.fromRGB(0,120,0)
        KeybindConnections[name] = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                Keybinds[key] = input.KeyCode
                keybindButton.Text = "Key: " .. tostring(input.KeyCode):gsub("Enum.KeyCode.", "")
                keybindButton.BackgroundColor3 = Color3.fromRGB(80,80,80)
                CancelKeybind(name)
            end
        end)
    end)

    resetButton.MouseButton1Click:Connect(function()
        CancelKeybind(name)
        Keybinds[key] = Enum.KeyCode.None
        keybindButton.Text = "Key: None"
        keybindButton.BackgroundColor3 = Color3.fromRGB(80,80,80)
    end)

    return button
end

local ESPButton = CreateFeatureButton("ESP", "Player ESP", 10, "ESP")
local WeaponESPButton = CreateFeatureButton("WeaponESP", "Weapon ESP", 50, "WeaponESP")
local AntiFlashButton = CreateFeatureButton("AntiFlash", "Anti-Flash", 90, "AntiFlash")
local AntiSmokeButton = CreateFeatureButton("AntiSmoke", "Anti-Smoke", 130, "AntiSmoke")

local ScopeButton = Instance.new("TextButton")
ScopeButton.Size = UDim2.new(0,215,0,35)
ScopeButton.Position = UDim2.new(0,15,0,170)
ScopeButton.BackgroundColor3 = Color3.fromRGB(80,80,80)
ScopeButton.BorderSizePixel = 1
ScopeButton.BorderColor3 = Color3.fromRGB(100,100,100)
ScopeButton.Text = "Remove Scope"
ScopeButton.TextColor3 = Color3.fromRGB(255,255,255)
ScopeButton.Font = Enum.Font.Legacy
ScopeButton.TextSize = 14
ScopeButton.ZIndex = 3
ScopeButton.Parent = ContentFrame

local ScopeRemoved = false

local WarningGui = Instance.new("Frame")
WarningGui.Name = "WarningGui"
WarningGui.Size = UDim2.new(0,350,0,180)
WarningGui.Position = UDim2.new(0.5,-175,0.5,-90)
WarningGui.BackgroundColor3 = Color3.fromRGB(45,45,45)
WarningGui.BorderSizePixel = 2
WarningGui.BorderColor3 = Color3.fromRGB(180,40,40)
WarningGui.ZIndex = 2000
WarningGui.Visible = false
WarningGui.Parent = ScreenGui

local WarningTitle = Instance.new("TextLabel")
WarningTitle.Size = UDim2.new(1,-20,0,30)
WarningTitle.Position = UDim2.new(0,10,0,10)
WarningTitle.BackgroundTransparency = 1
WarningTitle.Text = "WARNING"
WarningTitle.TextColor3 = Color3.fromRGB(255,100,100)
WarningTitle.Font = Enum.Font.Legacy
WarningTitle.TextSize = 22
WarningTitle.ZIndex = 2001
WarningTitle.Parent = WarningGui

local WarningText = Instance.new("TextLabel")
WarningText.Size = UDim2.new(1,-20,0,80)
WarningText.Position = UDim2.new(0,10,0,45)
WarningText.BackgroundTransparency = 1
WarningText.Text = "Are you sure you want to remove the scope?\nYou will need to REJOIN to restore it!"
WarningText.TextColor3 = Color3.fromRGB(255,255,255)
WarningText.Font = Enum.Font.Legacy
WarningText.TextSize = 14
WarningText.TextWrapped = true
WarningText.ZIndex = 2001
WarningText.Parent = WarningGui

local YesButton = Instance.new("TextButton")
YesButton.Size = UDim2.new(0,120,0,35)
YesButton.Position = UDim2.new(0,50,0,135)
YesButton.BackgroundColor3 = Color3.fromRGB(180,40,40)
YesButton.BorderSizePixel = 1
YesButton.BorderColor3 = Color3.fromRGB(100,100,100)
YesButton.Text = "YES"
YesButton.TextColor3 = Color3.fromRGB(255,255,255)
YesButton.Font = Enum.Font.Legacy
YesButton.TextSize = 16
YesButton.ZIndex = 2001
YesButton.Parent = WarningGui

local NoButton = Instance.new("TextButton")
NoButton.Size = UDim2.new(0,120,0,35)
NoButton.Position = UDim2.new(0,180,0,135)
NoButton.BackgroundColor3 = Color3.fromRGB(60,120,60)
NoButton.BorderSizePixel = 1
NoButton.BorderColor3 = Color3.fromRGB(100,100,100)
NoButton.Text = "NO"
NoButton.TextColor3 = Color3.fromRGB(255,255,255)
NoButton.Font = Enum.Font.Legacy
NoButton.TextSize = 16
NoButton.ZIndex = 2001
NoButton.Parent = WarningGui

ScopeButton.MouseButton1Click:Connect(function()
    if ScopeRemoved then return end
    WarningGui.Visible = true
end)

NoButton.MouseButton1Click:Connect(function()
    WarningGui.Visible = false
end)

YesButton.MouseButton1Click:Connect(function()
    WarningGui.Visible = false
    if ScopeRemoved then return end
    local mainGui = PlayerGui:FindFirstChild("MainGui")
    if mainGui then
        local gameplay = mainGui:FindFirstChild("Gameplay")
        if gameplay then
            local middle = gameplay:FindFirstChild("Middle")
            if middle then
                local sniperScope = middle:FindFirstChild("SniperScope")
                if sniperScope then
                    pcall(function() sniperScope:Destroy() end)
                end
            end
        end
    end
    ScopeRemoved = true
    ScopeButton.BackgroundColor3 = Color3.fromRGB(0,120,0)
    ScopeButton.Text = "Removed Scope"
    ScopeButton.TextColor3 = Color3.fromRGB(200,200,200)
    ScopeButton.AutoButtonColor = false
end)

local BigHeadButton = Instance.new("TextButton")
BigHeadButton.Size = UDim2.new(0,215,0,35)
BigHeadButton.Position = UDim2.new(0,15,0,210)
BigHeadButton.BackgroundColor3 = Color3.fromRGB(80,80,80)
BigHeadButton.BorderSizePixel = 1
BigHeadButton.BorderColor3 = Color3.fromRGB(100,100,100)
BigHeadButton.Text = "Big Head: OFF"
BigHeadButton.TextColor3 = Color3.fromRGB(255,255,255)
BigHeadButton.Font = Enum.Font.Legacy
BigHeadButton.TextSize = 14
BigHeadButton.ZIndex = 3
BigHeadButton.Parent = ContentFrame

local BigHeadKeybind = Instance.new("TextButton")
BigHeadKeybind.Size = UDim2.new(0,155,0,35)
BigHeadKeybind.Position = UDim2.new(0,240,0,210)
BigHeadKeybind.BackgroundColor3 = Color3.fromRGB(80,80,80)
BigHeadKeybind.BorderSizePixel = 1
BigHeadKeybind.BorderColor3 = Color3.fromRGB(100,100,100)
BigHeadKeybind.Text = "Key: None"
BigHeadKeybind.TextColor3 = Color3.fromRGB(255,255,255)
BigHeadKeybind.Font = Enum.Font.Legacy
BigHeadKeybind.TextSize = 12
BigHeadKeybind.ZIndex = 3
BigHeadKeybind.Parent = ContentFrame

local BigHeadReset = Instance.new("TextButton")
BigHeadReset.Size = UDim2.new(0,35,0,35)
BigHeadReset.Position = UDim2.new(0,400,0,210)
BigHeadReset.BackgroundColor3 = Color3.fromRGB(120,40,40)
BigHeadReset.BorderSizePixel = 1
BigHeadReset.BorderColor3 = Color3.fromRGB(100,100,100)
BigHeadReset.Text = "X"
BigHeadReset.TextColor3 = Color3.fromRGB(255,255,255)
BigHeadReset.Font = Enum.Font.Legacy
BigHeadReset.TextSize = 14
BigHeadReset.ZIndex = 3
BigHeadReset.Parent = ContentFrame

BigHeadKeybind.MouseButton1Click:Connect(function()
    CancelKeybind("BigHead")
    BigHeadKeybind.Text = "Press key..."
    BigHeadKeybind.BackgroundColor3 = Color3.fromRGB(0,120,0)
    KeybindConnections["BigHead"] = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            Keybinds.BigHead = input.KeyCode
            BigHeadKeybind.Text = "Key: " .. tostring(input.KeyCode):gsub("Enum.KeyCode.", "")
            BigHeadKeybind.BackgroundColor3 = Color3.fromRGB(80,80,80)
            CancelKeybind("BigHead")
        end
    end)
end)

BigHeadReset.MouseButton1Click:Connect(function()
    CancelKeybind("BigHead")
    Keybinds.BigHead = Enum.KeyCode.None
    BigHeadKeybind.Text = "Key: None"
    BigHeadKeybind.BackgroundColor3 = Color3.fromRGB(80,80,80)
end)

local BigHeadSettingsButton = Instance.new("TextButton")
BigHeadSettingsButton.Size = UDim2.new(0,215,0,35)
BigHeadSettingsButton.Position = UDim2.new(0,15,0,250)
BigHeadSettingsButton.BackgroundColor3 = Color3.fromRGB(80,80,80)
BigHeadSettingsButton.BorderSizePixel = 1
BigHeadSettingsButton.BorderColor3 = Color3.fromRGB(100,100,100)
BigHeadSettingsButton.Text = "Big Head Settings"
BigHeadSettingsButton.TextColor3 = Color3.fromRGB(255,255,255)
BigHeadSettingsButton.Font = Enum.Font.Legacy
BigHeadSettingsButton.TextSize = 14
BigHeadSettingsButton.ZIndex = 3
BigHeadSettingsButton.Parent = ContentFrame

local HeadSliderLabel = Instance.new("TextLabel")
HeadSliderLabel.Size = UDim2.new(0,50,0,20)
HeadSliderLabel.Position = UDim2.new(0,15,0,295)
HeadSliderLabel.BackgroundTransparency = 1
HeadSliderLabel.Text = "x2"
HeadSliderLabel.TextColor3 = Color3.fromRGB(255,255,255)
HeadSliderLabel.Font = Enum.Font.Legacy
HeadSliderLabel.TextSize = 12
HeadSliderLabel.TextXAlignment = Enum.TextXAlignment.Left
HeadSliderLabel.ZIndex = 3
HeadSliderLabel.Parent = ContentFrame

local HeadSlider = Instance.new("Frame")
HeadSlider.Size = UDim2.new(0,420,0,10)
HeadSlider.Position = UDim2.new(0,15,0,320)
HeadSlider.BackgroundColor3 = Color3.fromRGB(100,100,100)
HeadSlider.BorderSizePixel = 1
HeadSlider.BorderColor3 = Color3.fromRGB(150,150,150)
HeadSlider.ZIndex = 3
HeadSlider.Parent = ContentFrame

local HeadSliderFill = Instance.new("Frame")
HeadSliderFill.Size = UDim2.new(0.111,0,1,0)
HeadSliderFill.BackgroundColor3 = Color3.fromRGB(0,120,0)
HeadSliderFill.BorderSizePixel = 0
HeadSliderFill.ZIndex = 4
HeadSliderFill.Parent = HeadSlider

local RemoveWallsButton = CreateFeatureButton("RemoveWalls", "Remove Walls", 345, "RemoveWalls")

local MenuKeyButton = Instance.new("TextButton")
MenuKeyButton.Size = UDim2.new(0,215,0,30)
MenuKeyButton.Position = UDim2.new(0,15,0,385)
MenuKeyButton.BackgroundColor3 = Color3.fromRGB(80,80,80)
MenuKeyButton.BorderSizePixel = 1
MenuKeyButton.BorderColor3 = Color3.fromRGB(100,100,100)
MenuKeyButton.Text = "Menu Key: " .. tostring(MenuKey):gsub("Enum.KeyCode.", "")
MenuKeyButton.TextColor3 = Color3.fromRGB(255,255,255)
MenuKeyButton.Font = Enum.Font.Legacy
MenuKeyButton.TextSize = 12
MenuKeyButton.ZIndex = 3
MenuKeyButton.Parent = ContentFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1,-30,0,20)
StatusLabel.Position = UDim2.new(0,15,0,420)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Ready"
StatusLabel.TextColor3 = Color3.fromRGB(255,255,0)
StatusLabel.Font = Enum.Font.Legacy
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.ZIndex = 3
StatusLabel.Parent = ContentFrame

local PlayersFrame = Instance.new("Frame")
PlayersFrame.Name = "PlayersFrame"
PlayersFrame.Size = UDim2.new(0,450,0,420)
PlayersFrame.Position = UDim2.new(0.5,-225,0.5,-210)
PlayersFrame.BackgroundColor3 = Color3.fromRGB(60,60,60)
PlayersFrame.BorderSizePixel = 1
PlayersFrame.BorderColor3 = Color3.fromRGB(150,150,150)
PlayersFrame.Visible = false
PlayersFrame.Parent = ScreenGui

local PlayersTitleBar = Instance.new("Frame")
PlayersTitleBar.Size = UDim2.new(1,-2,0,35)
PlayersTitleBar.Position = UDim2.new(0,1,0,1)
PlayersTitleBar.BackgroundColor3 = Color3.fromRGB(35,35,35)
PlayersTitleBar.BorderSizePixel = 1
PlayersTitleBar.BorderColor3 = Color3.fromRGB(100,100,100)
PlayersTitleBar.ZIndex = 2
PlayersTitleBar.Parent = PlayersFrame

local PlayersBackButton = Instance.new("TextButton")
PlayersBackButton.Size = UDim2.new(0,35,0,30)
PlayersBackButton.Position = UDim2.new(0,5,0,2)
PlayersBackButton.BackgroundColor3 = Color3.fromRGB(60,140,200)
PlayersBackButton.BorderSizePixel = 1
PlayersBackButton.BorderColor3 = Color3.fromRGB(100,100,100)
PlayersBackButton.Text = "<"
PlayersBackButton.TextColor3 = Color3.fromRGB(255,255,255)
PlayersBackButton.Font = Enum.Font.Legacy
PlayersBackButton.TextSize = 20
PlayersBackButton.ZIndex = 3
PlayersBackButton.Parent = PlayersTitleBar

local PlayersTitle = Instance.new("TextLabel")
PlayersTitle.Size = UDim2.new(0,300,1,0)
PlayersTitle.Position = UDim2.new(0,50,0,0)
PlayersTitle.BackgroundTransparency = 1
PlayersTitle.Text = "Big Head Settings"
PlayersTitle.TextColor3 = Color3.fromRGB(255,255,255)
PlayersTitle.Font = Enum.Font.Legacy
PlayersTitle.TextSize = 16
PlayersTitle.TextXAlignment = Enum.TextXAlignment.Left
PlayersTitle.ZIndex = 3
PlayersTitle.Parent = PlayersTitleBar

local PlayersCloseButton = Instance.new("TextButton")
PlayersCloseButton.Size = UDim2.new(0,30,0,30)
PlayersCloseButton.Position = UDim2.new(1,-32,0,2)
PlayersCloseButton.BackgroundColor3 = Color3.fromRGB(180,40,40)
PlayersCloseButton.BorderSizePixel = 1
PlayersCloseButton.BorderColor3 = Color3.fromRGB(100,100,100)
PlayersCloseButton.Text = "X"
PlayersCloseButton.TextColor3 = Color3.fromRGB(255,255,255)
PlayersCloseButton.Font = Enum.Font.Legacy
PlayersCloseButton.TextSize = 16
PlayersCloseButton.ZIndex = 3
PlayersCloseButton.Parent = PlayersTitleBar

local PlayersScroll = Instance.new("ScrollingFrame")
PlayersScroll.Size = UDim2.new(1,-2,1,-37)
PlayersScroll.Position = UDim2.new(0,1,0,36)
PlayersScroll.BackgroundColor3 = Color3.fromRGB(45,45,45)
PlayersScroll.BorderSizePixel = 1
PlayersScroll.BorderColor3 = Color3.fromRGB(100,100,100)
PlayersScroll.ScrollBarThickness = 8
PlayersScroll.CanvasSize = UDim2.new(0,0,0,0)
PlayersScroll.ZIndex = 2
PlayersScroll.Parent = PlayersFrame

local PlayerButtons = {}

local function UpdatePlayerList()
    local currentPlayers = {}

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            currentPlayers[player.Name] = true
            PlayerList[player.Name] = true
        end
    end

    for _, model in pairs(Workspace:WaitForChild("Characters"):GetChildren()) do
        if model:IsA("Model") and model.Name ~= LocalPlayer.Name then
            currentPlayers[model.Name] = true
            PlayerList[model.Name] = true
        end
    end

    for name, button in pairs(PlayerButtons) do
        if not currentPlayers[name] then
            button:Destroy()
            PlayerButtons[name] = nil
            PlayerToggles[name] = nil
            PlayerList[name] = nil
        end
    end

    local y = 10
    for name, _ in pairs(PlayerList) do
        if not PlayerButtons[name] then
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1,-20,0,35)
            button.Position = UDim2.new(0,10,0,y)
            button.BackgroundColor3 = Color3.fromRGB(0,120,0)
            button.BorderSizePixel = 1
            button.BorderColor3 = Color3.fromRGB(100,100,100)
            button.Text = name
            button.TextColor3 = Color3.fromRGB(255,255,255)
            button.Font = Enum.Font.Legacy
            button.TextSize = 14
            button.ZIndex = 3
            button.Parent = PlayersScroll
            PlayerToggles[name] = true
            button.MouseButton1Click:Connect(function()
                PlayerToggles[name] = not PlayerToggles[name]
                if PlayerToggles[name] then
                    button.BackgroundColor3 = Color3.fromRGB(0,120,0)
                else
                    button.BackgroundColor3 = Color3.fromRGB(80,80,80)
                end
            end)
            PlayerButtons[name] = button
        end
    end

    local sortedNames = {}
    for name, _ in pairs(PlayerButtons) do
        table.insert(sortedNames, name)
    end
    table.sort(sortedNames)

    for i, name in ipairs(sortedNames) do
        PlayerButtons[name].Position = UDim2.new(0,10,0, 10 + (i-1) * 40)
    end

    PlayersScroll.CanvasSize = UDim2.new(0,0,0, 10 + #sortedNames * 40 + 10)
end

BigHeadSettingsButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    PlayersFrame.Visible = true
    UpdatePlayerList()
end)

PlayersBackButton.MouseButton1Click:Connect(function()
    PlayersFrame.Visible = false
    MainFrame.Visible = true
end)

PlayersCloseButton.MouseButton1Click:Connect(function()
    PlayersFrame.Visible = false
    MainFrame.Visible = true
end)

local playersDragging = false
local playersDragStart = nil
local playersStartPos = nil

PlayersTitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        playersDragging = true
        playersDragStart = input.Position
        playersStartPos = PlayersFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                playersDragging = false
            end
        end)
    end
end)

PlayersTitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and playersDragging then
        local delta = input.Position - playersDragStart
        PlayersFrame.Position = UDim2.new(playersStartPos.X.Scale, playersStartPos.X.Offset + delta.X, playersStartPos.Y.Scale, playersStartPos.Y.Offset + delta.Y)
    end
end)

local Characters = Workspace:WaitForChild("Characters")
local Debris = Workspace:WaitForChild("Debris")

local Highlights = {}
local ESPElements = {}

local function HasHelmet(model)
    local armor = model:FindFirstChild("CharacterArmor")
    if armor then
        return armor:FindFirstChild("Helmet") ~= nil
    end
    return false
end

local function HasBalaclava(model)
    local armor = model:FindFirstChild("CharacterArmor")
    if armor then
        return armor:FindFirstChild("Balaclava") ~= nil
    end
    return false
end

local function GetPlayerModel()
    return Characters:FindFirstChild(LocalPlayer.Name)
end

local function HasBomb(model)
    local weapons = Debris:FindFirstChild(model.Name .. "_WeaponAttachments")
    if weapons then
        return weapons:FindFirstChild("BombHolster") ~= nil
    end
    return false
end

local function GetESPColor(model)
    local playerModel = GetPlayerModel()
    local hasBomb = HasBomb(model)

    if playerModel then
        local playerHelmet = HasHelmet(playerModel)
        local playerBalaclava = HasBalaclava(playerModel)
        local targetHelmet = HasHelmet(model)
        local targetBalaclava = HasBalaclava(model)

        local playerType = playerHelmet and "Helmet" or (playerBalaclava and "Balaclava" or "None")
        local targetType = targetHelmet and "Helmet" or (targetBalaclava and "Balaclava" or "None")

        if playerType == targetType and playerType ~= "None" then
            return hasBomb and Color3.fromRGB(255,255,0) or Color3.fromRGB(0,255,0)
        else
            return hasBomb and Color3.fromRGB(255,128,0) or Color3.fromRGB(255,0,0)
        end
    else
        return HasHelmet(model) and Color3.fromRGB(0,0,255) or Color3.fromRGB(255,128,0)
    end
end

local function GetWeapons(model)
    local weapons = {}
    local weaponFolder = Debris:FindFirstChild(model.Name .. "_WeaponAttachments")
    if weaponFolder then
        for _, weapon in pairs(weaponFolder:GetChildren()) do
            if weapon:IsA("Model") or weapon:IsA("BasePart") then
                table.insert(weapons, weapon.Name)
            end
        end
    end
    return weapons
end

local function AddESP(model)
    local color = GetESPColor(model)

    if not model:FindFirstChild("PlayerESP") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "PlayerESP"
        highlight.FillColor = color
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = color
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Enabled = true
        highlight.Parent = model
        table.insert(Highlights, {Highlight = highlight, Model = model})
    end

    if not model:FindFirstChild("ESPName") then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESPName"
        billboard.Size = UDim2.new(0,200,0,60)
        billboard.StudsOffset = Vector3.new(0,3,0)
        billboard.AlwaysOnTop = true
        billboard.MaxDistance = 1000
        billboard.Parent = model

        local weaponLabel = Instance.new("TextLabel")
        weaponLabel.Name = "WeaponLabel"
        weaponLabel.Size = UDim2.new(1,0,0,30)
        weaponLabel.Position = UDim2.new(0,0,0,0)
        weaponLabel.BackgroundTransparency = 1
        weaponLabel.Text = ""
        weaponLabel.TextColor3 = Color3.fromRGB(255,255,255)
        weaponLabel.Font = Enum.Font.Legacy
        weaponLabel.TextSize = 12
        weaponLabel.TextStrokeTransparency = 0
        weaponLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
        weaponLabel.TextScaled = false
        weaponLabel.Parent = billboard

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "NameLabel"
        nameLabel.Size = UDim2.new(1,0,0,30)
        nameLabel.Position = UDim2.new(0,0,0,30)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = model.Name
        nameLabel.TextColor3 = color
        nameLabel.Font = Enum.Font.Legacy
        nameLabel.TextSize = 16
        nameLabel.TextStrokeTransparency = 0
        nameLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
        nameLabel.TextScaled = false
        nameLabel.Parent = billboard

        table.insert(ESPElements, {Billboard = billboard, NameLabel = nameLabel, WeaponLabel = weaponLabel, Model = model})
    end
end

local function UpdateWeapons()
    for _, data in pairs(ESPElements) do
        if data.WeaponLabel and data.WeaponLabel.Parent and data.Model and data.Model.Parent then
            if State.E and State.We then
                local weapons = GetWeapons(data.Model)
                if #weapons > 0 then
                    data.WeaponLabel.Text = "Weapons: " .. table.concat(weapons, ", ")
                else
                    data.WeaponLabel.Text = ""
                end
            else
                data.WeaponLabel.Text = ""
            end
        end
    end
end

local function UpdateESP()
    for _, data in pairs(Highlights) do
        if data.Highlight then
            data.Highlight:Destroy()
        end
    end
    Highlights = {}

    for _, data in pairs(ESPElements) do
        if data.Billboard then
            data.Billboard:Destroy()
        end
    end
    ESPElements = {}

    for _, model in pairs(Characters:GetChildren()) do
        local oldHighlight = model:FindFirstChild("PlayerESP")
        if oldHighlight then oldHighlight:Destroy() end
        local oldBillboard = model:FindFirstChild("ESPName")
        if oldBillboard then oldBillboard:Destroy() end
    end

    if not State.E then return end

    for _, model in pairs(Characters:GetChildren()) do
        if model:IsA("Model") and model.Name ~= LocalPlayer.Name then
            AddESP(model)
        end
    end

    UpdateWeapons()
end

local function UpdateESPColors()
    for _, data in pairs(Highlights) do
        if data.Highlight and data.Highlight.Parent and data.Model and data.Model.Parent then
            local color = GetESPColor(data.Model)
            data.Highlight.FillColor = color
            data.Highlight.OutlineColor = color
            data.Highlight.OutlineTransparency = 0
        end
    end

    for _, data in pairs(ESPElements) do
        if data.NameLabel and data.NameLabel.Parent and data.Model and data.Model.Parent then
            data.NameLabel.TextColor3 = GetESPColor(data.Model)
        end
    end
end

local flashNames = {"FlashbangEffect", "FlashScreenshot", "FlashEffect", "FlashbangColorCorrection", "ColorCorrection", "WhiteScreen", "WhiteScreenGui", "Flashbang", "FlashBang", "Flash"}

local function IsFlashEffect(obj)
    local name = obj.Name:lower()
    for _, flashName in pairs(flashNames) do
        if name:find(flashName:lower()) then
            return true
        end
    end
    return false
end

local function IsSmokeEffect(obj)
    local name = obj.Name:lower()
    return name:find("smoke") ~= nil or name:find("voxel") ~= nil
end

PlayerGui.ChildAdded:Connect(function(child)
    if State.Af and IsFlashEffect(child) then
        child:Destroy()
    end
end)

PlayerGui.DescendantAdded:Connect(function(descendant)
    if State.Af and IsFlashEffect(descendant) then
        descendant:Destroy()
    end
end)

Lighting.ChildAdded:Connect(function(child)
    if State.Af and IsFlashEffect(child) then
        child:Destroy()
    end
end)

Debris.ChildAdded:Connect(function(child)
    if State.As and IsSmokeEffect(child) then
        child:Destroy()
    end
end)

local OriginalHeadSizes = {}

local function UpdateBigHead()
    for _, model in pairs(Characters:GetChildren()) do
        if model:IsA("Model") and model.Name ~= LocalPlayer.Name then
            local head = model:FindFirstChild("Head")
            if head then
                if not OriginalHeadSizes[model.Name] then
                    OriginalHeadSizes[model.Name] = head.Size
                end
                if State.He and PlayerToggles[model.Name] then
                    head.Size = OriginalHeadSizes[model.Name] * State.Hv
                else
                    head.Size = OriginalHeadSizes[model.Name]
                end
            end
        end
    end
end

local sliderDragging = false
local maxSliderValue = 9

HeadSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        sliderDragging = true
        local mousePos = input.Position
        local sliderPos = HeadSlider.AbsolutePosition
        local sliderSize = HeadSlider.AbsoluteSize
        local ratio = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
        State.Hv = 1 + (ratio * maxSliderValue)
        HeadSliderFill.Size = UDim2.new(ratio, 0, 1, 0)
        HeadSliderLabel.Text = "x" .. string.format("%.1f", State.Hv)
        UpdateBigHead()
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if sliderDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = input.Position
        local sliderPos = HeadSlider.AbsolutePosition
        local sliderSize = HeadSlider.AbsoluteSize
        local ratio = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
        State.Hv = 1 + (ratio * maxSliderValue)
        HeadSliderFill.Size = UDim2.new(ratio, 0, 1, 0)
        HeadSliderLabel.Text = "x" .. string.format("%.1f", State.Hv)
        UpdateBigHead()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        sliderDragging = false
    end
end)

local GeometryPart = nil

local function ToggleWalls(enabled)
    if enabled then
        local map = Workspace:FindFirstChild("Map")
        if map then
            for _, child in pairs(map:GetChildren()) do
                if child.Name:lower():find("geometry") then
                    GeometryPart = child
                    child.Parent = ReplicatedStorage
                    break
                end
            end
        end
    else
        if GeometryPart and GeometryPart.Parent == ReplicatedStorage then
            local map = Workspace:FindFirstChild("Map")
            if map then
                GeometryPart.Parent = map
            end
            GeometryPart = nil
        else
            for _, child in pairs(ReplicatedStorage:GetChildren()) do
                if child.Name:lower():find("geometry") then
                    local map = Workspace:FindFirstChild("Map")
                    if map then
                        child.Parent = map
                    end
                    break
                end
            end
        end
    end
end

ESPButton.MouseButton1Click:Connect(function()
    State.E = not State.E
    ESPButton.Text = State.E and "Player ESP: ON" or "Player ESP: OFF"
    ESPButton.BackgroundColor3 = State.E and Color3.fromRGB(0,120,0) or Color3.fromRGB(80,80,80)
    UpdateESP()
end)

WeaponESPButton.MouseButton1Click:Connect(function()
    State.We = not State.We
    WeaponESPButton.Text = State.We and "Weapon ESP: ON" or "Weapon ESP: OFF"
    WeaponESPButton.BackgroundColor3 = State.We and Color3.fromRGB(0,120,0) or Color3.fromRGB(80,80,80)
    UpdateWeapons()
end)

AntiFlashButton.MouseButton1Click:Connect(function()
    State.Af = not State.Af
    AntiFlashButton.Text = State.Af and "Anti-Flash: ON" or "Anti-Flash: OFF"
    AntiFlashButton.BackgroundColor3 = State.Af and Color3.fromRGB(0,120,0) or Color3.fromRGB(80,80,80)
end)

AntiSmokeButton.MouseButton1Click:Connect(function()
    State.As = not State.As
    AntiSmokeButton.Text = State.As and "Anti-Smoke: ON" or "Anti-Smoke: OFF"
    AntiSmokeButton.BackgroundColor3 = State.As and Color3.fromRGB(0,120,0) or Color3.fromRGB(80,80,80)
end)

BigHeadButton.MouseButton1Click:Connect(function()
    State.He = not State.He
    BigHeadButton.Text = State.He and "Big Head: ON" or "Big Head: OFF"
    BigHeadButton.BackgroundColor3 = State.He and Color3.fromRGB(0,120,0) or Color3.fromRGB(80,80,80)
    UpdateBigHead()
end)

RemoveWallsButton.MouseButton1Click:Connect(function()
    State.Rw = not State.Rw
    RemoveWallsButton.Text = State.Rw and "Remove Walls: ON" or "Remove Walls: OFF"
    RemoveWallsButton.BackgroundColor3 = State.Rw and Color3.fromRGB(0,120,0) or Color3.fromRGB(80,80,80)
    ToggleWalls(State.Rw)
end)

local menuKeyWaiting = false

MenuKeyButton.MouseButton1Click:Connect(function()
    if menuKeyWaiting then
        if MenuKeyConn then
            MenuKeyConn:Disconnect()
            MenuKeyConn = nil
        end
        menuKeyWaiting = false
        MenuKeyButton.Text = "Menu Key: " .. tostring(MenuKey):gsub("Enum.KeyCode.", "")
        MenuKeyButton.BackgroundColor3 = Color3.fromRGB(80,80,80)
        return
    end
    menuKeyWaiting = true
    MenuKeyButton.Text = "Press key..."
    MenuKeyButton.BackgroundColor3 = Color3.fromRGB(0,120,0)
    MenuKeyConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            MenuKey = input.KeyCode
            menuKeyWaiting = false
            MenuKeyButton.Text = "Menu Key: " .. tostring(input.KeyCode):gsub("Enum.KeyCode.", "")
            MenuKeyButton.BackgroundColor3 = Color3.fromRGB(80,80,80)
            if MenuKeyConn then
                MenuKeyConn:Disconnect()
                MenuKeyConn = nil
            end
        end
    end)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end

    if MenuKey ~= Enum.KeyCode.None and input.KeyCode == MenuKey then
        if not Exiting and IntroDone then
            MainFrame.Visible = not MainFrame.Visible
            PlayersFrame.Visible = false
            WarningGui.Visible = false
        end
        return
    end

    if Keybinds.ESP ~= Enum.KeyCode.None and input.KeyCode == Keybinds.ESP then
        State.E = not State.E
        ESPButton.Text = State.E and "Player ESP: ON" or "Player ESP: OFF"
        ESPButton.BackgroundColor3 = State.E and Color3.fromRGB(0,120,0) or Color3.fromRGB(80,80,80)
        UpdateESP()
    elseif Keybinds.WeaponESP ~= Enum.KeyCode.None and input.KeyCode == Keybinds.WeaponESP then
        State.We = not State.We
        WeaponESPButton.Text = State.We and "Weapon ESP: ON" or "Weapon ESP: OFF"
        WeaponESPButton.BackgroundColor3 = State.We and Color3.fromRGB(0,120,0) or Color3.fromRGB(80,80,80)
        UpdateWeapons()
    elseif Keybinds.AntiFlash ~= Enum.KeyCode.None and input.KeyCode == Keybinds.AntiFlash then
        State.Af = not State.Af
        AntiFlashButton.Text = State.Af and "Anti-Flash: ON" or "Anti-Flash: OFF"
        AntiFlashButton.BackgroundColor3 = State.Af and Color3.fromRGB(0,120,0) or Color3.fromRGB(80,80,80)
    elseif Keybinds.AntiSmoke ~= Enum.KeyCode.None and input.KeyCode == Keybinds.AntiSmoke then
        State.As = not State.As
        AntiSmokeButton.Text = State.As and "Anti-Smoke: ON" or "Anti-Smoke: OFF"
        AntiSmokeButton.BackgroundColor3 = State.As and Color3.fromRGB(0,120,0) or Color3.fromRGB(80,80,80)
    elseif Keybinds.BigHead ~= Enum.KeyCode.None and input.KeyCode == Keybinds.BigHead then
        State.He = not State.He
        BigHeadButton.Text = State.He and "Big Head: ON" or "Big Head: OFF"
        BigHeadButton.BackgroundColor3 = State.He and Color3.fromRGB(0,120,0) or Color3.fromRGB(80,80,80)
        UpdateBigHead()
    elseif Keybinds.RemoveWalls ~= Enum.KeyCode.None and input.KeyCode == Keybinds.RemoveWalls then
        State.Rw = not State.Rw
        RemoveWallsButton.Text = State.Rw and "Remove Walls: ON" or "Remove Walls: OFF"
        RemoveWallsButton.BackgroundColor3 = State.Rw and Color3.fromRGB(0,120,0) or Color3.fromRGB(80,80,80)
        ToggleWalls(State.Rw)
    end
end)

local Crosshair = nil

local function CreateCrosshair()
    if Crosshair and Crosshair.Parent then return end
    Crosshair = Instance.new("Frame")
    Crosshair.AnchorPoint = Vector2.new(0.5, 0)
    Crosshair.Size = UDim2.new(0,20,0,20)
    Crosshair.Position = UDim2.new(0.5, 0, 0.467500001, 0)
    Crosshair.BackgroundTransparency = 1
    Crosshair.ZIndex = 100
    Crosshair.Parent = ScreenGui

    local horizontal = Instance.new("Frame")
    horizontal.Size = UDim2.new(1,0,0,2)
    horizontal.Position = UDim2.new(0,0,0.5,-1)
    horizontal.BackgroundColor3 = Color3.fromRGB(0,255,0)
    horizontal.BorderSizePixel = 0
    horizontal.Parent = Crosshair

    local vertical = Instance.new("Frame")
    vertical.Size = UDim2.new(0,2,1,0)
    vertical.Position = UDim2.new(0.5,-1,0,0)
    vertical.BackgroundColor3 = Color3.fromRGB(0,255,0)
    vertical.BorderSizePixel = 0
    vertical.Parent = Crosshair
end

local function RemoveCrosshair()
    if Crosshair and Crosshair.Parent then
        Crosshair:Destroy()
    end
    Crosshair = nil
end

local function IsSniperEquipped()
    local camera = Workspace:FindFirstChild("Camera")
    if camera then
        return camera:FindFirstChild("SSG 08") ~= nil or camera:FindFirstChild("AWP") ~= nil
    end
    return false
end

task.spawn(function()
    while true do
        if not ScopeRemoved and not Exiting then
            if IsSniperEquipped() then
                CreateCrosshair()
            else
                RemoveCrosshair()
            end
        else
            RemoveCrosshair()
        end
        task.wait(0.1)
    end
end)

local function ExitScript()
    if ExitStarted then return end
    ExitStarted = true
    Exiting = true
    State.E = false
    State.We = false
    State.Af = false
    State.As = false
    State.He = false

    for _, conn in pairs(KeybindConnections) do
        if conn then conn:Disconnect() end
    end
    KeybindConnections = {}
    if MenuKeyConn then
        MenuKeyConn:Disconnect()
        MenuKeyConn = nil
    end

    for _, data in pairs(Highlights) do
        if data.Highlight and data.Highlight.Parent then
            data.Highlight:Destroy()
        end
    end
    Highlights = {}

    for _, data in pairs(ESPElements) do
        if data.Billboard and data.Billboard.Parent then
            data.Billboard:Destroy()
        end
    end
    ESPElements = {}

    MainFrame.Visible = false
    PlayersFrame.Visible = false
    WarningGui.Visible = false

    local exitText = Instance.new("TextLabel")
    exitText.Name = "ExitText"
    exitText.AnchorPoint = Vector2.new(0.5, 0.5)
    exitText.Size = UDim2.new(0,300,0,50)
    exitText.Position = UDim2.new(-0.5, 0, 0.5, 0)
    exitText.BackgroundTransparency = 1
    exitText.Text = "See you later!"
    exitText.TextColor3 = Color3.fromRGB(255,255,255)
    exitText.Font = Enum.Font.Legacy
    exitText.TextSize = 30
    exitText.ZIndex = 100
    exitText.Parent = ScreenGui

    task.wait(0.5)
    local slideIn = TweenService:Create(exitText, TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0.5, 0)})
    slideIn:Play()
    slideIn.Completed:Wait()

    task.wait(1)
    local fadeOut = TweenService:Create(exitText, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
    fadeOut:Play()
    fadeOut.Completed:Wait()

    ScreenGui:Destroy()
end

CloseButton.MouseButton1Click:Connect(ExitScript)

task.spawn(function()
    while true do
        if not Exiting then
            if State.E then
                for _, model in pairs(Characters:GetChildren()) do
                    if model:IsA("Model") and model.Name ~= LocalPlayer.Name then
                        if not model:FindFirstChild("PlayerESP") or not model:FindFirstChild("ESPName") then
                            AddESP(model)
                        end
                    end
                end
                UpdateESPColors()
                if State.We then
                    UpdateWeapons()
                end
            end

            if State.He and next(PlayerToggles) then
                UpdateBigHead()
            end

            if State.Rw then
                local map = Workspace:FindFirstChild("Map")
                if map then
                    for _, child in pairs(map:GetChildren()) do
                        if child.Name:lower():find("geometry") then
                            child.Parent = ReplicatedStorage
                            break
                        end
                    end
                end
            end

            if PlayersFrame.Visible then
                UpdatePlayerList()
            end
        end
        task.wait(0.5)
    end
end)

UpdateESP()
