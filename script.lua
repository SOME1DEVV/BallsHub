-- BallsHub Menu - by MARGOSHA Team
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Camera = Workspace.CurrentCamera

-- Settings
local Settings = {
    Keybind = Enum.KeyCode.RightControl,
    ESPEnabled = false,
    WeaponESPEnabled = false,
    AntiFlashEnabled = false,
    AntiSmokeEnabled = false,
    HeadSizeEnabled = false,
    HeadSizeValue = 2,
    RemoveWallsEnabled = false
}

-- Keybinds для функций
local FunctionKeys = {
    ESP = Enum.KeyCode.None,
    WeaponESP = Enum.KeyCode.None,
    AntiFlash = Enum.KeyCode.None,
    AntiSmoke = Enum.KeyCode.None,
    RemoveScope = Enum.KeyCode.None,
    BigHead = Enum.KeyCode.None,
    RemoveWalls = Enum.KeyCode.None
}

-- Список игроков для Big Head (true = включён)
local BigHeadTargets = {}
-- Список всех когда-либо виденных игроков
local SeenPlayers = {}

local isExiting = false
local introComplete = false
local isClosing = false

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BallsHub"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

-- ============================================================
-- ГЛАВНОЕ МЕНЮ (MainFrame)
-- ============================================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 450, 0, 420)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(150, 150, 150)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- Intro Animation
local IntroFrame = Instance.new("Frame")
IntroFrame.Size = UDim2.new(1, 0, 1, 0)
IntroFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
IntroFrame.BackgroundTransparency = 1
IntroFrame.ZIndex = 1000
IntroFrame.Parent = ScreenGui

local LogoImage = Instance.new("ImageLabel")
LogoImage.Size = UDim2.new(0, 1, 0, 1)
LogoImage.Position = UDim2.new(0.5, -0.5, 0.5, -0.5)
LogoImage.BackgroundTransparency = 1
LogoImage.Image = "rbxassetid://91426913908147"
LogoImage.ZIndex = 1001
LogoImage.Parent = IntroFrame

local LogoText = Instance.new("TextLabel")
LogoText.Size = UDim2.new(0, 400, 0, 60)
LogoText.Position = UDim2.new(0.5, -200, 0.5, 100)
LogoText.BackgroundTransparency = 1
LogoText.Text = "MARGOSHA Team"
LogoText.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoText.Font = Enum.Font.Legacy
LogoText.TextSize = 35
LogoText.TextTransparency = 1
LogoText.ZIndex = 1001
LogoText.Parent = IntroFrame

task.spawn(function()
    task.wait(2)
    LogoImage.Rotation = 90
    TweenService:Create(LogoImage, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 250, 0, 250),
        Position = UDim2.new(0.5, -125, 0.5, -125),
        Rotation = 0
    }):Play()
    task.wait(1.8)
    TweenService:Create(LogoText, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
    task.wait(2)
    TweenService:Create(LogoText, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
    task.wait(0.3)
    TweenService:Create(LogoImage, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 3000, 0, 3000),
        Position = UDim2.new(0.5, -1500, 0.5, -1500),
        ImageTransparency = 1
    }):Play()
    task.wait(1)
    IntroFrame:Destroy()
    introComplete = true
    MainFrame.Visible = true
end)

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, -2, 0, 35)
TopBar.Position = UDim2.new(0, 1, 0, 1)
TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TopBar.BorderSizePixel = 1
TopBar.BorderColor3 = Color3.fromRGB(100, 100, 100)
TopBar.ZIndex = 2
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 150, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "BallsHub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.Legacy
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 3
Title.Parent = TopBar

local VersionLabel = Instance.new("TextLabel")
VersionLabel.Size = UDim2.new(0, 150, 1, 0)
VersionLabel.Position = UDim2.new(0, 160, 0, 0)
VersionLabel.BackgroundTransparency = 1
VersionLabel.Text = "v2.0 | by MARGOSHA Team"
VersionLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
VersionLabel.Font = Enum.Font.Legacy
VersionLabel.TextSize = 10
VersionLabel.TextXAlignment = Enum.TextXAlignment.Left
VersionLabel.ZIndex = 3
VersionLabel.Parent = TopBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -32, 0, 2)
CloseButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
CloseButton.BorderSizePixel = 1
CloseButton.BorderColor3 = Color3.fromRGB(100, 100, 100)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.Legacy
CloseButton.TextSize = 16
CloseButton.ZIndex = 3
CloseButton.Parent = TopBar

-- Dragging
local dragging = false
local dragStart = nil
local startPos = nil

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Content
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -2, 1, -37)
ContentFrame.Position = UDim2.new(0, 1, 0, 36)
ContentFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ContentFrame.BorderSizePixel = 1
ContentFrame.BorderColor3 = Color3.fromRGB(100, 100, 100)
ContentFrame.ZIndex = 2
ContentFrame.Parent = MainFrame

