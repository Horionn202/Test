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

	-- Spin stats (nuevo sistema de ruleta)
	local spinFolder = player:WaitForChild("SpinStats", 10)

	-- Esperar a que PetsHandler cree la carpeta Pets
	local petsFolder = player:WaitForChild("Pets", 10)

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

		-- Cargar datos de spin
		if spinFolder then
			local availableSpins = spinFolder:FindFirstChild("AvailableSpins")
			local lastSpinTime = spinFolder:FindFirstChild("LastSpinTime")
			if availableSpins then
				availableSpins.Value = data.AvailableSpins or 1 -- Empiezan con 1 spin gratis
			end
			if lastSpinTime then
				lastSpinTime.Value = data.LastSpinTime or 0
			end
		end

		-- Cargar pets
		if data.Pets and petsFolder then
			for _, petData in ipairs(data.Pets) do
				-- Soporte para formato viejo (string) y nuevo (tabla del sistema shiny)
				local petName
				if type(petData) == "string" then
					-- Formato original - string simple
					petName = petData
				elseif type(petData) == "table" then
					-- Formato de shiny (tabla) - extraer solo el nombre
					petName = petData.Name or "Unknown"
				end

				if petName then
					local newPet = Instance.new("StringValue")
					newPet.Name = petName
					newPet.Value = petName
					newPet.Parent = petsFolder
				end
			end
		end
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

		-- Valores por defecto de spin
		if spinFolder then
			local availableSpins = spinFolder:FindFirstChild("AvailableSpins")
			local lastSpinTime = spinFolder:FindFirstChild("LastSpinTime")
			if availableSpins then
				availableSpins.Value = 1 -- Empiezan con 1 spin gratis
			end
			if lastSpinTime then
				lastSpinTime.Value = 0
			end
		end
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

	-- Guardar pets
	local pets = {}
	local petsFolder = player:FindFirstChild("Pets")
	if petsFolder then
		for _, pet in ipairs(petsFolder:GetChildren()) do
			table.insert(pets, pet.Name)
		end
	end

	-- Obtener datos de spin
	local spinFolder = player:FindFirstChild("SpinStats")
	local availableSpins = 1
	local lastSpinTime = 0
	if spinFolder then
		local spinsValue = spinFolder:FindFirstChild("AvailableSpins")
		local lastTime = spinFolder:FindFirstChild("LastSpinTime")
		if spinsValue then
			availableSpins = spinsValue.Value
		end
		if lastTime then
			lastSpinTime = lastTime.Value
		end
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
		Pets = pets,
		-- Datos de spin
		AvailableSpins = availableSpins,
		LastSpinTime = lastSpinTime,
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
