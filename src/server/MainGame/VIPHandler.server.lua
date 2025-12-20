local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local VIP = require(ReplicatedStorage.Shared.VIPConfig)

Players.PlayerAdded:Connect(function(player)
	-- 🔴 TEST: fuerza VIP (QUÍTALO LUEGO)
	local isVIP = MarketplaceService:UserOwnsGamePassAsync(player.UserId, VIP.GamepassId)
	-- cuando publiques el juego, usa esto:
	-- local isVIP = MarketplaceService:UserOwnsGamePassAsync(player.UserId, VIP.GamepassId)

	player:SetAttribute("VIP", isVIP)
	print(player.Name, "VIP:", isVIP)

	-- aplicar bonus CUANDO YA EXISTAN LOS STATS
	task.spawn(function()
		local stats = player:WaitForChild("Stats")
		local baseCapacity = stats:WaitForChild("BaseCapacity")
		local capacity = stats:WaitForChild("Capacity")

		if isVIP then
			capacity.Value = baseCapacity.Value + VIP.Bonuses.ExtraCapacity
		else
			capacity.Value = baseCapacity.Value
		end
	end)
end)