-- Функция создания кнопки с keybind + X
local function createFunctionButton(name, text, yPos, keybindName)
    local btn = Instance.new("TextButton")
    btn.Name = name .. "Button"
    btn.Size = UDim2.new(0, 180, 0, 35)
    btn.Position = UDim2.new(0, 15, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(100, 100, 100)
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Legacy
    btn.TextSize = 14
    btn.ZIndex = 3
    btn.Parent = ContentFrame

    local kbBtn = Instance.new("TextButton")
    kbBtn.Name = name .. "Keybind"
    kbBtn.Size = UDim2.new(0, 130, 0, 35)
    kbBtn.Position = UDim2.new(0, 205, 0, yPos)
    kbBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    kbBtn.BorderSizePixel = 1
    kbBtn.BorderColor3 = Color3.fromRGB(100, 100, 100)
    kbBtn.Text = "Key: None"
    kbBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    kbBtn.Font = Enum.Font.Legacy
    kbBtn.TextSize = 12
    kbBtn.ZIndex = 3
    kbBtn.Parent = ContentFrame

    -- Кнопка X (сброс)
    local xBtn = Instance.new("TextButton")
    xBtn.Name = name .. "ResetKey"
    xBtn.Size = UDim2.new(0, 35, 0, 35)
    xBtn.Position = UDim2.new(0, 340, 0, yPos)
    xBtn.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
    xBtn.BorderSizePixel = 1
    xBtn.BorderColor3 = Color3.fromRGB(100, 100, 100)
    xBtn.Text = "X"
    xBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    xBtn.Font = Enum.Font.Legacy
    xBtn.TextSize = 14
    xBtn.ZIndex = 3
    xBtn.Parent = ContentFrame

    -- Клик на kbBtn — смена
    kbBtn.MouseButton1Click:Connect(function()
        kbBtn.Text = "Press key..."
        kbBtn.BackgroundColor3 = Color3.fromRGB(120, 120, 0)
        local connection
        connection = UserInputService.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                FunctionKeys[keybindName] = input.KeyCode
                kbBtn.Text = "Key: " .. tostring(input.KeyCode):gsub("Enum.KeyCode.", "")
                kbBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                connection:Disconnect()
            end
        end)
    end)

    -- Клик на X — сброс в None
    xBtn.MouseButton1Click:Connect(function()
        FunctionKeys[keybindName] = Enum.KeyCode.None
        kbBtn.Text = "Key: None"
        kbBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end)

    return btn
end

-- Создаём кнопки
local ESPButton = createFunctionButton("ESP", "Player ESP", 15, "ESP")
local WeaponESPButton = createFunctionButton("WeaponESP", "Weapon ESP", 55, "WeaponESP")
local AntiFlashButton = createFunctionButton("AntiFlash", "Anti-Flash", 95, "AntiFlash")
local AntiSmokeButton = createFunctionButton("AntiSmoke", "Anti-Smoke", 135, "AntiSmoke")
local AntiScopeButton = createFunctionButton("AntiScope", "Remove Scope", 175, "RemoveScope")

-- Big Head Settings Button (открывает второй Frame)
local BigHeadSettingsButton = Instance.new("TextButton")
BigHeadSettingsButton.Size = UDim2.new(0, 180, 0, 35)
BigHeadSettingsButton.Position = UDim2.new(0, 15, 0, 215)
BigHeadSettingsButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
BigHeadSettingsButton.BorderSizePixel = 1
BigHeadSettingsButton.BorderColor3 = Color3.fromRGB(100, 100, 100)
BigHeadSettingsButton.Text = "Big Head Settings"
BigHeadSettingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
BigHeadSettingsButton.Font = Enum.Font.Legacy
BigHeadSettingsButton.TextSize = 14
BigHeadSettingsButton.ZIndex = 3
BigHeadSettingsButton.Parent = ContentFrame

-- Keybind для BigHead (ставится на саму кнопку Settings)
local BigHeadKeybindBtn = Instance.new("TextButton")
BigHeadKeybindBtn.Size = UDim2.new(0, 130, 0, 35)
BigHeadKeybindBtn.Position = UDim2.new(0, 205, 0, 215)
BigHeadKeybindBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
BigHeadKeybindBtn.BorderSizePixel = 1
BigHeadKeybindBtn.BorderColor3 = Color3.fromRGB(100, 100, 100)
BigHeadKeybindBtn.Text = "Key: None"
BigHeadKeybindBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
BigHeadKeybindBtn.Font = Enum.Font.Legacy
BigHeadKeybindBtn.TextSize = 12
BigHeadKeybindBtn.ZIndex = 3
BigHeadKeybindBtn.Parent = ContentFrame

local BigHeadResetBtn = Instance.new("TextButton")
BigHeadResetBtn.Size = UDim2.new(0, 35, 0, 35)
BigHeadResetBtn.Position = UDim2.new(0, 340, 0, 215)
BigHeadResetBtn.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
BigHeadResetBtn.BorderSizePixel = 1
BigHeadResetBtn.BorderColor3 = Color3.fromRGB(100, 100, 100)
BigHeadResetBtn.Text = "X"
BigHeadResetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BigHeadResetBtn.Font = Enum.Font.Legacy
BigHeadResetBtn.TextSize = 14
BigHeadResetBtn.ZIndex = 3
BigHeadResetBtn.Parent = ContentFrame

BigHeadKeybindBtn.MouseButton1Click:Connect(function()
    BigHeadKeybindBtn.Text = "Press key..."
    BigHeadKeybindBtn.BackgroundColor3 = Color3.fromRGB(120, 120, 0)
    local connection
    connection = UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            FunctionKeys.BigHead = input.KeyCode
            BigHeadKeybindBtn.Text = "Key: " .. tostring(input.KeyCode):gsub("Enum.KeyCode.", "")
            BigHeadKeybindBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            connection:Disconnect()
        end
    end)
