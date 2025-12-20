local Crops = {
	Common = {
		Value = 5,
		Chance = 60,
		Color = Color3.fromRGB(85, 170, 0),
		Template = "Crop_Common",
	},

	Uncommon = {
		Value = 10,
		Chance = 25,
		Color = Color3.fromRGB(0, 170, 255),
		Template = "Crop_Uncommon",
	},

	Rare = {
		Value = 25,
		Chance = 10,
		Color = Color3.fromRGB(170, 85, 255),
		Template = "Crop_Rare",
	},

	Epic = {
		Value = 50,
		Chance = 4,
		Color = Color3.fromRGB(255, 170, 0),
		Template = "Crop_Epic",
	},

	Legendary = {
		Value = 120,
		Chance = 0.8,
		Color = Color3.fromRGB(255, 80, 80),
		Template = "Crop_Legendary",
	},

	Mythic = {
		Value = 300,
		Chance = 0.2,
		Color = Color3.fromRGB(255, 0, 255),
		Template = "Crop_Mythic",
	},
}

return Crops
