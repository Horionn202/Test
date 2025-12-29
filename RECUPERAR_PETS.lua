-- ============================================
-- SCRIPT DE RECUPERACIÓN DE PETS
-- ============================================
-- INSTRUCCIONES:
-- 1. Copia este script
-- 2. Pégalo en ServerScriptService como un Script normal
-- 3. Ejecuta el juego
-- 4. El script te dará pets automáticamente
-- 5. Borra el script después de usarlo
-- ============================================

local Players = game:GetService("Players")

-- ⚠️ CONFIGURA AQUÍ LAS PETS QUE TENÍAS
local PETS_A_RECUPERAR = {
	-- Ejemplo: descomenta y edita según las pets que tenías
	-- "Chicken",
	-- "Pig",
	-- "Cow",
	-- "Dog",
	-- Agrega todas las que recuerdes...
}

Players.PlayerAdded:Connect(function(player)
	-- Esperar a que se cree la carpeta Pets
	local petsFolder = player:WaitForChild("Pets", 10)

	if not petsFolder then
		warn("No se encontró la carpeta Pets para", player.Name)
		return
	end

	-- Esperar 2 segundos para asegurar que el DataStore terminó de cargar
	task.wait(2)

	-- Dar las pets configuradas
	for _, petName in ipairs(PETS_A_RECUPERAR) do
		local newPet = Instance.new("StringValue")
		newPet.Name = petName
		newPet.Value = petName
		newPet.Parent = petsFolder

		print("✅ Pet recuperada:", petName, "para", player.Name)
	end

	if #PETS_A_RECUPERAR > 0 then
		print("🎉 Recuperación completa! Se dieron", #PETS_A_RECUPERAR, "pets a", player.Name)
	else
		warn("⚠️ No hay pets configuradas en PETS_A_RECUPERAR")
	end
end)

print("🔧 Script de recuperación de pets cargado")
print("⚠️ Recuerda configurar PETS_A_RECUPERAR en la línea 13")
