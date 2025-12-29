-- SpinWheel.client.lua
-- Maneja la UI y animaciones de la ruleta

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Módulos
local SpinConfig = require(ReplicatedStorage.Shared.SpinConfig)

-- RemoteEvents
local eventsFolder = ReplicatedStorage:WaitForChild("Events")
local SpinRequestEvent = eventsFolder:WaitForChild("SpinRequest")
local SpinResultEvent = eventsFolder:WaitForChild("SpinResult")

-- UI Elements (usando nombres del proyecto original Ruelta)
local spinUI = playerGui:WaitForChild("SpinUI", 30)
if not spinUI then
	warn("[SpinWheel] No se encontró SpinUI en PlayerGui")
	return
end

-- Intentar encontrar el botón de abrir (puede ser OpenButton o SpinOpen)
local openButton = spinUI:FindFirstChild("OpenButton") or spinUI:FindFirstChild("SpinOpen")
if not openButton then
	warn("[SpinWheel] No se encontró botón de abrir (OpenButton o SpinOpen)")
	return
end

local mainFrame = spinUI:WaitForChild("Spin")
local spinButton = mainFrame:WaitForChild("SpinButton")
local wheel = mainFrame:WaitForChild("Spin") -- Frame interno que gira
local rewardLabel = mainFrame:WaitForChild("RewardName")
local timerLabel = mainFrame:WaitForChild("SpinTimer")

-- Variables
local isSpinning = false

-- Stats del jugador
local spinStats = player:WaitForChild("SpinStats")
local availableSpins = spinStats:WaitForChild("AvailableSpins")
local lastSpinTime = spinStats:WaitForChild("LastSpinTime")

-- ========================================
-- SONIDO DE SPIN
-- ========================================
local spinSound = Instance.new("Sound")
spinSound.SoundId = "rbxassetid://5406934065"
spinSound.Volume = 0.5
spinSound.Parent = spinButton

-- Esperar a que el audio cargue para obtener su duración
local audioDuration = 0
spinSound.Loaded:Connect(function()
	audioDuration = spinSound.TimeLength
	print("[SpinWheel] Duración del audio: "..audioDuration.." segundos")
end)

-- Cargar el audio inmediatamente
spinSound:Play()
spinSound:Stop()

print("[SpinWheel] Sonido de spin configurado: 5406934065")

-- ========================================
-- CALCULAR ÁNGULO PARA CADA RECOMPENSA
-- ========================================
-- Esto distribuye las recompensas uniformemente en la ruleta
local rewardAngles = {}
local rewardKeys = {}
for key, _ in pairs(SpinConfig.Rewards) do
	table.insert(rewardKeys, key)
end

local angleStep = 360 / #rewardKeys
for i, key in ipairs(rewardKeys) do
	rewardAngles[key] = (i - 1) * angleStep
end

-- ========================================
-- FORMATEAR TIEMPO
-- ========================================
local function formatTime(seconds)
	local minutes = math.floor(seconds / 60)
	local secs = seconds % 60
	return string.format("%02d:%02d", minutes, secs)
end

-- ========================================
-- ACTUALIZAR UI
-- ========================================
local function updateUI()
	-- Actualizar timer con formato del original
	local currentTime = os.time()
	local timeSinceLastSpin = currentTime - lastSpinTime.Value
	local timeUntilNextSpin = SpinConfig.SpinCooldown - timeSinceLastSpin

	if timeUntilNextSpin > 0 then
		timerLabel.Text = "Spin : "..availableSpins.Value.." ("..formatTime(timeUntilNextSpin)..")"
	else
		timerLabel.Text = "Spin : "..availableSpins.Value.." (Available!)"
		timerLabel.TextColor3 = Color3.fromRGB(85, 255, 127) -- Verde
	end
end

-- ========================================
-- ABRIR/CERRAR UI
-- ========================================
local function openSpinUI()
	if mainFrame.Visible then
		-- Cerrar
		local closeTween = TweenService:Create(
			mainFrame,
			TweenInfo.new(0.2),
			{Size = UDim2.fromScale(0, 0)}
		)
		closeTween:Play()
		closeTween.Completed:Connect(function()
			mainFrame.Visible = false
		end)

		-- Remover blur
		local blur = Lighting:FindFirstChild("Blur")
		if blur then
			blur:Destroy()
		end
	else
		-- Abrir
		mainFrame.Size = UDim2.fromScale(0, 0)
		mainFrame.Visible = true

		local openTween = TweenService:Create(
			mainFrame,
			TweenInfo.new(0.2),
			{Size = UDim2.fromScale(1, 1)}
		)
		openTween:Play()

		-- Agregar blur
		if not Lighting:FindFirstChild("Blur") then
			local blur = Instance.new("BlurEffect")
			blur.Name = "Blur"
			blur.Size = 24
			blur.Parent = Lighting
		end

		-- Actualizar UI al abrir
		updateUI()
	end
end

