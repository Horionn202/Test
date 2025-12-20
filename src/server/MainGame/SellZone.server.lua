local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local part = script.Parent

local VIP = require(ReplicatedStorage.Shared.VIPConfig)
local playSellSound = ReplicatedStorage.Remotes:WaitForChild("PlaySellSound")

part.Touched:Connect(function(hit)
	local character = hit.Parent
	local player = Players:GetPlayerFromCharacter(character)
	if not player then
		return
	end

	local stats = player:FindFirstChild("Stats")
	local leaderstats = player:FindFirstChild("leaderstats")
	if not stats or not leaderstats then
		return
	end

	local inventory = stats:FindFirstChild("Inventory")
	local inventoryValue = stats:FindFirstChild("InventoryValue")
	local money = leaderstats:FindFirstChild("Money")

	if inventory.Value <= 0 then
		return
	end

	-- 💰 calcular venta base
	local total = inventoryValue.Value
	print("BASE:", total)

	-- 💎 VIP (+50%)
	if player:GetAttribute("VIP") then
		total *= VIP.Bonuses.MoneyMultiplier
		print("VIP MULTIPLIER APLICADO")
	end

	-- 🔥 X2 DINERO
	if player:GetAttribute("X2Money") then
		total *= VIP.X2.Bonuses.MoneyMultiplier
		print("X2 MULTIPLIER APLICADO")
	end

	print("FINAL:", total)

	-- vender
	money.Value += math.floor(total)

	-- limpiar inventario
	inventory.Value = 0
	inventoryValue.Value = 0

	-- 🔊 sonido
	playSellSound:FireClient(player)
end)
