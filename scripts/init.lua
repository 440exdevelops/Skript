-- # MODULES / CORE HANDLERS / LIBRARIES #
local ScriptifyAPI = loadstring(game:HttpGet("https://raw.githubusercontent.com/440exdevelops/Skript/refs/heads/main/FuncLib.lua"))()

-- # ROBLOX SERVICES #
local RbxAnalyticsService = cloneref(game:GetService("RbxAnalyticsService"))
local Players = cloneref(game:GetService("Players"))

-- # CONSTANT VARIABLES #
local Player = Players.LocalPlayer

-- # CHECK FOR KEY IN ARGS #
local Key = ...
if not Key then
  return false, 'No Key Provided', false
end

-- # GATEKEEPER INTERACTION #
local GameSupported = ScriptifyAPI.Authorization.CheckGameSupport(game.PlaceId)
local Passed, ScoreTable = ScriptifyAPI.General.ExecutorInfo()
local Allowed, StatusCode = ScriptifyAPI.Authorization.CheckLicense(key, RbxAnalyticsService:GetClientId(), Player.UserId)
local Configuration = ScriptifyAPI.Other.ReturnConfiguration()

-- # END SCRIPT #
return function()
    if GameSupported and Passed and Allowed and Configuration then
        return true, 'User is authorized.', ScriptifyAPI.Interface.CreateWindow()
    elseif not GameSupported then
        return false, 'Game is not supported.', false
    elseif not Passed then
        return false, 'Executor power test failure.', false
    elseif not Allowed and StatusCode == 401 then
        return false, 'User is not authorized.', false
    elseif not Allowed and StatusCode == 404 then
        return false, 'The API is not able to read data. Contact developers.', false
    elseif not Configuration then
        return false, 'Unexpected error fetching Configuration. Contact developers.', false
    end
end
