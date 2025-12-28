local VIP = require(script.Parent.VIPConfig)

local CapacityUtils = {}

function CapacityUtils.Calculate(player)
	local stats = player:WaitForChild("Stats")

	local baseCapacity = stats:WaitForChild("BaseCapacity").Value
	local rebirths = stats:WaitForChild("Rebirths").Value

	local finalCapacity = baseCapacity
	finalCapacity += rebirths * 5

	if player:GetAttribute("VIP") then
		finalCapacity += VIP.Bonuses.ExtraCapacity
	end

	return finalCapacity
end

return CapacityUtils
