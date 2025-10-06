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
                    Ignore = { Name = "Okay!", Callback = function() end }
                },
            })

            task.wait(0.5)
            Rayfield:Destroy()

            -- Jalankan Script
           
