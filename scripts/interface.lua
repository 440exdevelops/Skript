local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "Test Hub",
   LoadingTitle = "Loading test hub...",
   LoadingSubtitle = "Powered by Scriptify",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

return Window
