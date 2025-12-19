local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local BuyUpgrade = Remotes:WaitForChild("BuyUpgrade")

local Upgrades = require(ReplicatedStorage.Shared.UpgradesConfig)

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
	local capacity = stats:FindFirstChild("Capacity")
	local money = leaderstats:FindFirstChild("Money")

	local levels = Upgrades.Backpack.Levels
	local currentLevel = backpackLevel.Value
	local nextLevel = currentLevel + 1
	local nextData = levels[nextLevel]

	if not nextData then
		return -- max level
	end

	if money.Value < nextData.Price then
		return -- no dinero
	end

	-- comprar
	money.Value -= nextData.Price
	backpackLevel.Value = nextLevel
	capacity.Value = nextData.Capacity
end)
