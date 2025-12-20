local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RebirthConfig = require(ReplicatedStorage.Shared.RebirthConfig)
local Upgrades = require(ReplicatedStorage.Shared.UpgradesConfig)
local VIP = require(ReplicatedStorage.Shared.VIPConfig)

local rebirthEvent = ReplicatedStorage.Remotes:WaitForChild("Rebirth")

rebirthEvent.OnServerEvent:Connect(function(player)
	local stats = player:WaitForChild("Stats")
	local leaderstats = player:WaitForChild("leaderstats")

	local money = leaderstats:WaitForChild("Money")
	local rebirths = stats:WaitForChild("Rebirths")
	local backpackLevel = stats:WaitForChild("BackpackLevel")
	local baseCapacity = stats:WaitForChild("BaseCapacity")
	local capacity = stats:WaitForChild("Capacity")
	local inventory = stats:WaitForChild("Inventory")
	local inventoryValue = stats:WaitForChild("InventoryValue")

	local nextLevel = rebirths.Value + 1
	local config = RebirthConfig.Levels[nextLevel]
	if not config then
		return
	end

	-- ❌ NO TIENE DINERO
	if money.Value < config.Price then
		return
	end

	-- 🔁 RESETEO TOTAL
	money.Value = 0
	backpackLevel.Value = 1
	inventory.Value = 0
	inventoryValue.Value = 0

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
end)
