local ReplicatedStorage = game:GetService("ReplicatedStorage")
local rollRarity = require(game.ReplicatedStorage.Shared.RarityRoll)
local Crops = require(game.ReplicatedStorage.Shared.CropsConfig)

local playSound = ReplicatedStorage.Remotes:WaitForChild("PlayCollectSound")

local part = script.Parent
local RESPAWN_TIME = 5
local debounce = false

-- generar rareza al spawnear
local rarity, data = rollRarity()
part.Color = data.Color
part:SetAttribute("Rarity", rarity)
part:SetAttribute("Value", data.Value)

part.Touched:Connect(function(hit)
	if debounce then
		return
	end

	local player = game.Players:GetPlayerFromCharacter(hit.Parent)
	if not player then
		return
	end

	local stats = player:FindFirstChild("Stats")
	if not stats then
		return
	end

	local inventory = stats.Inventory
	local capacity = stats.Capacity
	local inventoryValue = stats.InventoryValue

	if inventory.Value >= capacity.Value then
		return
	end

	debounce = true

	inventory.Value += 1
	inventoryValue.Value += part:GetAttribute("Value")

	-- 🔊 reproducir sonido SOLO para este jugador
	playSound:FireClient(player)

	-- ocultar
	part.Transparency = 1
	part.CanTouch = false

	task.delay(RESPAWN_TIME, function()
		rarity, data = rollRarity()
		part.Color = data.Color
		part:SetAttribute("Rarity", rarity)
		part:SetAttribute("Value", data.Value)

		part.Transparency = 0
		part.CanTouch = true
		debounce = false
	end)
end)
