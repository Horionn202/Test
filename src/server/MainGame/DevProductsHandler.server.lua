local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- ========================================
-- PRODUCTOS DE DINERO (MONEY)
-- ========================================
local MONEY_PRODUCTS = {
	[3483574803] = 10000,
	[3483575103] = 50000,
	[3483575321] = 100000,
	[3483575589] = 500000,
	[3483575890] = 1000000,
}

-- ========================================
-- PRODUCTOS DE SPINS (RULETA)
-- ========================================
local SPIN_PRODUCTS = {
	[3493829403] = 1,   -- Product1 - Da 1 spin
	[3493829852] = 3,   -- Product2 - Da 3 spins
	[3493830204] = 10,  -- Product3 - Da 10 spins
}

-- ========================================
-- FUNCIÓN: Dar spins al jugador
-- ========================================
local function giveSpins(player, amount)
	local spinStats = player:FindFirstChild("SpinStats")
	if spinStats then
		local availableSpins = spinStats:FindFirstChild("AvailableSpins")
		if availableSpins then
			availableSpins.Value = availableSpins.Value + amount
			print("[DevProducts] "..player.Name.." compró "..amount.." spins")
			return true
		end
	end
	return false
end

-- ========================================
-- FUNCIÓN: Elegir mascota del huevo (para huevos con Robux)
-- ========================================
local function choosePet(eggName)
	local chance = math.random(1, 100)
	local counter = 0

	local petsInEgg = ReplicatedStorage:FindFirstChild("Pets")
	if petsInEgg then
		petsInEgg = petsInEgg:FindFirstChild(eggName)
	end

	if not petsInEgg then
		warn("[DevProducts] No se encontró el huevo:", eggName)
		return nil
	end

	for _, pet in pairs(petsInEgg:GetChildren()) do
		if pet:FindFirstChild("Rarity") then
			counter = counter + pet.Rarity.Value
			if chance <= counter then
				return pet.Name
			end
		end
	end

	return nil
end

-- ========================================
-- PROCESAR TODAS LAS COMPRAS
-- ========================================
MarketplaceService.ProcessReceipt = function(receipt)
	local player = Players:GetPlayerByUserId(receipt.PlayerId)
	if not player then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	local productId = receipt.ProductId

	-- 1️⃣ PRODUCTOS DE DINERO
	local moneyAmount = MONEY_PRODUCTS[productId]
	if moneyAmount then
		local leaderstats = player:FindFirstChild("leaderstats")
		if leaderstats then
			local money = leaderstats:FindFirstChild("Money")
			if money then
				money.Value = money.Value + moneyAmount
				print("[DevProducts] "..player.Name.." compró $"..moneyAmount)
				return Enum.ProductPurchaseDecision.PurchaseGranted
			end
		end
	end

	-- 2️⃣ PRODUCTOS DE SPINS
	local spinAmount = SPIN_PRODUCTS[productId]
	if spinAmount then
		if giveSpins(player, spinAmount) then
			return Enum.ProductPurchaseDecision.PurchaseGranted
		else
			return Enum.ProductPurchaseDecision.NotProcessedYet
		end
	end

	-- 3️⃣ PRODUCTOS DE HUEVOS CON ROBUX (del sistema de pets)
	local eggName = player:GetAttribute("PendingEgg")
	if eggName then
		local eggInWorld = Workspace:FindFirstChild("Eggs")
		if eggInWorld then
			eggInWorld = eggInWorld:FindFirstChild(eggName)
		end

		if eggInWorld and eggInWorld:FindFirstChild("Price") then
			if eggInWorld.Price.Value == productId then
				-- Es un huevo con Robux
				local chosenPet = choosePet(eggName)

				if chosenPet then
					local petsFolder = player:FindFirstChild("Pets")
					if petsFolder then
						local newPet = Instance.new("StringValue")
						newPet.Name = chosenPet
						newPet.Value = chosenPet
						newPet.Parent = petsFolder

						print("[DevProducts] "..player.Name.." obtuvo "..chosenPet.." del huevo con Robux")

						player:SetAttribute("PendingEgg", nil)

						-- Notificar al cliente
						local EggHatchingRemotes = ReplicatedStorage:FindFirstChild("EggHatchingRemotes")
						if EggHatchingRemotes then
							local notifyRemote = EggHatchingRemotes:FindFirstChild("RobuxHatchSuccess")
							if notifyRemote then
								notifyRemote:FireClient(player, chosenPet)
							end
						end

						return Enum.ProductPurchaseDecision.PurchaseGranted
					end
				end
			end
		end
	end

	-- Si no se procesó ningún producto, no conceder la compra
	warn("[DevProducts] Producto no reconocido:", productId)
	return Enum.ProductPurchaseDecision.NotProcessedYet
end

print("[DevProducts] Sistema de productos cargado (Money, Spins y Pets)")