end)

BigHeadResetBtn.MouseButton1Click:Connect(function()
    FunctionKeys.BigHead = Enum.KeyCode.None
    BigHeadKeybindBtn.Text = "Key: None"
    BigHeadKeybindBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
end)

-- Слайдер Big Head (теперь ПОД кнопкой)
local HeadSizeValueLabel = Instance.new("TextLabel")
HeadSizeValueLabel.Size = UDim2.new(0, 50, 0, 20)
HeadSizeValueLabel.Position = UDim2.new(0, 15, 0, 255)
HeadSizeValueLabel.BackgroundTransparency = 1
HeadSizeValueLabel.Text = "x2"
HeadSizeValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
HeadSizeValueLabel.Font = Enum.Font.Legacy
HeadSizeValueLabel.TextSize = 12
HeadSizeValueLabel.TextXAlignment = Enum.TextXAlignment.Left
HeadSizeValueLabel.ZIndex = 3
HeadSizeValueLabel.Parent = ContentFrame

local HeadSizeSlider = Instance.new("Frame")
HeadSizeSlider.Size = UDim2.new(0, 360, 0, 10)
HeadSizeSlider.Position = UDim2.new(0, 15, 0, 280)
HeadSizeSlider.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
HeadSizeSlider.BorderSizePixel = 1
HeadSizeSlider.BorderColor3 = Color3.fromRGB(150, 150, 150)
HeadSizeSlider.ZIndex = 3
HeadSizeSlider.Parent = ContentFrame

local HeadSizeFill = Instance.new("Frame")
HeadSizeFill.Size = UDim2.new(0.111, 0, 1, 0)
HeadSizeFill.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
HeadSizeFill.BorderSizePixel = 0
HeadSizeFill.ZIndex = 4
HeadSizeFill.Parent = HeadSizeSlider

-- Remove Walls Button
local RemoveWallsButton = createFunctionButton("RemoveWalls", "Remove Walls", 300, "RemoveWalls")

-- Menu Keybind
local KeybindButton = Instance.new("TextButton")
KeybindButton.Size = UDim2.new(0, 180, 0, 30)
KeybindButton.Position = UDim2.new(0, 15, 0, 340)
KeybindButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
KeybindButton.BorderSizePixel = 1
KeybindButton.BorderColor3 = Color3.fromRGB(100, 100, 100)
KeybindButton.Text = "Menu Key: " .. tostring(Settings.Keybind):gsub("Enum.KeyCode.", "")
KeybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
KeybindButton.Font = Enum.Font.Legacy
KeybindButton.TextSize = 12
KeybindButton.ZIndex = 3
KeybindButton.Parent = ContentFrame

local MenuKeyResetBtn = Instance.new("TextButton")
MenuKeyResetBtn.Size = UDim2.new(0, 35, 0, 30)
MenuKeyResetBtn.Position = UDim2.new(0, 205, 0, 340)
MenuKeyResetBtn.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
MenuKeyResetBtn.BorderSizePixel = 1
MenuKeyResetBtn.BorderColor3 = Color3.fromRGB(100, 100, 100)
MenuKeyResetBtn.Text = "X"
MenuKeyResetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MenuKeyResetBtn.Font = Enum.Font.Legacy
MenuKeyResetBtn.TextSize = 14
MenuKeyResetBtn.ZIndex = 3
MenuKeyResetBtn.Parent = ContentFrame

-- Status
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -30, 0, 20)
StatusLabel.Position = UDim2.new(0, 15, 0, 375)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Ready"
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
StatusLabel.Font = Enum.Font.Legacy
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.ZIndex = 3
StatusLabel.Parent = ContentFrame

-- ============================================================
-- ВТОРОЙ FRAME — Big Head Settings (список игроков)
-- ============================================================
local PlayersFrame = Instance.new("Frame")
PlayersFrame.Name = "PlayersFrame"
PlayersFrame.Size = UDim2.new(0, 450, 0, 420)
PlayersFrame.Position = UDim2.new(0.5, -225, 0.5, -210)
PlayersFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
PlayersFrame.BorderSizePixel = 1
PlayersFrame.BorderColor3 = Color3.fromRGB(150, 150, 150)
PlayersFrame.Visible = false
PlayersFrame.Parent = ScreenGui

local PlayersTopBar = Instance.new("Frame")
PlayersTopBar.Size = UDim2.new(1, -2, 0, 35)
PlayersTopBar.Position = UDim2.new(0, 1, 0, 1)
PlayersTopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
PlayersTopBar.BorderSizePixel = 1
PlayersTopBar.BorderColor3 = Color3.fromRGB(100, 100, 100)
PlayersTopBar.ZIndex = 2
PlayersTopBar.Parent = PlayersFrame

-- Кнопка "<" (назад)
local BackButton = Instance.new("TextButton")
BackButton.Size = UDim2.new(0, 35, 0, 30)
BackButton.Position = UDim2.new(0, 5, 0, 2)
BackButton.BackgroundColor3 = Color3.fromRGB(60, 140, 200)
BackButton.BorderSizePixel = 1
BackButton.BorderColor3 = Color3.fromRGB(100, 100, 100)
BackButton.Text = "<"
BackButton.TextColor3 = Color3.fromRGB(255, 255, 255)
BackButton.Font = Enum.Font.Legacy
BackButton.TextSize = 20
BackButton.ZIndex = 3
BackButton.Parent = PlayersTopBar

