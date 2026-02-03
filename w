local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "BROOKHAVEN GROX HUB 😈",
    LoadingTitle = "Brookhaven RP Hub",
    LoadingSubtitle = "by Grox - Santa Catarina Style",
    Theme = "Default",
    ToggleUIKeybind = "K",
    ConfigurationSaving = { Enabled = true, FileName = "BrookhavenGrox" },
    KeySystem = false
})

local TabMain = Window:CreateTab("Main Cheats", 4483362458)
local TabTroll = Window:CreateTab("Troll & Fun", nil)
local TabVisual = Window:CreateTab("Visuals & ESP", nil)

-- Vars
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- Fly Vars
local flyEnabled = false
local flySpeed = 50
local bodyVelocity, bodyGyro

local function startFly()
    if flyEnabled then return end
    flyEnabled = true
    bodyVelocity = Instance.new("BodyVelocity", root)
    bodyVelocity.Velocity = Vector3.new(0,0,0)
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    
    bodyGyro = Instance.new("BodyGyro", root)
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.P = 9e4
    bodyGyro.CFrame = root.CFrame
    
    spawn(function()
        while flyEnabled do
            task.wait()
            hum.PlatformStand = true
            local cam = workspace.CurrentCamera
            local moveDir = Vector3.new(0,0,0)
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0,1,0) end
            bodyVelocity.Velocity = moveDir * flySpeed
            bodyGyro.CFrame = cam.CFrame
        end
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
        hum.PlatformStand = false
    end)
end

local ToggleFly = TabMain:CreateToggle({
    Name = "Fly (WASD + Space/Ctrl)",
    CurrentValue = false,
    Flag = "FlyBrook",
    Callback = function(Value)
        flyEnabled = Value
        if Value then startFly() else flyEnabled = false end
    end,
})

TabMain:CreateSlider({
    Name = "Fly Speed",
    Range = {20, 200},
    Increment = 5,
    CurrentValue = 50,
    Flag = "FlySpeed",
    Callback = function(Value) flySpeed = Value end,
})

-- Noclip
local noclipEnabled = false
local noclipConn
TabMain:CreateToggle({
    Name = "Noclip (Atravessa Tudo)",
    CurrentValue = false,
    Flag = "NoclipBrook",
    Callback = function(Value)
        noclipEnabled = Value
        if Value then
            noclipConn = game:GetService("RunService").Stepped:Connect(function()
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end)
        else
            if noclipConn then noclipConn:Disconnect() end
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
    end,
})

-- Speed & Jump
local speedVal = 16
TabMain:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 300},
    Increment = 5,
    CurrentValue = 16,
    Flag = "SpeedBrook",
    Callback = function(Value)
        speedVal = Value
        hum.WalkSpeed = Value
    end,
})

local jumpVal = 50
TabMain:CreateSlider({
    Name = "Jump Power",
    Range = {50, 300},
    Increment = 10,
    CurrentValue = 50,
    Flag = "JumpBrook",
    Callback = function(Value)
        jumpVal = Value
        hum.JumpPower = Value
    end,
})

-- Infinite Jump
TabMain:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfJumpBrook",
    Callback = function(Value)
        if Value then
            game:GetService("UserInputService").JumpRequest:Connect(function()
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end)
        end
    end,
})

-- God Mode (No Fall Damage / Health Lock)
TabMain:CreateToggle({
    Name = "God Mode (No Die)",
    CurrentValue = false,
    Flag = "GodBrook",
    Callback = function(Value)
        if Value then
            hum.MaxHealth = math.huge
            hum.Health = math.huge
            hum:GetPropertyChangedSignal("Health"):Connect(function()
                hum.Health = math.huge
            end)
        end
    end,
})

-- ESP Players
local espEnabled = false
local espConns = {}
TabVisual:CreateToggle({
    Name = "ESP Players (Names through walls)",
    CurrentValue = false,
    Flag = "ESPBrook",
    Callback = function(Value)
        espEnabled = Value
        if Value then
            for _, plr in ipairs(game.Players:GetPlayers()) do
                if plr ~= player and plr.Character then
                    local highlight = Instance.new("Highlight")
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                    highlight.Parent = plr.Character
                    espConns[plr] = highlight
                end
            end
            game.Players.PlayerAdded:Connect(function(plr)
                plr.CharacterAdded:Connect(function(char)
                    if espEnabled then
                        local highlight = Instance.new("Highlight")
                        highlight.FillColor = Color3.fromRGB(255, 0, 0)
                        highlight.Parent = char
                        espConns[plr] = highlight
                    end
                end)
            end)
        else
            for _, conn in pairs(espConns) do if conn then conn:Destroy() end end
            espConns = {}
        end
    end,
})

-- Teleport to Player (Dropdown)
local playerList = {}
for _, plr in ipairs(game.Players:GetPlayers()) do table.insert(playerList, plr.Name) end
game.Players.PlayerAdded:Connect(function(plr)
    table.insert(playerList, plr.Name)
end)

TabMain:CreateDropdown({
    Name = "Teleport to Player",
    Options = playerList,
    CurrentOption = "",
    MultipleOptions = false,
    Flag = "TPBrook",
    Callback = function(Option)
        local target = game.Players:FindFirstChild(Option)
        if target and target.Character and root then
            root.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
        end
    end,
})

-- Troll: Invisible
TabTroll:CreateToggle({
    Name = "Invisible (Self)",
    CurrentValue = false,
    Flag = "InvisBrook",
    Callback = function(Value)
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("MeshPart") then
                part.Transparency = Value and 1 or 0
            end
        end
    end,
})

-- Fling Player (Troll)
TabTroll:CreateButton({
    Name = "Fling Nearest Player",
    Callback = function()
        local nearest = nil
        local dist = math.huge
        for _, plr in ipairs(game.Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local d = (root.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                if d < dist then dist = d nearest = plr end
            end
        end
        if nearest then
            local hrp = nearest.Character.HumanoidRootPart
            hrp.Velocity = Vector3.new(0, 10000, 0) -- Fling up
        end
    end,
})

-- Notify Load
Rayfield:Notify({
    Title = "Brookhaven Grox Hub Loaded! 🔥",
    Content = "Fly, Noclip, ESP, Speed tudo ON! Testa no teu Arceus X brother, sem ban wave pesada em 2026 se não abusar.",
    Duration = 6,
    Image = 4483362458,
})

-- Re-apply on respawn
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    hum = newChar:WaitForChild("Humanoid")
    root = newChar:WaitForChild("HumanoidRootPart")
    task.wait(1)
    hum.WalkSpeed = speedVal
    hum.JumpPower = jumpVal
    if flyEnabled then startFly() end
    if noclipEnabled then -- Re-noclip
        noclipConn = game:GetService("RunService").Stepped:Connect(function()
            for _, part in ipairs(newChar:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end)
    end
end)
