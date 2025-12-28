-- DailyRewards.client.lua
-- LocalScript que maneja la UI de Daily Rewards

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local DailyRewardsConfig = require(ReplicatedStorage.Shared.DailyRewardsConfig)

local claimEvent = ReplicatedStorage.Remotes:WaitForChild("ClaimDailyReward")
local checkEvent = ReplicatedStorage.Remotes:WaitForChild("CheckDailyReward")

-- ======================
-- REFERENCIAS A LA UI
-- ======================
local dailyRewardsGui = playerGui:WaitForChild("DailyRewardsGui", 10)
if not dailyRewardsGui then
	warn("[DAILY REWARDS] DailyRewardsGui not found in PlayerGui")
	return
end

local mainFrame = dailyRewardsGui:WaitForChild("MainFrame")
local titleLabel = mainFrame:WaitForChild("TitleLabel")
local claimButton = mainFrame:WaitForChild("ClaimButton")
local statusLabel = mainFrame:WaitForChild("StatusLabel")
local closeButton = mainFrame:WaitForChild("CloseButton")
local daysContainer = mainFrame:WaitForChild("DaysContainer")

local currentState = {
	CanClaim = false,
	NextDay = 1,
	CurrentStreak = 0,
	TimeRemaining = 0,
}

-- ======================
-- SONIDOS
-- ======================
-- Sonido hover
local hoverSound = Instance.new("Sound")
hoverSound.SoundId = "rbxassetid://119354387183704" -- hover
hoverSound.Volume = 0.6
hoverSound.Parent = claimButton

-- Sonido click
local clickSound = Instance.new("Sound")
clickSound.SoundId = "rbxassetid://93826112721753" -- click
clickSound.Volume = 0.8
clickSound.Parent = claimButton

-- Sonido hover para close button
local hoverSoundClose = Instance.new("Sound")
hoverSoundClose.SoundId = "rbxassetid://119354387183704" -- hover
hoverSoundClose.Volume = 0.6
hoverSoundClose.Parent = closeButton

-- Sonido click para close button
local clickSoundClose = Instance.new("Sound")
clickSoundClose.SoundId = "rbxassetid://93826112721753" -- click
clickSoundClose.Volume = 0.8
clickSoundClose.Parent = closeButton

-- ======================
-- ACTUALIZAR UI DE DÍAS
-- ======================
local function updateDaysUI()
	for day = 1, 7 do
		local dayFrame = daysContainer:FindFirstChild("Day" .. day)
		if dayFrame then
			local rewardData = DailyRewardsConfig.Rewards[day]
			local dayLabel = dayFrame:FindFirstChild("DayLabel")
			local rewardLabel = dayFrame:FindFirstChild("RewardLabel")
			local iconLabel = dayFrame:FindFirstChild("IconLabel")

			-- Actualizar texto
			if dayLabel then
				dayLabel.Text = "Day " .. day
			end

			if rewardLabel then
				rewardLabel.Text = "$" .. rewardData.Money
			end

			-- Actualizar color según estado
			if day < currentState.NextDay then
				-- Día ya reclamado
				dayFrame.BackgroundColor3 = DailyRewardsConfig.UIColors.Claimed
				if iconLabel then
					iconLabel.Text = "✓"
					iconLabel.TextColor3 = Color3.new(1, 1, 1)
				end
			elseif day == currentState.NextDay and currentState.CanClaim then
				-- Día actual (puede reclamar)
				if rewardData.Special then
					dayFrame.BackgroundColor3 = DailyRewardsConfig.UIColors.Special
				else
					dayFrame.BackgroundColor3 = DailyRewardsConfig.UIColors.Available
				end
				if iconLabel then
					iconLabel.Text = "!"
					iconLabel.TextColor3 = Color3.new(1, 1, 1)
				end
			else
				-- Día futuro (bloqueado)
				dayFrame.BackgroundColor3 = DailyRewardsConfig.UIColors.Locked
				if iconLabel then
					iconLabel.Text = ""
				end
			end
		end
	end
end

