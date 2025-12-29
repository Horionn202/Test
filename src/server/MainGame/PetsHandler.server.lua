local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local ServerStorage = game:GetService("ServerStorage")

-- ⚙️ CONFIGURACIÓN
-- IDs de Gamepasses (cámbialos por los tuyos)
local TRIPLE_HATCH_GAMEPASS_ID = 0  -- Cambia esto por tu ID
local AUTO_HATCH_GAMEPASS_ID = 0    -- Cambia esto por tu ID

local PetsFolder = Workspace:WaitForChild("Player_Pets")
local EggHatchingRemotes = ReplicatedStorage:WaitForChild("EggHatchingRemotes")

-- Función para crear datos del jugador
local function setupPlayerPetsData(player)
	-- Copiar datos desde ServerStorage
	for _, dataFolder in pairs(ServerStorage.EggHatchingData:GetChildren()) do
		local clonedFolder = dataFolder:Clone()
		clonedFolder.Parent = player
	end

	-- Crear carpeta en Workspace para pets equipadas
	local playerPetsFolder = Instance.new("Folder")
	playerPetsFolder.Name = player.Name
	playerPetsFolder.Parent = PetsFolder

	-- Verificar gamepasses
	local success, hasTripleHatch = pcall(function()
		return MarketplaceService:UserOwnsGamePassAsync(player.UserId, TRIPLE_HATCH_GAMEPASS_ID)
	end)

	if success and hasTripleHatch then
		player.Values.CanTripleHatch.Value = true
	end

	local success2, hasAutoHatch = pcall(function()
		return MarketplaceService:UserOwnsGamePassAsync(player.UserId, AUTO_HATCH_GAMEPASS_ID)
	end)

	if success2 and hasAutoHatch then
		player.Values.CanAutoHatch.Value = true
	end
end

-- Función para elegir una pet al azar
local function choosePet(eggName)
	local chance = math.random(1, 100)
	local counter = 0

	local petsInEgg = ReplicatedStorage.Pets:FindFirstChild(eggName)

	if not petsInEgg then
		warn("No se encontró el huevo:", eggName)
		return nil
	end

	for _, pet in pairs(petsInEgg:GetChildren()) do
		if pet:FindFirstChild("Rarity") then
			counter = counter + pet.Rarity.Value
			if chance <= counter then
				return pet.Name
			end
		end
	end

	return nil
end

-- RemoteFunction: Abrir 1 huevo
EggHatchingRemotes.HatchServer.OnServerInvoke = function(player, eggModel)
	local eggInWorld = Workspace.Eggs:FindFirstChild(eggModel.Name)

	if not eggInWorld then
		return "Cannot Hatch"
	end

	local price = eggInWorld.Price.Value
	local currency = eggInWorld.Currency.Value

	-- 💎 Si es un huevo de Robux, mostrar prompt de compra
	if currency == "Robux" then
		local productId = price
		player:SetAttribute("PendingEgg", eggModel.Name)
		MarketplaceService:PromptProductPurchase(player, productId)
		return "Robux Purchase Prompted"
	end

	-- 💰 Si es moneda del juego (Money, Coins, etc.)
	local playerCurrency = player.leaderstats:FindFirstChild(currency)

	if not playerCurrency or playerCurrency.Value < price then
		return "Cannot Hatch"
	end

	-- Cobrar
	playerCurrency.Value = playerCurrency.Value - price

	-- Elegir pet
	local chosenPet = choosePet(eggModel.Name)

	if chosenPet then
		local newPet = Instance.new("StringValue")
		newPet.Name = chosenPet
		newPet.Value = chosenPet
		newPet.Parent = player.Pets
		return chosenPet
	else
		return "Cannot Hatch"
	end
end

-- RemoteFunction: Abrir 3 huevos
EggHatchingRemotes.Hatch3Pets.OnServerInvoke = function(player, eggModel)
	if not player.Values.CanTripleHatch.Value then
		return "The player does not own the gamepass"
	end

	local eggInWorld = Workspace.Eggs:FindFirstChild(eggModel.Name)

	if not eggInWorld then
		return false
	end

	local price = eggInWorld.Price.Value
	local currency = eggInWorld.Currency.Value

	local playerCurrency = player.leaderstats:FindFirstChild(currency)

	if not playerCurrency or playerCurrency.Value < (price * 3) then
		return false
	end

	-- Cobrar
	playerCurrency.Value = playerCurrency.Value - (price * 3)

	-- Elegir 3 pets
	local chosenPet1 = choosePet(eggModel.Name)
	local chosenPet2 = choosePet(eggModel.Name)
	local chosenPet3 = choosePet(eggModel.Name)

	if chosenPet1 then
		local newPet = Instance.new("StringValue")
		newPet.Name = chosenPet1
		newPet.Value = chosenPet1
		newPet.Parent = player.Pets
	end

	if chosenPet2 then
		local newPet = Instance.new("StringValue")
		newPet.Name = chosenPet2
		newPet.Value = chosenPet2
		newPet.Parent = player.Pets
	end

	if chosenPet3 then
		local newPet = Instance.new("StringValue")
		newPet.Name = chosenPet3
		newPet.Value = chosenPet3
		newPet.Parent = player.Pets
	end

	return chosenPet1, chosenPet2, chosenPet3
end