local PlayersTitle = Instance.new("TextLabel")
PlayersTitle.Size = UDim2.new(0, 300, 1, 0)
PlayersTitle.Position = UDim2.new(0, 50, 0, 0)
PlayersTitle.BackgroundTransparency = 1
PlayersTitle.Text = "Big Head Settings"
PlayersTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayersTitle.Font = Enum.Font.Legacy
PlayersTitle.TextSize = 16
PlayersTitle.TextXAlignment = Enum.TextXAlignment.Left
PlayersTitle.ZIndex = 3
PlayersTitle.Parent = PlayersTopBar

-- Кнопка закрытия (крестик)
local PlayersCloseBtn = Instance.new("TextButton")
PlayersCloseBtn.Size = UDim2.new(0, 30, 0, 30)
PlayersCloseBtn.Position = UDim2.new(1, -32, 0, 2)
PlayersCloseBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
PlayersCloseBtn.BorderSizePixel = 1
PlayersCloseBtn.BorderColor3 = Color3.fromRGB(100, 100, 100)
PlayersCloseBtn.Text = "X"
PlayersCloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayersCloseBtn.Font = Enum.Font.Legacy
PlayersCloseBtn.TextSize = 16
PlayersCloseBtn.ZIndex = 3
PlayersCloseBtn.Parent = PlayersTopBar

-- Скролл-контейнер для списка
local PlayersContent = Instance.new("ScrollingFrame")
PlayersContent.Size = UDim2.new(1, -2, 1, -37)
PlayersContent.Position = UDim2.new(0, 1, 0, 36)
PlayersContent.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
PlayersContent.BorderSizePixel = 1
PlayersContent.BorderColor3 = Color3.fromRGB(100, 100, 100)
PlayersContent.ScrollBarThickness = 8
PlayersContent.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayersContent.ZIndex = 2
PlayersContent.Parent = PlayersFrame

-- Кнопки игроков
local PlayerButtons = {} -- name -> button

local function UpdatePlayerList()
    -- Собираем всех игроков с сервера
    local currentPlayers = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Player then
            currentPlayers[p.Name] = true
            SeenPlayers[p.Name] = true
        end
    end

    -- Также смотрим в CharactersFolder (на случай, если игрок ещё не отобразился в Players)
    for _, model in pairs(CharactersFolder:GetChildren()) do
        if model:IsA("Model") and model.Name ~= Player.Name then
            currentPlayers[model.Name] = true
            SeenPlayers[model.Name] = true
        end
    end

    -- Удаляем кнопки тех, кто реально ливнул (нет в Players)
    for name, btn in pairs(PlayerButtons) do
        if not currentPlayers[name] then
            btn:Destroy()
            PlayerButtons[name] = nil
            BigHeadTargets[name] = nil
            SeenPlayers[name] = nil
        end
    end

    -- Создаём кнопки для новых
    local yPos = 10
    for name, _ in pairs(SeenPlayers) do
        if not PlayerButtons[name] then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -20, 0, 35)
            btn.Position = UDim2.new(0, 10, 0, yPos)
            btn.BackgroundColor3 = Color3.fromRGB(0, 120, 0) -- зелёный = включён
            btn.BorderSizePixel = 1
            btn.BorderColor3 = Color3.fromRGB(100, 100, 100)
            btn.Text = name
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.Legacy
            btn.TextSize = 14
            btn.ZIndex = 3
            btn.Parent = PlayersContent

            BigHeadTargets[name] = true -- по умолчанию ON

            btn.MouseButton1Click:Connect(function()
                BigHeadTargets[name] = not BigHeadTargets[name]
                if BigHeadTargets[name] then
                    btn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
                else
                    btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                end
            end)

            PlayerButtons[name] = btn
        end
    end

    -- Пересчитываем Y-позиции
    local sortedNames = {}
    for name, _ in pairs(PlayerButtons) do
        table.insert(sortedNames, name)
    end
    table.sort(sortedNames)

    for i, name in ipairs(sortedNames) do
        PlayerButtons[name].Position = UDim2.new(0, 10, 0, 10 + (i - 1) * 40)
    end

    PlayersContent.CanvasSize = UDim2.new(0, 0, 0, 10 + #sortedNames * 40 + 10)
end

-- Открыть второй Frame
BigHeadSettingsButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    PlayersFrame.Visible = true
    UpdatePlayerList()
end)

-- Назад
BackButton.MouseButton1Click:Connect(function()
    PlayersFrame.Visible = false
    MainFrame.Visible = true
end)

-- Закрытие второго Frame
PlayersCloseBtn.MouseButton1Click:Connect(function()
    PlayersFrame.Visible = false
    MainFrame.Visible = true
end)

-- Драг второго Frame
local dragging2 = false
local dragStart2 = nil
local startPos2 = nil

PlayersTopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging2 = true
        dragStart2 = input.Position
        startPos2 = PlayersFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging2 = false
            end
        end)
    end
end)

PlayersTopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging2 then
        local delta = input.Position - dragStart2
        PlayersFrame.Position = UDim2.new(startPos2.X.Scale, startPos2.X.Offset + delta.X, startPos2.Y.Scale, startPos2.Y.Offset + delta.Y)
    end
end)

