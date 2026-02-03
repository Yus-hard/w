local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Brookhaven Grox Hub 😈",
    Icon = 0,
    LoadingTitle = "Brookhaven RP",
    LoadingSubtitle = "by Grox - Delta Ready 2026",
    ShowText = "GROX BH",
    Theme = "Default",
    ToggleUIKeybind = "K",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "BrookhavenGrox"
    },
    Discord = { Enabled = false },
    KeySystem = false
})

local MainTab = Window:CreateTab("Main Cheats", 4483362458)
local VisualTab = Window:CreateTab("Visual & Troll", "rewind")

local Section = MainTab:CreateSection("Player Mods")

-- Speed Slider
local speedVal = 16
local SpeedSlider = MainTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 200},
    Increment = 5,
    Suffix = "",
    CurrentValue = 16,
    Flag = "SpeedBH",
    Callback = function(Value)
        speedVal = Value
        local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = Value end
    end,
})

-- Jump Slider
local jumpVal = 50
local JumpSlider = MainTab:CreateSlider({
    Name = "Jump Power",
    Range = {50, 300},
    Increment = 10,
    Suffix = "",
    CurrentValue = 50,
    Flag = "JumpBH",
    Callback = function(Value)
        jumpVal = Value
        local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum.JumpPower = Value end
    end,
})

-- Infinite Jump Toggle
local InfJumpToggle = MainTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfJumpBH",
    Callback = function(Value)
        if Value then
            local UIS = game:GetService("UserInputService")
            UIS.JumpRequest:Connect(function()
                local hum = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
                if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            end)
        end
    end,
})

-- God Mode Toggle
local GodToggle = MainTab:CreateToggle({
    Name = "God Mode (No Die)",
    CurrentValue = false,
    Flag = "GodBH",
    Callback = function(Value)
        if Value then
            local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then
                hum.MaxHealth = math.huge
                hum.Health = math.huge
                hum:GetPropertyChangedSignal("Health"):Connect(function()
                    hum.Health = math.huge
                end)
            end
        end
    end,
})

-- Fly Toggle (simples, Delta friendly)
local flyEnabled = false
local flySpeed = 50
local flyToggle = MainTab:CreateToggle({
    Name = "Fly (WASD + Space/Ctrl)",
    CurrentValue = false,
    Flag = "FlyBH",
    Callback = function(Value)
        flyEnabled = Value
        local player = game.Players.LocalPlayer
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local bv = root:FindFirstChild("FlyBV") or Instance.new("BodyVelocity", root)
        bv.Name = "FlyBV"
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bv.Velocity = Vector3.new()
        local bg = root:FindFirstChild("FlyBG") or Instance.new("BodyGyro", root)
        bg.Name = "FlyBG"
        bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        bg.P = 9e4
        if Value then
            spawn(function()
                while flyEnabled do
                    task.wait()
                    local cam = workspace.CurrentCamera
                    local dir = Vector3.new()
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0,1,0) end
                    bv.Velocity = dir * flySpeed
                    bg.CFrame = cam.CFrame
                end
                bv:Destroy()
                bg:Destroy()
            end)
        end
    end,
})

local FlySpeedSlider = MainTab:CreateSlider({
    Name = "Fly Speed",
    Range = {20, 150},
    Increment = 5,
    Suffix = "",
    CurrentValue = 50,
    Flag = "FlySpeedBH",
    Callback = function(Value) flySpeed = Value end,
})

-- Noclip Toggle
local noclipEnabled = false
local noclipConn
local NoclipToggle = MainTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "NoclipBH",
    Callback = function(Value)
        noclipEnabled = Value
        if Value then
            noclipConn = game:GetService("RunService").Stepped:Connect(function()
                local char = game.Players.LocalPlayer.Character
                if char then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end)
        else
            if noclipConn then noclipConn:Disconnect() end
        end
    end,
})

-- ESP Players (Highlight)
local espEnabled = false
local ESPToggle = VisualTab:CreateToggle({
    Name = "ESP Players",
    CurrentValue = false,
    Flag = "ESPBH",
    Callback = function(Value)
        espEnabled = Value
        if Value then
            for _, plr in ipairs(game.Players:GetPlayers()) do
                if plr ~= game.Players.LocalPlayer and plr.Character then
                    local hl = Instance.new("Highlight", plr.Character)
                    hl.FillColor = Color3.fromRGB(255, 0, 0)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 0)
                    hl.FillTransparency = 0.5
                end
            end
        else
            for _, plr in ipairs(game.Players:GetPlayers()) do
                if plr.Character then
                    local hl = plr.Character:FindFirstChildOfClass("Highlight")
                    if hl then hl:Destroy() end
                end
            end
        end
    end,
})

-- TP Dropdown (atualiza players)
local playersList = {}
for _, plr in ipairs(game.Players:GetPlayers()) do table.insert(playersList, plr.Name) end
game.Players.PlayerAdded:Connect(function(plr) table.insert(playersList, plr.Name) end)

local TPDropdown = MainTab:CreateDropdown({
    Name = "Teleport to Player",
    Options = playersList,
    CurrentOption = "",
    MultipleOptions = false,
    Flag = "TPBH",
    Callback = function(Option)
        local target = game.Players:FindFirstChild(Option)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local root = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then root.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0) end
        end
    end,
})

Rayfield:Notify({
    Title = "Brookhaven Grox Hub Loaded!",
    Content = "UI aberta com K! Testa Fly + Noclip + Speed no Delta brother. Se não abrir, checa HttpGet no console do Delta.",
    Duration = 6.5,
    Image = 4483362458,
})

-- Re-apply on respawn
game.Players.LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    local hum = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
    if hum then
        hum.WalkSpeed = speedVal
        hum.JumpPower = jumpVal
    end
end)