-- RemoteFunction: Auto Hatch
EggHatchingRemotes.AutoHatch.OnServerInvoke = function(player, eggModel)
	if not player.Values.CanAutoHatch.Value then
		return "The player does not own the gamepass"
	end

	local eggInWorld = Workspace.Eggs:FindFirstChild(eggModel.Name)

	if not eggInWorld then
		return "Cannot Hatch"
	end

	local price = eggInWorld.Price.Value
	local currency = eggInWorld.Currency.Value

	local playerCurrency = player.leaderstats:FindFirstChild(currency)

	if not playerCurrency or playerCurrency.Value < price then
		return "Cannot Hatch"
	end

	-- Cobrar
	playerCurrency.Value = playerCurrency.Value - price

	-- Elegir pet
	local chosenPet = choosePet(eggModel.Name)

	if chosenPet then
		local newPet = Instance.new("StringValue")
		newPet.Name = chosenPet
		newPet.Value = chosenPet
		newPet.Parent = player.Pets
		return chosenPet
	else
		return "Cannot Hatch"
	end
end

-- RemoteFunction: Equipar pet
EggHatchingRemotes.EquipPet.OnServerInvoke = function(player, petName)
	local numberOfPetsEquipped = #PetsFolder:FindFirstChild(player.Name):GetChildren()
	local maxPets = player.Values.MaxPetsEquipped.Value

	if (numberOfPetsEquipped + 1) > maxPets then
		return "Cannot Equip"
	end

	-- Buscar la pet en ReplicatedStorage
	local petModel = ReplicatedStorage.Pets:FindFirstChild(petName, true)

	if not petModel then
		warn("No se encontró el modelo de la pet:", petName)
		return "Cannot Equip"
	end

	local clonedPet = petModel:Clone()
	clonedPet.Name = petName
	clonedPet.Parent = PetsFolder:FindFirstChild(player.Name)

	-- Calcular multiplicador
	if clonedPet:FindFirstChild("Multiplier1") then
		local petMultiplier = clonedPet.Multiplier1.Value

		-- Actualizar multiplicador total
		if player.Values.Multiplier1.Value == "1" then
			player.Values.Multiplier1.Value = tostring(1 + (petMultiplier - 1))
		else
			player.Values.Multiplier1.Value = tostring(tonumber(player.Values.Multiplier1.Value) + petMultiplier)
		end
	end

	return "Equip"
end

-- RemoteFunction: Desequipar pet
EggHatchingRemotes.UnequipPet.OnServerInvoke = function(player, petName)
	local pet = PetsFolder:FindFirstChild(player.Name):FindFirstChild(petName)

	if not pet then
		return false
	end

	-- Buscar el modelo original para obtener el multiplicador
	local petModel = ReplicatedStorage.Pets:FindFirstChild(petName, true)

	if petModel and petModel:FindFirstChild("Multiplier1") then
		local petMultiplier = petModel.Multiplier1.Value

		-- Actualizar multiplicador
		local currentMultiplier = tonumber(player.Values.Multiplier1.Value)
		if currentMultiplier then
			local newMultiplier = currentMultiplier - petMultiplier
			if newMultiplier <= 1 then
				player.Values.Multiplier1.Value = "1"
			else
				player.Values.Multiplier1.Value = tostring(newMultiplier)
			end
		end
	end

	pet:Destroy()
	return true
end

-- RemoteEvent: Desequipar todas
EggHatchingRemotes.UnequipAll.OnServerEvent:Connect(function(player)
	local playerPets = PetsFolder:FindFirstChild(player.Name)

	if playerPets then
		playerPets:ClearAllChildren()
		player.Values.Multiplier1.Value = "1"
	end
end)

-- RemoteEvent: Eliminar pet
EggHatchingRemotes.DeletePet.OnServerEvent:Connect(function(player, petName)
	local petInInventory = player.Pets:FindFirstChild(petName)

	if petInInventory then
		-- Si estaba equipada, desequiparla primero
		local petEquipped = PetsFolder:FindFirstChild(player.Name):FindFirstChild(petName)

		if petEquipped then
			-- Usar la función de unequip
			EggHatchingRemotes.UnequipPet:InvokeServer(player, petName)
		end

		-- Eliminar del inventario
		petInInventory:Destroy()
	end
end)

-- RemoteEvent: Test (para probar multiplicador)
EggHatchingRemotes.Test.OnServerEvent:Connect(function(player)
	local multiplier = tonumber(player.Values.Multiplier1.Value) or 1
	player.leaderstats.Money.Value = player.leaderstats.Money.Value + (1 * multiplier)
end)

-- Cuando un jugador entra
Players.PlayerAdded:Connect(function(player)
	setupPlayerPetsData(player)
end)

-- Cuando un jugador sale
Players.PlayerRemoving:Connect(function(player)
	local playerFolder = PetsFolder:FindFirstChild(player.Name)
	if playerFolder then
		playerFolder:Destroy()
	end
end)

-- Para jugadores que ya están en el servidor
for _, player in pairs(Players:GetPlayers()) do
	setupPlayerPetsData(player)
end

-- Manejar compra de gamepasses
MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, gamepassID, purchased)
	if not purchased then return end

	if gamepassID == TRIPLE_HATCH_GAMEPASS_ID then
		player.Values.CanTripleHatch.Value = true
	elseif gamepassID == AUTO_HATCH_GAMEPASS_ID then
		player.Values.CanAutoHatch.Value = true
	end
end)

-- 💎 NOTA: El ProcessReceipt ahora está en DevProductsHandler.server.lua
-- Ese handler maneja TODOS los productos: Money, Spins y Huevos con Robux

print("✅ PetsHandler loaded successfully!")
