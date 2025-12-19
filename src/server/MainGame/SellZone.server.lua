local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local part = script.Parent

local playSellSound = ReplicatedStorage.Remotes:WaitForChild("PlaySellSound")

part.Touched:Connect(function(hit)
	local character = hit.Parent
	local player = game.Players:GetPlayerFromCharacter(character)
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

	if inventory.Value > 0 then
		money.Value += inventoryValue.Value
		inventory.Value = 0
		inventoryValue.Value = 0

		playSellSound:FireClient(player)
	end
end)
