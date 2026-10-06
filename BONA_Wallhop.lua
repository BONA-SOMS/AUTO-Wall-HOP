--==================================================
-- BONA WALLHOP
-- INJECT LOADING SCREEN
-- RAYFIELD GEN2
--==================================================

--==================================================
-- SERVICES
--==================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--==================================================
-- INJECT LOADING SCREEN
--==================================================

local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Name = "BONA_Inject_Loading"
LoadingGui.ResetOnSpawn = false
LoadingGui.IgnoreGuiInset = true
LoadingGui.DisplayOrder = 999999
LoadingGui.Parent = PlayerGui

local Background = Instance.new("Frame")
Background.Size = UDim2.fromScale(1, 1)
Background.Position = UDim2.fromScale(0, 0)
Background.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Background.BorderSizePixel = 0
Background.Parent = LoadingGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 70)
Title.Position = UDim2.new(0, 0, 0.38, 0)
Title.BackgroundTransparency = 1
Title.Text = "INJECT AUTO WALL HOP"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = Background

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, 0, 0, 40)
SubTitle.Position = UDim2.new(0, 0, 0.49, 0)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "BONA"
SubTitle.TextColor3 = Color3.fromRGB(180, 180, 180)
SubTitle.TextScaled = true
SubTitle.Font = Enum.Font.Gotham
SubTitle.Parent = Background

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, 0, 0, 35)
Status.Position = UDim2.new(0, 0, 0.57, 0)
Status.BackgroundTransparency = 1
Status.Text = "Injecting..."
Status.TextColor3 = Color3.fromRGB(150, 150, 150)
Status.TextScaled = true
Status.Font = Enum.Font.Gotham
Status.Parent = Background

--==================================================
-- LOADING ANIMATION
--==================================================

for i = 1, 3 do
    Status.Text = "Injecting" .. string.rep(".", i)
    task.wait(0.25)
end

Status.Text = "Loading Rayfield..."
task.wait(0.5)

--==================================================
-- RAYFIELD GEN2
--==================================================

local Rayfield = loadstring(game:HttpGet(
    "https://sirius.menu/gen2-preview"
))()

-- Remove loading screen after Rayfield starts
LoadingGui:Destroy()

--==================================================
-- CHARACTER
--==================================================

local Character
local Humanoid
local RootPart

local function SetupCharacter(char)
    Character = char

    Humanoid = char:WaitForChild("Humanoid")
    RootPart = char:WaitForChild("HumanoidRootPart")
end

if LocalPlayer.Character then
    SetupCharacter(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(function(char)
    SetupCharacter(char)
end)

--==================================================
-- SETTINGS
--==================================================

local WallhopEnabled = false
local CanJump = true
local JumpCooldown = 0.4

--==================================================
-- NOTIFICATION
--==================================================

local function ShowBONA()
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "BONA WALLHOP",
            Text = "Made by BONA",
            Duration = 3
        })
    end)
end

--==================================================
-- WINDOW
--==================================================

local Window = Rayfield:CreateWindow({
    name = "BONA Wallhop",
    subtitle = "Rayfield Gen2 • Wallhop",
    sidebarLayout = true,
})

--==================================================
-- HOME TAB
--==================================================

local HomeTab = Window:CreateTab({
    name = "Home",
    icon = 93364949241311
})

HomeTab:CreateToggle({
    name = "Wallhop",
    callback = function(Value)

        WallhopEnabled = Value

        if WallhopEnabled then
            ShowBONA()
        end

    end,
})

--==================================================
-- SETTINGS TAB
--==================================================

local SettingsTab = Window:CreateTab({
    name = "Settings",
    icon = 6031280882
})

SettingsTab:CreateSlider({
    name = "Jump Cooldown",
    min = 0.05,
    max = 1,
    default = 0.4,
    increment = 0.05,

    callback = function(Value)
        JumpCooldown = Value
    end,
})

--==================================================
-- WALLHOP
--==================================================

RunService.RenderStepped:Connect(function()

    if not WallhopEnabled then
        return
    end

    if not Character
        or not Character.Parent
        or not Humanoid
        or not RootPart then
        return
    end

    if Humanoid.Health <= 0 then
        return
    end

    if not CanJump then
        return
    end

    local RayOrigin = RootPart.Position
    local RayDirection = RootPart.CFrame.LookVector * 3

    local RaycastParams = RaycastParams.new()
    RaycastParams.FilterType = Enum.RaycastFilterType.Exclude
    RaycastParams.FilterDescendantsInstances = {
        Character
    }

    local Result = workspace:Raycast(
        RayOrigin,
        RayDirection,
        RaycastParams
    )

    if Result and Result.Instance then

        Humanoid:ChangeState(
            Enum.HumanoidStateType.Jumping
        )

        CanJump = false

        task.delay(JumpCooldown, function()
            CanJump = true
        end)

    end
end)

--==================================================
-- BONA
--==================================================

print("[BONA] Wallhop loaded successfully.")
