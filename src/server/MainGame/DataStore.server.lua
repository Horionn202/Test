local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local PlayerData = DataStoreService:GetDataStore("FarmingSimulator_V1")

local function loadPlayer(player)
	local leaderstats = player:WaitForChild("leaderstats")
	local stats = player:WaitForChild("Stats")

	local money = leaderstats:WaitForChild("Money")
	local inventory = stats:WaitForChild("Inventory")
	local inventoryValue = stats:WaitForChild("InventoryValue")
	local capacity = stats:WaitForChild("Capacity")
	local backpackLevel = stats:WaitForChild("backpackLevels")

	local data
	local success = pcall(function()
		data = PlayerData:GetAsync(player.UserId)
	end)

	if success and data then
		money.Value = data.Money or 0
		inventory.Value = data.Inventory or 0
		inventoryValue.Value = data.InventoryValue or 0
		capacity.Value = data.Capacity or 10
		backpackLevel.Value = data.BackpackLevel or 1
		capacity.Value = data.Capacity or 10
	else
		money.Value = 0
		inventory.Value = 0
		inventoryValue.Value = 0
		capacity.Value = 10
	end
end

local function savePlayer(player)
	local leaderstats = player:FindFirstChild("leaderstats")
	local stats = player:FindFirstChild("Stats")
	if not leaderstats or not stats then
		return
	end

	local data = {
		Money = leaderstats.Money.Value,
		Inventory = stats.Inventory.Value,
		InventoryValue = stats.InventoryValue.Value,
		Capacity = stats.Capacity.Value,
		BackpackLevel = stats.BackpackLevel.Value,
	}

	pcall(function()
		PlayerData:SetAsync(player.UserId, data)
	end)
end

Players.PlayerAdded:Connect(loadPlayer)
Players.PlayerRemoving:Connect(savePlayer)

game:BindToClose(function()
	for _, player in ipairs(Players:GetPlayers()) do
		savePlayer(player)
	end
end)
