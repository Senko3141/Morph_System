-- Morph Client

local Storage = game:GetService("ReplicatedStorage")
local SGUI = game:GetService("StarterGui")

local Remotes = Storage:WaitForChild("Remotes")

Remotes.Morph.OnInvoke = function(resp)
	if resp == "Yes" then
		Remotes.MorphNotif:InvokeServer("Accept")
	end
	if resp == "No" then
		Remotes.MorphNotif:InvokeServer("Decline")
	end
end

Remotes.MorphNotif.OnClientInvoke = function(action)
	if action == "Save" then
		SGUI:SetCore("SendNotification", {
			Title = "[MORPH SYSTEM]",
			Text = "Would you like to save your morph?",
			Duration = 8,
			Callback = Remotes.Morph,
			Button1 = "Yes",
			Button2 = "No"
		})
	end
end
