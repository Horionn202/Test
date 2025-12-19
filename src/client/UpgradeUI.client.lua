local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local remotes = ReplicatedStorage:WaitForChild("Remotes")
local buyUpgrade = remotes:WaitForChild("BuyUpgrade")

-- botón simple
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.fromScale(0.2, 0.08)
button.Position = UDim2.fromScale(0.4, 0.7)
button.Text = "Upgrade Backpack"
button.Parent = gui

button.MouseButton1Click:Connect(function()
	buyUpgrade:FireServer("Backpack")
end)
