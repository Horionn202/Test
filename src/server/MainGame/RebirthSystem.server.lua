local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RebirthConfig = require(ReplicatedStorage.Shared.RebirthConfig)
local Upgrades = require(ReplicatedStorage.Shared.UpgradesConfig)
local VIP = require(ReplicatedStorage.Shared.VIPConfig)

local rebirthEvent = ReplicatedStorage.Remotes:WaitForChild("Rebirth")

-- 🛡️ ANTI-EXPLOIT: Rate Limiting (Rebirth es más crítico, 3 segundos)
local COOLDOWN = 3 -- segundos entre rebirths
local lastRebirth = {} -- {[UserId] = tick()}

rebirthEvent.OnServerEvent:Connect(function(player)
	-- 🛡️ ANTI-EXPLOIT: Rate Limiting
	local now = tick()
	local userId = player.UserId
	if lastRebirth[userId] and (now - lastRebirth[userId]) < COOLDOWN then
		warn("[ANTI-EXPLOIT] Player", player.Name, "spamming Rebirth")
		return
	end

	local stats = player:WaitForChild("Stats")
	local leaderstats = player:WaitForChild("leaderstats")

	local money = leaderstats:WaitForChild("Money")
	local rebirths = stats:WaitForChild("Rebirths")
	local backpackLevel = stats:WaitForChild("BackpackLevel")
	local baseCapacity = stats:WaitForChild("BaseCapacity")
	local capacity = stats:WaitForChild("Capacity")
	local inventory = stats:WaitForChild("Inventory")
	local inventoryValue = stats:WaitForChild("InventoryValue")
	local CapacityUtils = require(ReplicatedStorage.Shared.CapacityUtils)

	local currentRebirths = rebirths.Value
	local nextLevel = currentRebirths + 1
	local config = RebirthConfig.Levels[nextLevel]
	if not config then
		return
	end

	-- 🛡️ ANTI-EXPLOIT: Validar dinero
	if money.Value < config.Price then
		warn("[ANTI-EXPLOIT] Player", player.Name, "tried to rebirth without money. Has:", money.Value, "Needs:", config.Price)
		return
	end

	-- 🛡️ ANTI-EXPLOIT: Validar que no salte niveles de rebirth
	if nextLevel ~= currentRebirths + 1 then
		warn("[ANTI-EXPLOIT] Player", player.Name, "tried to skip rebirth levels")
		return
	end

	-- ✅ 🔁 RESETEO TOTAL
	money.Value = 0
	backpackLevel.Value = 1
	inventory.Value = 0
	inventoryValue.Value = 0
	capacity.Value = CapacityUtils.Calculate(player)

	-- 🔁 BASE CAPACITY AL NIVEL 1
	baseCapacity.Value = Upgrades.Backpack.Levels[1].Capacity

	-- ➕ SUMAR REBIRTH
	rebirths.Value = nextLevel

	-- 🎒 RECALCULAR CAPACIDAD FINAL
	local finalCapacity = baseCapacity.Value
	finalCapacity += rebirths.Value * config.ExtraCapacity

	if player:GetAttribute("VIP") then
		finalCapacity += VIP.Bonuses.ExtraCapacity
	end

	capacity.Value = finalCapacity

	-- 🛡️ Actualizar cooldown
	lastRebirth[userId] = now

	print("[REBIRTH] Player", player.Name, "reached rebirth level", nextLevel)
end)