-- ============================================================
-- ESP System
-- ============================================================
local CharactersFolder = Workspace:WaitForChild("Characters")
local DebrisFolder = Workspace:WaitForChild("Debris")

local ESPHighlights = {}
local ESPLabels = {}

local function HasHelmet(model)
    local ca = model:FindFirstChild("CharacterArmor")
    if ca then return ca:FindFirstChild("Helmet") ~= nil end
    return false
end

local function HasBalaclava(model)
    local ca = model:FindFirstChild("CharacterArmor")
    if ca then return ca:FindFirstChild("Balaclava") ~= nil end
    return false
end

local function GetPlayerModel()
    return CharactersFolder:FindFirstChild(Player.Name)
end

local function HasBomb(model)
    local wf = DebrisFolder:FindFirstChild(model.Name .. "_WeaponAttachments")
    if wf then return wf:FindFirstChild("BombHolster") ~= nil end
    return false
end

local function GetESPColor(model)
    local pm = GetPlayerModel()
    local targetBomb = HasBomb(model)
    if pm then
        local pHelmet = HasHelmet(pm)
        local pBala = HasBalaclava(pm)
        local tHelmet = HasHelmet(model)
        local tBala = HasBalaclava(model)
        local pType = pHelmet and "Helmet" or (pBala and "Balaclava" or "None")
        local tType = tHelmet and "Helmet" or (tBala and "Balaclava" or "None")
        if pType == tType and pType ~= "None" then
            return targetBomb and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(0, 255, 0)
        else
            return targetBomb and Color3.fromRGB(255, 128, 0) or Color3.fromRGB(255, 0, 0)
        end
    else
        return HasHelmet(model) and Color3.fromRGB(0, 0, 255) or Color3.fromRGB(255, 128, 0)
    end
end

local function GetWeaponNames(model)
    local weapons = {}
    local weaponFolder = DebrisFolder:FindFirstChild(model.Name .. "_WeaponAttachments")
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
        local hl = Instance.new("Highlight")
        hl.Name = "PlayerESP"
        hl.FillColor = color
        hl.FillTransparency = 0.5
        hl.OutlineColor = color
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Enabled = true
        hl.Parent = model
        table.insert(ESPHighlights, {Highlight = hl, Model = model})
    end
    if not model:FindFirstChild("ESPName") then
        local bb = Instance.new("BillboardGui")
        bb.Name = "ESPName"
        bb.Size = UDim2.new(0, 200, 0, 60)
        bb.StudsOffset = Vector3.new(0, 3, 0)
        bb.AlwaysOnTop = true
        bb.MaxDistance = 1000
        bb.Parent = model

        local wl = Instance.new("TextLabel")
        wl.Name = "WeaponLabel"
        wl.Size = UDim2.new(1, 0, 0, 30)
        wl.Position = UDim2.new(0, 0, 0, 0)
        wl.BackgroundTransparency = 1
        wl.Text = ""
        wl.TextColor3 = Color3.fromRGB(255, 255, 255)
        wl.Font = Enum.Font.Legacy
        wl.TextSize = 12
        wl.TextStrokeTransparency = 0
        wl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        wl.TextScaled = false
        wl.Parent = bb

        local nl = Instance.new("TextLabel")
        nl.Name = "NameLabel"
        nl.Size = UDim2.new(1, 0, 0, 30)
        nl.Position = UDim2.new(0, 0, 0, 30)
        nl.BackgroundTransparency = 1
        nl.Text = model.Name
        nl.TextColor3 = color
        nl.Font = Enum.Font.Legacy
        nl.TextSize = 16
        nl.TextStrokeTransparency = 0
        nl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        nl.TextScaled = false
        nl.Parent = bb

        table.insert(ESPLabels, {Billboard = bb, NameLabel = nl, WeaponLabel = wl, Model = model})
    end
end

local function UpdateWeaponLabels()
    for _, data in pairs(ESPLabels) do
        if data.WeaponLabel and data.WeaponLabel.Parent and data.Model and data.Model.Parent then
            if Settings.ESPEnabled and Settings.WeaponESPEnabled then
                local weapons = GetWeaponNames(data.Model)
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
    for _, d in pairs(ESPHighlights) do if d.Highlight then d.Highlight:Destroy() end end
    ESPHighlights = {}
    for _, d in pairs(ESPLabels) do if d.Billboard then d.Billboard:Destroy() end end
    ESPLabels = {}

    for _, model in pairs(CharactersFolder:GetChildren()) do
        local oldHl = model:FindFirstChild("PlayerESP")
        if oldHl then oldHl:Destroy() end
        local oldBb = model:FindFirstChild("ESPName")
        if oldBb then oldBb:Destroy() end
    end

    if not Settings.ESPEnabled then return end
    for _, m in pairs(CharactersFolder:GetChildren()) do
        if m:IsA("Model") and m.Name ~= Player.Name then AddESP(m) end
    end
    UpdateWeaponLabels()
end

local function UpdateESPColors()
    for _, d in pairs(ESPHighlights) do
        if d.Highlight and d.Highlight.Parent and d.Model and d.Model.Parent then
            local c = GetESPColor(d.Model)
            d.Highlight.FillColor = c
            d.Highlight.OutlineColor = c
            d.Highlight.OutlineTransparency = 0
        end
    end
    for _, d in pairs(ESPLabels) do
        if d.NameLabel and d.NameLabel.Parent and d.Model and d.Model.Parent then
            d.NameLabel.TextColor3 = GetESPColor(d.Model)
        end
    end
