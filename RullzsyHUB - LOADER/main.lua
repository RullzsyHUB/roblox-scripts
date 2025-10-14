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
-- TAB MENU : UPDATE LOG / INFO HARI INI
-- ===========================================================
local UpdateTab = Window:CreateTab("📰 Update Log", 4483362458)
UpdateTab:CreateSection("📅 Informasi Update Terbaru")

-- Kamu bisa ubah isi changelog di sini ↓↓↓
local UpdateLog = [[
📆 Update: 14 Oktober 2025

🧩 Penambahan Fitur:
- Penambahan tab "Update Log" agar user bisa tahu update terbaru.
- Penambahan Fitur Bypass AFK (Tidak Semua Map).
- Penambahan Fitur Visual.
- Penambahan Fitur Otomatis mencari checkpoin (Yahayuk V2).

🐞 Fix:
- Fix jalur mount atin.
- Fix jalur mount nightmare.
- Fix jalur mount yahayuk.
- Fix jalur mount pengangguran
- Fix jalur mount yntkts (masih proses)
- Fix jalur mount hmmm (masih proses)

🗺️ Map:
- MOUNT YAHAYUK V1 (MANUAL): Versi Stabil tapi ga ada fitur, afk, otomatis injek checkpoint, jadi harus manual.
- MOUNT YAHAYUK V2 (OTOMATIS): Versi ini masih beta dan tidak support di semua device, cuman support di beberapa device, tapi jika ingin tes silahkan.

💡 Catatan:
Silakan klik menu "List Scripts" untuk menjalankan scripts.
]]

UpdateTab:CreateParagraph({
    Title = "🧾 Update (Changelog)",
    Content = UpdateLog
})

-- ===========================================================
-- TAB MENU : LIST SCRIPT
-- ===========================================================
local MainTab = Window:CreateTab("List Scripts", 4483362458)
MainTab:CreateSection("🟢 All Script: 13")

local ReleasedScripts = {
    { Name = "MOUNT ATIN", URL = "https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/refs/heads/main/RullzsyHUB%20-%20MOUNT%20ATIN/main.lua" },
    { Name = "MOUNT ARUNIKA", URL = "https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/refs/heads/main/RullzsyHUB%20-%20MOUNT%20ARUNIKA/main.lua" },
    { Name = "MOUNT HMMM", URL = "https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/refs/heads/main/RullzsyHUB%20-%20MOUNT%20HMMM/main.lua" },
    { Name = "MOUNT PARGOY", URL = "https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/refs/heads/main/RullzsyHUB%20-%20MOUNT%20PARGOY/main.lua" },
    { Name = "MOUNT PENGANGGURAN", URL = "https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/refs/heads/main/RullzsyHUB%20-%20MOUNT%20PENGANGGURAN/main.lua" },
    { Name = "MOUNT STECU", URL = "https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/refs/heads/main/RullzsyHUB%20-%20MOUNT%20STECU/main.lua" },
    { Name = "MOUNT YACAPE", URL = "https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/refs/heads/main/RullzsyHUB%20-%20MOUNT%20YACAPE/main.lua" },
    { Name = "MOUNT YUKARI", URL = "https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/refs/heads/main/RullzsyHUB%20-%20MOUNT%20YUKARI/main.lua" },
    { Name = "NIGHTMARE EXPEDITION", URL = "https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/refs/heads/main/RullzsyHUB%20-%20MOUNT%20NIGHTMARE%20EXPEDITION/main.lua" },
    { Name = "MOUNT YAHAYUK V1 (MANUAL)", URL = "https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/refs/heads/main/RullzsyHUB%20-%20MOUNT%20YAHAYUK%20V1/main.lua" },
    { Name = "MOUNT YAHAYUK V2 (OTOMATIS) (BETA)", URL = "https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/refs/heads/main/RullzsyHUB%20-%20MOUNT%20YAHAYUK%20V2/main.lua" },
    { Name = "MOUNT YNTKTS", URL = "https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/refs/heads/main/RullzsyHUB%20-%20MOUNT%20YNTKTS/main.lua" },
    { Name = "MOUNT DAUN", URL = "https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/refs/heads/main/RullzsyHUB%20-%20MOUNT%20DAUN/main.lua" },
}

