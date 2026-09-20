local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Camera = Workspace.CurrentCamera

local Settings = {
    K = Enum.KeyCode.RightControl,
    E = false,
    We = false,
    Af = false,
    As = false,
    He = false,
    Hv = 2,
    Rw = false,
    Th = 1
}

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

local Themes = {
    {n="Default", bg=Color3.fromRGB(45,45,45), tb=Color3.fromRGB(35,35,35), b=Color3.fromRGB(80,80,80), t=Color3.fromRGB(255,255,255), on=Color3.fromRGB(0,120,0), off=Color3.fromRGB(80,80,80)},
    {n="Crimson", bg=Color3.fromRGB(60,25,25), tb=Color3.fromRGB(40,15,15), b=Color3.fromRGB(140,40,40), t=Color3.fromRGB(255,200,200), on=Color3.fromRGB(180,40,40), off=Color3.fromRGB(100,30,30)},
    {n="Ocean", bg=Color3.fromRGB(25,40,60), tb=Color3.fromRGB(15,25,40), b=Color3.fromRGB(40,90,150), t=Color3.fromRGB(200,230,255), on=Color3.fromRGB(40,90,150), off=Color3.fromRGB(30,70,120)},
    {n="Forest", bg=Color3.fromRGB(25,50,25), tb=Color3.fromRGB(15,35,15), b=Color3.fromRGB(50,120,50), t=Color3.fromRGB(200,255,200), on=Color3.fromRGB(50,120,50), off=Color3.fromRGB(40,90,40)},
    {n="Sunset", bg=Color3.fromRGB(80,40,20), tb=Color3.fromRGB(60,25,10), b=Color3.fromRGB(200,100,50), t=Color3.fromRGB(255,230,200), on=Color3.fromRGB(200,100,50), off=Color3.fromRGB(160,80,40)},
    {n="Purple", bg=Color3.fromRGB(50,25,70), tb=Color3.fromRGB(35,15,50), b=Color3.fromRGB(120,60,180), t=Color3.fromRGB(230,200,255), on=Color3.fromRGB(120,60,180), off=Color3.fromRGB(90,45,140)},
    {n="Gold", bg=Color3.fromRGB(70,55,20), tb=Color3.fromRGB(50,40,10), b=Color3.fromRGB(200,170,40), t=Color3.fromRGB(255,245,200), on=Color3.fromRGB(200,170,40), off=Color3.fromRGB(150,130,30)},
    {n="Pink", bg=Color3.fromRGB(70,30,50), tb=Color3.fromRGB(50,20,35), b=Color3.fromRGB(220,80,160), t=Color3.fromRGB(255,220,240), on=Color3.fromRGB(220,80,160), off=Color3.fromRGB(160,60,120)},
    {n="Mint", bg=Color3.fromRGB(30,60,55), tb=Color3.fromRGB(20,45,40), b=Color3.fromRGB(80,200,180), t=Color3.fromRGB(210,255,250), on=Color3.fromRGB(80,200,180), off=Color3.fromRGB(50,140,130)},
    {n="Cyber", bg=Color3.fromRGB(20,20,40), tb=Color3.fromRGB(10,10,25), b=Color3.fromRGB(0,220,255), t=Color3.fromRGB(200,255,255), on=Color3.fromRGB(0,220,255), off=Color3.fromRGB(0,130,160)},
    {n="Blood", bg=Color3.fromRGB(50,0,0), tb=Color3.fromRGB(35,0,0), b=Color3.fromRGB(180,0,0), t=Color3.fromRGB(255,200,200), on=Color3.fromRGB(180,0,0), off=Color3.fromRGB(120,0,0)},
    {n="Ice", bg=Color3.fromRGB(40,60,80), tb=Color3.fromRGB(25,40,60), b=Color3.fromRGB(120,200,255), t=Color3.fromRGB(220,245,255), on=Color3.fromRGB(120,200,255), off=Color3.fromRGB(70,140,200)}
}

