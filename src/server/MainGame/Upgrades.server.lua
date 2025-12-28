local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BuyUpgrade = ReplicatedStorage.Remotes:WaitForChild("BuyUpgrade")
local Upgrades = require(ReplicatedStorage.Shared.UpgradesConfig)
local VIP = require(ReplicatedStorage.Shared.VIPConfig)

print("Upgrade handler cargado")

-- 🛡️ ANTI-EXPLOIT: Rate Limiting
local COOLDOWN = 1 -- segundos entre compras
local lastPurchase = {} -- {[UserId] = tick()}

local function recalcCapacity(player)
	local stats = player:FindFirstChild("Stats")
	if not stats then
		return
	end

	local baseCapacity = stats:FindFirstChild("BaseCapacity")
	local capacity = stats:FindFirstChild("Capacity")
	local rebirths = stats:FindFirstChild("Rebirths")

	if not baseCapacity or not capacity or not rebirths then
		return
	end

	local finalCapacity = baseCapacity.Value

	-- 🔥 BONUS POR REBIRTH
	finalCapacity += rebirths.Value * 5

	-- ⭐ VIP
	if player:GetAttribute("VIP") then
		finalCapacity += VIP.Bonuses.ExtraCapacity
	end

	capacity.Value = finalCapacity
end

BuyUpgrade.OnServerEvent:Connect(function(player, upgradeName)
	if upgradeName ~= "Backpack" then
		return
	end

	-- 🛡️ ANTI-EXPLOIT: Rate Limiting
	local now = tick()
	local userId = player.UserId
	if lastPurchase[userId] and (now - lastPurchase[userId]) < COOLDOWN then
		warn("[ANTI-EXPLOIT] Player", player.Name, "spamming BuyUpgrade")
		return
	end

	local stats = player:FindFirstChild("Stats")
	local leaderstats = player:FindFirstChild("leaderstats")
	if not stats or not leaderstats then
		return
	end

	local backpackLevel = stats:FindFirstChild("BackpackLevel")
	local baseCapacity = stats:FindFirstChild("BaseCapacity")
	local money = leaderstats:FindFirstChild("Money")
	if not backpackLevel or not baseCapacity or not money then
		return
	end

	local currentLevel = backpackLevel.Value
	local nextLevel = currentLevel + 1
	local nextData = Upgrades.Backpack.Levels[nextLevel]
	if not nextData then
		return
	end

	-- 🛡️ ANTI-EXPLOIT: Validar dinero
	if money.Value < nextData.Price then
		warn("[ANTI-EXPLOIT] Player", player.Name, "tried to buy without money. Has:", money.Value, "Needs:", nextData.Price)
		return
	end

	-- 🛡️ ANTI-EXPLOIT: Validar nivel (no puede saltar niveles)
	if nextLevel ~= currentLevel + 1 then
		warn("[ANTI-EXPLOIT] Player", player.Name, "tried to skip levels")
		return
	end

	-- ✅ comprar
	money.Value -= nextData.Price
	backpackLevel.Value = nextLevel
	baseCapacity.Value = nextData.Capacity

	-- 🔁 recalcular capacidad FINAL (con VIP)
	recalcCapacity(player)

	-- 🛡️ Actualizar cooldown
	lastPurchase[userId] = now

	print("[UPGRADE] Player", player.Name, "upgraded to level", nextLevel)
end)