for _, script in ipairs(ReleasedScripts) do
    MainTab:CreateButton({
        Name = "🟢 " .. script.Name,
        Callback = function()
            Rayfield:Notify({
                Title = "Executing Script",
                Content = "Loading " .. script.Name .. " Script...",
                Duration = 4
            })
            task.wait(0.5)
            loadstring(game:HttpGet(script.URL))()
        end
    })
end

-- ===========================================================
-- TAB MENU : PRIVATE SERVER
-- ===========================================================
local PrivateServerTab = Window:CreateTab("Private Server", 4483362458)
local authCode = ""
local placeId = tostring(game.PlaceId)

PrivateServerTab:CreateSection("🛡 CREATE PRIVATE SERVER")

PrivateServerTab:CreateParagraph({
    Title = "📘 Panduan Membuat Server",
    Content = table.concat({
        "Ikuti langkah-langkah di bawah ini untuk membuat private server.",
        "",
        "1. Pastikan kamu sudah berada di dalam game.",
        "2. Tekan tombol CREATE PRIVATE SERVER di bawah.",
        "3. Tunggu hingga proses selesai.",
        "4. Auth Key server otomatis tersalin ke clipboard.",
        "",
        "Bagikan Auth Key ini ke teman yang ingin kamu ajak.",
        "⚡ Script ini gratis, tanpa Robux.",
    }, "\n")
})

PrivateServerTab:CreateButton({
    Name = "🛠 CREATE PRIVATE SERVER",
    Callback = function()
        Rayfield:Notify({
            Title = "Bypass Private Server",
            Content = "Menjalankan script bypass... tunggu sebentar.",
            Duration = 3,
        })
        task.wait(0.5)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/refs/heads/main/RullzsyHUB%20-%20PRIVATE%20SERVER/main.lua"))()
    end
})

PrivateServerTab:CreateSection("🛡 JOIN PRIVATE SERVER")

PrivateServerTab:CreateParagraph({
    Title = "📗 Panduan Bergabung ke Server",
    Content = table.concat({
        "1. Pastikan host sudah membuat Private Server.",
        "2. Minta Auth Key dari host.",
        "3. Masukkan Auth Key ke kolom di bawah.",
        "4. Klik tombol JOIN untuk bergabung.",
    }, "\n")
})

PrivateServerTab:CreateInput({
    Name = "🔒 Auth Code Server",
    PlaceholderText = "Masukkan kode auth di sini...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        authCode = Text
    end
})

PrivateServerTab:CreateButton({
    Name = "🚀 JOIN PRIVATE SERVER",
    Callback = function()
        if authCode == "" then
            Rayfield:Notify({
                Title = "⚠ Gagal Join",
                Content = "Auth code tidak boleh kosong!",
                Duration = 3
            })
            return
        end

        Rayfield:Notify({
            Title = "⏳ Proses Join...",
            Content = "Sedang mencoba bergabung ke server...",
            Duration = 2
        })

        local success, err = pcall(function()
            game:GetService("RobloxReplicatedStorage").ContactListIrisInviteTeleport:FireServer(placeId, "", authCode)
        end)

        if success then
            Rayfield:Notify({
                Title = "✅ Berhasil Join!",
                Content = "Kamu berhasil masuk ke private server.",
                Duration = 3
            })
        else
            Rayfield:Notify({
                Title = "❌ Gagal Join!",
                Content = "Server tidak ditemukan atau kode auth salah.",
                Duration = 4
            })
        end
    end
})

-- ===========================================================
-- NOTIFIKASI SAAT LOAD
-- ===========================================================
Rayfield:Notify({
    Image = "badge-info",
    Title = "📰 Update Hari Ini",
    Content = "Cek tab 'Update Log' untuk melihat update, bug fix, dan map baru!",
    Duration = 7
})
