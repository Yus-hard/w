-- Volleyball Legends GUI by Grox (sem Key System) 😈🏐
-- Direto ao ponto, sem verificação de chave - carrega na hora!
-- Baseado no teu código, mas melhorado: mais limpo, com notify de load, e pronto pra executor mobile/PC.

-- Função principal (teu script original sem key)
local function runMainScript()
    -- Carrega o GUI externo pro Volleyball Legends
    local Games = loadstring(game:HttpGet('https://raw.githubusercontent.com/TheDarkoneMarcillisePex/Other-Scripts/refs/heads/main/Volleyball%20Legends%20GUI'))()
    for PlaceID, Execute in pairs(Games) do
        if PlaceID == game.PlaceId then
            loadstring(game:HttpGet(Execute))()
        end
    end
end

-- UI simples de loading (inspirado no teu, mas sem key input - só notify)
local function createLoadUI()
    local ScreenGui = Instance.new("ScreenGui")
    local StatusLabel = Instance.new("TextLabel")

    ScreenGui.Name = "LoadUI"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    StatusLabel.Name = "StatusLabel"
    StatusLabel.Parent = ScreenGui
    StatusLabel.BackgroundTransparency = 0.5
    StatusLabel.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
    StatusLabel.Position = UDim2.new(0.5, -150, 0.5, -20)
    StatusLabel.Size = UDim2.new(0, 300, 0, 40)
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.Text = "Carregando Volleyball Legends GUI... 😈"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    StatusLabel.TextSize = 16

    return { ScreenGui = ScreenGui, StatusLabel = StatusLabel }
end

-- Inicializa sem key
local function initNoKey()
    local ui = createLoadUI()
    task.delay(1.5, function()  -- Delay fake pra "loading"
        ui.StatusLabel.Text = "GUI Carregada! Domina a quadra brother! 🔥🏐"
        ui.StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        task.delay(2, function()
            ui.ScreenGui:Destroy()
            runMainScript()  -- Roda o script principal
        end)
    end)
end

-- Start direto
initNoKey()
