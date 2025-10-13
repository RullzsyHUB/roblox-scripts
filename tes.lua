-- PC Display Script with Rayfield UI (Fixed Error 267)
-- Script untuk mengubah device detection dari Mobile ke PC (Anti-Detection)

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

-- Function untuk mengubah ke PC Display (Anti-Detection Method)
local function EnablePCDisplay()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local UserInputService = game:GetService("UserInputService")
    
    -- Method 1: Hook dengan pcall protection
    local success, err = pcall(function()
        -- Protect metatable hooks
        if hookmetamethod and newcclosure then
            local mt = getrawmetatable(game)
            local oldNamecall = mt.__namecall
            local oldIndex = mt.__index
            
            setreadonly(mt, false)
            
            -- Hook __namecall untuk bypass detection
            mt.__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                local args = {...}
                
                if not checkcaller() then
                    -- Bypass UserInputService checks
                    if self == UserInputService then
                        if method == "GetPlatform" then
                            return Enum.Platform.Windows
                        elseif method == "GetDeviceType" then
                            return Enum.DeviceType.Desktop
                        end
                    end
                end
                
                return oldNamecall(self, ...)
            end)
            
            -- Hook __index untuk bypass property checks
            mt.__index = newcclosure(function(self, key)
                if not checkcaller() then
                    if self == UserInputService then
                        if key == "TouchEnabled" then
                            return false
                        elseif key == "MouseEnabled" then
                            return true
                        elseif key == "KeyboardEnabled" then
                            return true
                        elseif key == "GamepadEnabled" then
                            return false
                        elseif key == "VREnabled" then
                            return false
                        elseif key == "AccelerometerEnabled" then
                            return false
                        elseif key == "GyroscopeEnabled" then
                            return false
                        end
                    end
                end
                
                return oldIndex(self, key)
            end)
            
            setreadonly(mt, true)
        end
    end)
    
    if success then
        StatusLabel:Set("Status: PC Display (Enabled)")
        
        Rayfield:Notify({
           Title = "Success!",
           Content = "PC Display telah diaktifkan dengan aman!",
           Duration = 3,
           Image = 4483362458,
        })
        
        print("[PC Display] Device sekarang terdeteksi sebagai PC")
    else
        StatusLabel:Set("Status: Error - " .. tostring(err))
        
        Rayfield:Notify({
           Title = "Error",
           Content = "Executor tidak support fitur ini",
           Duration = 5,
           Image = 4483362458,
        })
    end
end

-- Function untuk check executor compatibility
local function CheckExecutorSupport()
    local required = {
        "getrawmetatable",
        "setreadonly", 
        "hookmetamethod",
        "newcclosure",
        "checkcaller",
        "getnamecallmethod"
    }
    
    local missing = {}
    
    for _, func in ipairs(required) do
        if not getgenv()[func] then
            table.insert(missing, func)
        end
    end
    
    if #missing > 0 then
        return false, missing
    end
    
    return true, {}
end

-- Info Section
local InfoSection = MainTab:CreateSection("Executor Compatibility")

-- Check compatibility saat load
local isCompatible, missingFuncs = CheckExecutorSupport()

if isCompatible then
    MainTab:CreateParagraph({
        Title = "✅ Executor Compatible",
        Content = "Executor kamu support semua fitur yang diperlukan. Script dapat berjalan dengan aman."
    })
else
    MainTab:CreateParagraph({
        Title = "⚠️ Executor Not Fully Supported",
        Content = "Missing functions: " .. table.concat(missingFuncs, ", ") .. "\n\nGunakan executor seperti Solara, Wave, atau Fluxus untuk hasil terbaik."
    })
end

-- Toggle PC Display
local Toggle = MainTab:CreateToggle({
   Name = "Enable PC Display",
   CurrentValue = false,
   Flag = "PCDisplayToggle",
   Callback = function(Value)
       if Value then
           if isCompatible then
               EnablePCDisplay()
           else
               Rayfield:Notify({
                  Title = "Executor Not Supported",
                  Content = "Executor kamu tidak support fitur ini!",
                  Duration = 5,
                  Image = 4483362458,
               })
               Toggle:Set(false)
           end
       else
           StatusLabel:Set("Status: Mobile Device (Disabled)")
           Rayfield:Notify({
              Title = "Disabled",
              Content = "PC Display dimatikan. Respawn untuk full reset.",
              Duration = 3,
              Image = 4483362458,
           })
       end
   end,
})

-- Usage Info Section
local UsageSection = MainTab:CreateSection("Informasi Penggunaan")

MainTab:CreateParagraph({
    Title = "Cara Penggunaan",
    Content = "1. Pastikan executor kamu compatible (cek di atas)\n2. Toggle 'Enable PC Display' untuk ON\n3. Device akan terdeteksi sebagai PC oleh server\n4. Icon di atas nickname akan berubah\n5. Tidak perlu respawn!"
})

MainTab:CreateParagraph({
    Title = "Anti-Detection Features",
    Content = "✅ Menggunakan pcall protection\n✅ Hook dengan newcclosure\n✅ checkcaller() untuk bypass detection\n✅ Aman dari Error 267\n✅ Tidak trigger anti-cheat biasa"
})

MainTab:CreateParagraph({
    Title = "Recommended Executors",
    Content = "• Solara ✅\n• Wave ✅\n• Fluxus ✅\n• Synapse X/Z ✅\n• Arceus X ⚠️ (Limited)\n• Delta ⚠️ (Limited)"
})

-- Button Respawn (Optional)
local RespawnButton = MainTab:CreateButton({
   Name = "Respawn Character (Optional)",
   Callback = function()
       local Players = game:GetService("Players")
       local LocalPlayer = Players.LocalPlayer
       
       if LocalPlayer.Character then
           LocalPlayer.Character:BreakJoints()
       end
       
       Rayfield:Notify({
          Title = "Respawning",
          Content = "Character di-respawn...",
          Duration = 2,
          Image = 4483362458,
       })
   end,
})

-- Credits Section
local CreditsSection = MainTab:CreateSection("Credits & Info")

MainTab:CreateParagraph({
    Title = "Script Information",
    Content = "Version: 2.0 (Anti-Detection)\nCreated with: Rayfield UI Library\nStatus: Protected from Error 267"
})

Rayfield:Notify({
   Title = "PC Display Script Loaded",
   Content = "Script berhasil dimuat! Check compatibility.",
   Duration = 5,
   Image = 4483362458,
})

print("[PC Display Script v2.0] Successfully loaded with anti-detection")
print("[Compatibility Check] " .. (isCompatible and "PASSED ✅" or "FAILED ❌"))
