-- TutorialSystem.client.lua
-- Sistema de tutorial para jugadores nuevos

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local TutorialConfig = require(ReplicatedStorage.Shared.TutorialConfig)
local tutorialCompleteEvent = ReplicatedStorage.Remotes:WaitForChild("TutorialComplete")

local currentStep = 0
local tutorialActive = false
local arrowPart = nil
local messageUI = nil

-- ======================
-- CREAR UI DE MENSAJE
-- ======================
local function createMessageUI()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "TutorialUI"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = player:WaitForChild("PlayerGui")

	local frame = Instance.new("Frame")
	frame.Name = "MessageFrame"
	frame.Size = UDim2.new(0.6, 0, 0.15, 0)
	frame.Position = UDim2.new(0.2, 0, 0.05, 0)
	frame.BackgroundColor3 = TutorialConfig.MessageBackgroundColor
	frame.BackgroundTransparency = TutorialConfig.MessageBackgroundTransparency
	frame.BorderSizePixel = 0
	frame.Parent = screenGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = frame

	local textLabel = Instance.new("TextLabel")
	textLabel.Name = "Message"
	textLabel.Size = UDim2.new(1, -20, 1, -20)
	textLabel.Position = UDim2.new(0, 10, 0, 10)
	textLabel.BackgroundTransparency = 1
	textLabel.TextColor3 = Color3.new(1, 1, 1)
	textLabel.TextSize = TutorialConfig.MessageTextSize
	textLabel.Font = Enum.Font.GothamBold
	textLabel.TextWrapped = true
	textLabel.TextXAlignment = Enum.TextXAlignment.Center
	textLabel.TextYAlignment = Enum.TextYAlignment.Center
	textLabel.Parent = frame

	return screenGui
end

-- ======================
-- CREAR FLECHA INDICADORA
-- ======================
local function createArrow(targetPosition)
	if arrowPart then
		arrowPart:Destroy()
	end

	local arrow = Instance.new("Part")
	arrow.Name = "TutorialArrow"
	arrow.Size = TutorialConfig.ArrowSize
	arrow.Color = TutorialConfig.ArrowColor
	arrow.Material = Enum.Material.Neon
	arrow.Transparency = TutorialConfig.ArrowTransparency
	arrow.Anchored = true
	arrow.CanCollide = false
	arrow.Position = targetPosition
	arrow.Parent = workspace

	-- Mesh de flecha (cono apuntando hacia abajo)
	local mesh = Instance.new("SpecialMesh")
	mesh.MeshType = Enum.MeshType.FileMesh
	mesh.MeshId = "rbxassetid://13106904616" -- Flecha
	mesh.Scale = Vector3.new(2, 2, 2)
	mesh.Parent = arrow

	arrowPart = arrow

	-- Animación de rotación
	RunService.RenderStepped:Connect(function(delta)
		if arrowPart and arrowPart.Parent then
			arrowPart.CFrame = arrowPart.CFrame * CFrame.Angles(0, math.rad(TutorialConfig.ArrowRotationSpeed * 60 * delta), 0)
		end
	end)

	-- Animación de subir/bajar
	task.spawn(function()
		local baseY = targetPosition.Y
		local offset = 0
		while arrowPart and arrowPart.Parent do
			offset = math.sin(tick() * 2) * 2
			if arrowPart then
				arrowPart.Position = Vector3.new(targetPosition.X, baseY + offset, targetPosition.Z)
			end
			task.wait(0.03)
		end
	end)
end

-- ======================
-- MOSTRAR MENSAJE
-- ======================
local function showMessage(text)
	if not messageUI then
		messageUI = createMessageUI()
	end

	local frame = messageUI:FindFirstChild("MessageFrame")
	if frame then
		local label = frame:FindFirstChild("Message")
		if label then
			label.Text = text
		end
		frame.Visible = true
	end
end

-- ======================
-- OCULTAR UI
-- ======================
local function hideUI()
	if messageUI then
		local frame = messageUI:FindFirstChild("MessageFrame")
		if frame then
			frame.Visible = false
		end
	end

	if arrowPart then
		arrowPart:Destroy()
		arrowPart = nil
	end
end

-- ======================
-- AVANZAR AL SIGUIENTE PASO
-- ======================
local function nextStep()
	currentStep += 1
	local stepData = TutorialConfig.Steps[currentStep]

	if not stepData then
		-- Tutorial completado
		showMessage(TutorialConfig.CompletionMessage)
		task.wait(5)
		hideUI()
		tutorialActive = false
		-- Notificar al servidor que completó el tutorial
		tutorialCompleteEvent:FireServer()
		return
	end

	-- Mostrar mensaje
	showMessage(stepData.Message)

	-- Crear flecha si hay zona objetivo
	if stepData.TargetZone then
		local zone = workspace:FindFirstChild(stepData.TargetZone)
		if zone then
			local targetPos = zone.Position + stepData.ArrowOffset
			createArrow(targetPos)
		else
			warn("[TUTORIAL] Zona no encontrada:", stepData.TargetZone)
		end
	else
		-- No hay flecha para este paso
		if arrowPart then
			arrowPart:Destroy()
			arrowPart = nil
		end
	end
end

-- ======================
-- VERIFICAR PROGRESO
-- ======================
local function checkProgress()
	if not tutorialActive then
		return
	end

	local stepData = TutorialConfig.Steps[currentStep]
	if not stepData then
		return
	end

	local character = player.Character
	if not character then
		return
	end

	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then
		return
	end

	local stats = player:FindFirstChild("Stats")
	if not stats then
		return
	end

	-- Verificar según el tipo de paso
	if stepData.TargetZone then
		local zone = workspace:FindFirstChild(stepData.TargetZone)
		if zone then
			local distance = (humanoidRootPart.Position - zone.Position).Magnitude
			local zoneRadius = math.max(zone.Size.X, zone.Size.Z) / 2

			if distance <= zoneRadius + 5 then
				-- Llegó a la zona
				task.wait(0.5)
				nextStep()
			end
		end
	elseif stepData.RequireInventory then
		local inventory = stats:FindFirstChild("Inventory")
		if inventory and inventory.Value >= stepData.RequireInventory then
			-- Recolectó suficientes crops
			task.wait(0.5)
			nextStep()
		end
	elseif stepData.RequireSell then
		local inventory = stats:FindFirstChild("Inventory")
		local money = player:FindFirstChild("leaderstats"):FindFirstChild("Money")
		if inventory and money and inventory.Value == 0 and money.Value > 0 then
			-- Vendió sus crops
			task.wait(0.5)
			nextStep()
		end
	end
end

-- ======================
-- INICIAR TUTORIAL
-- ======================
local function startTutorial()
	-- Verificar si ya completó el tutorial
	if player:GetAttribute("TutorialCompleted") then
		return
	end

	tutorialActive = true
	currentStep = 0
	nextStep()

	-- Loop de verificación de progreso
	task.spawn(function()
		while tutorialActive do
			checkProgress()
			task.wait(0.5)
		end
	end)
end

-- ======================
-- INICIALIZACIÓN
-- ======================
-- Esperar a que el personaje cargue
local function onCharacterAdded(character)
	character:WaitForChild("HumanoidRootPart")
	task.wait(2) -- Esperar 2 segundos para que cargue todo
	startTutorial()
end

if player.Character then
	onCharacterAdded(player.Character)
end

player.CharacterAdded:Connect(onCharacterAdded)