local GradThemes = {
    {n="Rainbow", c1=Color3.fromRGB(255,0,0), c2=Color3.fromRGB(0,0,255), off=Color3.fromRGB(80,80,80)},
    {n="Fire", c1=Color3.fromRGB(255,200,0), c2=Color3.fromRGB(255,0,0), off=Color3.fromRGB(150,60,0)},
    {n="Lava", c1=Color3.fromRGB(255,100,0), c2=Color3.fromRGB(100,0,0), off=Color3.fromRGB(120,30,0)},
    {n="Sky", c1=Color3.fromRGB(0,200,255), c2=Color3.fromRGB(255,255,255), off=Color3.fromRGB(80,140,180)},
    {n="Galaxy", c1=Color3.fromRGB(100,0,200), c2=Color3.fromRGB(0,100,255), off=Color3.fromRGB(60,40,140)},
    {n="Matrix", c1=Color3.fromRGB(0,255,0), c2=Color3.fromRGB(0,50,0), off=Color3.fromRGB(0,100,50)},
    {n="Cherry", c1=Color3.fromRGB(255,0,100), c2=Color3.fromRGB(200,0,0), off=Color3.fromRGB(140,20,80)},
    {n="Toxic", c1=Color3.fromRGB(200,255,0), c2=Color3.fromRGB(0,150,50), off=Color3.fromRGB(80,120,20)}
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BallsHub"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0,450,0,520)
MainFrame.Position = UDim2.new(0.5,-225,0.5,-260)
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

local function GetThemeColors()
    if Settings.Th <= #Themes then
        local theme = Themes[Settings.Th]
        return theme.on or theme.b, theme.off, theme.b, theme.t
    else
        local grad = GradThemes[Settings.Th - #Themes]
        return grad.c1, grad.off, grad.c1, Color3.fromRGB(255,255,255)
    end
end

local function CreateFeatureButton(name, text, y, key)
    local button = Instance.new("TextButton")
    button.Name = name .. "Button"
    button.Size = UDim2.new(0,180,0,35)
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
    keybindButton.Size = UDim2.new(0,130,0,35)
    keybindButton.Position = UDim2.new(0,205,0,y)
    keybindButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
    keybindButton.BorderSizePixel = 1
    keybindButton.BorderColor3 = Color3.fromRGB(100,100,100)
    keybindButton.Text = "Key: None"
    keybindButton.TextColor3 = Color3.fromRGB(200,200,200)
    keybindButton.Font = Enum.Font.Legacy
    keybindButton.TextSize = 12
    keybindButton.ZIndex = 3
    keybindButton.Parent = ContentFrame

    local resetButton = Instance.new("TextButton")
    resetButton.Name = name .. "ResetKey"
    resetButton.Size = UDim2.new(0,35,0,35)
    resetButton.Position = UDim2.new(0,340,0,y)
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
        keybindButton.Text = "Press key..."
        local _, _, mainColor = GetThemeColors()
        keybindButton.BackgroundColor3 = mainColor
        local conn
        conn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                Keybinds[key] = input.KeyCode
                keybindButton.Text = "Key: " .. tostring(input.KeyCode):gsub("Enum.KeyCode.", "")
                local _, off = GetThemeColors()
                keybindButton.BackgroundColor3 = off
                conn:Disconnect()
            end
        end)
    end)

    resetButton.MouseButton1Click:Connect(function()
        Keybinds[key] = Enum.KeyCode.None
        keybindButton.Text = "Key: None"
        local _, off = GetThemeColors()
        keybindButton.BackgroundColor3 = off
    end)

    return button
end

local ESPButton = CreateFeatureButton("ESP", "Player ESP", 15, "ESP")
local WeaponESPButton = CreateFeatureButton("WeaponESP", "Weapon ESP", 55, "WeaponESP")
local AntiFlashButton = CreateFeatureButton("AntiFlash", "Anti-Flash", 95, "AntiFlash")
local AntiSmokeButton = CreateFeatureButton("AntiSmoke", "Anti-Smoke", 135, "AntiSmoke")

local ScopeButton = Instance.new("TextButton")
ScopeButton.Size = UDim2.new(0,180,0,35)
ScopeButton.Position = UDim2.new(0,15,0,175)
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
    local _, _, mainColor = GetThemeColors()
    ScopeButton.BackgroundColor3 = mainColor
    ScopeButton.Text = "Removed Scope"
    ScopeButton.TextColor3 = Color3.fromRGB(200,200,200)
    ScopeButton.AutoButtonColor = false
end)

local BigHeadButton = Instance.new("TextButton")
BigHeadButton.Size = UDim2.new(0,180,0,35)
BigHeadButton.Position = UDim2.new(0,15,0,215)
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
BigHeadKeybind.Size = UDim2.new(0,130,0,35)
BigHeadKeybind.Position = UDim2.new(0,205,0,215)
BigHeadKeybind.BackgroundColor3 = Color3.fromRGB(60,60,60)
BigHeadKeybind.BorderSizePixel = 1
BigHeadKeybind.BorderColor3 = Color3.fromRGB(100,100,100)
BigHeadKeybind.Text = "Key: None"
BigHeadKeybind.TextColor3 = Color3.fromRGB(200,200,200)
BigHeadKeybind.Font = Enum.Font.Legacy
BigHeadKeybind.TextSize = 12
BigHeadKeybind.ZIndex = 3
BigHeadKeybind.Parent = ContentFrame

local BigHeadReset = Instance.new("TextButton")
BigHeadReset.Size = UDim2.new(0,35,0,35)
BigHeadReset.Position = UDim2.new(0,340,0,215)
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
    BigHeadKeybind.Text = "Press key..."
    local _, _, mainColor = GetThemeColors()
    BigHeadKeybind.BackgroundColor3 = mainColor
    local conn
    conn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            Keybinds.BigHead = input.KeyCode
            BigHeadKeybind.Text = "Key: " .. tostring(input.KeyCode):gsub("Enum.KeyCode.", "")
            local _, off = GetThemeColors()
            BigHeadKeybind.BackgroundColor3 = off
            conn:Disconnect()
        end
    end)
end)

BigHeadReset.MouseButton1Click:Connect(function()
    Keybinds.BigHead = Enum.KeyCode.None
    BigHeadKeybind.Text = "Key: None"
    local _, off = GetThemeColors()
    BigHeadKeybind.BackgroundColor3 = off
end)

