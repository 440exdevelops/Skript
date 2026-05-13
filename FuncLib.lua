-- # FUNCTION STORAGE #
local Functions = {
    General = {},
    Authorization = {},
    Interface = {},
    Other = {}
}

-- # SCRIPT CONFIGURATION VARIABLES #
local Configuration = {
	--// [AUTH CONFIGURATION] \\--
	Auth = {
		SupportedGames = { 85896571713843 },

		BlacklistedHardwareIDs = {
			["TEST-HARDWARE-ID-1234"] = "You are blacklisted for being gay.",
			["TEST-HARDWARE-ID-5678"] = "You are blacklisted for not being gay.",
		}
	},

	--// [GLOBAL CONFIGURATION] \\--
	Global = {
		ScriptVersion = '1.0.0',
		Changelogs = {
			['1.0.0'] = 'Menu Created.'
		},

		MenuToggleKey = "K",
		MenuTheme = "Default",


		UNCScoring = {
            Name = "",
            Passed = 0,
            Total = 0,
            Failed = 0,

            FunctionsToTest = {
                "request",
                "writefile",
                "identifyexecutor",
                "getgenv",
				"getfenv"
            }, 
            TotalFailed = {}
        }
	},

	--// [NETWORK CONFIGURATION] \\--
	Network = {
		API_Url = "http://67.217.243.205:3000/exploit-api/authorization/check-key",
		RayfieldScriptID = "sid_838og124dcbw"
	},

	--// [MENU FEATURES CONFIGURATION] \\--
	Features = {
		AutoBubble = false,

		AutoPlaytimeRewards = false,

		AutoSeasonRewards = false,

		AntiAFK = { Enabled = false, KeyToPress = Enum.KeyCode.X },

		AutoSell = { Enabled = false, Area = "Twilight", Cooldown = 10 },

		AutoHatching = { Enabled = false, Egg = "Common Egg" },

		AutoPotions = {
			UltraInfElixir = { Enabled = false, Cooldown = 12*60 },
			InfElixir = { Enabled = false, Cooldown = 6*60 },
			SecElixir = { Enabled = false, Cooldown = 12*60 },
			EggElixir = { Enabled = false, Cooldown = 25*60 },
			Lucky = { Enabled = false, Tier = 7,  Cooldown = 37*60 },
			Speed = { Enabled = false, Tier = 7, Cooldown = 37*60 },
			Mythic = { Enabled = false, Tier = 7, Cooldown = 37*60 }
		},

		WebhookLogs = { HatchNofication = { Enabled = false, Link = "", DiscordID = "" } },

		PlayerFlight = { Enabled = false, Speed = 35 }
	},
}

-- # MODULES / CORE HANDLERS / LIBRARIES #
local RayfieldUI = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- # ROBLOX SERVICES #
local ReplicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local RbxAnalyticsService = cloneref(game:GetService('RbxAnalyticsService'))
local HttpService = cloneref(game:GetService("HttpService"))
local PlayerService = cloneref(game:GetService("Players"))

-- # CONSTANT VARIABLES / DIRECTORIES #
--#Constants
local RemoteFunction = ReplicatedStorage.Shared.Framework.Network.Remote.RemoteFunction
local RemoteEvent = ReplicatedStorage.Shared.Framework.Network.Remote.RemoteEvent
local Player = PlayerService.LocalPlayer

--#Directores
local FeaturesConfig = Configuration.Features
local NetworkConfig = Configuration.Network
local GlobalConfig = Configuration.Global
local AuthConfig = Configuration.Auth

--#Network Config
local RayfieldScriptID = NetworkConfig.RayfieldScriptID
local APIUrl = NetworkConfig.API_Url

--#Auth Config
local BlacklistedHWIDS = AuthConfig.BlacklistedHardwareIDs
local SupportedGames = AuthConfig.SupportedGames

--#Global Config
local ScriptVersion = GlobalConfig.ScriptVersion
local Changelogs = GlobalConfig.Changelogs
local UNCScoring = GlobalConfig.UNCScoring

--#Features Config
local AutoHatching = FeaturesConfig.AutoHatching
local PlayerFlight = FeaturesConfig.PlayerFlight
local WebhookLogs = FeaturesConfig.WebhookLogs
local AutoPotions = FeaturesConfig.AutoPotions
local AutoSell = FeaturesConfig.AutoSell
local AntiAFK = FeaturesConfig.AntiAFK