-- Conectar botón de abrir
openButton.MouseButton1Click:Connect(function()
	-- Animar el botón si tiene Rotated dentro
	local rotated = openButton:FindFirstChild("Rotated")
	if rotated then
		local originalSize = rotated.Size
		local buttonTween1 = TweenService:Create(
			rotated,
			TweenInfo.new(0.1),
			{Size = UDim2.fromScale(1.5, 1.5)}
		)
		local buttonTween2 = TweenService:Create(
			rotated,
			TweenInfo.new(0.1),
			{Size = originalSize}
		)
		buttonTween1:Play()
		buttonTween1.Completed:Connect(function()
			buttonTween2:Play()
		end)
		task.wait(0.2)
	end

	openSpinUI()
end)

-- ========================================
-- ANIMACIÓN DE GIRO
-- ========================================
local function spinWheel(targetRewardKey)
	if isSpinning then return end
	isSpinning = true

	-- Ocultar reward label
	rewardLabel.Visible = false
	rewardLabel.Size = UDim2.fromScale(0, 0)

	-- Calcular ángulo final
	local targetAngle = rewardAngles[targetRewardKey] or 0
	local finalRotation = (360 * SpinConfig.SpinRotations) + targetAngle

	-- Usar la duración del audio o un valor por defecto
	local spinDuration = audioDuration > 0 and audioDuration or SpinConfig.SpinDuration

	print("[SpinWheel] Girando por "..spinDuration.." segundos (duración del audio)")

	-- Animar el giro (sincronizado con el audio)
	local spinTween = TweenService:Create(
		wheel,
		TweenInfo.new(
			spinDuration,
			Enum.EasingStyle.Quad,
			Enum.EasingDirection.Out
		),
		{Rotation = finalRotation}
	)

	-- Animar el botón (efecto de click)
	local buttonTween1 = TweenService:Create(
		spinButton,
		TweenInfo.new(0.1),
		{Size = UDim2.fromScale(0.25, 0.15)}
	)
	local buttonTween2 = TweenService:Create(
		spinButton,
		TweenInfo.new(0.1),
		{Size = UDim2.fromScale(0.2, 0.12)}
	)

	buttonTween1:Play()
	buttonTween1.Completed:Connect(function()
		buttonTween2:Play()
	end)

	-- Iniciar el giro
	spinTween:Play()

	spinTween.Completed:Connect(function()
		-- Resetear rotación para la próxima vez
		wheel.Rotation = 0

		isSpinning = false
	end)
end

-- ========================================
-- MOSTRAR RECOMPENSA
-- ========================================
local function showReward(rewardData)
	-- Formato: "You won +Amount Type" o "You won PetName"
	local rewardText
	if rewardData.Type == "Pet" then
		rewardText = "You won "..rewardData.Name.."!"
	else
		rewardText = "You won +"..SpinConfig.formatNumber(rewardData.Amount).." "..rewardData.Type
	end

	rewardLabel.Text = rewardText
	rewardLabel.TextColor3 = rewardData.TextColor
	rewardLabel.Visible = true

	-- Animar aparición
	rewardLabel.Size = UDim2.fromScale(0, 0)
	local appearTween = TweenService:Create(
		rewardLabel,
		TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{Size = UDim2.fromScale(0.258, 0.069)}
	)
	appearTween:Play()

	-- Ocultar después de 3 segundos
	task.wait(3)
	local disappearTween = TweenService:Create(
		rewardLabel,
		TweenInfo.new(0.2),
		{Size = UDim2.fromScale(0, 0)}
	)
	disappearTween:Play()
	disappearTween.Completed:Connect(function()
		rewardLabel.Visible = false
	end)
end

-- ========================================
-- BOTÓN DE SPIN
-- ========================================
spinButton.MouseButton1Click:Connect(function()
	if isSpinning then return end

	if availableSpins.Value < 1 then
		-- No tiene spins
		warn("[SpinWheel] No tienes spins disponibles")
		-- Aquí podrías mostrar un mensaje de error
		return
	end

	-- Reproducir sonido de spin
	spinSound:Play()

	-- Solicitar spin al servidor
	SpinRequestEvent:FireServer()
end)

-- ========================================
-- RECIBIR RESULTADO DEL SERVIDOR
-- ========================================
SpinResultEvent.OnClientEvent:Connect(function(result)
	if result.success then
		-- Girar la ruleta con el resultado
		spinWheel(result.rewardKey)

		-- Esperar a que termine la animación (usar duración del audio)
		local waitTime = (audioDuration > 0 and audioDuration or SpinConfig.SpinDuration) + 0.5
		task.wait(waitTime)

		-- Mostrar recompensa
		showReward(result.rewardData)

		-- Actualizar UI
		updateUI()
	else
		-- Mostrar error
		warn("[SpinWheel] Error: "..tostring(result.error))
	end
end)

-- ========================================
-- ACTUALIZAR TIMER CADA SEGUNDO
-- ========================================
task.spawn(function()
	while true do
		task.wait(1)
		updateUI()
	end
end)

-- ========================================
-- LISTENER PARA CAMBIOS EN SPINS
-- ========================================
availableSpins.Changed:Connect(function()
	updateUI()
end)

-- Inicializar UI cerrada
mainFrame.Visible = false
mainFrame.Size = UDim2.fromScale(0, 0)

-- Inicializar timer
updateUI()

print("[SpinWheel] Cliente de ruleta cargado exitosamente")
