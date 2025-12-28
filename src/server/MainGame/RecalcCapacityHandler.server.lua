local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local VIP = require(ReplicatedStorage.Shared.VIPConfig)

local function recalcCapacity(player)
	local stats = player:WaitForChild("Stats")

	local baseCapacity = stats:WaitForChild("BaseCapacity")
	local capacity = stats:WaitForChild("Capacity")
	local rebirths = stats:WaitForChild("Rebirths")

	local finalCapacity = baseCapacity.Value

	-- 🔥 bonus por rebirth
	finalCapacity += rebirths.Value * 5

	-- ⭐ VIP
	if player:GetAttribute("VIP") then
		finalCapacity += VIP.Bonuses.ExtraCapacity
	end

	capacity.Value = finalCapacity
end

Players.PlayerAdded:Connect(function(player)
	-- esperar a que el DataStore cargue
	task.wait(1)

	recalcCapacity(player)

	local stats = player:WaitForChild("Stats")

	stats.BaseCapacity.Changed:Connect(function()
		recalcCapacity(player)
	end)

	stats.Rebirths.Changed:Connect(function()
		recalcCapacity(player)
	end)
end)