end

-- Anti-Flash/Smoke
local flashNames = {"FlashbangEffect", "FlashScreenshot", "FlashEffect", "FlashbangColorCorrection", "ColorCorrection", "WhiteScreen", "WhiteScreenGui", "Flashbang", "FlashBang", "Flash"}
local function isFlashObject(obj)
    local name = obj.Name:lower()
    for _, fn in pairs(flashNames) do if name:find(fn:lower()) then return true end end
    return false
end
local function isSmokeObject(obj)
    local name = obj.Name:lower()
    return name:find("smoke") ~= nil or name:find("voxel") ~= nil
end

PlayerGui.ChildAdded:Connect(function(child)
    if Settings.AntiFlashEnabled and isFlashObject(child) then child:Destroy() end
end)
PlayerGui.DescendantAdded:Connect(function(descendant)
    if Settings.AntiFlashEnabled and isFlashObject(descendant) then descendant:Destroy() end
end)
Lighting.ChildAdded:Connect(function(child)
    if Settings.AntiFlashEnabled and isFlashObject(child) then child:Destroy() end
end)
DebrisFolder.ChildAdded:Connect(function(child)
    if Settings.AntiSmokeEnabled and isSmokeObject(child) then child:Destroy() end
end)

-- Head Size (только для выбранных)
local OriginalHeadSizes = {}
local function UpdateHeadSizes()
    for _, model in pairs(CharactersFolder:GetChildren()) do
        if model:IsA("Model") and model.Name ~= Player.Name then
            local head = model:FindFirstChild("Head")
            if head then
                if not OriginalHeadSizes[model.Name] then
                    OriginalHeadSizes[model.Name] = head.Size
                end
                -- Если BigHeadTargets[model.Name] == true, увеличиваем
                if BigHeadTargets[model.Name] then
                    head.Size = OriginalHeadSizes[model.Name] * Settings.HeadSizeValue
                else
                    head.Size = OriginalHeadSizes[model.Name]
                end
            end
        end
    end
end

-- Slider
local isDraggingSlider = false
HeadSizeSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDraggingSlider = true
        local mousePos = input.Position
        local sliderPos = HeadSizeSlider.AbsolutePosition
        local sliderSize = HeadSizeSlider.AbsoluteSize
        local relativeX = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
        Settings.HeadSizeValue = 1 + (relativeX * 9)
        HeadSizeFill.Size = UDim2.new(relativeX, 0, 1, 0)
        HeadSizeValueLabel.Text = "x" .. string.format("%.1f", Settings.HeadSizeValue)
        UpdateHeadSizes()
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDraggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = input.Position
        local sliderPos = HeadSizeSlider.AbsolutePosition
        local sliderSize = HeadSizeSlider.AbsoluteSize
        local relativeX = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
        Settings.HeadSizeValue = 1 + (relativeX * 9)
        HeadSizeFill.Size = UDim2.new(relativeX, 0, 1, 0)
        HeadSizeValueLabel.Text = "x" .. string.format("%.1f", Settings.HeadSizeValue)
        UpdateHeadSizes()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDraggingSlider = false
    end
end)

-- ============================================================
-- Remove Walls
-- ============================================================
local HiddenGeometry = nil

local function ToggleRemoveWalls(enable)
    if enable then
        local map = Workspace:FindFirstChild("Map")
        if map then
            for _, child in pairs(map:GetChildren()) do
                if child.Name:lower():find("geometry") then
                    HiddenGeometry = child
                    child.Parent = ReplicatedStorage
                    break
                end
            end
        end
    else
        if HiddenGeometry and HiddenGeometry.Parent == ReplicatedStorage then
            local map = Workspace:FindFirstChild("Map")
            if map then
                HiddenGeometry.Parent = map
            end
            HiddenGeometry = nil
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

-- ============================================================
-- Кнопки
-- ============================================================
ESPButton.MouseButton1Click:Connect(function()
    Settings.ESPEnabled = not Settings.ESPEnabled
    ESPButton.Text = Settings.ESPEnabled and "Player ESP: ON" or "Player ESP: OFF"
    ESPButton.BackgroundColor3 = Settings.ESPEnabled and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(80, 80, 80)
    UpdateESP()
end)

WeaponESPButton.MouseButton1Click:Connect(function()
    Settings.WeaponESPEnabled = not Settings.WeaponESPEnabled
    WeaponESPButton.Text = Settings.WeaponESPEnabled and "Weapon ESP: ON" or "Weapon ESP: OFF"
    WeaponESPButton.BackgroundColor3 = Settings.WeaponESPEnabled and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(80, 80, 80)
    UpdateWeaponLabels()
end)

AntiFlashButton.MouseButton1Click:Connect(function()
    Settings.AntiFlashEnabled = not Settings.AntiFlashEnabled
    AntiFlashButton.Text = Settings.AntiFlashEnabled and "Anti-Flash: ON" or "Anti-Flash: OFF"
    AntiFlashButton.BackgroundColor3 = Settings.AntiFlashEnabled and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(80, 80, 80)
end)

