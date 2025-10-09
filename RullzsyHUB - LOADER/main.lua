-- =========================================================== =
-- LOAD LIBRARY UI
-- =========================================================== =
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/refs/heads/main/UI%20Liblary/Rayfield.lua'))()

-- =========================================================== =
-- WINDOW SETUP
-- =========================================================== =
local Window = Rayfield:CreateWindow({
    Name = "RullzsyHUB | Script Loader",
    LoadingTitle = "Created By RullzsyHUB",
    LoadingSubtitle = "Follow Tiktok: @rullzsy99",
})

-- =========================================================== =
-- TAB MENU : LIST SCRIPT
-- =========================================================== =
local MainTab = Window:CreateTab("List Scripts", 4483362458)

-- =========================================================== =
-- 🟢 SCRIPT SUDAH RILIS (MAP BIASA)
-- =========================================================== =
MainTab:CreateSection("🟢 All Script: 8")

local ReleasedScripts = {
    {
        Name = "MOUNT ATIN",
        URL = "https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/refs/heads/main/RullzsyHUB%20-%20MOUNT%20ATIN/main.lua",
    },
    {
        Name = "MOUNT YNTKTS",
        URL = "https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/refs/heads/main/RullzsyHUB%20-%20MOUNT%20YNTKTS/main.lua",
    },
    {
        Name = "MOUNT ARUNIKA",
        URL = "https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/refs/heads/main/RullzsyHUB%20-%20MOUNT%20ARUNIKA/main.lua",
    },
    {
        Name = "MOUNT YUKARI",
        URL = "https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/refs/heads/main/RullzsyHUB%20-%20MOUNT%20YUKARI/main.lua",
    },
    {
        Name = "MOUNT PENGANGGURAN",
        URL = "https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/refs/heads/main/RullzsyHUB%20-%20MOUNT%20PENGANGGURAN/main.lua",
    },
    {
        Name = "MOUNT YAHAYUK",
        URL = "https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/refs/heads/main/RullzsyHUB%20-%20MOUNT%20YAHAYUK/main.lua",
    },
    {
        Name = "MOUNT HMMM",
        URL = "https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/refs/heads/main/RullzsyHUB%20-%20MOUNT%20HMMM/main.lua",
    },
    {
        Name = "MOUNT STECU",
        URL = "https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/refs/heads/main/RullzsyHUB%20-%20MOUNT%20STECU/main.lua",
    },
}

for _, script in ipairs(ReleasedScripts) do
    MainTab:CreateButton({
        Name = "🟢 " .. script.Name,
        Callback = function()
            Rayfield:Notify({
                Title = "Executing Script",
                Content = "Loading " .. script.Name .. " Script...",
                Duration = 4,
                Image = 4483362458,
                Actions = { Ignore = { Name = "Okay!", Callback = function() end } },
            })

            task.wait(0.5)
            Rayfield:Destroy()
            loadstring(game:HttpGet(script.URL))()
        end,
    })
end

-- =========================================================== =
-- TAB MENU : PRIVATE SERVER
-- =========================================================== =
local PrivateServerTab = Window:CreateTab("Private Server", 4483362458)

PrivateServerTab:CreateSection("🛡️ PRIVATE SERVER")

PrivateServerTab:CreateParagraph({
    Title = "💡 Cara Penggunaan",
    Content = table.concat({
        "Untuk membuat Private Server cukup tekan tombol di bawah ini.",
        "",
        "Langkah-langkah:",
        "1. Pastikan kamu sudah berada di dalam server yang ingin kamu mainkan.",
        "2. Klik tombol 'CREATE PRIVATE SERVER' di bawah.",
        "3. Tunggu proses pembuatan private server hingga selesai.",
        "",
        "Script akan otomatis memproses dan menjalankan server private tanpa perlu bayar dengan robux.",
    }, "\n")
})

PrivateServerTab:CreateButton({
    Name = "🛠️ CREATE PRIVATE SERVER",
    Callback = function()
        Rayfield:Notify({
            Title = "Bypass Private Server",
            Content = "Menjalankan script bypass... tunggu sebentar.",
            Duration = 3,
            Image = 4483362458,
            Actions = { Ignore = { Name = "Okay!", Callback = function() end } },
        })

        task.wait(0.5)
        Rayfield:Destroy()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/refs/heads/main/RullzsyHUB%20-%20PRIVATE%20SERVER/main.lua"))()
    end,
})

-- =========================================================== =
-- NOTIFIKASI SAAT LOAD
-- =========================================================== =
Rayfield:Notify({
    Title = "RullzsyHUB Loader!",
    Content = "Selamat datang! Silahkan pilih menu 'List Scripts' atau 'Private Server' untuk melanjutkan.",
    Duration = 5,
    Image = 4483362458,
    Actions = {
        Ignore = { Name = "Got it!", Callback = function() end },
    },
})
