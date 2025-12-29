-- SpinEvents.lua
-- Inicializa los RemoteEvents para el sistema de ruleta
-- Este script debe estar en ReplicatedStorage para que cliente y servidor puedan acceder

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Crear carpeta Events si no existe
local eventsFolder = ReplicatedStorage:FindFirstChild("Events")
if not eventsFolder then
	eventsFolder = Instance.new("Folder")
	eventsFolder.Name = "Events"
	eventsFolder.Parent = ReplicatedStorage
end

-- Crear RemoteEvent para solicitar spin
if not eventsFolder:FindFirstChild("SpinRequest") then
	local spinRequest = Instance.new("RemoteEvent")
	spinRequest.Name = "SpinRequest"
	spinRequest.Parent = eventsFolder
end

-- Crear RemoteEvent para enviar resultado
if not eventsFolder:FindFirstChild("SpinResult") then
	local spinResult = Instance.new("RemoteEvent")
	spinResult.Name = "SpinResult"
	spinResult.Parent = eventsFolder
end

print("[SpinEvents] RemoteEvents del sistema de ruleta creados")

return eventsFolder
