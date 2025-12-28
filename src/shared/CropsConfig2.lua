local Crops = {
	Common = {
		Value = 20,
		Chance = 55,
		Color = Color3.fromRGB(120, 200, 80),
		Template = "Crop2_Common",
	},

	Uncommon = {
		Value = 40,
		Chance = 25,
		Color = Color3.fromRGB(80, 180, 255),
		Template = "Crop2_Uncommon",
	},

	Rare = {
		Value = 100,
		Chance = 12,
		Color = Color3.fromRGB(190, 120, 255),
		Template = "Crop2_Rare",
	},

	Epic = {
		Value = 250,
		Chance = 5,
		Color = Color3.fromRGB(255, 190, 80),
		Template = "Crop2_Epic",
	},

	Legendary = {
		Value = 600,
		Chance = 2,
		Color = Color3.fromRGB(255, 90, 90),
		Template = "Crop2_Legendary",
	},

	Mythic = {
		Value = 1500,
		Chance = 1,
		Color = Color3.fromRGB(255, 0, 255),
		Template = "Crop2_Mythic",
	},
}

return Crops