AntiSmokeButton.MouseButton1Click:Connect(function()
    Settings.AntiSmokeEnabled = not Settings.AntiSmokeEnabled
    AntiSmokeButton.Text = Settings.AntiSmokeEnabled and "Anti-Smoke: ON" or "Anti-Smoke: OFF"
    AntiSmokeButton.BackgroundColor3 = Settings.AntiSmokeEnabled and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(80, 80, 80)
end)

AntiScopeButton.MouseButton1Click:Connect(function()
    local mainGui = PlayerGui:FindFirstChild("MainGui")
    if mainGui then
        local gameplay = mainGui:FindFirstChild("Gameplay")
        if gameplay then
            local middle = gameplay:FindFirstChild("Middle")
            if middle then
                local sniperScope = middle:FindFirstChild("SniperScope")
                if sniperScope then
                    pcall(function() sniperScope:Destroy() end)
                    AntiScopeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                    AntiScopeButton.Text = "Scope Removed"
                end
            end
        end
    end
end)

RemoveWallsButton.MouseButton1Click:Connect(function()
    Settings.RemoveWallsEnabled = not Settings.RemoveWallsEnabled
    RemoveWallsButton.Text = Settings.RemoveWallsEnabled and "Remove Walls: ON" or "Remove Walls: OFF"
    RemoveWallsButton.BackgroundColor3 = Settings.RemoveWallsEnabled and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(80, 80, 80)
    ToggleRemoveWalls(Settings.RemoveWallsEnabled)
end)

-- Keybind меню
local isChangingKeybind = false
KeybindButton.MouseButton1Click:Connect(function()
    isChangingKeybind = true
    KeybindButton.Text = "Press key..."
    KeybindButton.BackgroundColor3 = Color3.fromRGB(120, 120, 0)
end)

MenuKeyResetBtn.MouseButton1Click:Connect(function()
    Settings.Keybind = Enum.KeyCode.None
    KeybindButton.Text = "Menu Key: None"
    KeybindButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
end)

-- ============================================================
-- Обработка клавиш
-- ============================================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if isChangingKeybind and input.UserInputType == Enum.UserInputType.Keyboard then
        Settings.Keybind = input.KeyCode
        isChangingKeybind = false
        KeybindButton.Text = "Menu Key: " .. tostring(input.KeyCode):gsub("Enum.KeyCode.", "")
        KeybindButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        return
    end
    if gameProcessed then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end

    -- Keybind меню
    if Settings.Keybind ~= Enum.KeyCode.None and input.KeyCode == Settings.Keybind then
        if not isExiting and introComplete then
            MainFrame.Visible = not MainFrame.Visible
            PlayersFrame.Visible = false
        end
        return
    end

    -- Функции
    if FunctionKeys.ESP ~= Enum.KeyCode.None and input.KeyCode == FunctionKeys.ESP then
        Settings.ESPEnabled = not Settings.ESPEnabled
        ESPButton.Text = Settings.ESPEnabled and "Player ESP: ON" or "Player ESP: OFF"
        ESPButton.BackgroundColor3 = Settings.ESPEnabled and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(80, 80, 80)
        UpdateESP()
    elseif FunctionKeys.WeaponESP ~= Enum.KeyCode.None and input.KeyCode == FunctionKeys.WeaponESP then
        Settings.WeaponESPEnabled = not Settings.WeaponESPEnabled
        WeaponESPButton.Text = Settings.WeaponESPEnabled and "Weapon ESP: ON" or "Weapon ESP: OFF"
        WeaponESPButton.BackgroundColor3 = Settings.WeaponESPEnabled and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(80, 80, 80)
        UpdateWeaponLabels()
    elseif FunctionKeys.AntiFlash ~= Enum.KeyCode.None and input.KeyCode == FunctionKeys.AntiFlash then
        Settings.AntiFlashEnabled = not Settings.AntiFlashEnabled
        AntiFlashButton.Text = Settings.AntiFlashEnabled and "Anti-Flash: ON" or "Anti-Flash: OFF"
        AntiFlashButton.BackgroundColor3 = Settings.AntiFlashEnabled and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(80, 80, 80)
    elseif FunctionKeys.AntiSmoke ~= Enum.KeyCode.None and input.KeyCode == FunctionKeys.AntiSmoke then
        Settings.AntiSmokeEnabled = not Settings.AntiSmokeEnabled
        AntiSmokeButton.Text = Settings.AntiSmokeEnabled and "Anti-Smoke: ON" or "Anti-Smoke: OFF"
        AntiSmokeButton.BackgroundColor3 = Settings.AntiSmokeEnabled and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(80, 80, 80)
    elseif FunctionKeys.RemoveScope ~= Enum.KeyCode.None and input.KeyCode == FunctionKeys.RemoveScope then
        local mainGui = PlayerGui:FindFirstChild("MainGui")
        if mainGui then
            local gameplay = mainGui:FindFirstChild("Gameplay")
            if gameplay then
                local middle = gameplay:FindFirstChild("Middle")
                if middle then
                    local sniperScope = middle:FindFirstChild("SniperScope")
                    if sniperScope then
                        pcall(function() sniperScope:Destroy() end)
                        AntiScopeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                        AntiScopeButton.Text = "Scope Removed"
                    end
                end
            end
        end
    elseif FunctionKeys.BigHead ~= Enum.KeyCode.None and input.KeyCode == FunctionKeys.BigHead then
        MainFrame.Visible = false
        PlayersFrame.Visible = true
        UpdatePlayerList()
    elseif FunctionKeys.RemoveWalls ~= Enum.KeyCode.None and input.KeyCode == FunctionKeys.RemoveWalls then
        Settings.RemoveWallsEnabled = not Settings.RemoveWallsEnabled
        RemoveWallsButton.Text = Settings.RemoveWallsEnabled and "Remove Walls: ON" or "Remove Walls: OFF"
        RemoveWallsButton.BackgroundColor3 = Settings.RemoveWallsEnabled and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(80, 80, 80)
        ToggleRemoveWalls(Settings.RemoveWallsEnabled)
    end
