local Players = game:GetService("Players")

-- Create a RemoteEvent to send the health data to the client
local healthChangeEvent = Instance.new("RemoteEvent")
healthChangeEvent.Name = "HealthChangeEvent"
healthChangeEvent.Parent = game:GetService("ReplicatedStorage")

local function onPlayerAdded(player)
	player.CharacterAdded:Connect(function(character)
		-- Store the player's starting health
		local humanoid = character:WaitForChild("Humanoid")
		local startingHealth = humanoid.MaxHealth
		player:SetAttribute("StartingHealth", startingHealth)

		-- Connect to the humanoid's health changed event to detect when the player takes damage
		humanoid.HealthChanged:Connect(function(health)
			-- Calculate the difference between the starting health and current health
			local healthLost = startingHealth - health

			-- Update the player's attribute with the new health value
			player:SetAttribute("HealthLost", healthLost)

			-- Send the health data to the client
			healthChangeEvent:FireClient(player, health, healthLost)

			-- Print the health lost value for testing purposes
			print(player.Name .. " lost " .. healthLost .. " health")
		end)
	end)
end

-- Connect to the player added event to start tracking health on spawn
Players.PlayerAdded:Connect(onPlayerAdded)

-- Create a RemoteFunction to handle client requests for health data
local healthDataFunction = Instance.new("RemoteFunction")
healthDataFunction.Name = "HealthDataFunction"
healthDataFunction.Parent = game:GetService("ReplicatedStorage")

-- Define the function to handle the client request
healthDataFunction.OnServerInvoke = function(player)
	local startingHealth = player:GetAttribute("StartingHealth") or 0
	local healthLost = player:GetAttribute("HealthLost") or 0
	return startingHealth, healthLost
end