-- ======================
-- ACTUALIZAR ESTADO UI
-- ======================
local function updateUI()
	updateDaysUI()

	if currentState.CanClaim then
		-- Puede reclamar
		claimButton.Text = "CLAIM DAY " .. currentState.NextDay .. " REWARD"
		claimButton.BackgroundColor3 = Color3.fromRGB(85, 255, 127)
		claimButton.TextColor3 = Color3.new(0, 0, 0)
		claimButton.Active = true

		local reward = DailyRewardsConfig.Rewards[currentState.NextDay]
		statusLabel.Text = "Available: $" .. reward.Money
		statusLabel.TextColor3 = Color3.fromRGB(85, 255, 127)
	else
		-- No puede reclamar
		local hours = math.floor(currentState.TimeRemaining / 3600)
		local minutes = math.floor((currentState.TimeRemaining % 3600) / 60)

		claimButton.Text = "CLAIMED - COME BACK LATER"
		claimButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
		claimButton.TextColor3 = Color3.fromRGB(200, 200, 200)
		claimButton.Active = false

		if hours > 0 then
			statusLabel.Text = "Next reward in " .. hours .. "h " .. minutes .. "m"
		else
			statusLabel.Text = "Next reward in " .. minutes .. " minutes"
		end
		statusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
	end

	-- Actualizar título con streak
	if currentState.CurrentStreak > 0 then
		titleLabel.Text = "DAILY REWARDS - Day " .. currentState.CurrentStreak .. " Streak"
	else
		titleLabel.Text = "DAILY REWARDS"
	end
end

-- ======================
-- VERIFICAR ESTADO
-- ======================
local function checkDailyReward()
	checkEvent:FireServer()
end

-- Recibir estado del servidor
checkEvent.OnClientEvent:Connect(function(data)
	currentState.CanClaim = data.CanClaim
	currentState.NextDay = data.NextDay
	currentState.CurrentStreak = data.CurrentStreak
	currentState.TimeRemaining = data.TimeRemaining

	updateUI()
end)

-- ======================
-- RECLAMAR RECOMPENSA
-- ======================
-- Hover en botón de claim
claimButton.MouseEnter:Connect(function()
	if currentState.CanClaim then
		hoverSound:Play()
	end
end)

claimButton.MouseButton1Click:Connect(function()
	if not currentState.CanClaim then
		return
	end

	-- Reproducir sonido
	clickSound:Play()

	-- Deshabilitar botón temporalmente
	claimButton.Active = false
	claimButton.Text = "CLAIMING..."

	claimEvent:FireServer()
end)

-- Recibir resultado de claim
claimEvent.OnClientEvent:Connect(function(success, data)
	if success then
		-- Mostrar mensaje de éxito
		statusLabel.Text = "Claimed $" .. data.Money .. "! 🎉"
		statusLabel.TextColor3 = Color3.fromRGB(255, 215, 0)

		-- Actualizar estado
		task.wait(1)
		checkDailyReward()
	else
		-- Mostrar error
		statusLabel.Text = data -- Mensaje de error
		statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)

		claimButton.Active = true
		claimButton.Text = "CLAIM DAILY REWARD"
	end
end)

-- ======================
-- ABRIR/CERRAR UI
-- ======================
local function openUI()
	mainFrame.Visible = true
	checkDailyReward()
end

local function closeUI()
	mainFrame.Visible = false
end

-- Hover en close button
closeButton.MouseEnter:Connect(function()
	hoverSoundClose:Play()
end)

closeButton.MouseButton1Click:Connect(function()
	clickSoundClose:Play()
	closeUI()
end)

-- Ocultar al inicio
mainFrame.Visible = false

-- ======================
-- BOTÓN PARA ABRIR (Opcional)
-- ======================
-- Si tienes un botón en tu HUD para abrir Daily Rewards
local hudGui = playerGui:WaitForChild("HUD", 10)
if hudGui then
	local dailyRewardsButton = hudGui:FindFirstChild("DailyRewardsButton", true)
	if dailyRewardsButton then
		dailyRewardsButton.MouseButton1Click:Connect(openUI)
	end
end

-- ======================
-- AUTO-ABRIR AL ENTRAR (si puede reclamar)
-- ======================
task.wait(3) -- Esperar 3 segundos después de entrar
checkEvent:FireServer()

-- Esperar respuesta
task.wait(1)
if currentState.CanClaim then
	openUI()
end

-- ======================
-- ACTUALIZACIÓN PERIÓDICA
-- ======================
task.spawn(function()
	while true do
		task.wait(60) -- Actualizar cada minuto
		if mainFrame.Visible then
			checkDailyReward()
		end
	end
end)
