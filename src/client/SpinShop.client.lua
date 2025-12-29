-- SpinShop.client.lua
-- Maneja las compras de spins con Developer Products

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ========================================
-- CONFIGURACIÓN DE PRODUCTOS
-- ========================================
local PRODUCTS = {
	Product1 = 3493829403,  -- Product1 - Da 1 spin
	Product2 = 3493829852,  -- Product2 - Da 3 spins
	Product3 = 3493830204,  -- Product3 - Da 10 spins
}

-- Mapeo de botones a cantidad de spins
local SPIN_AMOUNTS = {
	Product1 = 1,
	Product2 = 3,
	Product3 = 10,
}

-- ========================================
-- BUSCAR BOTONES EN LA UI
-- ========================================
local spinUI = playerGui:WaitForChild("SpinUI", 10)
if not spinUI then
	warn("[SpinShop] No se encontró SpinUI")
	return
end

local mainFrame = spinUI:FindFirstChild("Spin")
if not mainFrame then
	warn("[SpinShop] No se encontró el Frame principal")
	return
end

-- Buscar frame de productos (ProductSpin del proyecto Ruelta)
local productFrame = mainFrame:FindFirstChild("ProductSpin")

-- ========================================
-- FUNCIÓN: Comprar spins
-- ========================================
local function buySpin(productId, spinAmount)
	if productId == 0 then
		warn("[SpinShop] Product ID no configurado para "..spinAmount.." spins")
		warn("[SpinShop] Configura los IDs en SpinShop.client.lua")
		return
	end

	-- Mostrar prompt de compra
	MarketplaceService:PromptProductPurchase(player, productId)
end

-- ========================================
-- CONECTAR BOTONES (product1, product2, product3)
-- ========================================
if productFrame then
	-- Buscar los botones específicos dentro de ProductSpin
	for buttonName, productId in pairs(PRODUCTS) do
		local button = productFrame:FindFirstChild(buttonName)

		if button and (button:IsA("ImageButton") or button:IsA("TextButton")) then
			local spinAmount = SPIN_AMOUNTS[buttonName]

			button.MouseButton1Click:Connect(function()
				if productId == 0 then
					warn("[SpinShop] Product ID no configurado para "..buttonName)
					warn("[SpinShop] Crea el producto en Creator Dashboard y agrega el ID")
					return
				end

				buySpin(productId, spinAmount)
			end)

			print("[SpinShop] Botón conectado: "..buttonName.." = "..spinAmount.." spins")
		else
			warn("[SpinShop] No se encontró el botón: "..buttonName)
		end
	end
else
	warn("[SpinShop] No se encontró ProductSpin frame en la UI")
end

-- ========================================
-- LISTENER: Resultado de la compra
-- ========================================
MarketplaceService.PromptProductPurchaseFinished:Connect(function(userId, productId, isPurchased)
	if userId ~= player.UserId then return end

	if isPurchased then
		print("[SpinShop] Compra exitosa!")
		-- El servidor automáticamente agregará los spins
	else
		print("[SpinShop] Compra cancelada")
	end
end)

print("[SpinShop] Sistema de compra de spins cargado")
