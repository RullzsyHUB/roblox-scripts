-- ===========================================================
-- LOAD LIBRARY UI
-- ===========================================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ===========================================================
-- WINDOW SETUP
-- ===========================================================
local Window = Rayfield:CreateWindow({
    Name = "RullzsyHUB | Script Loader",
    LoadingTitle = "Created By RullzsyHUB",
    LoadingSubtitle = "Follow Tiktok: @rullzsy99",
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
    KeySystem = false
})

-- ===========================================================
-- TAB MENU : UPDATE LOG / INFO
-- ===========================================================
local UpdateTab = Window:CreateTab("Update Log", 4483362458)
UpdateTab:CreateSection("📅 Informasi Update Terbaru")

UpdateTab:CreateParagraph({
    Title = "🧾 Update 16 Oktober 2025",
    Content = [[
🧩 Penambahan Fitur:
- MT YAHAYUK > Mode 180 Derajat (Pause/Rotate Menu)
- MT YAHAYUK > Always Run (otomatis sprint di PC)

🐞 Fix:
- Jalur Mount Atin & Checkpoint 5 diperbaiki.

🗺️ Map Baru:
- Fokus ke event, map baru menyusul 😎

💡 Catatan:
Klik menu "List Scripts" untuk membuka dan menjalankan script.
]]
})

-- ===========================================================
-- TAB MENU : LIST SCRIPT (LOADSTRING LANGSUNG)
-- ===========================================================
local ScriptTab = Window:CreateTab("List Scripts", 4483362458)
ScriptTab:CreateSection("🟢 TOTAL MAP: 14")

-- ===========================================================
-- SCRIPT BUTTONS (SEMUA MAP)
-- ===========================================================

-- 1. KOTA BUKAN GUNUNG
ScriptTab:CreateButton({
    Name = "🟢 KOTA BUKAN GUNUNG",
    Callback = function()
        Rayfield:Notify({Title="Executing", Content="Loading KOTA BUKAN GUNUNG...", Duration=4})
        loadstring(game:HttpGet("https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/refs/heads/main/RullzsyHUB%20-%20KOTA%20BUKAN%20GUNUNG/main.lua"))()
    end
})

-- 2. MOUNT ATIN
ScriptTab:CreateButton({
    Name = "🟢 MOUNT ATIN",
    Callback = function()
        Rayfield:Notify({Title="Executing", Content="Loading MOUNT ATIN...", Duration=4})
        loadstring(game:HttpGet("https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/main/RullzsyHUB%20-%20MOUNT%20ATIN/main.lua"))()
    end
})

-- 3. MOUNT ARUNIKA
ScriptTab:CreateButton({
    Name = "🟢 MOUNT ARUNIKA",
    Callback = function()
        Rayfield:Notify({Title="Executing", Content="Loading MOUNT ARUNIKA...", Duration=4})
        loadstring(game:HttpGet("https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/main/RullzsyHUB%20-%20MOUNT%20ARUNIKA/main.lua"))()
    end
})

-- 4. MOUNT HMMM
ScriptTab:CreateButton({
    Name = "🟢 MOUNT HMMM",
    Callback = function()
        Rayfield:Notify({Title="Executing", Content="Loading MOUNT HMMM...", Duration=4})
        loadstring(game:HttpGet("https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/main/RullzsyHUB%20-%20MOUNT%20HMMM/main.lua"))()
    end
})

-- 5. MOUNT PARGOY
ScriptTab:CreateButton({
    Name = "🟢 MOUNT PARGOY",
    Callback = function()
        Rayfield:Notify({Title="Executing", Content="Loading MOUNT PARGOY...", Duration=4})
        loadstring(game:HttpGet("https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/main/RullzsyHUB%20-%20MOUNT%20PARGOY/main.lua"))()
    end
})

-- 6. MOUNT PENGANGGURAN
ScriptTab:CreateButton({
    Name = "🟢 MOUNT PENGANGGURAN",
    Callback = function()
        Rayfield:Notify({Title="Executing", Content="Loading MOUNT PENGANGGURAN...", Duration=4})
        loadstring(game:HttpGet("https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/main/RullzsyHUB%20-%20MOUNT%20PENGANGGURAN/main.lua"))()
    end
})

-- 7. MOUNT STECU
ScriptTab:CreateButton({
    Name = "🟢 MOUNT STECU",
    Callback = function()
        Rayfield:Notify({Title="Executing", Content="Loading MOUNT STECU...", Duration=4})
        loadstring(game:HttpGet("https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/main/RullzsyHUB%20-%20MOUNT%20STECU/main.lua"))()
    end
})

-- 8. MOUNT YACAPE
ScriptTab:CreateButton({
    Name = "🟢 MOUNT YACAPE",
    Callback = function()
        Rayfield:Notify({Title="Executing", Content="Loading MOUNT YACAPE...", Duration=4})
        loadstring(game:HttpGet("https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/main/RullzsyHUB%20-%20MOUNT%20YACAPE/main.lua"))()
    end
})

