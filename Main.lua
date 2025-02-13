local UserInputService = game:GetService("UserInputService")
local StarterPlayer = game:GetService("StarterPlayer")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

local Character = Player.Character or Player.CharacterAdded:Wait()

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
			Text = "Infinite Oxygen(doesn't work)",
			Default = false,
			Callback = function(Value)
				EnableInfiniteOxygen(Value)
			end,
		})
	end
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
	end

	RightGroupbox_Main_1:AddToggle("Toggle_InfinityJumps", {
		Text = "Infinite Jumps",
		Default = false,
		Callback = function(Value)
			EnableInfinityJumps(Value)
		end,
	})

	RightGroupbox_Main_1:AddDivider()
	
	do
		RightGroupbox_Main_1:AddToggle("Toggle_CustomWalkSpeed", {
			Text = "Custom WalkSpeed",
			Default = false,
			Callback = function(Value)
				SetCustomWalkSpeed(Value)
			end,
		})

		RightGroupbox_Main_1:AddSlider("Slider_WalkSpeed", {
			Text = "WalkSpeed",
			Default = 16,
			Min = 1,
			Max = 200,
			Rounding = 0,
		})
	end
	
	do
		RightGroupbox_Main_1:AddToggle("Toggle_CustomJumpPower", {
			Text = "Custom JumpPower(doesn't work)",
			Default = false,
		})

		RightGroupbox_Main_1:AddSlider("Slider_JumpPower", {
			Text = "JumpPower",
			Default = 50,
			Min = 1,
			Max = 200,
			Rounding = 0,
		})
	end

local RightGroupbox_Settings_1 = Settings:AddRightGroupbox("Unload")
do
	RightGroupbox_Settings_1:AddButton({
		Text = "Press to unload",
		DoubleClick = true,
		Func = function()
			Library:Unload()
		end,
	})
end

local LeftGroupbox_Credits_1 = Credits:AddLeftGroupbox("Credits")
do
	LeftGroupbox_Credits_1:AddToggle("first", {
		Text = "Inori - Main developer",
		Default = false,
	})
end
	
do
	LeftGroupbox_Credits_1:AddToggle("second", {
		Text = "matas3535 - Creator of Splix.",
		Default = false,
	})
end

do
	LeftGroupbox_Credits_1:AddToggle("fifth", {
		Text = "6u3st - Creator of this script.",
		Default = false,
	})
end

local RightGroupbox_Credits_1 = Credits:AddRightGroupbox("Testers")
do
	RightGroupbox_Credits_1:AddToggle("n1n1n", {
		Text = "kom_sx - first tester.",
		Default = false,
	})
end

Library:OnUnload(function()
	Library.Unloaded = true
	
	do
		EnableCustomReelSize(false)
		SetCustomWalkSpeed(false)
		EnableInfiniteOxygen(false)
		EnableInfinityJumps(false)
	end
end)
