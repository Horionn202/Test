-- DailyRewardsConfig.lua
-- Configuración del sistema de recompensas diarias

local DailyRewardsConfig = {}

-- Recompensas por día
DailyRewardsConfig.Rewards = {
	[1] = {
		Money = 100,
		Name = "Day 1",
		Description = "Welcome back!",
	},
	[2] = {
		Money = 200,
		Name = "Day 2",
		Description = "Keep it up!",
	},
	[3] = {
		Money = 300,
		Name = "Day 3",
		Description = "You're on a roll!",
	},
	[4] = {
		Money = 500,
		Name = "Day 4",
		Description = "Great streak!",
	},
	[5] = {
		Money = 750,
		Name = "Day 5",
		Description = "Almost there!",
	},
	[6] = {
		Money = 1000,
		Name = "Day 6",
		Description = "One more day!",
	},
	[7] = {
		Money = 2000,
		Name = "Day 7",
		Description = "JACKPOT! 🎉",
		Special = true, -- Marca el día 7 como especial
	},
}

-- Configuración de tiempo
DailyRewardsConfig.ClaimCooldown = 86400 -- 24 horas en segundos (86400)
-- Para testing: DailyRewardsConfig.ClaimCooldown = 60 -- 1 minuto

-- Configuración de streak
DailyRewardsConfig.MaxStreak = 7 -- Después del día 7, vuelve a día 1
DailyRewardsConfig.StreakResetTime = 172800 -- 48 horas (2 días) sin reclamar = reset

-- Configuración visual (para que el cliente sepa qué mostrar)
DailyRewardsConfig.UIColors = {
	Available = Color3.fromRGB(85, 255, 127), -- Verde (puede reclamar)
	Claimed = Color3.fromRGB(100, 100, 100), -- Gris (ya reclamado hoy)
	Locked = Color3.fromRGB(50, 50, 50), -- Gris oscuro (días futuros)
	Special = Color3.fromRGB(255, 215, 0), -- Dorado (día 7)
}

return DailyRewardsConfig
