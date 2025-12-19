local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local zone = script.Parent

local MAX_CROPS = 20
local RESPAWN_TIME = 5

local rollRarity = require(game.ReplicatedStorage.Shared.RarityRoll)
local CropsFolder = ServerStorage:WaitForChild("Crops")

-- 🔊 RemoteEvent
local playSound = ReplicatedStorage.Remotes:WaitForChild("PlayCollectSound")

local activeCrops = {}

-- posición random dentro de la zona
local function getRandomPosition()
	local size = zone.Size
	local center = zone.Position

	local x = (math.random() - 0.5) * size.X
	local z = (math.random() - 0.5) * size.Z

	return Vector3.new(center.X + x, center.Y + 1, center.Z + z)
end

local function spawnCrop()
	if #activeCrops >= MAX_CROPS then
		return
	end

	local rarity, data = rollRarity()

	local template = CropsFolder:FindFirstChild(data.Template)
	if not template then
		warn("Template missing:", data.Template)
		return
	end

	local crop = template:Clone()
	local position = getRandomPosition()

	if crop:IsA("Model") then
		if not crop.PrimaryPart then
			warn("Model has no PrimaryPart:", crop.Name)
			return
		end
		crop:SetPrimaryPartCFrame(CFrame.new(position))
	else
		crop.Position = position
	end

	crop:SetAttribute("Rarity", rarity)
	crop:SetAttribute("Value", data.Value)

	if crop:IsA("BasePart") then
		crop.Color = data.Color
	end

	crop.Parent = workspace
	table.insert(activeCrops, crop)

	-- RECOLECCIÓN
	local debounce = false
	crop.Touched:Connect(function(hit)
		if debounce then
			return
		end

		local player = Players:GetPlayerFromCharacter(hit.Parent)
		if not player then
			return
		end

		local stats = player:FindFirstChild("Stats")
		if not stats then
			return
		end

		local inventory = stats:FindFirstChild("Inventory")
		local capacity = stats:FindFirstChild("Capacity")
		local inventoryValue = stats:FindFirstChild("InventoryValue")

		if inventory.Value >= capacity.Value then
			return
		end

		debounce = true

		inventory.Value += 1
		inventoryValue.Value += crop:GetAttribute("Value")

		-- 🔊 AVISAR AL CLIENTE
		playSound:FireClient(player)

		-- eliminar crop
		table.remove(activeCrops, table.find(activeCrops, crop))
		crop:Destroy()

		-- respawn
		task.delay(RESPAWN_TIME, function()
			spawnCrop()
		end)
	end)
end

-- spawn inicial
for i = 1, MAX_CROPS do
	spawnCrop()
end