local BigHeadSettingsButton = Instance.new("TextButton")
BigHeadSettingsButton.Size = UDim2.new(0,180,0,35)
BigHeadSettingsButton.Position = UDim2.new(0,15,0,255)
BigHeadSettingsButton.BackgroundColor3 = Color3.fromRGB(80,80,80)
BigHeadSettingsButton.BorderSizePixel = 1
BigHeadSettingsButton.BorderColor3 = Color3.fromRGB(100,100,100)
BigHeadSettingsButton.Text = "Big Head Settings"
BigHeadSettingsButton.TextColor3 = Color3.fromRGB(255,255,255)
BigHeadSettingsButton.Font = Enum.Font.Legacy
BigHeadSettingsButton.TextSize = 14
BigHeadSettingsButton.ZIndex = 3
BigHeadSettingsButton.Parent = ContentFrame

local SettingsButton = Instance.new("TextButton")
SettingsButton.Size = UDim2.new(0,180,0,35)
SettingsButton.Position = UDim2.new(0,15,0,295)
SettingsButton.BackgroundColor3 = Color3.fromRGB(80,80,80)
SettingsButton.BorderSizePixel = 1
SettingsButton.BorderColor3 = Color3.fromRGB(100,100,100)
SettingsButton.Text = "Settings"
SettingsButton.TextColor3 = Color3.fromRGB(255,255,255)
SettingsButton.Font = Enum.Font.Legacy
SettingsButton.TextSize = 14
SettingsButton.ZIndex = 3
SettingsButton.Parent = ContentFrame

local HeadSliderLabel = Instance.new("TextLabel")
HeadSliderLabel.Size = UDim2.new(0,50,0,20)
HeadSliderLabel.Position = UDim2.new(0,15,0,340)
HeadSliderLabel.BackgroundTransparency = 1
HeadSliderLabel.Text = "x2"
HeadSliderLabel.TextColor3 = Color3.fromRGB(255,255,255)
HeadSliderLabel.Font = Enum.Font.Legacy
HeadSliderLabel.TextSize = 12
HeadSliderLabel.TextXAlignment = Enum.TextXAlignment.Left
HeadSliderLabel.ZIndex = 3
HeadSliderLabel.Parent = ContentFrame

local HeadSlider = Instance.new("Frame")
HeadSlider.Size = UDim2.new(0,360,0,10)
HeadSlider.Position = UDim2.new(0,15,0,365)
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

local RemoveWallsButton = CreateFeatureButton("RemoveWalls", "Remove Walls", 390, "RemoveWalls")

local MenuKeyButton = Instance.new("TextButton")
MenuKeyButton.Size = UDim2.new(0,180,0,30)
MenuKeyButton.Position = UDim2.new(0,15,0,430)
MenuKeyButton.BackgroundColor3 = Color3.fromRGB(80,80,80)
MenuKeyButton.BorderSizePixel = 1
MenuKeyButton.BorderColor3 = Color3.fromRGB(100,100,100)
MenuKeyButton.Text = "Menu Key: " .. tostring(Settings.K):gsub("Enum.KeyCode.", "")
MenuKeyButton.TextColor3 = Color3.fromRGB(255,255,255)
MenuKeyButton.Font = Enum.Font.Legacy
MenuKeyButton.TextSize = 12
MenuKeyButton.ZIndex = 3
MenuKeyButton.Parent = ContentFrame

local MenuKeyReset = Instance.new("TextButton")
MenuKeyReset.Size = UDim2.new(0,35,0,30)
MenuKeyReset.Position = UDim2.new(0,205,0,430)
MenuKeyReset.BackgroundColor3 = Color3.fromRGB(120,40,40)
MenuKeyReset.BorderSizePixel = 1
MenuKeyReset.BorderColor3 = Color3.fromRGB(100,100,100)
MenuKeyReset.Text = "X"
MenuKeyReset.TextColor3 = Color3.fromRGB(255,255,255)
MenuKeyReset.Font = Enum.Font.Legacy
MenuKeyReset.TextSize = 14
MenuKeyReset.ZIndex = 3
MenuKeyReset.Parent = ContentFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1,-30,0,20)
StatusLabel.Position = UDim2.new(0,15,0,465)
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

local SettingsFrame = Instance.new("Frame")
SettingsFrame.Name = "SettingsFrame"
SettingsFrame.Size = UDim2.new(0,450,0,420)
SettingsFrame.Position = UDim2.new(0.5,-225,0.5,-210)
SettingsFrame.BackgroundColor3 = Color3.fromRGB(60,60,60)
SettingsFrame.BorderSizePixel = 1
SettingsFrame.BorderColor3 = Color3.fromRGB(150,150,150)
SettingsFrame.Visible = false
SettingsFrame.Parent = ScreenGui

local SettingsTitleBar = Instance.new("Frame")
SettingsTitleBar.Size = UDim2.new(1,-2,0,35)
SettingsTitleBar.Position = UDim2.new(0,1,0,1)
SettingsTitleBar.BackgroundColor3 = Color3.fromRGB(35,35,35)
SettingsTitleBar.BorderSizePixel = 1
SettingsTitleBar.BorderColor3 = Color3.fromRGB(100,100,100)
SettingsTitleBar.ZIndex = 2
SettingsTitleBar.Parent = SettingsFrame

