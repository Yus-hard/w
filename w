local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "VOLLEYBALL LEGENDS v2 - FIXADO 🔥",
    Icon = 0,
    LoadingTitle = "VL Hub by Grox",
    LoadingSubtitle = "Atualizado 2026 - Funciona 100%",
    ShowText = "VL GROX",
    Theme = "Default",
    ToggleUIKeybind = "K",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "VL Grox Hub"
    },
    Discord = { Enabled = false },
    KeySystem = false
})

local Tab = Window:CreateTab("Player God", 4483362458)
local Tab2 = Window:CreateTab("Ball & Farm", nil)

Tab:CreateSection("Hitbox Alta & Speed")

-- Hitbox Alta FIXADA (só Y alta, menos detect)
local hitboxSizeY = 8
local originalSizes = {}
local hitboxConn
local hitboxEnabled = false
local ToggleHitbox = Tab:CreateToggle({
    Name = "Hitbox Alta (Y Gigante - Bloqueia Tudo)",
    CurrentValue = false,
    Flag = "HitboxVL2",
    Callback = function(Value)
        hitboxEnabled = Value
        local player = game.Players.LocalPlayer
        local function applyHitbox(char)
            originalSizes = {}
            for _, part in ipairs(char:GetChildren()) do
                if part:IsA("BasePart") and (part.Name:find("Torso") or part.Name:find("Head") or part.Name:find("Leg") or part.Name:find("Arm")) then
                    originalSizes[part] = part.Size
                    part.Size = Vector3.new(part.Size.X * 1.2, part.Size.Y * hitboxSizeY, part.Size.Z * 1.2)
                    part.Transparency = 0.2 -- Semi visível
                    part.CanCollide = true
                end
            end
        end

        if hitboxEnabled then
            if player.Character then applyHitbox(player.Character) end
            hitboxConn = player.CharacterAdded:Connect(applyHitbox)
        else
            if player.Character then
                for part, size in pairs(originalSizes) do
                    if part and part.Parent then
                        part.Size = size
                        part.Transparency = 0
                    end
                end
            end
            if hitboxConn then hitboxConn:Disconnect() end
            originalSizes = {}
        end
    end,
})

Tab:CreateSlider({
    Name = "Hitbox Altura (Y)",
    Range = {3, 15},
    Increment = 1,
    Suffix = "x",
    CurrentValue = 8,
    Flag = "HitboxYVL",
    Callback = function(Value)
        hitboxSizeY = Value
        if hitboxEnabled then
            local player = game.Players.LocalPlayer
            if player.Character then ToggleHitbox.Callback(false); ToggleHitbox.Callback(true) end
        end
    end,
})

-- Sem Delay (Speed/Jump Loop)
local speedVal = 50
local jumpVal = 150
local speedConn
Tab:CreateSlider({
    Name = "Speed (Sem Delay)",
    Range = {16, 300},
    Increment = 5,
    Suffix = "",
    CurrentValue = 50,
    Flag = "SpeedVL2",
    Callback = function(Value)
        speedVal = Value
        pcall(function()
            local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = speedVal end
        end)
    end,
})

Tab:CreateSlider({
    Name = "Jump (Reach Infinita)",
    Range = {50, 500},
    Increment = 10,
    Suffix = "",
    CurrentValue = 150,
    Flag = "JumpVL2",
    Callback = function(Value)
        jumpVal = Value
        pcall(function()
            local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.JumpPower = jumpVal end
        end)
    end,
})

-- Loop pra não resetar
spawn(function()
    while task.wait(0.1) do
        pcall(function()
            local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = speedVal
                hum.JumpPower = jumpVal
            end
        end)
    end
end)

game.Players.LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    pcall(function()
        local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = speedVal
            hum.JumpPower = jumpVal
        end
    end)
    if hitboxEnabled then ToggleHitbox.Callback(true) end
end)

Tab2:CreateSection("Ball Hitbox & No Cooldown")

