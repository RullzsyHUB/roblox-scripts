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
local Section = MainTab:CreateSection("Scripts Tersedia")

-- =========================================================== =
-- 🟢 SCRIPT SUDAH RILIS (BISA DIEKSEKUSI)
-- =========================================================== =
local Button = MainTab:CreateButton({
   Name = "🟢 SCRIPT MOUNT ATIN",
   Callback = function()
      Rayfield:Notify({
         Title = "Executing Script",
         Content = "Loading Mount Atin Script...",
         Duration = 2,
         Image = 4483362458,
         Actions = { Ignore = { Name = "Okay!", Callback = function() end } },
      })

      task.wait(0.5)
      Rayfield:Destroy()

      -- Jalankan Script Mount Atin
      loadstring(game:HttpGet("https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/refs/heads/main/RullzsyHUB%20-%20MOUNT%20ATIN/main.lua"))()
   end,
})

-- =========================================================== =
-- 🟠 SCRIPT DALAM TAHAP UPDATE (TIDAK BISA DIEKSEKUSI)
-- =========================================================== =
local UpdatingScripts = {
   "MOUNT YAHAYUK",
   "MOUNT STECU",
   "MOUNT YNTKTS",
}

for _, name in ipairs(UpdatingScripts) do
   MainTab:CreateButton({
      Name = "🟠 SCRIPT " .. name,
      Callback = function()
         Rayfield:Notify({
            Title = "Script Sedang Diperbarui",
            Content = "Script " .. name .. " sedang dalam tahap update. Mohon tunggu hingga versi terbaru dirilis.",
            Duration = 3,
            Image = 4483362458,
            Actions = { Ignore = { Name = "Okay!", Callback = function() end } },
         })
      end,
   })
end

-- =========================================================== =
-- 🔴 SCRIPT BELUM RILIS (COMING SOON)
-- =========================================================== =
local UnreleasedScripts = {
   "MOUNT LEMBAYANA",
   "MOUNT DAUN",
   "MOUNT ARUNIKA",
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
            Actions = { Ignore = { Name = "Okay!", Callback = function() end } },
         })
      end,
   })
end

-- =========================================================== =
-- INFO SECTION
-- =========================================================== =
local InfoSection = MainTab:CreateSection("Information")

local Paragraph = MainTab:CreateParagraph({
   Title = "📌 Panduan Penggunaan",
   Content = table.concat({
      "Silakan pilih salah satu script yang tersedia di atas untuk digunakan.",
      "",
      "🟢  = Script sudah rilis & bisa dijalankan.",
      "🟠  = Script sedang dalam tahap update (belum bisa dijalankan).",
      "🔴  = Script belum rilis (coming soon)."
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
