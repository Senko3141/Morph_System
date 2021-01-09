-- Morph System
--[[
	SenkoArdeth, 1-6-2021
	
	Morph System that saves your morph, etc.
	
	Methods:
	
	new(player, morphname)
	equip()
	terminate()
	
	Snippet:
	
	local Module = require()
	
	local Object = Module.new(plr, "Dummy")
	Object:equip()
	
	player.Character.Died:Connect(function()
		-- saving will be done like this, if you don't wanna save just do the .Died event listener.
	
		Object:terminate()
		Object = nil
	end)
]]

local Morphs = script:WaitForChild("Morphs")
local RS = game:GetService("RunService")

local Neccess = script:WaitForChild("Neccess")
local WeldService = require(Neccess.Weld)

local Clothing = script:WaitForChild("Clothing")

local module = {};
module.__index = module

function module.new(plr, morphName)
	if Morphs:FindFirstChild(morphName) then
		local self = setmetatable({}, module)
		self.Owner = plr 
		self.Name = morphName
		self.Equipped = false
		self.CanSave = false
		self.SaveConnection = plr.CharacterAdded:Connect(function(char)
			if self.CanSave == true then
				if char then
					self.Owner.CharacterAppearanceLoaded:Wait()
					
					if Clothing:FindFirstChild(self.Name) then
						-- remove pants
						for _,v in pairs(self.Owner.Character:GetChildren()) do
							if v.Name == "Pants" or v.Name == "Shirt" then
								v:Destroy()
							end
						end

						for _,v in pairs(Clothing[self.Name]:GetChildren()) do
							v:Clone().Parent = self.Owner.Character
						end
					end
					
					WeldService:Weld(char, self.Name)
					self.Owner.Character.Humanoid:RemoveAccessories()
				end
				
			else
				module:terminate()
			end
		end)
		
		warn("[MORPH SYSTEM] Successfully created morph object: ".. morphName.." for ".. plr.Name..'.')
		
		return self
	else
		warn("[MORPH SYSTEM] Could not find morph ".. morphName..'.')
		return 'Error'
	end
end

function module:equip()
	self.Equipped = not self.Equipped
	
	local Equipped = self.Equipped
	if Equipped == true then
		-- equip
		WeldService:Weld(self.Owner.Character, self.Name)
		
		if Clothing:FindFirstChild(self.Name) then
			-- remove pants
			for _,v in pairs(self.Owner.Character:GetChildren()) do
				if v.Name == "Pants" or v.Name == "Shirt" then
					v:Destroy()
				end
			end

			for _,v in pairs(Clothing[self.Name]:GetChildren()) do
				v:Clone().Parent = self.Owner.Character
			end
		end

		WeldService:Weld(self.Owner.Character, self.Name)
		self.Owner.Character.Humanoid:RemoveAccessories()
		warn("[MORPH SYSTEM] ".. self.Owner.Name.." has equipped his/her morph.")
	end
end

function module:terminate()
	warn("[MORPH SYSTEM] Successfully removed ".. self.Owner.Name.."'s morph. | Morph Name: ".. self.Name)
	
	self.SaveConnection:Disconnect()
	self.SaveConnection = nil
	self.Equipped = false

	self = nil
end


return module
