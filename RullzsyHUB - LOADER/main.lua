print([[
 _______             __  __                                __    __  __    __  _______                                
|       \           |  \|  \                              |  \  |  \|  \  |  \|       \                               
| $$$$$$$\ __    __ | $$| $$ ________   _______  __    __ | $$  | $$| $$  | $$| $$$$$$$\                              
| $$__| $$|  \  |  \| $$| $$|        \ /       \|  \  |  \| $$__| $$| $$  | $$| $$__/ $$                              
| $$    $$| $$  | $$| $$| $$ \$$$$$$$$|  $$$$$$$| $$  | $$| $$    $$| $$  | $$| $$    $$                              
| $$$$$$$\| $$  | $$| $$| $$  /    $$  \$$    \ | $$  | $$| $$$$$$$$| $$  | $$| $$$$$$$\                              
| $$  | $$| $$__/ $$| $$| $$ /  $$$$_  _\$$$$$$\| $$__/ $$| $$  | $$| $$__/ $$| $$__/ $$                              
| $$  | $$ \$$    $$| $$| $$|  $$    \|       $$ \$$    $$| $$  | $$ \$$    $$| $$    $$                              
 \$$   \$$  \$$$$$$  \$$ \$$ \$$$$$$$$ \$$$$$$$  _\$$$$$$$ \$$   \$$  \$$$$$$  \$$$$$$$                               
                                                |  \__| $$                                                            
                                                 \$$    $$                                                            
                                                  \$$$$$$                                                             
  ______                       __             __            __                                 __                     
 /      \                     |  \           |  \          |  \                               |  \                    
|  $$$$$$\  _______   ______   \$$  ______  _| $$_         | $$       ______    ______    ____| $$  ______    ______  
| $$___\$$ /       \ /      \ |  \ /      \|   $$ \        | $$      /      \  |      \  /      $$ /      \  /      \ 
 \$$    \ |  $$$$$$$|  $$$$$$\| $$|  $$$$$$\\$$$$$$        | $$     |  $$$$$$\  \$$$$$$\|  $$$$$$$|  $$$$$$\|  $$$$$$\
 _\$$$$$$\| $$      | $$   \$$| $$| $$  | $$ | $$ __       | $$     | $$  | $$ /      $$| $$  | $$| $$    $$| $$   \$$
|  \__| $$| $$_____ | $$      | $$| $$__/ $$ | $$|  \      | $$_____| $$__/ $$|  $$$$$$$| $$__| $$| $$$$$$$$| $$      
 \$$    $$ \$$     \| $$      | $$| $$    $$  \$$  $$      | $$     \\$$    $$ \$$    $$ \$$    $$ \$$     \| $$      
  \$$$$$$   \$$$$$$$ \$$       \$$| $$$$$$$    \$$$$        \$$$$$$$$ \$$$$$$   \$$$$$$$  \$$$$$$$  \$$$$$$$ \$$      
                                  | $$                                                                                
                                  | $$                                                                                
                                   \$$                                                                                
]])