local SettingsBackButton = Instance.new("TextButton")
SettingsBackButton.Size = UDim2.new(0,35,0,30)
SettingsBackButton.Position = UDim2.new(0,5,0,2)
SettingsBackButton.BackgroundColor3 = Color3.fromRGB(60,140,200)
SettingsBackButton.BorderSizePixel = 1
SettingsBackButton.BorderColor3 = Color3.fromRGB(100,100,100)
SettingsBackButton.Text = "<"
SettingsBackButton.TextColor3 = Color3.fromRGB(255,255,255)
SettingsBackButton.Font = Enum.Font.Legacy
SettingsBackButton.TextSize = 20
SettingsBackButton.ZIndex = 3
SettingsBackButton.Parent = SettingsTitleBar

local SettingsTitle = Instance.new("TextLabel")
SettingsTitle.Size = UDim2.new(0,300,1,0)
SettingsTitle.Position = UDim2.new(0,50,0,0)
SettingsTitle.BackgroundTransparency = 1
SettingsTitle.Text = "Settings - Theme"
SettingsTitle.TextColor3 = Color3.fromRGB(255,255,255)
SettingsTitle.Font = Enum.Font.Legacy
SettingsTitle.TextSize = 16
SettingsTitle.TextXAlignment = Enum.TextXAlignment.Left
SettingsTitle.ZIndex = 3
SettingsTitle.Parent = SettingsTitleBar

local SettingsCloseButton = Instance.new("TextButton")
SettingsCloseButton.Size = UDim2.new(0,30,0,30)
SettingsCloseButton.Position = UDim2.new(1,-32,0,2)
SettingsCloseButton.BackgroundColor3 = Color3.fromRGB(180,40,40)
SettingsCloseButton.BorderSizePixel = 1
SettingsCloseButton.BorderColor3 = Color3.fromRGB(100,100,100)
SettingsCloseButton.Text = "X"
SettingsCloseButton.TextColor3 = Color3.fromRGB(255,255,255)
SettingsCloseButton.Font = Enum.Font.Legacy
SettingsCloseButton.TextSize = 16
SettingsCloseButton.ZIndex = 3
SettingsCloseButton.Parent = SettingsTitleBar

local SettingsScroll = Instance.new("ScrollingFrame")
SettingsScroll.Size = UDim2.new(1,-2,1,-37)
SettingsScroll.Position = UDim2.new(0,1,0,36)
SettingsScroll.BackgroundColor3 = Color3.fromRGB(45,45,45)
SettingsScroll.BorderSizePixel = 1
SettingsScroll.BorderColor3 = Color3.fromRGB(100,100,100)
SettingsScroll.ScrollBarThickness = 8
SettingsScroll.CanvasSize = UDim2.new(0,0,0,0)
SettingsScroll.ZIndex = 2
SettingsScroll.Parent = SettingsFrame

local ThemeButtons = {}