-- # CORE FUNCTIONS #

-- # AUTHORIZATION FUNCTIONS #
Functions.Authorization.CheckLicense = function(LicenseID, HardwareID, UserID)
    local success, response = pcall(function()
        return request({
            Url = APIUrl,
            Method = 'POST',
            Headers = { ['Content-Type'] = 'application/json' },
            Body = HttpService:JSONEncode({ api_key = LicenseID, hardware_id = HardwareID, user_id = UserID })
        })
    end)
    
    if not success then
        return false, 'Offline'
    end

    if response.StatusCode == 200 then
        return true, response.StatusCode
    elseif response.StatusCode == 401 then
        return false, response.StatusCode
    else
        return false, response.StatusCode
    end
end
Functions.Authorization.CheckGameSupport = function(currentPlace)
	if not table.find(SupportedGames, currentPlace) then
		return false
	end

	return true
end

-- # GENERAL SCRIPT FUNCTIONS #
Functions.General.ExecutorInfo = function()
    local testsPassed = 0

    for _, functionName in ipairs(UNCScoring.FunctionsToTest) do
        if getfenv()[functionName] or _G[functionName] or shared[functionName] then
            testsPassed = testsPassed + 1
        else
            table.insert(UNCScoring.TotalFailed, functionName)
        end
    end

    if not identifyexecutor() then
        UNCScoring.Name = "UNC Test Failure - identifyexecutor()"
    end

    UNCScoring.Name = identifyexecutor()
    UNCScoring.Total = #UNCScoring.FunctionsToTest
    UNCScoring.Passed = testsPassed
    UNCScoring.Percentage = (testsPassed / #UNCScoring.FunctionsToTest) * 100

    if #UNCScoring.TotalFailed > 0 then
        return false, UNCScoring
    end
    
    return true, UNCScoring
end
Functions.General.FireEvent = function(args)
    local success, RemoteEvent = pcall(function()
    	return ReplicatedStorage.Shared.Framework.Network.Remote.RemoteEvent
    end)

    if not RemoteEvent then warn('Could not locate RemoteEvent/RemoteFunction. - FireEvent()') return end

    if not success then warn('Unexpected error while attempting to fire the specified event. - FireEvent()') return end


    RemoteEvent:FireServer(unpack(args))
end
Functions.General.TeleportPlayer = function(position)
    local rootPart = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if rootPart then
    	rootPart.CFrame = CFrame.new(position)
    else
    	return
    end
end

-- # RAYFIELD FUCNTIONS #
Functions.Interface.CreateWindow = function()
	local Window = RayfieldUI:CreateWindow({
        Name = "Bubble Gum Simulator Infinity",
        Icon = 0,
        LoadingTitle = "Loading script...",
        LoadingSubtitle = "Powered by Scriptify",
        ShowText = "BGSI Hub",
        Theme = "Default",
        ToggleUIKeybind = "K",
        DisableRayfieldPrompts = true,
        DisableBuildWarnings = true,
        ScriptID = RayfieldScriptID,
        ConfigurationSaving = { Enabled = false, FolderName = nil, FileName = "Big Hub" },
        Discord = { Enabled = false, Invite = "noinvitelink", RememberJoins = true },
        KeySystem = false  
    })
	
	local HomeTab = Window:CreateTab('🏡 Home', 0)
	local HatchingTab = Window:CreateTab('🥚 Hatching', 0)
	local AutoFarmTab = Window:CreateTab('⚡ Auto Farming', 0)
	local TeleportTab = Window:CreateTab('💨 Teleportation & Player', 0)
	local TradingTab = Window:CreateTab('♻️ Pets & Trading', 0)
	local WebhookTab = Window:CreateTab('🚨 Webhooks', 0)
	local SettingsTab = Window:CreateTab('⚙️ Settings', 0)
	local CreditsTab = Window:CreateTab('📜 Credits', 0)
	
    return Window
end

-- # MISC / OTHER FUNCTIONS #
Functions.Other.ReturnConfiguration = function()
    if not Configuration then
        warn('Could not find the specified Configuration file. - ReturnConfiguration()')
        return false, {}
    end

    return Configuration
end

--#End Of Script
return Functions
