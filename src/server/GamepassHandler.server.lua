local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local VIPConfig = require(ReplicatedStorage.Shared.VIPConfig)

local function checkGamepasses(player)
	local isVIP = false
	local hasX2 = false

	pcall(function()
		isVIP = MarketplaceService:UserOwnsGamePassAsync(player.UserId, VIPConfig.GamepassId)
		hasX2 = MarketplaceService:UserOwnsGamePassAsync(player.UserId, VIPConfig.X2.GamepassId)
	end)

	player:SetAttribute("VIP", isVIP)
	player:SetAttribute("X2Money", hasX2)
end

Players.PlayerAdded:Connect(function(player)
	checkGamepasses(player)
end)

MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, passId, purchased)
	if not purchased then
		return
	end

	if passId == VIPConfig.GamepassId then
		player:SetAttribute("VIP", true)
	end

	if passId == VIPConfig.X2.GamepassId then
		player:SetAttribute("X2Money", true)
	end
end)