local function ApplyTheme(index)
    local clearGradients = function(obj)
        if not obj then return end
        for _, child in pairs(obj:GetChildren()) do
            if child:IsA("UIGradient") then
                child:Destroy()
            end
        end
    end

    local applyColor = function(btn, color)
        if not btn then return end
        clearGradients(btn)
        btn.BackgroundColor3 = color
    end

    local applyGradient = function(btn, c1, c2)
        if not btn then return end
        clearGradients(btn)
        local gradient = Instance.new("UIGradient")
        gradient.Color = ColorSequence.new(c1, c2)
        gradient.Rotation = 90
        gradient.Parent = btn
        btn.BackgroundColor3 = Color3.fromRGB(150,150,150)
    end

    local applyTextColor = function(label, color)
        if not label then return end
        label.TextColor3 = color
    end

    local mainButtons = {ESPButton, WeaponESPButton, AntiFlashButton, AntiSmokeButton, ScopeButton, BigHeadButton, BigHeadSettingsButton, SettingsButton, RemoveWallsButton, MenuKeyButton, MenuKeyReset, CloseButton, PlayersCloseButton, SettingsCloseButton}
    local keyButtons = {}
    local resetButtons = {}

    for _, name in ipairs({"ESP", "WeaponESP", "AntiFlash", "AntiSmoke", "RemoveWalls"}) do
        local kb = ContentFrame:FindFirstChild(name .. "Keybind")
        local rb = ContentFrame:FindFirstChild(name .. "ResetKey")
        if kb then table.insert(keyButtons, kb) end
        if rb then table.insert(resetButtons, rb) end
    end

    table.insert(keyButtons, BigHeadKeybind)
    table.insert(resetButtons, BigHeadReset)
    table.insert(resetButtons, MenuKeyReset)

    local settingsButtons = {PlayersBackButton, SettingsBackButton}
    local settingsFrames = {PlayersFrame, PlayersTitleBar, SettingsFrame, SettingsTitleBar, PlayersScroll, SettingsScroll}

    if index == 1 then
        local theme = Themes[1]
        applyColor(ContentFrame, theme.bg)
        applyColor(TitleBar, theme.tb)
        applyColor(MainFrame, theme.bg)
        applyColor(HeadSlider, Color3.fromRGB(100,100,100))
        applyColor(HeadSliderFill, theme.on)

        for _, f in ipairs(settingsFrames) do applyColor(f, theme.bg) end
        applyColor(PlayersTitleBar, theme.tb)
        applyColor(SettingsTitleBar, theme.tb)

        for _, b in ipairs(mainButtons) do applyColor(b, theme.b) end
        for _, b in ipairs(keyButtons) do applyColor(b, theme.off) end
        for _, b in ipairs(resetButtons) do applyColor(b, Color3.fromRGB(120,40,40)) end
        for _, b in ipairs(settingsButtons) do applyColor(b, theme.b) end

        applyTextColor(TitleLabel, theme.t)
        applyTextColor(VersionLabel, theme.t)
        applyTextColor(HeadSliderLabel, theme.t)
        applyTextColor(StatusLabel, theme.t)
        applyTextColor(PlayersTitle, theme.t)
        applyTextColor(SettingsTitle, theme.t)
        applyTextColor(ESPButton, theme.t)
        applyTextColor(WeaponESPButton, theme.t)
        applyTextColor(AntiFlashButton, theme.t)
        applyTextColor(AntiSmokeButton, theme.t)
        applyTextColor(BigHeadButton, theme.t)
        applyTextColor(BigHeadSettingsButton, theme.t)
        applyTextColor(SettingsButton, theme.t)
        applyTextColor(RemoveWallsButton, theme.t)
        applyTextColor(MenuKeyButton, theme.t)

        if Settings.E then ESPButton.BackgroundColor3 = theme.on else ESPButton.BackgroundColor3 = theme.off end
        if Settings.We then WeaponESPButton.BackgroundColor3 = theme.on else WeaponESPButton.BackgroundColor3 = theme.off end
        if Settings.Af then AntiFlashButton.BackgroundColor3 = theme.on else AntiFlashButton.BackgroundColor3 = theme.off end
        if Settings.As then AntiSmokeButton.BackgroundColor3 = theme.on else AntiSmokeButton.BackgroundColor3 = theme.off end
        if Settings.He then BigHeadButton.BackgroundColor3 = theme.on else BigHeadButton.BackgroundColor3 = theme.off end
        if Settings.Rw then RemoveWallsButton.BackgroundColor3 = theme.on else RemoveWallsButton.BackgroundColor3 = theme.off end

        if ScopeRemoved then
            ScopeButton.BackgroundColor3 = theme.on
            ScopeButton.TextColor3 = Color3.fromRGB(200,200,200)
        else
            ScopeButton.TextColor3 = theme.t
        end
    elseif index > #Themes then
        local grad = GradThemes[index - #Themes]

        applyGradient(ContentFrame, grad.c1, grad.c2)
        applyGradient(TitleBar, grad.c1, grad.c2)
        applyGradient(MainFrame, grad.c1, grad.c2)
        applyGradient(HeadSlider, grad.c1, grad.c2)
        applyGradient(HeadSliderFill, grad.c1:lerp(Color3.new(1,1,1), 0.35), grad.c2:lerp(Color3.new(1,1,1), 0.35))

        for _, f in ipairs(settingsFrames) do applyGradient(f, grad.c1, grad.c2) end
        applyGradient(PlayersTitleBar, grad.c1, grad.c2)
        applyGradient(SettingsTitleBar, grad.c1, grad.c2)

        for _, b in ipairs(mainButtons) do applyGradient(b, grad.c1, grad.c2) end
        for _, b in ipairs(keyButtons) do
            clearGradients(b)
            b.BackgroundColor3 = grad.off
        end
        for _, b in ipairs(resetButtons) do applyColor(b, Color3.fromRGB(120,40,40)) end
        for _, b in ipairs(settingsButtons) do applyGradient(b, grad.c1, grad.c2) end

        applyTextColor(TitleLabel, Color3.fromRGB(255,255,255))
        applyTextColor(VersionLabel, Color3.fromRGB(255,215,0))
        applyTextColor(HeadSliderLabel, Color3.fromRGB(255,255,255))
        applyTextColor(StatusLabel, Color3.fromRGB(255,255,0))
        applyTextColor(PlayersTitle, Color3.fromRGB(255,255,255))
        applyTextColor(SettingsTitle, Color3.fromRGB(255,255,255))
        applyTextColor(ESPButton, Color3.fromRGB(255,255,255))
        applyTextColor(WeaponESPButton, Color3.fromRGB(255,255,255))
        applyTextColor(AntiFlashButton, Color3.fromRGB(255,255,255))
        applyTextColor(AntiSmokeButton, Color3.fromRGB(255,255,255))
        applyTextColor(BigHeadButton, Color3.fromRGB(255,255,255))
        applyTextColor(BigHeadSettingsButton, Color3.fromRGB(255,255,255))
        applyTextColor(SettingsButton, Color3.fromRGB(255,255,255))
        applyTextColor(RemoveWallsButton, Color3.fromRGB(255,255,255))
        applyTextColor(MenuKeyButton, Color3.fromRGB(255,255,255))

        local onColor = grad.c1
        if Settings.E then ESPButton.BackgroundColor3 = onColor else ESPButton.BackgroundColor3 = grad.off end
        if Settings.We then WeaponESPButton.BackgroundColor3 = onColor else WeaponESPButton.BackgroundColor3 = grad.off end
        if Settings.Af then AntiFlashButton.BackgroundColor3 = onColor else AntiFlashButton.BackgroundColor3 = grad.off end
        if Settings.As then AntiSmokeButton.BackgroundColor3 = onColor else AntiSmokeButton.BackgroundColor3 = grad.off end
        if Settings.He then BigHeadButton.BackgroundColor3 = onColor else BigHeadButton.BackgroundColor3 = grad.off end
        if Settings.Rw then RemoveWallsButton.BackgroundColor3 = onColor else RemoveWallsButton.BackgroundColor3 = grad.off end

        if ScopeRemoved then
            ScopeButton.BackgroundColor3 = onColor
            ScopeButton.TextColor3 = Color3.fromRGB(200,200,200)
        else
            ScopeButton.TextColor3 = Color3.fromRGB(255,255,255)
        end
    else
        local theme = Themes[index]

        applyColor(ContentFrame, theme.bg)
        applyColor(TitleBar, theme.tb)
        applyColor(MainFrame, theme.bg)
        applyColor(HeadSlider, Color3.fromRGB(100,100,100))
        applyColor(HeadSliderFill, theme.on or theme.b)

        for _, f in ipairs(settingsFrames) do applyColor(f, theme.bg) end
        applyColor(PlayersTitleBar, theme.tb)
        applyColor(SettingsTitleBar, theme.tb)

        for _, b in ipairs(mainButtons) do applyColor(b, theme.b) end
        for _, b in ipairs(keyButtons) do applyColor(b, theme.off) end
        for _, b in ipairs(resetButtons) do applyColor(b, Color3.fromRGB(120,40,40)) end
        for _, b in ipairs(settingsButtons) do applyColor(b, theme.b) end

        applyTextColor(TitleLabel, theme.t)
        applyTextColor(VersionLabel, theme.t)
        applyTextColor(HeadSliderLabel, theme.t)
        applyTextColor(StatusLabel, theme.t)
        applyTextColor(PlayersTitle, theme.t)
        applyTextColor(SettingsTitle, theme.t)
        applyTextColor(ESPButton, theme.t)
        applyTextColor(WeaponESPButton, theme.t)
        applyTextColor(AntiFlashButton, theme.t)
        applyTextColor(AntiSmokeButton, theme.t)
        applyTextColor(BigHeadButton, theme.t)
        applyTextColor(BigHeadSettingsButton, theme.t)
        applyTextColor(SettingsButton, theme.t)
        applyTextColor(RemoveWallsButton, theme.t)
        applyTextColor(MenuKeyButton, theme.t)

        local onColor = theme.on or theme.b
        if Settings.E then ESPButton.BackgroundColor3 = onColor else ESPButton.BackgroundColor3 = theme.off end
        if Settings.We then WeaponESPButton.BackgroundColor3 = onColor else WeaponESPButton.BackgroundColor3 = theme.off end
        if Settings.Af then AntiFlashButton.BackgroundColor3 = onColor else AntiFlashButton.BackgroundColor3 = theme.off end
        if Settings.As then AntiSmokeButton.BackgroundColor3 = onColor else AntiSmokeButton.BackgroundColor3 = theme.off end
        if Settings.He then BigHeadButton.BackgroundColor3 = onColor else BigHeadButton.BackgroundColor3 = theme.off end
        if Settings.Rw then RemoveWallsButton.BackgroundColor3 = onColor else RemoveWallsButton.BackgroundColor3 = theme.off end

        if ScopeRemoved then
            ScopeButton.BackgroundColor3 = onColor
            ScopeButton.TextColor3 = Color3.fromRGB(200,200,200)
        else
            ScopeButton.TextColor3 = theme.t
        end
    end

    for i, b in ipairs(ThemeButtons) do
        if i == index then
            b.BorderColor3 = Color3.fromRGB(0,255,0)
            b.BorderSizePixel = 3
        else
            b.BorderColor3 = Color3.fromRGB(100,100,100)
            b.BorderSizePixel = 1
        end
    end

    Settings.Th = index
end

for i, theme in ipairs(Themes) do
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0,80,0,60)
    button.Position = UDim2.new(0, 10 + ((i-1) % 5) * 88, 0, 10 + math.floor((i-1) / 5) * 70)
    button.BackgroundColor3 = theme.b
    button.BorderSizePixel = 1
    button.BorderColor3 = Color3.fromRGB(100,100,100)
    button.Text = theme.n
    button.TextColor3 = Color3.fromRGB(255,255,255)
    button.Font = Enum.Font.Legacy
    button.TextSize = 12
    button.ZIndex = 3
    button.Parent = SettingsScroll
    ThemeButtons[i] = button
    button.MouseButton1Click:Connect(function() ApplyTheme(i) end)
