-- PC Display Script with Rayfield UI
-- Script untuk mengubah device detection dari Mobile ke PC

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "PC Display Changer",
   LoadingTitle = "Loading PC Display Script",
   LoadingSubtitle = "by Script Creator",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil,
      FileName = "PCDisplay"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false,
})

local MainTab = Window:CreateTab("Main", 4483362458)

local Section = MainTab:CreateSection("Device Display Settings")

-- Status Label
local StatusLabel = MainTab:CreateLabel("Status: Mobile Device")

-- Function untuk mengubah ke PC Display
local function EnablePCDisplay()
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    -- Backup original values
    local OriginalTouchEnabled = UserInputService.TouchEnabled
    local OriginalMouseEnabled = UserInputService.MouseEnabled
    
    -- Override Touch & Mouse Detection
    local mt = getrawmetatable(game)
    local oldindex = mt.__index
    setreadonly(mt, false)
    
    mt.__index = newcclosure(function(self, key)
        if self == UserInputService then
            if key == "TouchEnabled" then
                return false
            elseif key == "MouseEnabled" then
                return true
            elseif key == "KeyboardEnabled" then
                return true
            elseif key == "GamepadEnabled" then
                return false
            end
        end
        return oldindex(self, key)
    end)
    
    setreadonly(mt, true)
    
    -- Update Status
    StatusLabel:Set("Status: PC Display (Enabled)")
    
    Rayfield:Notify({
       Title = "Success!",
       Content = "PC Display telah diaktifkan!",
       Duration = 3,
       Image = 4483362458,
    })
    
    print("[PC Display] Device sekarang terdeteksi sebagai PC")
end

-- Function untuk reset ke Mobile
local function DisablePCDisplay()
    -- Reload character untuk reset
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    if LocalPlayer.Character then
        LocalPlayer.Character:BreakJoints()
    end
    
    StatusLabel:Set("Status: Mobile Device (Default)")
    
    Rayfield:Notify({
       Title = "Reset",
       Content = "Silahkan respawn untuk kembali ke Mobile",
       Duration = 3,
       Image = 4483362458,
    })
end

-- Toggle PC Display
local Toggle = MainTab:CreateToggle({
   Name = "Enable PC Display",
   CurrentValue = false,
   Flag = "PCDisplayToggle",
   Callback = function(Value)
       if Value then
           EnablePCDisplay()
       else
           DisablePCDisplay()
       end
   end,
})

-- Info Section
local InfoSection = MainTab:CreateSection("Informasi")

MainTab:CreateParagraph({
    Title = "Cara Penggunaan",
    Content = "1. Toggle 'Enable PC Display' untuk ON\n2. Device kamu akan terdeteksi sebagai PC\n3. Icon di atas nickname akan berubah menjadi PC\n4. Toggle OFF untuk kembali ke Mobile (perlu respawn)"
})

MainTab:CreateParagraph({
    Title = "Catatan",
    Content = "Script ini mengubah UserInputService detection agar server mengenali device sebagai PC/Desktop. Beberapa game mungkin memiliki anti-cheat yang mendeteksi ini."
})

-- Button Respawn
local RespawnButton = MainTab:CreateButton({
   Name = "Respawn Character",
   Callback = function()
       local Players = game:GetService("Players")
       local LocalPlayer = Players.LocalPlayer
       
       if LocalPlayer.Character then
           LocalPlayer.Character:BreakJoints()
       end
       
       Rayfield:Notify({
          Title = "Respawning",
          Content = "Character sedang di-respawn...",
          Duration = 2,
          Image = 4483362458,
       })
   end,
})

Rayfield:Notify({
   Title = "PC Display Script Loaded",
   Content = "Script berhasil dimuat!",
   Duration = 5,
   Image = 4483362458,
})

print("[PC Display Script] Successfully loaded with Rayfield UI")
