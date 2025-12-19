local Crops = require(script.Parent.CropsConfig)

local function rollRarity()
	local totalChance = 0
	for _, data in pairs(Crops) do
		totalChance += data.Chance
	end

	local roll = math.random(1, totalChance)
	local current = 0

	for rarity, data in pairs(Crops) do
		current += data.Chance
		if roll <= current then
			return rarity, data
		end
	end
end

return rollRarity
