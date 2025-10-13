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
-- TAB MENU : INFORMASI
-- =========================================================== =
local InfoTab = Window:CreateTab("Maintenance Info", 4483362458)

InfoTab:CreateParagraph({
    Title = "⚙️ Maintenance Sedang Berlangsung",
    Content = table.concat({
        "Halo pengguna RullzsyHUB 👋",
        "",
        "Saat ini seluruh fitur dan script sedang dalam tahap *maintenance*.",
        "Proses ini bertujuan untuk memperbaiki bug serta meningkatkan performa sistem.",
        "",
        "🕒 Estimasi waktu: 1–2 hari.",
        "",
        "Mohon bersabar hingga maintenance selesai.",
        "Informasi terbaru akan diumumkan melalui update script ini.",
        "",
        "Terima kasih atas pengertiannya 🙏"
    }, "\n")
})

-- =========================================================== =
-- NOTIFIKASI SAAT LOAD
-- =========================================================== =
Rayfield:Notify({
    Title = "RullzsyHUB Loader (Maintenance Mode)",
    Content = "Script sedang dalam perbaikan. Silakan cek kembali dalam 1–2 hari.",
    Duration = 6,
})
