-- DAILY REWARDS BUTTON SCRIPT
-- Copia este LocalScript y ponlo DENTRO del botón que creaste

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local button = script.Parent -- El botón donde está este script
local checkEvent = ReplicatedStorage.Remotes:WaitForChild("CheckDailyReward")

-- Obtener la UI de Daily Rewards
local dailyRewardsGui = playerGui:WaitForChild("DailyRewardsGui", 10)
if not dailyRewardsGui then
	warn("[DAILY REWARDS BUTTON] DailyRewardsGui not found")
	return
end

local mainFrame = dailyRewardsGui:WaitForChild("MainFrame")

-- ======================
-- SONIDOS
-- ======================
-- Sonido hover
local hoverSound = Instance.new("Sound")
hoverSound.SoundId = "rbxassetid://119354387183704" -- hover
hoverSound.Volume = 0.6
hoverSound.Parent = button

-- Sonido click
local clickSound = Instance.new("Sound")
clickSound.SoundId = "rbxassetid://93826112721753" -- click
clickSound.Volume = 0.8
clickSound.Parent = button

-- ======================
-- EVENTOS
-- ======================
-- Hover (mouse entra)
button.MouseEnter:Connect(function()
	hoverSound:Play()
end)

-- Click en el botón
button.MouseButton1Click:Connect(function()
	-- Reproducir sonido
	clickSound:Play()

	-- Abrir la UI
	mainFrame.Visible = true

	-- Actualizar el estado desde el servidor
	checkEvent:FireServer()
end)
