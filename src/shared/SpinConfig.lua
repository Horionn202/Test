-- SpinConfig.lua
-- Configuración del sistema de ruleta (Spin Wheel)

local SpinConfig = {}

-- ========================================
-- CONFIGURACIÓN DE TIEMPO
-- ========================================
SpinConfig.SpinCooldown = 60 * 30 -- 30 minutos en segundos (1800 segundos)
-- Para testing: SpinConfig.SpinCooldown = 60 -- 1 minuto

-- Cuántas vueltas gira la ruleta antes de parar
SpinConfig.SpinRotations = 5

-- Duración de la animación de giro (en segundos)
SpinConfig.SpinDuration = 5

-- ========================================
-- RECOMPENSAS
-- ========================================
-- Tipos de recompensas:
-- - "Money": Dinero del juego
-- - "Pet": Mascota (nombre específico)
-- - "Spins": Tiradas adicionales para la ruleta

SpinConfig.Rewards = {
	-- MONEY - Común
	["Reward1"] = {
		Type = "Money",
		Amount = 100,
		TextColor = Color3.fromRGB(115, 255, 131), -- Verde claro
		Rarity = 30,
		Name = "$100",
	},
	["Reward2"] = {
		Type = "Money",
		Amount = 250,
		TextColor = Color3.fromRGB(115, 255, 131),
		Rarity = 25,
		Name = "$250",
	},

	-- SPINS - Medio
	["Reward3"] = {
		Type = "Spins",
		Amount = 1,
		TextColor = Color3.fromRGB(85, 255, 255), -- Cyan
		Rarity = 15,
		Name = "+1 Spin",
	},

	-- MONEY - Medio-Alto
	["Reward4"] = {
		Type = "Money",
		Amount = 500,
		TextColor = Color3.fromRGB(85, 170, 255), -- Azul
		Rarity = 12,
		Name = "$500",
	},
	["Reward5"] = {
		Type = "Money",
		Amount = 1000,
		TextColor = Color3.fromRGB(85, 170, 255),
		Rarity = 8,
		Name = "$1,000",
	},

	-- SPINS - Raro
	["Reward6"] = {
		Type = "Spins",
		Amount = 3,
		TextColor = Color3.fromRGB(255, 170, 0), -- Naranja
		Rarity = 5,
		Name = "+3 Spins",
	},

	-- MONEY - Raro
	["Reward7"] = {
		Type = "Money",
		Amount = 2500,
		TextColor = Color3.fromRGB(199, 108, 255), -- Morado
		Rarity = 3,
		Name = "$2,500",
	},

	-- PET - Muy Raro (JACKPOT)
	["Reward8"] = {
		Type = "Pet",
		PetName = "Aqua Dragon", -- Nombre de la pet
		EggFolder = "Premiun Egg", -- ⚠️ IMPORTANTE: Nombre del huevo donde está (debe coincidir EXACTAMENTE)
		TextColor = Color3.fromRGB(255, 215, 0), -- Dorado
		Rarity = 1,
		Name = "Aqua Dragon",
		IsJackpot = true, -- Marca esto como jackpot
	},

	-- MONEY - SUPER JACKPOT (alternativa)
	["Reward9"] = {
		Type = "Money",
		Amount = 10000,
		TextColor = Color3.fromRGB(255, 85, 85), -- Rojo brillante
		Rarity = 1,
		Name = "$10,000 MEGA JACKPOT!",
		IsJackpot = true,
	},
}

-- ========================================
-- CONFIGURACIÓN DE PETS
-- ========================================
-- Lista de pets que pueden salir en la ruleta
-- Puedes agregar más pets aquí
SpinConfig.AvailablePets = {
	"Golden Dragon", -- Ultra raro
	"Rainbow Unicorn", -- Muy raro
	"Diamond Cat", -- Muy raro
	-- Agrega más pets según tu juego
}

-- ========================================
-- FUNCIÓN: Obtener recompensa aleatoria
-- ========================================
-- Usa el sistema de rareza ponderada
function SpinConfig.getRandomReward()
	-- Calcular el total de probabilidades
	local totalChance = 0
	for _, rewardData in pairs(SpinConfig.Rewards) do
		totalChance = totalChance + rewardData.Rarity
	end

	-- Elegir un valor aleatorio
	local randomValue = math.random() * totalChance
	local accumulatedChance = 0

	-- Iterar por todas las recompensas
	for rewardName, rewardData in pairs(SpinConfig.Rewards) do
		accumulatedChance = accumulatedChance + rewardData.Rarity
		if randomValue <= accumulatedChance then
			return rewardName
		end
	end

	-- Fallback (no debería llegar aquí)
	return "Reward1"
end

-- ========================================
-- FUNCIÓN: Formatear números grandes
-- ========================================
function SpinConfig.formatNumber(val)
	local suffixes = { "", "k", "m", "b", "t", "qa", "qi", "sx", "sp", "oc" }
	for i = 1, #suffixes do
		if tonumber(val) < 10 ^ (i * 3) then
			return math.floor(val / ((10 ^ ((i - 1) * 3)) / 100)) / 100 .. suffixes[i]
		end
	end
	return tostring(val)
end

return SpinConfig