-- =========================================================== =
-- LOAD LIBRARY UI (Resmi dari Sirius)
-- =========================================================== =
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- =========================================================== =
-- WINDOW SETUP
-- =========================================================== =
local Window = Rayfield:CreateWindow({
    Name = "RullzsyHUB | Script Loader",
    LoadingTitle = "Created By RullzsyHUB",
    LoadingSubtitle = "Follow Tiktok: @rullzsy99",
    ConfigurationSaving = {
        Enabled = false
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

-- =========================================================== =
-- TAB MENU : LIST SCRIPT
-- =========================================================== =
local MainTab = Window:CreateTab("List Scripts", 4483362458)

MainTab:CreateSection("🟢 All Script: 10")

local ReleasedScripts = {
    { Name = "MOUNT ATIN", URL = "https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/refs/heads/main/RullzsyHUB%20-%20MOUNT%20ATIN/main.lua" },
    { Name = "MOUNT YNTKTS", URL = "https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/refs/heads/main/RullzsyHUB%20-%20MOUNT%20YNTKTS/main.lua" },
    { Name = "MOUNT ARUNIKA", URL = "https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/refs/heads/main/RullzsyHUB%20-%20MOUNT%20ARUNIKA/main.lua" },
    { Name = "MOUNT YUKARI", URL = "https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/refs/heads/main/RullzsyHUB%20-%20MOUNT%20YUKARI/main.lua" },
    { Name = "MOUNT PENGANGGURAN", URL = "https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/refs/heads/main/RullzsyHUB%20-%20MOUNT%20PENGANGGURAN/main.lua" },
    { Name = "MOUNT YAHAYUK", URL = "https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/refs/heads/main/RullzsyHUB%20-%20MOUNT%20YAHAYUK/main.lua" },
    { Name = "MOUNT HMMM", URL = "https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/refs/heads/main/RullzsyHUB%20-%20MOUNT%20HMMM/main.lua" },
    { Name = "MOUNT STECU", URL = "https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/refs/heads/main/RullzsyHUB%20-%20MOUNT%20STECU/main.lua" },
    { Name = "MOUNT NIGHTMARE EXPEDITION", URL = "https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/refs/heads/main/RullzsyHUB%20-%20MOUNT%20NIGHTMARE%20EXPEDITION/main.lua" },
    { Name = "MOUNT YACAPE", URL = "https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/refs/heads/main/RullzsyHUB%20-%20MOUNT%20YACAPE/main.lua" },
    { Name = "MOUNT PARGOY", URL = "https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/refs/heads/main/RullzsyHUB%20-%20MOUNT%20PARGOY/main.lua" },
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

-- =========================================================== =
-- TAB MENU : PRIVATE SERVER
-- =========================================================== =
local PrivateServerTab = Window:CreateTab("Private Server", 4483362458)

local authCode = ""
local placeId = tostring(game.PlaceId)

-- =========================================================== =
-- 🛡️ CREATE PRIVATE SERVER
-- =========================================================== =
PrivateServerTab:CreateSection("🛡️ CREATE PRIVATE SERVER")

PrivateServerTab:CreateParagraph({
    Title = "📘 Panduan Membuat Server",
    Content = table.concat({
        "Ikuti langkah-langkah di bawah ini untuk membuat private server.",
        "",
        "Langkah-langkah:",
        "1. Pastikan kamu sudah berada di dalam game yang ingin dimainkan.",
        "2. Tekan tombol *CREATE PRIVATE SERVER* di bawah.",
        "3. Tunggu beberapa detik hingga proses selesai.",
        "4. Setelah berhasil, *Auth Key* server kamu akan otomatis tersalin ke clipboard.",
        "",
        "Bagikan *Auth Key* ini ke teman yang ingin kamu ajak bergabung ke servermu.",
        "",
        "⚡ Script ini akan membuat server privat tanpa perlu membayar Robux.",
    }, "\n")
})

PrivateServerTab:CreateButton({
    Name = "🛠️ CREATE PRIVATE SERVER",
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

-- =========================================================== =
-- 🛡️ JOIN PRIVATE SERVER
-- =========================================================== =
PrivateServerTab:CreateSection("🛡️ JOIN PRIVATE SERVER")

PrivateServerTab:CreateParagraph({
    Title = "📗 Panduan Bergabung ke Server",
    Content = table.concat({
        "Ikuti langkah-langkah di bawah ini untuk bergabung ke server privat teman kamu.",
        "",
        "Langkah-langkah:",
        "1. Pastikan host (teman kamu) sudah membuat *Private Server* menggunakan tombol di atas.",
        "2. Setelah server dibuat, host akan menerima *Auth Key* yang otomatis tersalin ke clipboard.",
        "3. Minta host untuk mengirimkan *Auth Key* tersebut kepadamu.",
        "4. Masukkan *Auth Key* ke kolom input di bawah ini.",
        "5. Klik tombol *JOIN PRIVATE SERVER* untuk mulai bergabung.",
        "",
        "✨ Setelah itu, sistem akan memproses dan langsung menghubungkanmu ke server privat tanpa perlu Robux.",
    }, "\n")
})

-- === Input Auth Code ===
PrivateServerTab:CreateInput({
    Name = "🔒 Auth Code Server",
    PlaceholderText = "Masukkan kode auth di sini...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        authCode = Text
    end
})

-- === Tombol Join Server ===
PrivateServerTab:CreateButton({
    Name = "🚀 JOIN PRIVATE SERVER",
    Callback = function()
        if authCode == "" then
            Rayfield:Notify({
                Title = "⚠️ Gagal Join",
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

-- =========================================================== =
-- NOTIFIKASI SAAT LOAD
-- =========================================================== =
Rayfield:Notify({
    Title = "RullzsyHUB Loader!",
    Content = "Selamat datang! Silakan pilih menu 'List Scripts' atau 'Private Server' untuk melanjutkan.",
    Duration = 5,
})
