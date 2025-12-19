game.Players.PlayerAdded:Connect(function(player)
	-- leaderstats
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local Money = Instance.new("IntValue")
	Money.Name = "Money"
	Money.Value = 0
	Money.Parent = leaderstats

	-- stats internos
	local stats = Instance.new("Folder")
	stats.Name = "Stats"
	stats.Parent = player

	local Capacity = Instance.new("IntValue")
	Capacity.Name = "Capacity"
	Capacity.Value = 10
	Capacity.Parent = stats

	local Inventory = Instance.new("IntValue")
	Inventory.Name = "Inventory"
	Inventory.Value = 0
	Inventory.Parent = stats

	-- 💡 VALOR TOTAL de lo recolectado
	local InventoryValue = Instance.new("IntValue")
	InventoryValue.Name = "InventoryValue"
	InventoryValue.Value = 0
	InventoryValue.Parent = stats

	local BackpackLevel = Instance.new("IntValue")
	BackpackLevel.Name = "BackpackLevel"
	BackpackLevel.Value = 1
	BackpackLevel.Parent = stats
end)
