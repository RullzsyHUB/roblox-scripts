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
-- TAB MENU
-- =========================================================== =
local MainTab = Window:CreateTab("List Scripts", 4483362458)

-- =========================================================== =
-- 🔰 BYPASS PRIVATE SERVER
-- =========================================================== =
MainTab:CreateSection("🔰 Bypass Private Server")

MainTab:CreateParagraph({
    Title = "💡 Cara Penggunaan",
    Content = table.concat({
        "1. Masuk ke server yang tersedia pada script di bawah.",
        "2. Execute script loader ini.",
        "3. Klik tombol 'RUN BYPASS PRIVATE SERVER'.",
        "4. Tunggu sekitar 1 menit dan bypass akan aktif otomatis.",
    }, "\n")
})

MainTab:CreateButton({
    Name = "🛡️ RUN BYPASS PRIVATE SERVER",
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
-- 🟢 SCRIPT SUDAH RILIS (MAP BIASA)
-- =========================================================== =
MainTab:CreateSection("🟢 Script Rilis")

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
-- MOUNT YAHAYUK
-- =========================================================== =
MainTab:CreateSection("🟢 Script Rilis (Yahayuk)")

local YahyaScripts = {
    {
        Name = "MOUNT YAHAYUK 🟢",
        Description = "Beberapa fitur di hilangkan seperti loop, sama auto injek checkpoint, jadi sekarang sistem nya injek checkpoint manual.",
        URL = "https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/refs/heads/main/RullzsyHUB%20-%20MOUNT%20YAHAYUK/main.lua",
    },
}

for _, script in ipairs(YahyaScripts) do
    MainTab:CreateButton({
        Name = script.Name,
        Callback = function()
            Rayfield:Notify({
                Title = "Executing Script",
                Content = script.Description,
                Duration = 5,
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
-- 🟠 SCRIPT DALAM TAHAP UPDATE / MAINTENANCE
-- =========================================================== =
MainTab:CreateSection("🟠 Script Dalam Update / Maintenance")

local UpdatingScripts = {
    "MOUNT STECU",
}

for _, name in ipairs(UpdatingScripts) do
    MainTab:CreateButton({
        Name = "🟠 SCRIPT " .. name,
        Callback = function()
            Rayfield:Notify({
                Title = "Maintenance Mode",
                Content = "Script " .. name .. " sedang dalam tahap update / maintenance.\nUntuk sementara tidak dapat diakses.",
                Duration = 3,
                Image = 4483362458,
                Actions = { Ignore = { Name = "Okay!", Callback = function() end } },
            })
        end,
    })
end

-- =========================================================== =
-- INFO SECTION
-- =========================================================== =
MainTab:CreateSection("Information")

MainTab:CreateParagraph({
    Title = "📌 Panduan Penggunaan",
    Content = table.concat({
        "Silakan pilih salah satu script yang tersedia di atas untuk digunakan.",
        "",
        "🟢 = Script sudah rilis & bisa dijalankan.",
        "🟠 = Script sedang dalam tahap update / maintenance (tidak bisa dijalankan)."
    }, "\n")
})

-- =========================================================== =
-- NOTIFIKASI SAAT LOAD
-- =========================================================== =
Rayfield:Notify({
    Title = "RullzsyHUB Loader!",
    Content = "Selamat datang! Silahkan pilih salah satu menu di atas.",
    Duration = 5,
    Image = 4483362458,
    Actions = {
        Ignore = { Name = "Got it!", Callback = function() end },
    },
})
