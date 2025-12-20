local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BuyUpgrade = ReplicatedStorage.Remotes:WaitForChild("BuyUpgrade")
local Upgrades = require(ReplicatedStorage.Shared.UpgradesConfig)
local VIP = require(ReplicatedStorage.Shared.VIPConfig)

print("Upgrade handler cargado")

local function recalcCapacity(player)
	local stats = player:FindFirstChild("Stats")
	if not stats then
		return
	end

	local baseCapacity = stats:FindFirstChild("BaseCapacity")
	local capacity = stats:FindFirstChild("Capacity")
	if not baseCapacity or not capacity then
		return
	end

	local finalCapacity = baseCapacity.Value

	if player:GetAttribute("VIP") then
		finalCapacity += VIP.Bonuses.ExtraCapacity
	end

	capacity.Value = finalCapacity
end

BuyUpgrade.OnServerEvent:Connect(function(player, upgradeName)
	if upgradeName ~= "Backpack" then
		return
	end

	local stats = player:FindFirstChild("Stats")
	local leaderstats = player:FindFirstChild("leaderstats")
	if not stats or not leaderstats then
		return
	end

	local backpackLevel = stats:FindFirstChild("BackpackLevel")
	local baseCapacity = stats:FindFirstChild("BaseCapacity")
	local money = leaderstats:FindFirstChild("Money")
	if not backpackLevel or not baseCapacity or not money then
		return
	end

	local currentLevel = backpackLevel.Value
	local nextLevel = currentLevel + 1
	local nextData = Upgrades.Backpack.Levels[nextLevel]
	if not nextData then
		return
	end

	if money.Value < nextData.Price then
		return
	end

	-- comprar
	money.Value -= nextData.Price
	backpackLevel.Value = nextLevel
	baseCapacity.Value = nextData.Capacity

	-- 🔁 recalcular capacidad FINAL (con VIP)
	recalcCapacity(player)
end)
