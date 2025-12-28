-- TutorialConfig.lua
-- Configuración del sistema de tutorial

local TutorialConfig = {}

-- Pasos del tutorial
TutorialConfig.Steps = {
	{
		Name = "GoToFarm",
		Message = "Welcome! Go to the farm zone to start collecting crops",
		TargetZone = "FarmZone", -- Nombre de la Part en Workspace
		ArrowOffset = Vector3.new(0, 15, 0), -- Altura de la flecha sobre la zona
	},
	{
		Name = "CollectCrops",
		Message = "Walk over the crops to collect them! Fill your inventory",
		RequireInventory = 1, -- Necesita al menos 1 crop en inventario
	},
	{
		Name = "GoToSell",
		Message = "Great! Now go to the sell zone to sell your crops",
		TargetZone = "SellZone",
		ArrowOffset = Vector3.new(0, 15, 0),
	},
	{
		Name = "SellCrops",
		Message = "Walk over the sell zone to sell your crops for money!",
		RequireSell = true, -- Necesita vender (inventario = 0, dinero > 0)
	},
}

-- Mensaje de finalización
TutorialConfig.CompletionMessage = "Tutorial completed! You now know how to play. Have fun!"

-- Configuración visual
TutorialConfig.ArrowColor = Color3.fromRGB(255, 255, 0) -- Amarillo brillante
TutorialConfig.ArrowSize = Vector3.new(3, 6, 3)
TutorialConfig.ArrowTransparency = 0.3
TutorialConfig.ArrowRotationSpeed = 2 -- Rotación por segundo

-- UI Settings
TutorialConfig.MessageDisplayTime = 5 -- Segundos que se muestra cada mensaje
TutorialConfig.MessageTextSize = 24
TutorialConfig.MessageBackgroundColor = Color3.fromRGB(0, 0, 0)
TutorialConfig.MessageBackgroundTransparency = 0.5

return TutorialConfig
