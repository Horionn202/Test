local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local PlayerData = DataStoreService:GetDataStore("FarmingSimulator_V3")

local AUTOSAVE_TIME = 30

-- ======================
-- CARGAR
-- ======================
local function loadPlayer(player)
	local leaderstats = player:WaitForChild("leaderstats", 10)
	local stats = player:WaitForChild("Stats", 10)
	if not leaderstats or not stats then
		return
	end

	-- leaderstats
	local money = leaderstats:WaitForChild("Money")

	-- stats
	local inventory = stats:WaitForChild("Inventory")
	local inventoryValue = stats:WaitForChild("InventoryValue")
	local backpackLevel = stats:WaitForChild("BackpackLevel")
	local rebirths = stats:WaitForChild("Rebirths")
	local speedLevel = stats:WaitForChild("SpeedLevel")
	local capacity = stats:WaitForChild("Capacity")
	local baseCapacity = stats:WaitForChild("BaseCapacity")

	local data
	local success = pcall(function()
		data = PlayerData:GetAsync(player.UserId)
	end)

	if success and data then
		money.Value = data.Money or 0
		inventory.Value = data.Inventory or 0
		inventoryValue.Value = data.InventoryValue or 0
		backpackLevel.Value = data.BackpackLevel or 1
		rebirths.Value = data.Rebirths or 0
		speedLevel.Value = data.SpeedLevel or 0
		baseCapacity.Value = data.BaseCapacity or 10
		player:SetAttribute("TutorialCompleted", data.TutorialCompleted or false)
		player:SetAttribute("LastDailyReward", data.LastDailyReward or 0)
		player:SetAttribute("DailyStreak", data.DailyStreak or 0)
		-- NO cargar Capacity aquí, RecalcCapacityHandler lo recalculará
	else
		-- valores por defecto
		money.Value = 0
		inventory.Value = 0
		inventoryValue.Value = 0
		backpackLevel.Value = 1
		rebirths.Value = 0
		speedLevel.Value = 0
		baseCapacity.Value = 10
		player:SetAttribute("TutorialCompleted", false)
		player:SetAttribute("LastDailyReward", 0)
		player:SetAttribute("DailyStreak", 0)
		-- NO setear Capacity aquí, RecalcCapacityHandler lo recalculará
	end
end

-- ======================
-- GUARDAR
-- ======================
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
		BackpackLevel = stats.BackpackLevel.Value,
		Rebirths = stats.Rebirths.Value,
		SpeedLevel = stats.SpeedLevel.Value,
		BaseCapacity = stats.BaseCapacity.Value, -- Guardar BaseCapacity en vez de Capacity final
		TutorialCompleted = player:GetAttribute("TutorialCompleted") or false,
		LastDailyReward = player:GetAttribute("LastDailyReward") or 0,
		DailyStreak = player:GetAttribute("DailyStreak") or 0,
		-- No guardar Capacity porque se recalcula automáticamente
	}

	pcall(function()
		PlayerData:UpdateAsync(player.UserId, function()
			return data
		end)
	end)
end

-- ======================
-- AUTOSAVE
-- ======================
task.spawn(function()
	while true do
		task.wait(AUTOSAVE_TIME)
		for _, player in ipairs(Players:GetPlayers()) do
			savePlayer(player)
		end
	end
end)

-- ======================
-- CONEXIONES
-- ======================
Players.PlayerAdded:Connect(loadPlayer)
Players.PlayerRemoving:Connect(savePlayer)

game:BindToClose(function()
	for _, player in ipairs(Players:GetPlayers()) do
		savePlayer(player)
	end
end)
