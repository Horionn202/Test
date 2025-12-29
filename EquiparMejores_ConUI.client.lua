-- ============================================
-- EQUIPAR MEJORES MASCOTAS - VERSIÓN CON UI
-- ============================================
-- Esta versión muestra feedback visual al usuario
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

-- Variable para prevenir spam de clicks
local isEquipping = false

-- Función para obtener el multiplicador de una pet
local function getPetMultiplier(petName)
	local petModel = ReplicatedStorage.Pets:FindFirstChild(petName, true)

	if petModel and petModel:FindFirstChild("Multiplier1") then
		return petModel.Multiplier1.Value
	end

	return 0
end

-- Función para equipar las mejores mascotas
local function equipBestPets()
	if isEquipping then
		warn("⏳ Ya se están equipando las mascotas, espera...")
		return
	end

	isEquipping = true

	-- Cambiar texto del botón temporalmente (si tiene texto)
	local originalText
	if button:IsA("TextButton") then
		originalText = button.Text
		button.Text = "Equipando..."
	end

	print("🔄 Equipando mejores mascotas...")

	-- 1. Desequipar todas
	EggHatchingRemotes.UnequipAll:FireServer()
	task.wait(0.3)

	-- 2. Crear lista de pets con multiplicadores
	local petsList = {}

	for _, pet in ipairs(petsFolder:GetChildren()) do
		if pet:IsA("StringValue") then
			local petName = pet.Value
			local multiplier = getPetMultiplier(petName)

			-- Agregar cada pet individual (soporte para duplicados)
			table.insert(petsList, {
				FolderName = pet.Name, -- Nombre único del StringValue
				PetName = petName,     -- Nombre del modelo de la pet
				Multiplier = multiplier
			})
		end
	end

	-- 3. Verificar que hay pets
	if #petsList == 0 then
		warn("❌ No tienes mascotas para equipar")
		isEquipping = false
		if originalText then
			button.Text = originalText
		end
		return
	end

	-- 4. Ordenar por multiplicador (mayor a menor)
	table.sort(petsList, function(a, b)
		-- Si tienen el mismo multiplicador, ordenar alfabéticamente
		if a.Multiplier == b.Multiplier then
			return a.PetName < b.PetName
		end
		return a.Multiplier > b.Multiplier
	end)

	-- 5. Equipar las mejores
	local maxPets = maxPetsEquipped.Value
	local equipped = 0

	print("📊 Top", maxPets, "mejores mascotas:")

	for i, petData in ipairs(petsList) do
		if equipped >= maxPets then
			break
		end

		print(i .. ".", petData.PetName, "- x" .. petData.Multiplier)

		-- Equipar usando el nombre único del folder
		local result = EggHatchingRemotes.EquipPet:InvokeServer(petData.FolderName)

		if result == "Equip" then
			equipped = equipped + 1
		else
			warn("❌ No se pudo equipar:", petData.PetName)
		end

		task.wait(0.1)
	end

	-- 6. Mostrar resultado
	task.wait(0.2)
	local totalMultiplier = tonumber(player.Values.Multiplier1.Value) or 1

	print("✅ Equipadas", equipped, "/", maxPets, "mascotas")
	print("📊 Multiplicador total: x" .. totalMultiplier)

	-- Restaurar botón
	if originalText then
		button.Text = originalText
	end

	isEquipping = false
end

-- Conectar el botón
button.MouseButton1Click:Connect(function()
	equipBestPets()
end)

print("✅ Script de Equipar Mejores cargado (Versión con UI)")
print("   Botón:", button:GetFullName())