end

local gradientStart = #Themes

for i, grad in ipairs(GradThemes) do
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0,80,0,60)
    button.Position = UDim2.new(0, 10 + ((i-1) % 5) * 88, 0, 10 + math.floor((i-1+gradientStart) / 5) * 70)
    button.BackgroundColor3 = Color3.fromRGB(150,150,150)
    button.BorderSizePixel = 1
    button.BorderColor3 = Color3.fromRGB(100,100,100)
    button.Text = grad.n
    button.TextColor3 = Color3.fromRGB(255,255,255)
    button.Font = Enum.Font.Legacy
    button.TextSize = 12
    button.ZIndex = 3
    button.Parent = SettingsScroll

    local gr = Instance.new("UIGradient")
    gr.Color = ColorSequence.new(grad.c1, grad.c2)
    gr.Rotation = 90
    gr.Parent = button

    ThemeButtons[gradientStart + i] = button
    button.MouseButton1Click:Connect(function() ApplyTheme(gradientStart + i) end)
end

SettingsScroll.CanvasSize = UDim2.new(0,0,0, 10 + math.ceil((#Themes + #GradThemes) / 5) * 70 + 10)

SettingsButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    SettingsFrame.Visible = true
end)

SettingsBackButton.MouseButton1Click:Connect(function()
    SettingsFrame.Visible = false
    MainFrame.Visible = true
end)

SettingsCloseButton.MouseButton1Click:Connect(function()
    SettingsFrame.Visible = false
    MainFrame.Visible = true
end)

local settingsDragging = false
local settingsDragStart = nil
local settingsStartPos = nil

SettingsTitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        settingsDragging = true
        settingsDragStart = input.Position
        settingsStartPos = SettingsFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                settingsDragging = false
            end
        end)
    end
end)

SettingsTitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and settingsDragging then
        local delta = input.Position - settingsDragStart
        SettingsFrame.Position = UDim2.new(settingsStartPos.X.Scale, settingsStartPos.X.Offset + delta.X, settingsStartPos.Y.Scale, settingsStartPos.Y.Offset + delta.Y)
    end
end)

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
                local on, off = GetThemeColors()
                if PlayerToggles[name] then
                    button.BackgroundColor3 = on
                else
                    button.BackgroundColor3 = off
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
            if Settings.E and Settings.We then
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

    if not Settings.E then return end

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
    if Settings.Af and IsFlashEffect(child) then
        child:Destroy()
    end
end)

PlayerGui.DescendantAdded:Connect(function(descendant)
    if Settings.Af and IsFlashEffect(descendant) then
        descendant:Destroy()
    end
end)

Lighting.ChildAdded:Connect(function(child)
    if Settings.Af and IsFlashEffect(child) then
        child:Destroy()
    end
end)

Debris.ChildAdded:Connect(function(child)
    if Settings.As and IsSmokeEffect(child) then
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
                if Settings.He and PlayerToggles[model.Name] then
                    head.Size = OriginalHeadSizes[model.Name] * Settings.Hv
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
        Settings.Hv = 1 + (ratio * maxSliderValue)
        HeadSliderFill.Size = UDim2.new(ratio, 0, 1, 0)
        HeadSliderLabel.Text = "x" .. string.format("%.1f", Settings.Hv)
        UpdateBigHead()
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if sliderDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = input.Position
        local sliderPos = HeadSlider.AbsolutePosition
        local sliderSize = HeadSlider.AbsoluteSize
        local ratio = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
        Settings.Hv = 1 + (ratio * maxSliderValue)
        HeadSliderFill.Size = UDim2.new(ratio, 0, 1, 0)
        HeadSliderLabel.Text = "x" .. string.format("%.1f", Settings.Hv)
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
    Settings.E = not Settings.E
    local on, off = GetThemeColors()
    ESPButton.Text = Settings.E and "Player ESP: ON" or "Player ESP: OFF"
    ESPButton.BackgroundColor3 = Settings.E and on or off
    UpdateESP()
end)

WeaponESPButton.MouseButton1Click:Connect(function()
    Settings.We = not Settings.We
    local on, off = GetThemeColors()
    WeaponESPButton.Text = Settings.We and "Weapon ESP: ON" or "Weapon ESP: OFF"
    WeaponESPButton.BackgroundColor3 = Settings.We and on or off
    UpdateWeapons()
end)

AntiFlashButton.MouseButton1Click:Connect(function()
    Settings.Af = not Settings.Af
    local on, off = GetThemeColors()
    AntiFlashButton.Text = Settings.Af and "Anti-Flash: ON" or "Anti-Flash: OFF"
    AntiFlashButton.BackgroundColor3 = Settings.Af and on or off
end)

AntiSmokeButton.MouseButton1Click:Connect(function()
    Settings.As = not Settings.As
    local on, off = GetThemeColors()
    AntiSmokeButton.Text = Settings.As and "Anti-Smoke: ON" or "Anti-Smoke: OFF"
    AntiSmokeButton.BackgroundColor3 = Settings.As and on or off
end)

