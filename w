local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "VOLLEYBALL LEGENDS",
    Icon = 0,
    LoadingTitle = "Volleyball Legends Hub",
    LoadingSubtitle = "by Hard's Amigão",
    ShowText = "VL HUB",
    Theme = "Default",
    ToggleUIKeybind = "K",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "VL Hub"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false
})

local Tab = Window:CreateTab("Main", 4483362458)

local Section = Tab:CreateSection("Player Cheats")

-- Hitbox Alta (Tall Hitbox)
local hitboxSize = 6
local originalSizes = {}
local hitboxEnabled = false
local ToggleHitbox = Tab:CreateToggle({
    Name = "Hitbox Alta (Player Tall)",
    CurrentValue = false,
    Flag = "HitboxVL",
    Callback = function(Value)
        hitboxEnabled = Value
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        if not character then return end

        if hitboxEnabled then
            originalSizes = {}
            for _, part in ipairs(character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then -- Don't mess root
                    originalSizes[part] = part.Size
                    -- Make tall: increase Y massively, keep X/Z normal-ish
                    part.Size = Vector3.new(part.Size.X * 1.5, part.Size.Y * hitboxSize, part.Size.Z * 1.5)
                    part.Transparency = 0.3 -- Semi-transparent to see
                end
            end
            -- Re-apply on respawn
            player.CharacterAdded:Connect(function(char)
                if hitboxEnabled then
                    task.wait(1)
                    ToggleHitbox.Callback(true)
                end
            end)
        else
            for part, size in pairs(originalSizes) do
                if part and part.Parent then
                    part.Size = size
                    part.Transparency = 0
                end
            end
            originalSizes = {}
        end
    end,
})

local SliderHitbox = Tab:CreateSlider({
    Name = "Hitbox Multiplier (Y Alta)",
    Range = {2, 12},
    Increment = 1,
    Suffix = "x",
    CurrentValue = 6,
    Flag = "HitboxSizeVL",
    Callback = function(Value)
        hitboxSize = Value
        if hitboxEnabled then
            ToggleHitbox.Callback(false)
            ToggleHitbox.Callback(true)
        end
    end,
})

-- Ball Hitbox Expander (Easier to hit)
local ballSize = 5
local originalBallSize
local ballEnabled = false
local ToggleBall = Tab:CreateToggle({
    Name = "Ball Hitbox Expander",
    CurrentValue = false,
    Flag = "BallHitboxVL",
    Callback = function(Value)
        ballEnabled = Value
        spawn(function()
            while ballEnabled do
                for _, obj in ipairs(workspace:GetChildren()) do
                    if obj.Name:lower():find("ball") and obj:IsA("BasePart") then
                        if not originalBallSize then
                            originalBallSize = obj.Size
                        end
                        obj.Size = originalBallSize * ballSize
                        obj.Transparency = 0.5
                    end
                end
                task.wait(0.1)
            end
            -- Restore
            if originalBallSize then
                for _, obj in ipairs(workspace:GetChildren()) do
                    if obj.Name:lower():find("ball") and obj:IsA("BasePart") then
                        obj.Size = originalBallSize
                        obj.Transparency = 0
                    end
                end
            end
        end)
    end,
})

local SliderBall = Tab:CreateSlider({
    Name = "Ball Size",
    Range = {2, 10},
    Increment = 0.5,
    Suffix = "x",
    CurrentValue = 5,
    Flag = "BallSizeVL",
    Callback = function(Value)
        ballSize = Value
    end,
})

-- Sem Delay (High Speed/Jump)
local speedValue = 50
local jumpValue = 100
Tab:CreateSlider({
    Name = "WalkSpeed (Sem Delay)",
    Range = {16, 200},
    Increment = 5,
    Suffix = "",
    CurrentValue = 50,
    Flag = "SpeedVL",
    Callback = function(Value)
        speedValue = Value
        local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.WalkSpeed = speedValue end
    end,
})

Tab:CreateSlider({
    Name = "JumpPower (Reach Alta)",
    Range = {50, 300},
    Increment = 10,
    Suffix = "",
    CurrentValue = 100,
    Flag = "JumpVL",
    Callback = function(Value)
        jumpValue = Value
        local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.JumpPower = jumpValue end
    end,
})

-- Apply on spawn
game.Players.LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = speedValue
        humanoid.JumpPower = jumpValue
    end
    if hitboxEnabled then ToggleHitbox.Callback(true) end
end)

-- Sem Cooldown (Set all cooldowns to 0 + Spam Rewards for inf money/spins)
local noCdEnabled = false
local cdConnection
local ToggleNoCD = Tab:CreateToggle({
    Name = "Sem Cooldown (Zero CD + Inf Rewards)",
    CurrentValue = false,
    Flag = "NoCDVL",
    Callback = function(Value)
        noCdEnabled = Value
        local player = game.Players.LocalPlayer
        if noCdEnabled then
            -- Loop set cooldown values to 0
            cdConnection = game:GetService("RunService").Heartbeat:Connect(function()
                for _, v in ipairs(player.PlayerGui:GetDescendants()) do
                    if v:IsA("NumberValue") and (v.Name:lower():find("cooldown") or v.Name:lower():find("cd")) then
                        v.Value = 0
                    end
                end
                for _, v in ipairs(player.Character:GetDescendants()) do
                    if v:IsA("NumberValue") and (v.Name:lower():find("cooldown") or v.Name:lower():find("cd")) then
                        v.Value = 0
                    end
                end
                -- Inf Rewards (Auto Farm Money/Spins)
                local success, err = pcall(function()
                    local ReplicatedStorage = game:GetService("ReplicatedStorage")
                    local RewardService = ReplicatedStorage:FindFirstChild("Packages") and ReplicatedStorage.Packages._Index["[email protected]"].knit.Services.RewardService.RF.RequestPlayWithDeveloperAward
                    if RewardService then
                        RewardService:InvokeServer()
                    end
                end)
            end)
        else
            if cdConnection then cdConnection:Disconnect() end
        end
    end,
})

Tab:CreateSection("Extras")

local ToggleInfJump = Tab:CreateToggle({
    Name = "Infinite Jump (Spamma Space)",
    CurrentValue = false,
    Flag = "InfJumpVL",
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if Value then
            local UserInputService = game:GetService("UserInputService")
            UserInputService.JumpRequest:Connect(function()
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end)
        end
    end,
})

Rayfield:Notify({
    Title = "VOLLEYBALL LEGENDS Loaded! 🔥",
    Content = "Hitbox Alta, Sem Delay, Sem Cooldown ON! Domina a quadra brother! 😈",
    Duration = 6.5,
    Image = 4483362458,
})
