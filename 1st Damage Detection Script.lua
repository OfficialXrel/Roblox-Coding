local Players = game:GetService("Players")

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

			-- Print the health lost value for testing purposes
			print(player.Name .. " lost " .. healthLost .. " health")
		end)
	end)
end

-- Connect to the player added event to start tracking health on spawn
Players.PlayerAdded:Connect(onPlayerAdded)
