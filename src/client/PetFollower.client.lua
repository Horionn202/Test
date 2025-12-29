local RunService = game:GetService("RunService")

local playerPets = workspace:WaitForChild("Player_Pets")

local circle = math.pi * 2

-- Calcular posición en círculo
local function getPosition(angle, radius)
	local x = math.cos(angle) * radius
	local z = math.sin(angle) * radius
	return x, z
end

-- Posicionar pets alrededor del jugador
local function positionPets(character, folder)
	for i, pet in pairs(folder:GetChildren()) do
		if not pet.PrimaryPart then
			continue
		end

		local radius = 4 + #folder:GetChildren()
		local angle = i * (circle / #folder:GetChildren())
		local x, z = getPosition(angle, radius)
		local _, characterSize = character:GetBoundingBox()
		local _, petSize = pet:GetBoundingBox()

		local offsetY = -characterSize.Y / 2 + petSize.Y / 2
		local sin = (math.sin(15 * time() + 1.6) / 0.5) + 1
		local cos = math.cos(7 * time() + 1) / 4

		-- Si el jugador se está moviendo
		if character.Humanoid.MoveDirection.Magnitude > 0 then
			if pet:FindFirstChild("Walks") then
				-- Pets que caminan
				pet:SetPrimaryPartCFrame(
					pet.PrimaryPart.CFrame:Lerp(
						character.PrimaryPart.CFrame * CFrame.new(x, offsetY + sin, z) * CFrame.fromEulerAnglesXYZ(0, 0, cos),
						0.1
					)
				)
			else
				-- Pets que flotan
				pet:SetPrimaryPartCFrame(
					pet.PrimaryPart.CFrame:Lerp(
						character.PrimaryPart.CFrame * CFrame.new(x, offsetY / 2 + math.sin(time() * 3) + 1, z),
						0.1
					)
				)
			end
		else
			-- Si el jugador está quieto
			if pet:FindFirstChild("Walks") then
				-- Pets que caminan se quedan quietas
				pet:SetPrimaryPartCFrame(
					pet.PrimaryPart.CFrame:Lerp(
						character.PrimaryPart.CFrame * CFrame.new(x, offsetY, z),
						0.1
					)
				)
			else
				-- Pets que flotan siguen flotando
				pet:SetPrimaryPartCFrame(
					pet.PrimaryPart.CFrame:Lerp(
						character.PrimaryPart.CFrame * CFrame.new(x, offsetY / 2 + math.sin(time() * 3) + 1, z),
						0.1
					)
				)
			end
		end
	end
end

-- Loop principal
RunService.RenderStepped:Connect(function()
	for _, plrFolder in pairs(playerPets:GetChildren()) do
		local player = game.Players:FindFirstChild(plrFolder.Name)
		if player then
			local character = player.Character
			if character and character:FindFirstChild("Humanoid") and character:FindFirstChild("PrimaryPart") then
				positionPets(character, plrFolder)
			end
		end
	end
end)

print("PetFollower loaded successfully!")