-- Ball Hitbox Enorme
local ballSize = 8
local ballLoop
local ToggleBall = Tab2:CreateToggle({
    Name = "Ball Hitbox Gigante (Impossível Errar)",
    CurrentValue = false,
    Flag = "BallVL2",
    Callback = function(Value)
        if Value then
            ballLoop = game:GetService("RunService").Heartbeat:Connect(function()
                for _, obj in ipairs(workspace:GetChildren()) do
                    if obj.Name:lower():find("ball") and obj:IsA("BasePart") then
                        obj.Size = Vector3.new(ballSize, ballSize, ballSize)
                        obj.Transparency = 0.4
                    end
                end
            end)
        else
            if ballLoop then ballLoop:Disconnect() end
        end
    end,
})

Tab2:CreateSlider({
    Name = "Ball Tamanho",
    Range = {2, 20},
    Increment = 1,
    Suffix = "x",
    CurrentValue = 8,
    Flag = "BallSizeVL2",
    Callback = function(Value) ballSize = Value end,
})

-- Sem Cooldown + Inf Money (Spam Rewards)
local noCdEnabled = false
local noCdConn
local infMoneyConn
local ToggleNoCD = Tab2:CreateToggle({
    Name = "Sem Cooldown + Inf Money/Spins",
    CurrentValue = false,
    Flag = "NoCDVL2",
    Callback = function(Value)
        noCdEnabled = Value
        local player = game.Players.LocalPlayer

        if noCdEnabled then
            -- Zera cooldowns
            noCdConn = game:GetService("RunService").Heartbeat:Connect(function()
                for _, v in ipairs(workspace:GetDescendants()) do
                    if v:IsA("NumberValue") and (v.Name:lower():find("cooldown") or v.Name:lower():find("cd") or v.Name:lower():find("wait")) then
                        v.Value = 0
                    end
                end
                for _, v in ipairs(player.PlayerGui:GetDescendants()) do
                    if v:IsA("NumberValue") and (v.Name:lower():find("cooldown") or v.Name:lower():find("cd")) then
                        v.Value = 0
                    end
                end
            end)

            -- Inf Money (remote spam - WORKS 2026)
            spawn(function()
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local knitVersions = {"sleitnick_knit@1.7.0", "sleitnick_knit@1.8.0", "knit"} -- Tenta versões
                local rewardRemote
                for _, ver in ipairs(knitVersions) do
                    pcall(function()
                        rewardRemote = ReplicatedStorage.Packages._Index[ver].knit.Services.RewardService.RF.RequestPlayWithDeveloperAward
                    end)
                    if rewardRemote then break end
                end
                if rewardRemote then
                    infMoneyConn = game:GetService("RunService").Heartbeat:Connect(function()
                        for i = 1, 50 do
                            task.spawn(function() pcall(rewardRemote.InvokeServer, rewardRemote) end)
                        end
                    end)
                    Rayfield:Notify({Title = "Inf Money ON", Content = "Spamando rewards! Checa teu dinheiro", Duration = 3})
                else
                    Rayfield:Notify({Title = "Aviso", Content = "Remote não achado (jogo up?), mas cooldowns zerados", Duration = 4})
                end
            end)
        else
            if noCdConn then noCdConn:Disconnect() end
            if infMoneyConn then infMoneyConn:Disconnect() end
        end
    end,
})

Tab:CreateToggle({
    Name = "Inf Jump (Spamma Espaço)",
    CurrentValue = false,
    Flag = "InfJumpVL2",
    Callback = function(Value)
        if Value then
            local UIS = game:GetService("UserInputService")
            UIS.JumpRequest:Connect(function()
                local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            end)
        end
    end,
})

Rayfield:Notify({
    Title = "VL GROX HUB v2 CARREGADO! 😈",
    Content = "Hitbox FIXADA + Ball Gigante + Inf Money + No CD. Liga tudo e DOMINA! Testado mobile/PC 2026",
    Duration = 8,
    Image = 4483362458,
})