BigHeadButton.MouseButton1Click:Connect(function()
    Settings.He = not Settings.He
    local on, off = GetThemeColors()
    BigHeadButton.Text = Settings.He and "Big Head: ON" or "Big Head: OFF"
    BigHeadButton.BackgroundColor3 = Settings.He and on or off
    UpdateBigHead()
end)

RemoveWallsButton.MouseButton1Click:Connect(function()
    Settings.Rw = not Settings.Rw
    local on, off = GetThemeColors()
    RemoveWallsButton.Text = Settings.Rw and "Remove Walls: ON" or "Remove Walls: OFF"
    RemoveWallsButton.BackgroundColor3 = Settings.Rw and on or off
    ToggleWalls(Settings.Rw)
end)

local menuKeyWaiting = false

MenuKeyButton.MouseButton1Click:Connect(function()
    menuKeyWaiting = true
    MenuKeyButton.Text = "Press key..."
    local _, _, mainColor = GetThemeColors()
    MenuKeyButton.BackgroundColor3 = mainColor
end)

MenuKeyReset.MouseButton1Click:Connect(function()
    Settings.K = Enum.KeyCode.None
    MenuKeyButton.Text = "Menu Key: None"
    local _, off = GetThemeColors()
    MenuKeyButton.BackgroundColor3 = off
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if menuKeyWaiting and input.UserInputType == Enum.UserInputType.Keyboard then
        Settings.K = input.KeyCode
        menuKeyWaiting = false
        MenuKeyButton.Text = "Menu Key: " .. tostring(input.KeyCode):gsub("Enum.KeyCode.", "")
        local _, off = GetThemeColors()
        MenuKeyButton.BackgroundColor3 = off
        return
    end

    if gameProcessed then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end

    if Settings.K ~= Enum.KeyCode.None and input.KeyCode == Settings.K then
        if not Exiting and IntroDone then
            MainFrame.Visible = not MainFrame.Visible
            PlayersFrame.Visible = false
            SettingsFrame.Visible = false
            WarningGui.Visible = false
        end
        return
    end

    if Keybinds.ESP ~= Enum.KeyCode.None and input.KeyCode == Keybinds.ESP then
        Settings.E = not Settings.E
        local on, off = GetThemeColors()
        ESPButton.Text = Settings.E and "Player ESP: ON" or "Player ESP: OFF"
        ESPButton.BackgroundColor3 = Settings.E and on or off
        UpdateESP()
    elseif Keybinds.WeaponESP ~= Enum.KeyCode.None and input.KeyCode == Keybinds.WeaponESP then
        Settings.We = not Settings.We
        local on, off = GetThemeColors()
        WeaponESPButton.Text = Settings.We and "Weapon ESP: ON" or "Weapon ESP: OFF"
        WeaponESPButton.BackgroundColor3 = Settings.We and on or off
        UpdateWeapons()
    elseif Keybinds.AntiFlash ~= Enum.KeyCode.None and input.KeyCode == Keybinds.AntiFlash then
        Settings.Af = not Settings.Af
        local on, off = GetThemeColors()
        AntiFlashButton.Text = Settings.Af and "Anti-Flash: ON" or "Anti-Flash: OFF"
        AntiFlashButton.BackgroundColor3 = Settings.Af and on or off
    elseif Keybinds.AntiSmoke ~= Enum.KeyCode.None and input.KeyCode == Keybinds.AntiSmoke then
        Settings.As = not Settings.As
        local on, off = GetThemeColors()
        AntiSmokeButton.Text = Settings.As and "Anti-Smoke: ON" or "Anti-Smoke: OFF"
        AntiSmokeButton.BackgroundColor3 = Settings.As and on or off
    elseif Keybinds.BigHead ~= Enum.KeyCode.None and input.KeyCode == Keybinds.BigHead then
        Settings.He = not Settings.He
        local on, off = GetThemeColors()
        BigHeadButton.Text = Settings.He and "Big Head: ON" or "Big Head: OFF"
        BigHeadButton.BackgroundColor3 = Settings.He and on or off
        UpdateBigHead()
    elseif Keybinds.RemoveWalls ~= Enum.KeyCode.None and input.KeyCode == Keybinds.RemoveWalls then
        Settings.Rw = not Settings.Rw
        local on, off = GetThemeColors()
        RemoveWallsButton.Text = Settings.Rw and "Remove Walls: ON" or "Remove Walls: OFF"
        RemoveWallsButton.BackgroundColor3 = Settings.Rw and on or off
        ToggleWalls(Settings.Rw)
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
    Settings.E = false
    Settings.We = false
    Settings.Af = false
    Settings.As = false
    Settings.He = false

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
    SettingsFrame.Visible = false
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
            if Settings.E then
                for _, model in pairs(Characters:GetChildren()) do
                    if model:IsA("Model") and model.Name ~= LocalPlayer.Name then
                        if not model:FindFirstChild("PlayerESP") or not model:FindFirstChild("ESPName") then
                            AddESP(model)
                        end
                    end
                end
                UpdateESPColors()
                if Settings.We then
                    UpdateWeapons()
                end
            end

            if Settings.He and next(PlayerToggles) then
                UpdateBigHead()
            end

            if Settings.Rw then
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