end)

-- Кастомный Crosshair
local CustomCrosshair = nil

local function createCustomCrosshair()
    if CustomCrosshair and CustomCrosshair.Parent then return end
    CustomCrosshair = Instance.new("Frame")
    CustomCrosshair.AnchorPoint = Vector2.new(0.5, 0)
    CustomCrosshair.Size = UDim2.new(0, 20, 0, 20)
    CustomCrosshair.Position = UDim2.new(0.5, 0, 0.467500001, 0)
    CustomCrosshair.BackgroundTransparency = 1
    CustomCrosshair.ZIndex = 100
    CustomCrosshair.Parent = ScreenGui

    local horizontal = Instance.new("Frame")
    horizontal.Size = UDim2.new(1, 0, 0, 2)
    horizontal.Position = UDim2.new(0, 0, 0.5, -1)
    horizontal.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    horizontal.BorderSizePixel = 0
    horizontal.Parent = CustomCrosshair

    local vertical = Instance.new("Frame")
    vertical.Size = UDim2.new(0, 2, 1, 0)
    vertical.Position = UDim2.new(0.5, -1, 0, 0)
    vertical.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    vertical.BorderSizePixel = 0
    vertical.Parent = CustomCrosshair
end

local function removeCustomCrosshair()
    if CustomCrosshair and CustomCrosshair.Parent then
        CustomCrosshair:Destroy()
    end
    CustomCrosshair = nil
end

local function checkSniperWeapon()
    local camera = Workspace:FindFirstChild("Camera")
    if camera then
        return camera:FindFirstChild("SSG 08") ~= nil or camera:FindFirstChild("AWP") ~= nil
    end
    return false
end

task.spawn(function()
    while true do
        if not AntiScopeButton.Active and not isExiting then
            if checkSniperWeapon() then
                createCustomCrosshair()
            else
                removeCustomCrosshair()
            end
        else
            removeCustomCrosshair()
        end
        task.wait(0.1)
    end
end)

-- Exit Animation
local function ExitAnimation()
    if isClosing then return end
    isClosing = true
    isExiting = true
    Settings.ESPEnabled = false
    Settings.WeaponESPEnabled = false
    Settings.AntiFlashEnabled = false
    Settings.AntiSmokeEnabled = false
    Settings.HeadSizeEnabled = false

    for _, d in pairs(ESPHighlights) do if d.Highlight and d.Highlight.Parent then d.Highlight:Destroy() end end
    ESPHighlights = {}
    for _, d in pairs(ESPLabels) do if d.Billboard and d.Billboard.Parent then d.Billboard:Destroy() end end
    ESPLabels = {}

    MainFrame.Visible = false
    PlayersFrame.Visible = false

    local ExitText = Instance.new("TextLabel")
    ExitText.Name = "ExitText"
    ExitText.AnchorPoint = Vector2.new(0.5, 0.5)
    ExitText.Size = UDim2.new(0, 300, 0, 50)
    ExitText.Position = UDim2.new(-0.5, 0, 0.5, 0)
    ExitText.BackgroundTransparency = 1
    ExitText.Text = "See you later!"
    ExitText.TextColor3 = Color3.fromRGB(255, 255, 255)
    ExitText.Font = Enum.Font.Legacy
    ExitText.TextSize = 30
    ExitText.ZIndex = 100
    ExitText.Parent = ScreenGui

    task.wait(0.5)

    local slideIn = TweenService:Create(ExitText, TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    slideIn:Play()
    slideIn.Completed:Wait()

    task.wait(1)

    local fadeOut = TweenService:Create(ExitText, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        TextTransparency = 1
    })
    fadeOut:Play()
    fadeOut.Completed:Wait()

    ScreenGui:Destroy()
end

CloseButton.MouseButton1Click:Connect(ExitAnimation)

-- ============================================================
-- Периодическое обновление (каждые 0.5 сек)
-- ============================================================
task.spawn(function()
    while true do
        if not isExiting then
            -- ESP
            if Settings.ESPEnabled then
                for _, model in pairs(CharactersFolder:GetChildren()) do
                    if model:IsA("Model") and model.Name ~= Player.Name then
                        if not model:FindFirstChild("PlayerESP") or not model:FindFirstChild("ESPName") then
                            AddESP(model)
                        end
                    end
                end
                UpdateESPColors()
                if Settings.WeaponESPEnabled then
                    UpdateWeaponLabels()
                end
            end

            -- Big Head
            if next(BigHeadTargets) then
                UpdateHeadSizes()
            end

            -- Remove Walls (перепроверка на смену раунда)
            if Settings.RemoveWallsEnabled then
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

            -- Обновление списка игроков во втором Frame
            if PlayersFrame.Visible then
                UpdatePlayerList()
            end
        end
        task.wait(0.5)
    end
end)

UpdateESP()
