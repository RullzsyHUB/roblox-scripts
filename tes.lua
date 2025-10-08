-- Load UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Deteksi mobile
local UserInputService = game:GetService("UserInputService")
local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

-- Create Window
local Window = Rayfield:CreateWindow({
   Name = "Rayfield Example Window",
   Icon = 0,
   LoadingTitle = "Rayfield Interface Suite",
   LoadingSubtitle = "by Sirius",
   ShowText = "Rayfield",
   Theme = "Default",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
})

-- Tab Menu
local Tab = Window:CreateTab("Tab Example", 4483362458)

-- Contoh Button
local Button = Tab:CreateButton({
   Name = "Button Example",
   Callback = function()
      print("Button pressed")
   end,
})

-- ====== Tambahan: Penyesuaian Ukuran UI untuk Mobile ======

-- Fungsi untuk skala UI
local function adjustUIForScreen()
   -- Cari GUI utama Rayfield (namanya bisa berbeda tergantung versi)
   local playerGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
   if not playerGui then return end

   -- Coba cari ScreenGui Rayfield (nama bisa berbeda)
   local rayfieldGui = playerGui:FindFirstChild("Rayfield") or playerGui:FindFirstChild("RayfieldGui")
   if not rayfieldGui then return end

   local absSize = rayfieldGui.AbsoluteSize
   -- Misal kita ingin container Rayfield punya lebar max 60% dari layar jika mobile
   if isMobile then
      -- Temukan frame utama Rayfield
      local mainFrame = rayfieldGui:FindFirstChild("Main") or rayfieldGui:FindFirstChild("Container") 
      -- (nama “Main” / “Container” hanya contoh — kamu perlu menyesuaikan dengan struktur bawaan Rayfield kamu)
      if mainFrame and mainFrame:IsA("GuiObject") then
         mainFrame.Size = UDim2.new(0.6, 0, 0.8, 0)  -- 60% lebar, 80% tinggi
         mainFrame.Position = UDim2.new(0.2, 0, 0.1, 0)  -- jadi ada margin kiri, atas
      end
   else
      -- Jika bukan mobile, kamu bisa set default atau biarkan lib bawaan
      -- (boleh dikosongkan atau diatur sesuai keinginan)
   end
end

-- Sambungkan ke event perubahan ukuran GUI
local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local rayfieldGui = playerGui:WaitForChild("Rayfield") or playerGui:WaitForChild("RayfieldGui")
if rayfieldGui then
   rayfieldGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(adjustUIForScreen)
end

-- Jalankan sekali saat inisialisasi
adjustUIForScreen()
