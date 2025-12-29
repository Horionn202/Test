-- SpinHandler.server.lua
-- Maneja la lógica del servidor para el sistema de ruleta

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

-- Módulos
local SpinConfig = require(ReplicatedStorage.Shared.SpinConfig)

-- RemoteEvents (se crearán en ReplicatedStorage/Events)
local SpinRequestEvent
local SpinResultEvent

-- Esperar a que existan los eventos
task.spawn(function()
	local eventsFolder = ReplicatedStorage:WaitForChild("Events", 30)
	if eventsFolder then
		SpinRequestEvent = eventsFolder:WaitForChild("SpinRequest", 10)
		SpinResultEvent = eventsFolder:WaitForChild("SpinResult", 10)
	else
		warn("[SpinHandler] No se encontró la carpeta Events en ReplicatedStorage")
	end
end)

-- ========================================
-- CREAR CARPETA DE SPINS AL JUGADOR
-- ========================================
local function createSpinStats(player)
	local spinFolder = Instance.new("Folder")
	spinFolder.Name = "SpinStats"
	spinFolder.Parent = player

	local availableSpins = Instance.new("IntValue")
	availableSpins.Name = "AvailableSpins"
	availableSpins.Value = 1 -- Empieza con 1 spin gratis
	availableSpins.Parent = spinFolder

	local lastSpinTime = Instance.new("IntValue")
	lastSpinTime.Name = "LastSpinTime"
	lastSpinTime.Value = 0
	lastSpinTime.Parent = spinFolder

	-- Loop para dar spins gratis cada cierto tiempo
	task.spawn(function()
		while player.Parent and spinFolder.Parent do
			task.wait(1) -- Verificar cada segundo

			local currentTime = os.time()
			local timeSinceLastSpin = currentTime - lastSpinTime.Value

			-- Si pasó el cooldown, dar un spin gratis
			if timeSinceLastSpin >= SpinConfig.SpinCooldown then
				lastSpinTime.Value = currentTime
				availableSpins.Value = availableSpins.Value + 1

				-- Notificar al jugador (opcional)
				print("[SpinHandler] "..player.Name.." recibió un spin gratis!")
			end
		end
	end)
end

-- ========================================
-- DAR RECOMPENSA AL JUGADOR
-- ========================================
local function giveReward(player, rewardKey)
	local rewardData = SpinConfig.Rewards[rewardKey]
	if not rewardData then
		warn("[SpinHandler] Recompensa no encontrada: "..tostring(rewardKey))
		return false
	end

	local rewardType = rewardData.Type

	if rewardType == "Money" then
		-- Dar dinero
		local leaderstats = player:FindFirstChild("leaderstats")
		if leaderstats then
			local money = leaderstats:FindFirstChild("Money")
			if money then
				money.Value = money.Value + rewardData.Amount
				return true
			end
		end

	elseif rewardType == "Spins" then
		-- Dar spins adicionales
		local spinFolder = player:FindFirstChild("SpinStats")
		if spinFolder then
			local availableSpins = spinFolder:FindFirstChild("AvailableSpins")
			if availableSpins then
				availableSpins.Value = availableSpins.Value + rewardData.Amount
				return true
			end
		end

	elseif rewardType == "Pet" then
		-- Dar mascota
		local petsFolder = player:FindFirstChild("Pets")
		if petsFolder then
			local petName = rewardData.PetName
			local eggFolder = rewardData.EggFolder

			if petName then
				-- Verificar que la pet existe en ReplicatedStorage
				local petExists = false

				if eggFolder then
					-- Buscar en la carpeta específica del huevo
					local eggPath = ReplicatedStorage:FindFirstChild("Pets")
					if eggPath then
						local eggFolderObj = eggPath:FindFirstChild(eggFolder)
						if eggFolderObj then
							local petModel = eggFolderObj:FindFirstChild(petName)
							if petModel then
								petExists = true
							end
						end
					end
				else
					-- Buscar recursivamente si no se especificó huevo
					local petModel = ReplicatedStorage:FindFirstChild("Pets")
					if petModel then
						petModel = petModel:FindFirstChild(petName, true)
						if petModel then
							petExists = true
						end
					end
				end

				-- Si la pet no existe en ReplicatedStorage, dar compensación
				if not petExists then
					warn("[SpinHandler] La pet '"..petName.."' no existe en ReplicatedStorage.Pets. Dando compensación.")
					local leaderstats = player:FindFirstChild("leaderstats")
					if leaderstats then
						local money = leaderstats:FindFirstChild("Money")
						if money then
							money.Value = money.Value + 10000 -- Compensación por pet inexistente
							print("[SpinHandler] "..player.Name.." recibió $10,000 de compensación (pet no existe)")
							return true
						end
					end
					return false
				end

				-- Verificar que el jugador no tiene ya la mascota
				local existingPet = petsFolder:FindFirstChild(petName)
				if not existingPet then
					local newPet = Instance.new("StringValue")
					newPet.Name = petName
					newPet.Value = petName
					newPet.Parent = petsFolder
					print("[SpinHandler] "..player.Name.." ganó una mascota: "..petName)
					return true
				else
					-- Si ya tiene la mascota, dar dinero como compensación
					print("[SpinHandler] "..player.Name.." ya tiene "..petName..", dando dinero de compensación")
					local leaderstats = player:FindFirstChild("leaderstats")
					if leaderstats then
						local money = leaderstats:FindFirstChild("Money")
						if money then
							money.Value = money.Value + 5000 -- Compensación por pet duplicada
							return true
						end
					end
				end
			end
		end
	end

	return false
end

-- ========================================
-- PROCESAR SOLICITUD DE SPIN
-- ========================================
local function onSpinRequest(player)
	if not SpinRequestEvent or not SpinResultEvent then
		warn("[SpinHandler] Eventos no están listos aún")
		return
	end

	-- Verificar que el jugador tenga spins disponibles
	local spinFolder = player:FindFirstChild("SpinStats")
	if not spinFolder then
		warn("[SpinHandler] "..player.Name.." no tiene SpinStats")
		return
	end

	local availableSpins = spinFolder:FindFirstChild("AvailableSpins")
	if not availableSpins or availableSpins.Value < 1 then
		-- No tiene spins disponibles
		SpinResultEvent:FireClient(player, {
			success = false,
			error = "No tienes spins disponibles"
		})
		return
	end

	-- Consumir un spin
	availableSpins.Value = availableSpins.Value - 1

	-- Elegir recompensa aleatoria
	local rewardKey = SpinConfig.getRandomReward()
	local rewardData = SpinConfig.Rewards[rewardKey]

	-- Dar la recompensa
	local success = giveReward(player, rewardKey)

	if success then
		-- Enviar resultado al cliente
		SpinResultEvent:FireClient(player, {
			success = true,
			rewardKey = rewardKey,
			rewardData = rewardData
		})

		print("[SpinHandler] "..player.Name.." giró la ruleta y ganó: "..rewardData.Name)
	else
		-- Error al dar recompensa, devolver el spin
		availableSpins.Value = availableSpins.Value + 1
		SpinResultEvent:FireClient(player, {
			success = false,
			error = "Error al dar la recompensa"
		})
	end
end

-- ========================================
-- CONEXIONES
-- ========================================
Players.PlayerAdded:Connect(function(player)
	createSpinStats(player)
end)

-- Esperar a que los eventos estén listos
task.spawn(function()
	while not SpinRequestEvent do
		task.wait(0.1)
	end
	SpinRequestEvent.OnServerEvent:Connect(onSpinRequest)
end)

print("[SpinHandler] Sistema de ruleta cargado exitosamente")
