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
MainTab:CreateSection("Scripts Tersedia")

-- =========================================================== =
-- 🟢 SCRIPT SUDAH RILIS
-- =========================================================== =
local ReleasedScripts = {
    {
        Name = "MOUNT ATIN",
        URL = "https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/refs/heads/main/RullzsyHUB%20-%20MOUNT%20ATIN/main.lua",
    },
    {
        Name = "MOUNT YNTKTS",
        URL = "https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/refs/heads/main/RullzsyHUB%20-%20MOUNT%20YNTKTS/main.lua",
    },
}

for _, script in ipairs(ReleasedScripts) do
    MainTab:CreateButton({
        Name = "🟢 SCRIPT " .. script.Name,
        Callback = function()
            Rayfield:Notify({
                Title = "Executing Script",
                Content = "Loading " .. script.Name .. " Script...",
                Duration = 2,
                Image = 4483362458,
                Actions = {
                    Ignore = { Name = "Okay!", Callback = function() end },
                },
            })

            task.wait(0.5)
            Rayfield:Destroy()

            -- Jalankan Script
            loadstring(game:HttpGet(script.URL))()
        end,
    })
end

-- =========================================================== =
-- 🟠 SCRIPT DALAM TAHAP UPDATE / MAINTENANCE
-- =========================================================== =
local UpdatingScripts = {
    "MOUNT YAHAYUK",
    "MOUNT ARUNIKA",
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
                Actions = {
                    Ignore = { Name = "Okay!", Callback = function() end },
                },
            })
        end,
    })
end

-- =========================================================== =
-- 🔴 SCRIPT BELUM RILIS
-- =========================================================== =
local UnreleasedScripts = {
    "MOUNT LEMBAYANA",
    "MOUNT DAUN",
    "MOUNT RAVIKA",
    "ANTARTIKA EXPEDITION",
    "MOUNT SAKAHAYANG",
    "MOUNT HANA",
    "MOUNT CKPTW",
    "MOUNT KALISTA",
}

for _, name in ipairs(UnreleasedScripts) do
    MainTab:CreateButton({
        Name = "🔴 SCRIPT " .. name,
        Callback = function()
            Rayfield:Notify({
                Title = "Script Belum Rilis",
                Content = "Script " .. name .. " belum tersedia.",
                Duration = 3,
                Image = 4483362458,
                Actions = {
                    Ignore = { Name = "Okay!", Callback = function() end },
                },
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
        "🟠 = Script sedang dalam tahap update / maintenance.",
        "🔴 = Script belum rilis (coming soon)."
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
