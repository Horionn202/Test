-- TutorialHandler.server.lua
-- Maneja la completación del tutorial desde el cliente

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local tutorialCompleteEvent = ReplicatedStorage.Remotes:WaitForChild("TutorialComplete")

tutorialCompleteEvent.OnServerEvent:Connect(function(player)
	-- Verificar que el jugador no lo haya completado ya (anti-exploit)
	if player:GetAttribute("TutorialCompleted") then
		return
	end

	-- Establecer en el servidor para que se guarde en DataStore
	player:SetAttribute("TutorialCompleted", true)
	print("[TUTORIAL] Player", player.Name, "completed tutorial")
end)
