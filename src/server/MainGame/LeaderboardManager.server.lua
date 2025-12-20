local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VIP = require(ReplicatedStorage.Shared.VIPConfig)
local Upgrades = require(ReplicatedStorage.Shared.UpgradesConfig)

Players.PlayerAdded:Connect(function(player)
	-- leaderstats
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local Money = Instance.new("IntValue")
	Money.Name = "Money"
	Money.Value = 0
	Money.Parent = leaderstats

	-- stats
	local stats = Instance.new("Folder")
	stats.Name = "Stats"
	stats.Parent = player

	local BackpackLevel = Instance.new("IntValue")
	BackpackLevel.Name = "BackpackLevel"
	BackpackLevel.Value = 1
	BackpackLevel.Parent = stats

	-- 🔁 REBIRTHS
	local Rebirths = Instance.new("IntValue")
	Rebirths.Name = "Rebirths"
	Rebirths.Value = 0
	Rebirths.Parent = stats

	-- 🔹 BASE CAPACITY (NUEVO)
	local BaseCapacity = Instance.new("IntValue")
	BaseCapacity.Name = "BaseCapacity"
	BaseCapacity.Value = Upgrades.Backpack.Levels[1].Capacity
	BaseCapacity.Parent = stats

	-- 🔹 CAPACIDAD FINAL
	local Capacity = Instance.new("IntValue")
	Capacity.Name = "Capacity"

	local finalCapacity = BaseCapacity.Value

	-- +5 de capacidad por cada rebirth
	finalCapacity += Rebirths.Value * 5

	-- VIP bonus
	if player:GetAttribute("VIP") then
		finalCapacity += VIP.Bonuses.ExtraCapacity
	end

	Capacity.Value = finalCapacity
	Capacity.Parent = stats

	local Inventory = Instance.new("IntValue")
	Inventory.Name = "Inventory"
	Inventory.Value = 0
	Inventory.Parent = stats

	local InventoryValue = Instance.new("IntValue")
	InventoryValue.Name = "InventoryValue"
	InventoryValue.Value = 0
	InventoryValue.Parent = stats
end)
