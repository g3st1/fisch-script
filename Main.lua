local UserInputService = game:GetService("UserInputService")
local StarterPlayer = game:GetService("StarterPlayer")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

local URL = "https://raw.githubusercontent.com/g3st1/LinoriaLib/main/"

local Library = loadstring(game:HttpGet(URL .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(URL .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(URL .. "addons/SaveManager.lua"))()

local Toggles = Library.Toggles
local Options = Library.Options

local Window = Library:CreateWindow({
	Title = "Best Fisch Script | by 6u3st",
	Center = true,
	AutoShow = true,
	TabPadding = 8,
	MenuFadeTime = 0.2
})

local Main = Window:AddTab("Main")
local Settings = Window:AddTab("Settings")
local Credits = Window:AddTab("Credits")

local LeftGroupbox_Main_1 = Main:AddLeftGroupbox("Main")
do
	local Connect = nil
	
	local function UpdateReelSize()
		local reel = PlayerGui:FindFirstChild("reel")

		if reel then
			local bar = reel:FindFirstChild("bar")

			if bar then
				local playerbar = bar:FindFirstChild("playerbar")

				if playerbar then
					playerbar.Size = UDim2.new(Options.Slider_ReelSize.Value / 100, 0, 1.3, 0)
				end
			end
		end
	end

	function EnableCustomReelSize(Bool: boolean)
		if Bool then
			UpdateReelSize()
			
			Connect = PlayerGui.ChildAdded:Connect(function(Child)
				if Child.Name == "reel" and Child:IsA("ScreenGui") and Toggles.Toggle_CustomReelSize.Value then
					UpdateReelSize()
				end
			end)
		else
			if Connect then
				Connect:Disconnect()
			end
		end
	end

	LeftGroupbox_Main_1:AddToggle("Toggle_CustomReelSize", {
		Text = "Custom Reel Size",
		Default = false,
		Callback = function(Value)
			EnableCustomReelSize(Value)
		end,
	})

	LeftGroupbox_Main_1:AddSlider("Slider_ReelSize", {
		Text = "Reel Size",
		Default = 100,
		Min = 1,
		Max = 100,
		Rounding = 0,
		Suffix = "%",
		Callback = function(Value)
			if Toggles.Toggle_CustomReelSize.Value then
				UpdateReelSize()
			end
		end,
	})
end

local RightGroupbox_Main_1 = Settings:AddLeftGroupbox("Player")
do
	do
		function EnableInfiniteOxygen(Bool: boolean)
			local Character = Player.Character
			local client = StarterPlayer.StarterCharacterScripts:FindFirstChild("client")

			if Character and client then
				local Head = Character:WaitForChild("Head")
				local mainclient = Character:FindFirstChild("client")
				local oxygen = client:FindFirstChild("oxygen")

				if Head and mainclient and oxygen then
					local mainoxygen = mainclient:FindFirstChild("oxygen")

					if mainoxygen then
						mainoxygen.Enabled = not Bool; oxygen.Enabled = not Bool

						if Bool then
							local ui = Head:FindFirstChild("ui")

							if ui then
								ui:Destroy()
							end
						end
					end
				end
			end
		end
		
		RightGroupbox_Main_1:AddToggle("Toggle_InfiniteOxygen", {
			Text = "Infinite Oxygen(Doesn't working yet!)",
			Default = false,
			Callback = function(Value)
				EnableInfiniteOxygen(Value)
			end,
		})
	end
	
	do
		local Connect = nil
		
		function EnableInfinityJumps(Bool: boolean)
			if Bool then
				Connect = UserInputService.JumpRequest:Connect(function()
					local Character = Player.Character
					
					if Character then
						local Humanoid = Character:FindFirstChild("Humanoid")
						
						if Humanoid then
							Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
						end
					end
				end)
			else
				if Connect then
					Connect:Disconnect()
				end
			end
		end
		
		RightGroupbox_Main_1:AddToggle("Toggle_InfinityJumps", {
			Text = "Infinity Jumps",
			Default = false,
			Callback = function(Value)
				EnableInfinityJumps(Value)
			end,
		})
	end
	
	RightGroupbox_Main_1:AddDivider()
	
	do
		RightGroupbox_Main_1:AddToggle("Toggle_CustomWalkSpeed", {
			Text = "Custom WalkSpeed",
			Default = false,
		})

		RightGroupbox_Main_1:AddSlider("Slider_WalkSpeed", {
			Text = "WalkSpeed(Doesn't working yet!)",
			Default = 16,
			Min = 1,
			Max = 200,
			Rounding = 0,
		})
	end
	
	do
		RightGroupbox_Main_1:AddToggle("Toggle_CustomJumpPower", {
			Text = "Custom JumpPower",
			Default = false,
		})

		RightGroupbox_Main_1:AddSlider("Slider_JumpPower", {
			Text = "JumpPower(Doesn't working yet!)",
			Default = 50,
			Min = 1,
			Max = 200,
			Rounding = 0,
		})
	end
end

local LeftGroupbox_Settings_1 = Settings:AddRightGroupbox("Unload")
do
	LeftGroupbox_Settings_1:AddButton({
		Text = "Press to unload",
		DoubleClick = true,
		Func = function()
			Library:Unload()
		end,
	})
end

Library:OnUnload(function()
	Library.Unloaded = true
	
	do
		EnableCustomReelSize(false)
		EnableInfiniteOxygen(false)
		EnableInfinityJumps(false)
	end
end)
