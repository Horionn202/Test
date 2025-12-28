-- DailyRewardsHandler.server.lua
-- Maneja la lógica de las recompensas diarias

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DailyRewardsConfig = require(ReplicatedStorage.Shared.DailyRewardsConfig)

local claimEvent = ReplicatedStorage.Remotes:WaitForChild("ClaimDailyReward")
local checkEvent = ReplicatedStorage.Remotes:WaitForChild("CheckDailyReward")

-- ======================
-- VERIFICAR SI PUEDE RECLAMAR
-- ======================
local function canClaim(player)
	local lastClaim = player:GetAttribute("LastDailyReward") or 0
	local currentTime = os.time()
	local timeSinceLastClaim = currentTime - lastClaim

	-- Si nunca reclamó, puede reclamar
	if lastClaim == 0 then
		return true, 1 -- Puede reclamar, día 1
	end

	-- Si pasaron 24+ horas, puede reclamar
	if timeSinceLastClaim >= DailyRewardsConfig.ClaimCooldown then
		local currentStreak = player:GetAttribute("DailyStreak") or 0

		-- Si pasaron más de 48 horas, resetear streak
		if timeSinceLastClaim >= DailyRewardsConfig.StreakResetTime then
			return true, 1 -- Reset a día 1
		end

		-- Si no, continuar streak
		local nextDay = currentStreak + 1
		if nextDay > DailyRewardsConfig.MaxStreak then
			nextDay = 1 -- Volver a empezar después del día 7
		end

		return true, nextDay
	end

	-- Aún no han pasado 24 horas
	local timeRemaining = DailyRewardsConfig.ClaimCooldown - timeSinceLastClaim
	return false, 0, timeRemaining
end

-- ======================
-- RECLAMAR RECOMPENSA
-- ======================
claimEvent.OnServerEvent:Connect(function(player)
	local canClaimNow, nextDay, timeRemaining = canClaim(player)

	if not canClaimNow then
		warn("[DAILY REWARDS] Player", player.Name, "tried to claim too early. Time remaining:", timeRemaining)
		claimEvent:FireClient(player, false, "Come back in " .. math.floor(timeRemaining / 3600) .. " hours!")
		return
	end

	-- Obtener la recompensa del día
	local reward = DailyRewardsConfig.Rewards[nextDay]
	if not reward then
		warn("[DAILY REWARDS] Invalid day:", nextDay)
		return
	end

	-- Dar la recompensa
	local leaderstats = player:FindFirstChild("leaderstats")
	if leaderstats then
		local money = leaderstats:FindFirstChild("Money")
		if money then
			money.Value += reward.Money
		end
	end

	-- Actualizar atributos
	player:SetAttribute("LastDailyReward", os.time())
	player:SetAttribute("DailyStreak", nextDay)

	print("[DAILY REWARDS] Player", player.Name, "claimed Day", nextDay, "reward:", reward.Money, "coins")

	-- Notificar al cliente
	claimEvent:FireClient(player, true, reward)
end)

-- ======================
-- VERIFICAR ESTADO
-- ======================
checkEvent.OnServerEvent:Connect(function(player)
	local canClaimNow, nextDay, timeRemaining = canClaim(player)
	local currentStreak = player:GetAttribute("DailyStreak") or 0

	checkEvent:FireClient(player, {
		CanClaim = canClaimNow,
		NextDay = nextDay,
		CurrentStreak = currentStreak,
		TimeRemaining = timeRemaining or 0,
	})
end)

-- ======================
-- INICIALIZACIÓN
-- ======================
Players.PlayerAdded:Connect(function(player)
	-- Esperar a que los atributos se carguen desde DataStore
	task.wait(1)

	-- Verificar si puede reclamar automáticamente
	local canClaimNow, nextDay = canClaim(player)
	if canClaimNow then
		print("[DAILY REWARDS] Player", player.Name, "can claim Day", nextDay, "reward")
	end
end)
