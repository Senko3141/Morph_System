-- Morph Server
--[[

	TODO: Add saving.

]]

local Players = game:GetService("Players")
local WSP = game:GetService("Workspace")
local Storage = game:GetService("ReplicatedStorage")

local Modules = Storage:WaitForChild("Modules")
local Remotes = Storage:WaitForChild("Remotes")
local Folder = WSP:WaitForChild("MorphsWSP")

local System = require(Modules.MorphSystem)

local CurrentMorphs = {};

Players.PlayerRemoving:Connect(function(plr)
	if CurrentMorphs[plr] then
		CurrentMorphs[plr]:terminate()
		CurrentMorphs[plr] = nil
	end
end)

Remotes.MorphNotif.OnServerInvoke = function(plr, action)
	if action == "Accept" then
		if CurrentMorphs[plr] then
			CurrentMorphs[plr].CanSave = true
		end
	end
	if action == "Decline" then
		if CurrentMorphs[plr] then
			CurrentMorphs[plr].CanSave = false
		end
	end
end

for _,morph in pairs(Folder:GetChildren()) do
	morph.Interaction.ProximityPrompt.Triggered:Connect(function(plr)
		if CurrentMorphs[plr] then
			return;
		end
		
		local newMorph = System.new(plr, morph.Name)
		CurrentMorphs[plr] = newMorph
		
		newMorph:equip()
		Remotes.MorphNotif:InvokeClient(plr, "Save")
	end)
end