-- 9. MOUNT YUKARI
ScriptTab:CreateButton({
    Name = "🟢 MOUNT YUKARI",
    Callback = function()
        Rayfield:Notify({Title="Executing", Content="Loading MOUNT YUKARI...", Duration=4})
        loadstring(game:HttpGet("https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/main/RullzsyHUB%20-%20MOUNT%20YUKARI/main.lua"))()
    end
})

-- 10. NIGHTMARE EXPEDITION
ScriptTab:CreateButton({
    Name = "🟢 NIGHTMARE EXPEDITION",
    Callback = function()
        Rayfield:Notify({Title="Executing", Content="Loading NIGHTMARE EXPEDITION...", Duration=4})
        loadstring(game:HttpGet("https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/main/RullzsyHUB%20-%20MOUNT%20NIGHTMARE%20EXPEDITION/main.lua"))()
    end
})

-- 11. MOUNT YAHAYUK
ScriptTab:CreateButton({
    Name = "🟢 MOUNT YAHAYUK (NEW)",
    Callback = function()
        Rayfield:Notify({Title="Executing", Content="Loading MOUNT YAHAYUK...", Duration=4})
        loadstring(game:HttpGet("https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/main/RullzsyHUB%20-%20MOUNT%20YAHAYUK%20V1/main.lua"))()
    end
})

-- 12. MOUNT YNTKTS
ScriptTab:CreateButton({
    Name = "🟢 MOUNT YNTKTS",
    Callback = function()
        Rayfield:Notify({Title="Executing", Content="Loading MOUNT YNTKTS...", Duration=4})
        loadstring(game:HttpGet("https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/main/RullzsyHUB%20-%20MOUNT%20YNTKTS/main.lua"))()
    end
})

-- 13. MOUNT DAUN
ScriptTab:CreateButton({
    Name = "🟢 MOUNT DAUN",
    Callback = function()
        Rayfield:Notify({Title="Executing", Content="Loading MOUNT DAUN...", Duration=4})
        loadstring(game:HttpGet("https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/main/RullzsyHUB%20-%20MOUNT%20DAUN/main.lua"))()
    end
})

-- 14. MOUNT KAWAH EXPEDITION
ScriptTab:CreateButton({
    Name = "🟢 MOUNT KAWAH EXPEDITION",
    Callback = function()
        Rayfield:Notify({Title="Executing", Content="Loading MOUNT KAWAH EXPEDITION...", Duration=4})
        loadstring(game:HttpGet("https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/main/RullzsyHUB%20-%20MOUNT%20KAWAH%20EXPEDITION/main.lua"))()
    end
})

-- ===========================================================
-- TAB MENU : PRIVATE SERVER
-- ===========================================================
local PrivateTab = Window:CreateTab("Private Server", 4483362458)
PrivateTab:CreateSection("🛡 CREATE PRIVATE SERVER")

PrivateTab:CreateButton({
    Name = "🛠 CREATE PRIVATE SERVER",
    Callback = function()
        Rayfield:Notify({Title="Bypass Private Server", Content="Menjalankan script bypass...", Duration=3})
        loadstring(game:HttpGet("https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/main/RullzsyHUB%20-%20PRIVATE%20SERVER/main.lua"))()
    end
})

PrivateTab:CreateSection("🛡 JOIN PRIVATE SERVER")

local authCode = ""

PrivateTab:CreateInput({
    Name = "🔒 Auth Code Server",
    PlaceholderText = "Masukkan kode auth di sini...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        authCode = Text
    end
})

PrivateTab:CreateButton({
    Name = "🚀 JOIN PRIVATE SERVER",
    Callback = function()
        if authCode == "" then
            Rayfield:Notify({Title="⚠️ Gagal Join", Content="Auth code tidak boleh kosong!", Duration=3})
            return
        end

        Rayfield:Notify({Title="⏳ Proses Join...", Content="Mencoba bergabung ke server...", Duration=2})
        local success, err = pcall(function()
            game:GetService("RobloxReplicatedStorage").ContactListIrisInviteTeleport:FireServer(tostring(game.PlaceId), "", authCode)
        end)

        if success then
            Rayfield:Notify({Title="✅ Berhasil Join", Content="Kamu berhasil masuk ke private server.", Duration=3})
        else
            Rayfield:Notify({Title="❌ Gagal Join", Content="Server tidak ditemukan atau kode salah.", Duration=4})
        end
    end
})

-- ===========================================================
-- NOTIFIKASI SAAT LOAD
-- ===========================================================
Rayfield:Notify({
    Image = "badge-info",
    Title = "RullzsyHUB Loader",
    Content = "Berhasil di-load sepenuhnya.",
    Duration = 7
})
