local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local PRODUCTS = {
	[3483574803] = 10000,
	[3483575103] = 50000,
	[3483575321] = 100000,
	[3483575589] = 500000,
	[3483575890] = 1000000,
}

MarketplaceService.ProcessReceipt = function(receipt)
	local player = Players:GetPlayerByUserId(receipt.PlayerId)
	if not player then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	local coins = PRODUCTS[receipt.ProductId]
	if coins then
		player.leaderstats.Money.Value += coins
	end

	return Enum.ProductPurchaseDecision.PurchaseGranted
end
