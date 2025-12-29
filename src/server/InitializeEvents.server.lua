-- InitializeEvents.server.lua
-- Inicializa los RemoteEvents necesarios para el juego

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Inicializar eventos de ruleta
local success, err = pcall(function()
	require(ReplicatedStorage.SpinEvents)
end)

if success then
	print("[InitializeEvents] Eventos de ruleta inicializados correctamente")
else
	warn("[InitializeEvents] Error al inicializar eventos de ruleta: "..tostring(err))
end
