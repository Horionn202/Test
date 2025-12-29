-- ============================================
-- EQUIPAR MEJORES MASCOTAS - LocalScript
-- ============================================
-- INSTRUCCIONES:
-- 1. En Roblox Studio, ve a donde está tu botón de "Equipar Mejores"
-- 2. Crea un LocalScript como hijo del BOTÓN
-- 3. Copia y pega este código
-- 4. El script detectará automáticamente el botón padre
-- ============================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local button = script.Parent -- El botón donde está este script

-- Esperar servicios
local EggHatchingRemotes = ReplicatedStorage:WaitForChild("EggHatchingRemotes")
local petsFolder = player:WaitForChild("Pets")
local values = player:WaitForChild("Values")
local maxPetsEquipped = values:WaitForChild("MaxPetsEquipped")

-- Función para obtener el multiplicador de una pet
local function getPetMultiplier(petName)
	-- Buscar el modelo de la pet en ReplicatedStorage
	local petModel = ReplicatedStorage.Pets:FindFirstChild(petName, true)

	if petModel and petModel:FindFirstChild("Multiplier1") then
		return petModel.Multiplier1.Value
	end

	return 0 -- Si no tiene multiplicador, retornar 0
end

-- Función para equipar las mejores mascotas
local function equipBestPets()
	print("🔄 Equipando mejores mascotas...")

	-- 1. Desequipar todas las mascotas primero
	EggHatchingRemotes.UnequipAll:FireServer()
	task.wait(0.2) -- Pequeño delay para asegurar que se desequiparon

	-- 2. Crear tabla con todas las pets y sus multiplicadores
	local petsList = {}

	for _, pet in ipairs(petsFolder:GetChildren()) do
		if pet:IsA("StringValue") then
			local multiplier = getPetMultiplier(pet.Value)

			table.insert(petsList, {
				Name = pet.Name,
				PetName = pet.Value,
				Multiplier = multiplier
			})
		end
	end

	-- 3. Ordenar por multiplicador (de mayor a menor)
	table.sort(petsList, function(a, b)
		return a.Multiplier > b.Multiplier
	end)

	-- 4. Equipar las mejores hasta el límite
	local maxPets = maxPetsEquipped.Value
	local equipped = 0

	print("📊 Pets ordenadas por multiplicador:")
	for i, petData in ipairs(petsList) do
		print(i .. ".", petData.PetName, "- x" .. petData.Multiplier)
	end

	print("\n⚡ Equipando las", maxPets, "mejores...")

	for i, petData in ipairs(petsList) do
		if equipped >= maxPets then
			break -- Ya equipamos el máximo permitido
		end

		-- Equipar esta pet
		local result = EggHatchingRemotes.EquipPet:InvokeServer(petData.Name)

		if result == "Equip" then
			equipped = equipped + 1
			print("✅", equipped .. ".", petData.PetName, "(x" .. petData.Multiplier .. ")")
		else
			warn("❌ No se pudo equipar:", petData.PetName)
		end

		task.wait(0.1) -- Pequeño delay entre equipar cada pet
	end

	print("\n🎉 Listo! Se equiparon", equipped, "mascotas")

	-- Mostrar multiplicador total
	task.wait(0.2)
	local totalMultiplier = player.Values.Multiplier1.Value
	print("📊 Multiplicador total:", totalMultiplier)
end

-- Conectar el botón
button.MouseButton1Click:Connect(function()
	equipBestPets()
end)

print("✅ Script de Equipar Mejores cargado")
print("   Botón:", button:GetFullName())
