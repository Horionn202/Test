local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local BuySpeed = ReplicatedStorage.Remotes:WaitForChild("BuySpeed")
local SpeedConfig = require(ReplicatedStorage.Shared.SpeedConfig)

-- 🛡️ ANTI-EXPLOIT: Rate Limiting
local COOLDOWN = 1 -- segundos entre compras
local lastPurchase = {} -- {[UserId] = tick()}

local function applySpeed(player)
	local stats = player:FindFirstChild("Stats")
	if not stats then
		return
	end

	local speedLevel = stats:FindFirstChild("SpeedLevel")
	if not speedLevel then
		return
	end

	local character = player.Character
	if not character then
		return
	end

	local humanoid = character:FindFirstChild("Humanoid")
	if not humanoid then
		return
	end

	local data = SpeedConfig.Levels[speedLevel.Value]
	if data then
		humanoid.WalkSpeed = data.Speed
	else
		humanoid.WalkSpeed = SpeedConfig.DefaultSpeed
	end
end

BuySpeed.OnServerEvent:Connect(function(player)
	-- 🛡️ ANTI-EXPLOIT: Rate Limiting
	local now = tick()
	local userId = player.UserId
	if lastPurchase[userId] and (now - lastPurchase[userId]) < COOLDOWN then
		warn("[ANTI-EXPLOIT] Player", player.Name, "spamming BuySpeed")
		return
	end

	local stats = player:FindFirstChild("Stats")
	local leaderstats = player:FindFirstChild("leaderstats")
	if not stats or not leaderstats then
		return
	end

	local speedLevel = stats:FindFirstChild("SpeedLevel")
	local money = leaderstats:FindFirstChild("Money")
	if not speedLevel or not money then
		return
	end

	local currentLevel = speedLevel.Value
	local nextLevel = currentLevel + 1
	local data = SpeedConfig.Levels[nextLevel]
	if not data then
		return
	end

	-- 🛡️ ANTI-EXPLOIT: Validar dinero
	if money.Value < data.Price then
		warn("[ANTI-EXPLOIT] Player", player.Name, "tried to buy speed without money. Has:", money.Value, "Needs:", data.Price)
		return
	end

	-- 🛡️ ANTI-EXPLOIT: Validar nivel (no puede saltar niveles)
	if nextLevel ~= currentLevel + 1 then
		warn("[ANTI-EXPLOIT] Player", player.Name, "tried to skip speed levels")
		return
	end

	-- ✅ 💸 pagar
	money.Value -= data.Price
	speedLevel.Value = nextLevel

	-- 🏃 aplicar velocidad
	applySpeed(player)

	-- 🛡️ Actualizar cooldown
	lastPurchase[userId] = now

	print("[SPEED] Player", player.Name, "upgraded speed to level", nextLevel)
end)

-- 🔁 reaplicar velocidad al respawn
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		task.wait(0.2)
		applySpeed(player)
	end)
end)
