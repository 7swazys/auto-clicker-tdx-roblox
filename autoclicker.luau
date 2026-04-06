local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local autoClickerEnabled = false
local clickSpeed = 0.1
local clickTask = nil
local mouse = LocalPlayer:GetMouse()

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoClickerGUI"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 250, 0, 180)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -90)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.BackgroundTransparency = 0.3
title.Text = "Auto Clicker - Credits TDX, 7swazyscripts"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = title

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 30)
statusLabel.Position = UDim2.new(0, 10, 0, 40)
statusLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
statusLabel.BackgroundTransparency = 0.5
statusLabel.Text = "Status: OFF"
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 4)
statusCorner.Parent = statusLabel

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0, 80, 0, 25)
speedLabel.Position = UDim2.new(0, 10, 0, 80)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed (sec):"
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedLabel.TextSize = 12
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = mainFrame

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0, 60, 0, 25)
speedBox.Position = UDim2.new(0, 100, 0, 80)
speedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedBox.Text = "0.1"
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.TextSize = 12
speedBox.Font = Enum.Font.Gotham
speedBox.Parent = mainFrame

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 4)
speedCorner.Parent = speedBox

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 100, 0, 35)
toggleButton.Position = UDim2.new(0, 10, 0, 115)
toggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
toggleButton.Text = "Toggle"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 14
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Parent = mainFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 4)
toggleCorner.Parent = toggleButton

local keybindLabel = Instance.new("TextLabel")
keybindLabel.Size = UDim2.new(0, 120, 0, 25)
keybindLabel.Position = UDim2.new(0, 120, 0, 120)
keybindLabel.BackgroundTransparency = 1
keybindLabel.Text = "No keybind set"
keybindLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
keybindLabel.TextSize = 11
keybindLabel.Font = Enum.Font.Gotham
keybindLabel.TextXAlignment = Enum.TextXAlignment.Left
keybindLabel.Parent = mainFrame

speedBox.FocusLost:Connect(function(enterPressed)
    local num = tonumber(speedBox.Text)
    if num and num > 0 then
        clickSpeed = num
        speedBox.Text = tostring(clickSpeed)
        
        if autoClickerEnabled then
            autoClickerEnabled = false
            statusLabel.Text = "Status: OFF"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            toggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            task.wait(0.1)
            autoClickerEnabled = true
            statusLabel.Text = "Status: ON"
            statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            toggleButton.BackgroundColor3 = Color3.fromRGB(100, 150, 100)
            startClicker()
        end
    else
        speedBox.Text = tostring(clickSpeed)
    end
end)

local function doClick()
    mouse1press()
    task.wait(0.01)
    mouse1release()
end

local function startClicker()
    if clickTask then
        task.cancel(clickTask)
        clickTask = nil
    end
    
    clickTask = task.spawn(function()
        while autoClickerEnabled do
            doClick()
            task.wait(clickSpeed)
        end
    end)
end

local function toggleAutoClicker()
    autoClickerEnabled = not autoClickerEnabled
    
    if autoClickerEnabled then
        statusLabel.Text = "Status: ON"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        toggleButton.BackgroundColor3 = Color3.fromRGB(100, 150, 100)
        startClicker()
    else
        statusLabel.Text = "Status: OFF"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        toggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        
        if clickTask then
            task.cancel(clickTask)
            clickTask = nil
        end
    end
end

toggleButton.MouseButton1Click:Connect(toggleAutoClicker)

LocalPlayer.CharacterAdded:Connect(function()
    if autoClickerEnabled then
        autoClickerEnabled = false
        if clickTask then
            task.cancel(clickTask)
            clickTask = nil
        end
    end
end)

local indicator = Instance.new("TextLabel")
indicator.Name = "Indicator"
indicator.Size = UDim2.new(0, 60, 0, 30)
indicator.Position = UDim2.new(1, -70, 0, 10)
indicator.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
indicator.BackgroundTransparency = 0.3
indicator.Text = "🔴 OFF"
indicator.TextColor3 = Color3.fromRGB(255, 100, 100)
indicator.TextSize = 12
indicator.Font = Enum.Font.GothamBold
indicator.Parent = screenGui

local indicatorCorner = Instance.new("UICorner")
indicatorCorner.CornerRadius = UDim.new(0, 4)
indicatorCorner.Parent = indicator

local function updateIndicator()
    while true do
        if autoClickerEnabled then
            indicator.Text = "🟢 CLICKING"
            indicator.TextColor3 = Color3.fromRGB(100, 255, 100)
        else
            indicator.Text = "🔴 OFF"
            indicator.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
        task.wait(0.5)
    end
end
task.spawn(updateIndicator)

print("Auto Clicker Loaded!")
print("Click the Toggle button to start/stop")
print("Speed: " .. clickSpeed .. " seconds per click")
