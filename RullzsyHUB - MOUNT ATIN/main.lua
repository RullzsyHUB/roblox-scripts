	-------------------------------------------------------------
-- LOAD LIBRARY UI
-------------------------------------------------------------
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/refs/heads/main/UI%20Liblary/Rayfield.lua'))()

-------------------------------------------------------------
-- WINDOW PROCESS
-------------------------------------------------------------
local Window = Rayfield:CreateWindow({
   Name = "RullzsyHUB | MOUNT ATIN",
   Icon = "braces",
   LoadingTitle = "Created By RullzsyHUB",
   LoadingSubtitle = "Follow Tiktok: @rullzsy99",
})

-------------------------------------------------------------
-- TAB MENU
-------------------------------------------------------------
local AccountTab = Window:CreateTab("Account", "user")
local AutoWalkTab = Window:CreateTab("Auto Walk", "bot")
local TeleportTab = Window:CreateTab("Teleport", "layers")
local RunAnimationTab = Window:CreateTab("Run Animation", "person-standing")
local UpdateTab = Window:CreateTab("Update Script", "file")
local CreditsTab = Window:CreateTab("Credits", "scroll-text")

-------------------------------------------------------------
-- SERVICES
-------------------------------------------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-------------------------------------------------------------
-- IMPORT
-------------------------------------------------------------
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local setclipboard = setclipboard or toclipboard


-------------------------------------------------------------
-- ACCOUNT
-------------------------------------------------------------
-- Api Config
local API_CONFIG = {
    base_url = "https://monotonal-unhoneyed-rita.ngrok-free.dev",
    get_user_endpoint = "/get_user.php",
}

-- File config (sama dengan auth script)
local FILE_CONFIG = {
    folder = "RullzsyHUB",
    subfolder = "auth",
    filename = "token.dat"
}

local function getAuthFilePath()
    return FILE_CONFIG.folder .. "/" .. FILE_CONFIG.subfolder .. "/" .. FILE_CONFIG.filename
end

-- Load token from file
local function loadToken()
    local success, result = pcall(function()
        if not isfile(getAuthFilePath()) then
            return nil
        end
        
        local content = readfile(getAuthFilePath())
        local data = HttpService:JSONDecode(content)
        
        -- Verify username matches
        if data.username == LocalPlayer.Name then
            print("[ACCOUNT] Token loaded from file")
            return data.token
        else
            print("[ACCOUNT] Username mismatch")
            return nil
        end
    end)
    
    if success then
        return result
    else
        warn("[ACCOUNT] Failed to load token: " .. tostring(result))
        return nil
    end
end

-- Fungsi HTTP aman
local function safeHttpRequest(url, method, data, headers)
    method = method or "GET"
    local requestData = { Url = url, Method = method }

    if headers then requestData.Headers = headers end
    if data and method == "POST" then requestData.Body = data end

    local ok, res = pcall(function() return HttpService:RequestAsync(requestData) end)
    if ok and res and res.Success and res.StatusCode == 200 then
        return true, res.Body
    end

    if method == "GET" then
        local ok2, res2 = pcall(function() return HttpService:GetAsync(url, false) end)
        if ok2 and res2 then return true, res2 end
        local ok3, res3 = pcall(function() return game:HttpGet(url) end)
        if ok3 and res3 then return true, res3 end
    end

    return false, tostring(res)
end

-- Get token from multiple sources (priority order)
local function getToken()
    -- Priority 1: File system (most reliable)
    local fileToken = loadToken()
    if fileToken and fileToken ~= "" then
        print("[ACCOUNT] Using token from file")
        return fileToken
    end
    
    -- Priority 2: getgenv (for compatibility)
    local envToken = getgenv().UserToken
    if envToken and envToken ~= "" then
        print("[ACCOUNT] Using token from getgenv")
        return envToken
    end
    
    print("[ACCOUNT] No token found")
    return nil
end

local userData = {
    username = "Guest",
    role = "Member",
    expire_timestamp = os.time()
}

-- UI
local HeaderSection = AccountTab:CreateSection("Informasi Akun")
local InfoParagraph = AccountTab:CreateParagraph({
    Title = "📊 Akun Status",
    Content = "🔄 Menginisialisasi...\n⏳ Tunggu sebentar..."
})

local BuyInfoParagraph = AccountTab:CreateParagraph({
    Title = "💡 Ingin beli kunci nya lagi?",
    Content = "Silahkan untuk membuat ticket di discord"
})

-- Format waktu realtime
local function formatTimeRealtime(seconds)
    if seconds <= 0 then return "Expired" end
    local days = math.floor(seconds / 86400)
    local hours = math.floor((seconds % 86400) / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = math.floor(seconds % 60)
    return string.format("%d Hari | %02d Jam | %02d Menit | %02d Detik", days, hours, minutes, secs)
end

local function getExpiryStatusRealtime(expireTimestamp)
    local remaining = expireTimestamp - os.time()
    local emoji = "🟢"

    if remaining <= 0 then
        emoji = "🔴"
        return emoji, "Expired"
    elseif remaining <= 86400 then -- kurang dari 1 hari
        emoji = "🟠"
    elseif remaining <= 259200 then -- kurang dari 3 hari
        emoji = "🟠"
    end

    return emoji, formatTimeRealtime(remaining)
end

-- Update data akun
local function updateAccountInfo()
    local savedToken = getToken()
    
    if not savedToken or savedToken == "" then
        InfoParagraph:Set({
            Title = "🚫 Tidak Ada Token",
            Content = "❌ Kamu belum login atau token tidak ditemukan.\n\n💡 Silakan lakukan authentication terlebih dahulu.\n\n📍 Token dicari dari:\n  1. File: RullzsyHUB/auth/token.dat\n  2. Memory: getgenv().UserToken"
        })
        return
    end

    InfoParagraph:Set({
        Title = "🔄 Memuat Data Akun",
        Content = "⏳ Menghubungkan ke server...\n📡 Mendapatkan informasi akun Anda...\n🔐 Token ditemukan!"
    })

    local encodedToken = HttpService:UrlEncode(tostring(savedToken))
    local url = API_CONFIG.base_url .. API_CONFIG.get_user_endpoint .. "?token=" .. encodedToken
    local headers = {
        ["Content-Type"] = "application/json",
        ["User-Agent"] = "Roblox/WinInet",
        ["ngrok-skip-browser-warning"] = "true"
    }

    local ok, res = safeHttpRequest(url, "GET", nil, headers)
    if not ok then
        InfoParagraph:Set({
            Title = "🚨 Connection Error",
            Content = "❌ Gagal terhubung ke server.\n🌐 Cek koneksi internet Anda.\n\n🔧 Error: " .. tostring(res)
        })
        return
    end

    local okDecode, data = pcall(function() return HttpService:JSONDecode(res) end)
    if not okDecode or type(data) ~= "table" then
        InfoParagraph:Set({
            Title = "🔐 Server Error",
            Content = "❌ Format response server tidak valid.\n🛠️ Silakan coba lagi nanti.\n\n🔧 Debug: Invalid JSON"
        })
        return
    end

    if data.status ~= "success" then
        local errorMsg = tostring(data.message or "Authentication failed")
        InfoParagraph:Set({
            Title = "🔐 Authentication Failed",
            Content = "❌ " .. errorMsg .. "\n\n💡 Token mungkin expired atau invalid.\n🔄 Silakan login ulang di tab Authentication."
        })
        return
    end

    -- Simpan data user
    userData.username = tostring(data.name or "Unknown")
    userData.role = tostring(data.role or "Member")
    userData.expire_timestamp = tonumber(data.expire_timestamp) or (os.time() + 86400)

    print("[ACCOUNT] User data loaded:")
    print("  Username: " .. userData.username)
    print("  Role: " .. userData.role)
    print("  Expire: " .. os.date("%Y-%m-%d %H:%M:%S", userData.expire_timestamp))

    -- Realtime update
    RunService.Heartbeat:Connect(function()
        local emoji, timeStr = getExpiryStatusRealtime(userData.expire_timestamp)
        InfoParagraph:Set({
            Title = "👨🏻‍💼 Welcome, " .. userData.username,
            Content = string.format(
                "🏷️ Role         : %s\n⏰ Expire       : %s %s\n\n✅ Token aktif dan terverifikasi!",
                userData.role,
                emoji, timeStr
            )
        })
    end)
    
    Rayfield:Notify({
        Title = "✅ Data Loaded",
        Content = "Welcome back, " .. userData.username .. "!",
        Duration = 3
    })
end

-- Buttons
local ActionsSection = AccountTab:CreateSection("Quick Actions")

AccountTab:CreateButton({
    Name = "🔄 Refresh Informasi Akun",
    Callback = function()
        Rayfield:Notify({
            Title = "🔄 Refreshing...",
            Content = "Mengambil data terbaru...",
            Duration = 2
        })
        task.wait(0.5)
        updateAccountInfo()
    end
})

AccountTab:CreateButton({
    Name = "🔍 Check Token Status",
    Callback = function()
        local token = getToken()
        if token and token ~= "" then
            local maskedToken = string.sub(token, 1, 8) .. "..." .. string.sub(token, -4)
            Rayfield:Notify({
                Title = "✅ Token Found",
                Content = "Token: " .. maskedToken .. "\nLength: " .. #token .. " chars",
                Duration = 4
            })
        else
            Rayfield:Notify({
                Title = "❌ No Token",
                Content = "Token tidak ditemukan.\nSilakan login terlebih dahulu.",
                Duration = 4
            })
        end
    end
})

AccountTab:CreateButton({
    Name = "🛒 Klik disini untuk membeli kunci",
    Callback = function()
        local discordLink = "https://discord.gg/KEajwZQaRd"
        if setclipboard then
            setclipboard(discordLink)
            Rayfield:Notify({
                Title = "📋 Link Copied!",
                Content = "Link Discord disalin ke clipboard.\nJoin RullzsyHUB Discord server",
                Duration = 4
            })
        else
            Rayfield:Notify({
                Title = "🌐 Discord Link",
                Content = discordLink .. "\nJoin RullzsyHUB Discord server",
                Duration = 5
            })
        end
    end
})

-- Auto load on tab open
task.spawn(function()
    print("[ACCOUNT] Initializing account tab...")
    task.wait(2)
    updateAccountInfo()
end)

-------------------------------------------------------------
-- ACCOUNT - END
-------------------------------------------------------------


-------------------------------------------------------------
-- AUTO WALK
-------------------------------------------------------------
-----| AUTO WALK VARIABLES |-----
-- Setup folder save file json
local mainFolder = "RullzsyHUB"
local jsonFolder = mainFolder .. "/json_mount_atin"
if not isfolder(mainFolder) then
    makefolder(mainFolder)
end
if not isfolder(jsonFolder) then
    makefolder(jsonFolder)
end

-- Server URL and JSON checkpoint file list
local baseURL = "https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts-json/refs/heads/main/json_mount_atin/"
local jsonFiles = {
    "spawnpoint.json",
    "checkpoint_1.json",
	"checkpoint_2.json",
	"checkpoint_3.json",
	"checkpoint_4.json",
	"checkpoint_5.json",
    "checkpoint_6.json",
    "checkpoint_7.json",
    "checkpoint_8.json",
    "checkpoint_9.json",
    "checkpoint_10.json",
    "checkpoint_11.json",
    "checkpoint_12.json",
    "checkpoint_13.json",
    "checkpoint_14.json",
    "checkpoint_15.json",
    "checkpoint_16.json",
    "checkpoint_17.json",
    "checkpoint_18.json",
    "checkpoint_19.json",
    "checkpoint_20.json",
    "checkpoint_21.json",
    "checkpoint_22.json",
    "checkpoint_23.json",
    "checkpoint_24.json",
    "checkpoint_25.json",
    "checkpoint_26.json",
}

-- Variables to control auto walk status
local isPlaying = false
local playbackConnection = nil
local autoLoopEnabled = false
local currentCheckpoint = 0

--Variables for pause and resume features
local isPaused = false
local manualLoopEnabled = false
local pausedTime = 0
local pauseStartTime = 0

-- FPS Independent Playback Variables
local lastPlaybackTime = 0
local accumulatedTime = 0

-- Looping Variables
local loopingEnabled = false
local isManualMode = false
local manualStartCheckpoint = 0

-- NEW: Avatar Size Compensation Variables
local recordedHipHeight = nil
local currentHipHeight = nil
local hipHeightOffset = 0

-- NEW: Speed Control Variables
local playbackSpeed = 1.0 -- Default speed (1.0 = normal, 0.5 = half speed, 2.0 = double speed)

-- NEW: Footstep Sound Variables
local lastFootstepTime = 0
local footstepInterval = 0.35 -- Time between footsteps (adjusts with speed)
local leftFootstep = true -- Alternate between left and right foot
-------------------------------------------------------------

-----| AUTO WALK FUNCTIONS |-----
-- Function to convert Vector3 to table
local function vecToTable(v3)
    return {x = v3.X, y = v3.Y, z = v3.Z}
end

-- Function to convert a table to Vector3
local function tableToVec(t)
    return Vector3.new(t.x, t.y, t.z)
end

-- Linear interpolation function for numbers
local function lerp(a, b, t)
    return a + (b - a) * t
end

-- Linear interpolation function for Vector3
local function lerpVector(a, b, t)
    return Vector3.new(lerp(a.X, b.X, t), lerp(a.Y, b.Y, t), lerp(a.Z, b.Z, t))
end

-- Linear interpolation function for rotation angle
local function lerpAngle(a, b, t)
    local diff = (b - a)
    while diff > math.pi do diff = diff - 2*math.pi end
    while diff < -math.pi do diff = diff + 2*math.pi end
    return a + diff * t
end

-- NEW: Function to calculate HipHeight offset
local function calculateHipHeightOffset()
    if not humanoid then return 0 end
    
    currentHipHeight = humanoid.HipHeight
    
    -- If no recorded hip height, assume standard avatar (2.0)
    if not recordedHipHeight then
        recordedHipHeight = 2.0
    end
    
    -- Calculate offset based on hip height difference
    hipHeightOffset = recordedHipHeight - currentHipHeight
    
    return hipHeightOffset
end

-- NEW: Function to adjust position based on avatar size
local function adjustPositionForAvatarSize(position)
    if hipHeightOffset == 0 then return position end
    
    -- Apply vertical offset to compensate for hip height difference
    return Vector3.new(
        position.X,
        position.Y - hipHeightOffset,
        position.Z
    )
end

-- NEW: Function to play footstep sounds
local function playFootstepSound()
    if not humanoid or not character then return end
    
    pcall(function()
        -- Get the HumanoidRootPart for raycasting
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        -- Raycast downward to detect floor material
        local rayOrigin = hrp.Position
        local rayDirection = Vector3.new(0, -5, 0)
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {character}
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        
        local rayResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
        
        if rayResult and rayResult.Instance then
            local material = rayResult.Material
            
            -- Create a sound instance for footstep
            local sound = Instance.new("Sound")
            sound.Volume = 0.8 -- Increased volume for louder footsteps
            sound.RollOffMaxDistance = 100
            sound.RollOffMinDistance = 10
            
            -- Assign sound based on material
            -- Using Roblox's built-in footstep sounds
            local soundId = "rbxasset://sounds/action_footsteps_plastic.mp3"
            
            -- Different sounds for different materials
            if material == Enum.Material.Grass then
                soundId = "rbxasset://sounds/action_footsteps_plastic.mp3"
            elseif material == Enum.Material.Wood or material == Enum.Material.WoodPlanks then
                soundId = "rbxasset://sounds/action_footsteps_plastic.mp3"
            elseif material == Enum.Material.Metal or material == Enum.Material.DiamondPlate or material == Enum.Material.CorrodedMetal then
                soundId = "rbxasset://sounds/action_footsteps_plastic.mp3"
            elseif material == Enum.Material.Water then
                soundId = "rbxasset://sounds/action_footsteps_plastic.mp3"
            elseif material == Enum.Material.Snow or material == Enum.Material.Glacier or material == Enum.Material.Ice then
                soundId = "rbxasset://sounds/action_footsteps_plastic.mp3"
            elseif material == Enum.Material.Sand then
                soundId = "rbxasset://sounds/action_footsteps_plastic.mp3"
            else
                soundId = "rbxasset://sounds/action_footsteps_plastic.mp3"
            end
            
            sound.SoundId = soundId
            sound.Parent = hrp
            sound:Play()
            
            -- Cleanup sound after it finishes
            game:GetService("Debris"):AddItem(sound, 1)
        end
    end)
end

-- NEW: Function to simulate natural movement for footsteps
local function simulateNaturalMovement(moveDirection, velocity)
    if not humanoid or not character then return end
    
    -- Calculate horizontal movement speed (ignore Y axis)
    local horizontalVelocity = Vector3.new(velocity.X, 0, velocity.Z)
    local speed = horizontalVelocity.Magnitude
    
    -- Check if character is on ground
    local onGround = false
    pcall(function()
        local state = humanoid:GetState()
        onGround = (state == Enum.HumanoidStateType.Running or 
                   state == Enum.HumanoidStateType.RunningNoPhysics or 
                   state == Enum.HumanoidStateType.Landed)
    end)
    
    -- Only play footsteps if moving and on ground
    if speed > 0.5 and onGround then
        local currentTime = tick()
        
        -- Adjust footstep interval based on speed and playback speed
        local speedMultiplier = math.clamp(speed / 16, 0.3, 2)
        local adjustedInterval = footstepInterval / (speedMultiplier * playbackSpeed)
        
        if currentTime - lastFootstepTime >= adjustedInterval then
            playFootstepSound()
            lastFootstepTime = currentTime
            leftFootstep = not leftFootstep -- Alternate feet
        end
    end
end

-- Function to ensure the JSON file is available (download if it does not exist)
local function EnsureJsonFile(fileName)
    local savePath = jsonFolder .. "/" .. fileName
    if isfile(savePath) then return true, savePath end
    local ok, res = pcall(function() return game:HttpGet(baseURL..fileName) end)
    if ok and res and #res > 0 then
        writefile(savePath, res)
        return true, savePath
    end
    return false, nil
end

-- Function to read and decode JSON checkpoint files
local function loadCheckpoint(fileName)
    local filePath = jsonFolder .. "/" .. fileName
    
    if not isfile(filePath) then
        warn("File not found:", filePath)
        return nil
    end
    
    local success, result = pcall(function()
        local jsonData = readfile(filePath)
        if not jsonData or jsonData == "" then
            error("Empty file")
        end
        return HttpService:JSONDecode(jsonData)
    end)
    
    if success and result then
        -- NEW: Try to extract recorded hip height from first frame
        if result[1] and result[1].hipHeight then
            recordedHipHeight = result[1].hipHeight
        end
        return result
    else
        warn("❌ Load error for", fileName, ":", result)
        return nil
    end
end

-- Binary search for better performance
local function findSurroundingFrames(data, t)
    if #data == 0 then return nil, nil, 0 end
    if t <= data[1].time then return 1, 1, 0 end
    if t >= data[#data].time then return #data, #data, 0 end
    
    -- Binary search for efficiency
    local left, right = 1, #data
    while left < right - 1 do
        local mid = math.floor((left + right) / 2)
        if data[mid].time <= t then
            left = mid
        else
            right = mid
        end
    end
    
    local i0, i1 = left, right
    local span = data[i1].time - data[i0].time
    local alpha = span > 0 and math.clamp((t - data[i0].time) / span, 0, 1) or 0
    
    return i0, i1, alpha
end

-- Function to stop auto walk playback
local function stopPlayback()
    isPlaying = false
    isPaused = false
    pausedTime = 0
    accumulatedTime = 0
    lastPlaybackTime = 0
    lastFootstepTime = 0 -- Reset footstep timer
    recordedHipHeight = nil
    hipHeightOffset = 0
    if playbackConnection then
        playbackConnection:Disconnect()
        playbackConnection = nil
    end
end

-- IMPROVED: FPS-independent playback with avatar size compensation
local function startPlayback(data, onComplete)
    if not data or #data == 0 then
        warn("No data to play!")
        if onComplete then onComplete() end
        return
    end
    
    if isPlaying then stopPlayback() end
    
    isPlaying = true
    isPaused = false
    pausedTime = 0
    accumulatedTime = 0
    local playbackStartTime = tick()
    lastPlaybackTime = playbackStartTime
    local lastJumping = false
    
    -- NEW: Calculate hip height offset at start
    calculateHipHeightOffset()
    
    if playbackConnection then
        playbackConnection:Disconnect()
        playbackConnection = nil
    end

    -- Teleport directly to the starting point JSON with size adjustment
    local first = data[1]
    if character and character:FindFirstChild("HumanoidRootPart") then
        local hrp = character.HumanoidRootPart
        local firstPos = tableToVec(first.position)
        -- NEW: Apply avatar size adjustment
        firstPos = adjustPositionForAvatarSize(firstPos)
        local firstYaw = first.rotation or 0
        local startCFrame = CFrame.new(firstPos) * CFrame.Angles(0, firstYaw, 0)
        hrp.CFrame = startCFrame
        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)

        if humanoid then
            humanoid:Move(tableToVec(first.moveDirection or {x=0,y=0,z=0}), false)
        end
    end

    -- FPS-INDEPENDENT PLAYBACK LOOP
    playbackConnection = RunService.Heartbeat:Connect(function(deltaTime)
        if not isPlaying then return end
        
        -- Handle pause
        if isPaused then
            if pauseStartTime == 0 then
                pauseStartTime = tick()
            end
            lastPlaybackTime = tick()
            return
        else
            if pauseStartTime > 0 then
                pausedTime = pausedTime + (tick() - pauseStartTime)
                pauseStartTime = 0
                lastPlaybackTime = tick()
            end
        end
        
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end
        if not humanoid or humanoid.Parent ~= character then
            humanoid = character:FindFirstChild("Humanoid")
            -- Recalculate offset if humanoid changed
            calculateHipHeightOffset()
        end
        
        -- FPS-independent time tracking using deltaTime
        local currentTime = tick()
        local actualDelta = currentTime - lastPlaybackTime
        lastPlaybackTime = currentTime
        
        -- Clamp delta to prevent huge jumps on lag spikes
        actualDelta = math.min(actualDelta, 0.1)
        
        -- NEW: Apply playback speed multiplier
        accumulatedTime = accumulatedTime + (actualDelta * playbackSpeed)
        
        local totalDuration = data[#data].time
        
        -- Check if playback is complete
        if accumulatedTime > totalDuration then
            local final = data[#data]
            if character and character:FindFirstChild("HumanoidRootPart") then
                local hrp = character.HumanoidRootPart
                local finalPos = tableToVec(final.position)
                -- NEW: Apply avatar size adjustment
                finalPos = adjustPositionForAvatarSize(finalPos)
                local finalYaw = final.rotation or 0
                local targetCFrame = CFrame.new(finalPos) * CFrame.Angles(0, finalYaw, 0)
                hrp.CFrame = targetCFrame
                if humanoid then
                    humanoid:Move(tableToVec(final.moveDirection or {x=0,y=0,z=0}), false)
                end
            end
            stopPlayback()
            if onComplete then onComplete() end
            return
        end
        
        -- Interpolation with binary search
        local i0, i1, alpha = findSurroundingFrames(data, accumulatedTime)
        local f0, f1 = data[i0], data[i1]
        if not f0 or not f1 then return end
        
        local pos0 = tableToVec(f0.position)
        local pos1 = tableToVec(f1.position)
        local vel0 = tableToVec(f0.velocity or {x=0,y=0,z=0})
        local vel1 = tableToVec(f1.velocity or {x=0,y=0,z=0})
        local move0 = tableToVec(f0.moveDirection or {x=0,y=0,z=0})
        local move1 = tableToVec(f1.moveDirection or {x=0,y=0,z=0})
        local yaw0 = f0.rotation or 0
        local yaw1 = f1.rotation or 0
        
        local interpPos = lerpVector(pos0, pos1, alpha)
        -- NEW: Apply avatar size adjustment to interpolated position
        interpPos = adjustPositionForAvatarSize(interpPos)
        
        local interpVel = lerpVector(vel0, vel1, alpha)
        local interpMove = lerpVector(move0, move1, alpha)
        local interpYaw = lerpAngle(yaw0, yaw1, alpha)
        
        local hrp = character.HumanoidRootPart
        local targetCFrame = CFrame.new(interpPos) * CFrame.Angles(0, interpYaw, 0)
        
        -- Dynamic lerp factor based on deltaTime
        local lerpFactor = math.clamp(1 - math.exp(-10 * actualDelta), 0, 1)
        hrp.CFrame = hrp.CFrame:Lerp(targetCFrame, lerpFactor)
        
        -- Apply velocity more directly
        pcall(function()
            hrp.AssemblyLinearVelocity = interpVel
        end)
        
        if humanoid then
            humanoid:Move(interpMove, false)
        end
        
        -- NEW: Simulate footstep sounds
        simulateNaturalMovement(interpMove, interpVel)
        
        -- Handle jumping
        local jumpingNow = f0.jumping or false
        if f1.jumping then jumpingNow = true end
        if jumpingNow and not lastJumping then
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
        lastJumping = jumpingNow
    end)
end

-- Function to run the auto walk sequence from start to finish
local function startAutoWalkSequence()
    currentCheckpoint = 0

    local function playNext()
        if not autoLoopEnabled then return end
        
        currentCheckpoint = currentCheckpoint + 1
        if currentCheckpoint > #jsonFiles then
            -- All checkpoints completed
            if loopingEnabled then
                -- Loop kembali dari awal
                Rayfield:Notify({
                    Title = "Auto Walk",
                    Content = "Semua checkpoint selesai! Looping dari awal...",
                    Duration = 3,
                    Image = "repeat"
                })
                task.wait(1)
                startAutoWalkSequence()
            else
                autoLoopEnabled = false
                Rayfield:Notify({
                    Title = "Auto Walk",
                    Content = "Auto walk selesai! Semua checkpoint sudah dilewati.",
                    Duration = 5,
                    Image = "check-check"
                })
            end
            return
        end

        local checkpointFile = jsonFiles[currentCheckpoint]

        local ok, path = EnsureJsonFile(checkpointFile)
        if not ok then
            Rayfield:Notify({
                Title = "Error",
                Content = "Failed to download: ",
                Duration = 5,
                Image = "ban"
            })
            autoLoopEnabled = false
            return
        end

        local data = loadCheckpoint(checkpointFile)
        if data and #data > 0 then
            Rayfield:Notify({
                Title = "Auto Walk (Automatic)",
                Content = "Auto walk berhasil di jalankan",
                Duration = 2,
                Image = "bot"
            })
            task.wait(0.5)
            startPlayback(data, playNext)
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Error loading: " .. checkpointFile,
                Duration = 5,
                Image = "ban"
            })
            autoLoopEnabled = false
        end
    end

    playNext()
end

-- Function to run manual auto walk with looping
local function startManualAutoWalkSequence(startCheckpoint)
    currentCheckpoint = startCheckpoint - 1
    isManualMode = true
    autoLoopEnabled = true

    local function playNext()
        if not autoLoopEnabled then return end
        
        currentCheckpoint = currentCheckpoint + 1
        if currentCheckpoint > #jsonFiles then
            -- All checkpoints completed
            if loopingEnabled then
                -- Loop kembali dari spawnpoint (checkpoint 1)
                Rayfield:Notify({
                    Title = "Auto Walk (Manual)",
                    Content = "Checkpoint terakhir selesai! Looping dari spawnpoint...",
                    Duration = 3,
                    Image = "repeat"
                })
                task.wait(1)
                currentCheckpoint = 0
                playNext()
            else
                autoLoopEnabled = false
                isManualMode = false
                Rayfield:Notify({
                    Title = "Auto Walk (Manual)",
                    Content = "Auto walk selesai!",
                    Duration = 2,
                    Image = "check-check"
                })
            end
            return
        end

        local checkpointFile = jsonFiles[currentCheckpoint]

        local ok, path = EnsureJsonFile(checkpointFile)
        if not ok then
            Rayfield:Notify({
                Title = "Error",
                Content = "Failed to download checkpoint",
                Duration = 5,
                Image = "ban"
            })
            autoLoopEnabled = false
            isManualMode = false
            return
        end

        local data = loadCheckpoint(checkpointFile)
        if data and #data > 0 then
            task.wait(0.5)
            startPlayback(data, playNext)
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Error loading: " .. checkpointFile,
                Duration = 5,
                Image = "ban"
            })
            autoLoopEnabled = false
            isManualMode = false
        end
    end

    playNext()
end

-- Function to rotate a single checkpoint (manual)
local function playSingleCheckpointFile(fileName, checkpointIndex)
    if loopingEnabled then
        -- Jika looping aktif, gunakan mode manual sequence
        stopPlayback()
        startManualAutoWalkSequence(checkpointIndex)
        return
    end
    
    -- Mode normal tanpa looping
    autoLoopEnabled = false
    isManualMode = false
    stopPlayback()
    
    local ok = EnsureJsonFile(fileName)
    if not ok then
        Rayfield:Notify({
            Title = "Error",
            Content = "Failed to ensure",
            Duration = 4,
            Image = "ban"
        })
        return
    end
    
    local data = loadCheckpoint(fileName)
    if not data or #data == 0 then
        Rayfield:Notify({
            Title = "Error",
            Content = "File invalid",
            Duration = 4,
            Image = "ban"
        })
        return
    end
    
    Rayfield:Notify({
        Title = "Auto Walk (Manual)",
        Content = "Auto walk berhasil di jalankan",
        Duration = 3,
        Image = "bot"
    })
    
    startPlayback(data, function()
        Rayfield:Notify({
            Title = "Auto Walk (Manual)",
            Content = "Auto walk selesai!",
            Duration = 2,
            Image = "check-check"
        })
    end)
end

-- Event listener when the player respawns
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    if isPlaying then stopPlayback() end
end)

-------------------------------------------------------------

-------------------------------------------------------------

-----| MENU 1 > AUTO WALK SETTINGS |-----
local Section = AutoWalkTab:CreateSection("Auto Walk (Settings)")

-- Button Pause
local PauseButton = AutoWalkTab:CreateButton({
   Name = "⏸️ Pause (Auto Walk)",
   Callback = function()
       if not isPlaying then
           Rayfield:Notify({
               Title = "Auto Walk",
               Content = "Tidak ada auto walk yang berjalan",
               Duration = 3,
               Image = "pause"
           })
           return
       end
       if isPaused then	
           Rayfield:Notify({
               Title = "Auto Walk",
               Content = "Auto walk sebelum nya sudah di pause",
               Duration = 2,
               Image = "pause"
           })
           return
       end

       isPaused = true
       Rayfield:Notify({
           Title = "Auto Walk",
           Content = "Behasil di pause",
           Duration = 2,
           Image = "pause"
       })
   end,
})

-- Button Resume
local ResumeButton = AutoWalkTab:CreateButton({
   Name = "▶️ Resume (Auto Walk)",
   Callback = function()
       if not isPlaying then
           Rayfield:Notify({
               Title = "Auto Walk",
               Content = "Tidak ada auto walk yang berjalan",
               Duration = 3,
               Image = "play"
           })
           return
       end
       if not isPaused then
           Rayfield:Notify({
               Title = "Auto Walk",
               Content = "Auto walk sedang berjalan",
               Duration = 2,
               Image = "play"
           })
           return
       end

       isPaused = false
       Rayfield:Notify({
           Title = "Auto Walk",
           Content = "Berhasil di resume",
           Duration = 2,
           Image = "play"
       })
   end,
})

-- Slider Speed Auto
local SpeedSlider = AutoWalkTab:CreateSlider({
    Name = "⚡ Speed Auto Walk",
    Range = {0.5, 2},
    Increment = 0.01,
    Suffix = "x Speed",
    CurrentValue = 1,
    Callback = function(Value)
        playbackSpeed = Value

        local speedText = "Normal"
        if Value < 1.0 then
            speedText = "Lambat (" .. string.format("%.1f", Value) .. "x)"
        elseif Value > 1.0 then
            speedText = "Cepat (" .. string.format("%.1f", Value) .. "x)"
        else
            speedText = "Normal (" .. Value .. "x)"
        end
    end,
})
-------------------------------------------------------------

-----| MENU 1.5 > AUTO WALK LOOPING |-----
local Section = AutoWalkTab:CreateSection("Auto Walk (Looping)")

local LoopingToggle = AutoWalkTab:CreateToggle({
   Name = "🔄 Enable Looping",
   CurrentValue = false,
   Callback = function(Value)
       loopingEnabled = Value
       if Value then
           Rayfield:Notify({
               Title = "Looping",
               Content = "Fitur looping diaktifkan!",
               Duration = 3,
               Image = "repeat"
           })
       else
           Rayfield:Notify({
               Title = "Looping",
               Content = "Fitur looping dinonaktifkan!",
               Duration = 3,
               Image = "x"
           })
       end
   end,
})

-------------------------------------------------------------

-----| MENU 2 > AUTO WALK (AUTOMATIC) |-----
local Section = AutoWalkTab:CreateSection("Auto Walk (Automatic)")

local AutoToggle = AutoWalkTab:CreateToggle({
   Name = "Auto Walk (Start To End)",
   CurrentValue = false,
   Callback = function(Value)
       if Value then
           isManualMode = false
           autoLoopEnabled = true
           startAutoWalkSequence()
       else
           autoLoopEnabled = false
           isManualMode = false
           stopPlayback()
       end
   end,
})

-------------------------------------------------------------

-----| MENU 3 > AUTO WALK (MANUAL) |-----
local Section = AutoWalkTab:CreateSection("Auto Walk (Manual)")

-- Toggle Auto Walk (Spawnpoint)
local CPSToggle = AutoWalkTab:CreateToggle({
    Name = "Auto Walk (Spawnpoint)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("spawnpoint.json", 1)
        else
            autoLoopEnabled = false
            isManualMode = false
            stopPlayback()
        end
    end,
})

-- Toggle Auto Walk (Checkpoint 1)
local CP1Toggle = AutoWalkTab:CreateToggle({
    Name = "Auto Walk (Checkpoint 1)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("checkpoint_1.json", 2)
        else
            autoLoopEnabled = false
            isManualMode = false
            stopPlayback()
        end
    end,
})

-- Toggle Auto Walk (Checkpoint 2)
local CP2Toggle = AutoWalkTab:CreateToggle({
    Name = "Auto Walk (Checkpoint 2)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("checkpoint_2.json", 3)
        else
            autoLoopEnabled = false
            isManualMode = false
            stopPlayback()
        end
    end,
})

-- Toggle Auto Walk (Checkpoint 3)
local CP3Toggle = AutoWalkTab:CreateToggle({
    Name = "Auto Walk (Checkpoint 3)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("checkpoint_3.json", 4)
        else
            autoLoopEnabled = false
            isManualMode = false
            stopPlayback()
        end
    end,
})

-- Toggle Auto Walk (Checkpoint 4)
local CP4Toggle = AutoWalkTab:CreateToggle({
    Name = "Auto Walk (Checkpoint 4)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("checkpoint_4.json", 5)
        else
            autoLoopEnabled = false
            isManualMode = false
            stopPlayback()
        end
    end,
})

-- Toggle Auto Walk (Checkpoint 5)
local CP5Toggle = AutoWalkTab:CreateToggle({
    Name = "Auto Walk (Checkpoint 5)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("checkpoint_5.json", 6)
        else
            autoLoopEnabled = false
            isManualMode = false
            stopPlayback()
        end
    end,
})

-- Toggle Auto Walk (Checkpoint 6)
local CP6Toggle = AutoWalkTab:CreateToggle({
    Name = "Auto Walk (Checkpoint 6)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("checkpoint_6.json", 7)
        else
            autoLoopEnabled = false
            isManualMode = false
            stopPlayback()
        end
    end,
})

-- Toggle Auto Walk (Checkpoint 7)
local CP7Toggle = AutoWalkTab:CreateToggle({
    Name = "Auto Walk (Checkpoint 7)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("checkpoint_7.json", 8)
        else
            autoLoopEnabled = false
            isManualMode = false
            stopPlayback()
        end
    end,
})

-- Toggle Auto Walk (Checkpoint 8)
local CP8Toggle = AutoWalkTab:CreateToggle({
    Name = "Auto Walk (Checkpoint 8)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("checkpoint_8.json", 9)
        else
            autoLoopEnabled = false
            isManualMode = false
            stopPlayback()
        end
    end,
})

-- Toggle Auto Walk (Checkpoint 9)
local CP9Toggle = AutoWalkTab:CreateToggle({
    Name = "Auto Walk (Checkpoint 9)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("checkpoint_9.json", 10)
        else
            autoLoopEnabled = false
            isManualMode = false
            stopPlayback()
        end
    end,
})

-- Toggle Auto Walk (Checkpoint 10)
local CP10Toggle = AutoWalkTab:CreateToggle({
    Name = "Auto Walk (Checkpoint 10)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("checkpoint_10.json", 11)
        else
            autoLoopEnabled = false
            isManualMode = false
            stopPlayback()
        end
    end,
})

-- Toggle Auto Walk (Checkpoint 11)
local CP11Toggle = AutoWalkTab:CreateToggle({
    Name = "Auto Walk (Checkpoint 11)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("checkpoint_11.json", 12)
        else
            autoLoopEnabled = false
            isManualMode = false
            stopPlayback()
        end
    end,
})

-- Toggle Auto Walk (Checkpoint 12)
local CP12Toggle = AutoWalkTab:CreateToggle({
    Name = "Auto Walk (Checkpoint 12)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("checkpoint_12.json", 13)
        else
            autoLoopEnabled = false
            isManualMode = false
            stopPlayback()
        end
    end,
})

-- Toggle Auto Walk (Checkpoint 13)
local CP13Toggle = AutoWalkTab:CreateToggle({
    Name = "Auto Walk (Checkpoint 13)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("checkpoint_13.json", 14)
        else
            autoLoopEnabled = false
            isManualMode = false
            stopPlayback()
        end
    end,
})

-- Toggle Auto Walk (Checkpoint 14)
local CP14Toggle = AutoWalkTab:CreateToggle({
    Name = "Auto Walk (Checkpoint 14)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("checkpoint_14.json", 15)
        else
            autoLoopEnabled = false
            isManualMode = false
            stopPlayback()
        end
    end,
})

-- Toggle Auto Walk (Checkpoint 15)
local CP15Toggle = AutoWalkTab:CreateToggle({
    Name = "Auto Walk (Checkpoint 15)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("checkpoint_15.json", 16)
        else
            autoLoopEnabled = false
            isManualMode = false
            stopPlayback()
        end
    end,
})

-- Toggle Auto Walk (Checkpoint 16)
local CP16Toggle = AutoWalkTab:CreateToggle({
    Name = "Auto Walk (Checkpoint 16)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("checkpoint_16.json", 17)
        else
            autoLoopEnabled = false
            isManualMode = false
            stopPlayback()
        end
    end,
})

-- Toggle Auto Walk (Checkpoint 17)
local CP17Toggle = AutoWalkTab:CreateToggle({
    Name = "Auto Walk (Checkpoint 17)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("checkpoint_17.json", 18)
        else
            autoLoopEnabled = false
            isManualMode = false
            stopPlayback()
        end
    end,
})

-- Toggle Auto Walk (Checkpoint 18)
local CP18Toggle = AutoWalkTab:CreateToggle({
    Name = "Auto Walk (Checkpoint 18)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("checkpoint_18.json", 19)
        else
            autoLoopEnabled = false
            isManualMode = false
            stopPlayback()
        end
    end,
})

-- Toggle Auto Walk (Checkpoint 19)
local CP19Toggle = AutoWalkTab:CreateToggle({
    Name = "Auto Walk (Checkpoint 19)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("checkpoint_19.json", 20)
        else
            autoLoopEnabled = false
            isManualMode = false
            stopPlayback()
        end
    end,
})

-- Toggle Auto Walk (Checkpoint 20)
local CP20Toggle = AutoWalkTab:CreateToggle({
    Name = "Auto Walk (Checkpoint 20)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("checkpoint_20.json", 21)
        else
            autoLoopEnabled = false
            isManualMode = false
            stopPlayback()
        end
    end,
})

-- Toggle Auto Walk (Checkpoint 21)
local CP21Toggle = AutoWalkTab:CreateToggle({
    Name = "Auto Walk (Checkpoint 21)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("checkpoint_21.json", 22)
        else
            autoLoopEnabled = false
            isManualMode = false
            stopPlayback()
        end
    end,
})

-- Toggle Auto Walk (Checkpoint 22)
local CP22Toggle = AutoWalkTab:CreateToggle({
    Name = "Auto Walk (Checkpoint 22)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("checkpoint_22.json", 23)
        else
            autoLoopEnabled = false
            isManualMode = false
            stopPlayback()
        end
    end,
})

-- Toggle Auto Walk (Checkpoint 23)
local CP23Toggle = AutoWalkTab:CreateToggle({
    Name = "Auto Walk (Checkpoint 23)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("checkpoint_23.json", 24)
        else
            autoLoopEnabled = false
            isManualMode = false
            stopPlayback()
        end
    end,
})

-- Toggle Auto Walk (Checkpoint 24)
local CP24Toggle = AutoWalkTab:CreateToggle({
    Name = "Auto Walk (Checkpoint 24)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("checkpoint_24.json", 25)
        else
            autoLoopEnabled = false
            isManualMode = false
            stopPlayback()
        end
    end,
})

-- Toggle Auto Walk (Checkpoint 25)
local CP25Toggle = AutoWalkTab:CreateToggle({
    Name = "Auto Walk (Checkpoint 25)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("checkpoint_25.json", 26)
        else
            autoLoopEnabled = false
            isManualMode = false
            stopPlayback()
        end
    end,
})

-- Toggle Auto Walk (Checkpoint 26)
local CP26Toggle = AutoWalkTab:CreateToggle({
    Name = "Auto Walk (Checkpoint 26)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            playSingleCheckpointFile("checkpoint_26.json", 27)
        else
            autoLoopEnabled = false
            isManualMode = false
            stopPlayback()
        end
    end,
})
-------------------------------------------------------------
-- AUTO WALK - END
-------------------------------------------------------------



-------------------------------------------------------------
-- TELEPORT
-------------------------------------------------------------
local OffsetY = 10

-- Manual Teleport Notification
local function ManualTeleport(x, y, z, name)
   local player = game.Players.LocalPlayer
   if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
      player.Character.HumanoidRootPart.CFrame = CFrame.new(x, y + OffsetY, z)
   end

   Rayfield:Notify({
      Title = "Teleport",
      Content = "Teleport berhasil",
      Duration = 3,
      Image = "check-check",
   })
end

-----------------------------------------------------------

-----| MENU - LIST TELEPORT |-----
local Section = TeleportTab:CreateSection("List All Checkpoint")

TeleportTab:CreateButton({
   Name = "Teleport (Spawnpoint)",
   Callback = function()
      ManualTeleport(16.50, 55.17, -1082.46, "Spawnpoint")
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport (Checkpoint 1)",
   Callback = function()
      ManualTeleport(4.55, 12.59, -404.47, "Checkpoint 1")
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport (Checkpoint 2)",
   Callback = function()
      ManualTeleport(-184.65, 128.12, 409.67, "Checkpoint 2")
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport (Checkpoint 3)",
   Callback = function()
      ManualTeleport(-165.27, 229.63, 653.13, "Checkpoint 3")
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport (Checkpoint 4)",
   Callback = function()
      ManualTeleport(-38.09, 406.57, 615.99, "Checkpoint 4")
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport (Checkpoint 5)",
   Callback = function()
      ManualTeleport(130.63, 650.62, 613.20, "Checkpoint 5")
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport (Checkpoint 6)",
   Callback = function()
      ManualTeleport(-246.42, 665.71, 734.37, "Checkpoint 6")
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport (Checkpoint 7)",
   Callback = function()
      ManualTeleport(-684.35, 640.78, 867.35, "Checkpoint 7")
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport (Checkpoint 8)",
   Callback = function()
      ManualTeleport(-658.12, 688.45, 1458.11, "Checkpoint 8")
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport (Checkpoint 9)",
   Callback = function()
      ManualTeleport(-508.14, 902.88, 1868.13, "Checkpoint 9")
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport (Checkpoint 10)",
   Callback = function()
      ManualTeleport(60.87, 949.89, 2088.47, "Checkpoint 10")
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport (Checkpoint 11)",
   Callback = function()
      ManualTeleport(52.08, 981.51, 2450.21, "Checkpoint 11")
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport (Checkpoint 12)",
   Callback = function()
      ManualTeleport(72.78, 1096.94, 2457.26, "Checkpoint 12")
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport (Checkpoint 13)",
   Callback = function()
      ManualTeleport(262.57, 1270.09, 2037.86, "Checkpoint 13")
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport (Checkpoint 14)",
   Callback = function()
      ManualTeleport(-418.76, 1302.15, 2394.39, "Checkpoint 14")
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport (Checkpoint 15)",
   Callback = function()
      ManualTeleport(-773.30, 1313.91, 2664.31, "Checkpoint 15")
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport (Checkpoint 16)",
   Callback = function()
      ManualTeleport(-837.48, 1474.65, 2625.87, "Checkpoint 16")
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport (Checkpoint 17)",
   Callback = function()
      ManualTeleport(-468.58, 1465.65, 2769.42, "Checkpoint 17")
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport (Checkpoint 18)",
   Callback = function()
      ManualTeleport(-467.13, 1537.45, 2836.52, "Checkpoint 18")
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport (Checkpoint 19)",
   Callback = function()
      ManualTeleport(-384.99, 1640.25, 2794.14, "Checkpoint 19")
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport (Checkpoint 20)",
   Callback = function()
      ManualTeleport(-208.39, 1665.73, 2749.29, "Checkpoint 20")
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport (Checkpoint 21)",
   Callback = function()
      ManualTeleport(-232.70, 1738.04, 2792.17, "Checkpoint 21")
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport (Checkpoint 22)",
   Callback = function()
      ManualTeleport(-424.35, 1740.62, 2798.06, "Checkpoint 22")
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport (Checkpoint 23)",
   Callback = function()
      ManualTeleport(-423.62, 1712.72, 3420.89, "Checkpoint 23")
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport (Checkpoint 24)",
   Callback = function()
      ManualTeleport(70.76, 1718.67, 3427.36, "Checkpoint 24")
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport (Checkpoint 25)",
   Callback = function()
      ManualTeleport(436.04, 1720.55, 3430.73, "Checkpoint 25")
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport (Checkpoint 26)",
   Callback = function()
      ManualTeleport(625.14, 1799.19, 3432.80, "Checkpoint 26")
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport (Puncak)",
   Callback = function()
      ManualTeleport(781.26, 2163.24, 3921.02, "Puncak")
   end,
})
-------------------------------------------------------------
-- TELEPORT - END
-------------------------------------------------------------



-------------------------------------------------------------
-- RUN ANIMATION
-------------------------------------------------------------
local Section = RunAnimationTab:CreateSection("Animation Pack List")

-----| ID ANIMATION |-----
local RunAnimations = {
    ["Run Animation 1"] = {
        Idle1   = "rbxassetid://122257458498464",
        Idle2   = "rbxassetid://102357151005774",
        Walk    = "http://www.roblox.com/asset/?id=18537392113",
        Run     = "rbxassetid://82598234841035",
        Jump    = "rbxassetid://75290611992385",
        Fall    = "http://www.roblox.com/asset/?id=11600206437",
        Climb   = "http://www.roblox.com/asset/?id=10921257536",
        Swim    = "http://www.roblox.com/asset/?id=10921264784",
        SwimIdle= "http://www.roblox.com/asset/?id=10921265698"
    },
    ["Run Animation 2"] = {
        Idle1   = "rbxassetid://122257458498464",
        Idle2   = "rbxassetid://102357151005774",
        Walk    = "rbxassetid://122150855457006",
        Run     = "rbxassetid://82598234841035",
        Jump    = "rbxassetid://75290611992385",
        Fall    = "rbxassetid://98600215928904",
        Climb   = "rbxassetid://88763136693023",
        Swim    = "rbxassetid://133308483266208",
        SwimIdle= "rbxassetid://109346520324160"
    },
    ["Run Animation 3"] = {
        Idle1   = "http://www.roblox.com/asset/?id=18537376492",
        Idle2   = "http://www.roblox.com/asset/?id=18537371272",
        Walk    = "http://www.roblox.com/asset/?id=18537392113",
        Run     = "http://www.roblox.com/asset/?id=18537384940",
        Jump    = "http://www.roblox.com/asset/?id=18537380791",
        Fall    = "http://www.roblox.com/asset/?id=18537367238",
        Climb   = "http://www.roblox.com/asset/?id=10921271391",
        Swim    = "http://www.roblox.com/asset/?id=99384245425157",
        SwimIdle= "http://www.roblox.com/asset/?id=113199415118199"
    },
    ["Run Animation 4"] = {
        Idle1   = "http://www.roblox.com/asset/?id=118832222982049",
        Idle2   = "http://www.roblox.com/asset/?id=76049494037641",
        Walk    = "http://www.roblox.com/asset/?id=92072849924640",
        Run     = "http://www.roblox.com/asset/?id=72301599441680",
        Jump    = "http://www.roblox.com/asset/?id=104325245285198",
        Fall    = "http://www.roblox.com/asset/?id=121152442762481",
        Climb   = "http://www.roblox.com/asset/?id=507765644",
        Swim    = "http://www.roblox.com/asset/?id=99384245425157",
        SwimIdle= "http://www.roblox.com/asset/?id=113199415118199"
    },
    ["Run Animation 5"] = {
        Idle1   = "http://www.roblox.com/asset/?id=656117400",
        Idle2   = "http://www.roblox.com/asset/?id=656118341",
        Walk    = "http://www.roblox.com/asset/?id=656121766",
        Run     = "http://www.roblox.com/asset/?id=656118852",
        Jump    = "http://www.roblox.com/asset/?id=656117878",
        Fall    = "http://www.roblox.com/asset/?id=656115606",
        Climb   = "http://www.roblox.com/asset/?id=656114359",
        Swim    = "http://www.roblox.com/asset/?id=910028158",
        SwimIdle= "http://www.roblox.com/asset/?id=910030921"
    },
    ["Run Animation 6"] = {
        Idle1   = "http://www.roblox.com/asset/?id=616006778",
        Idle2   = "http://www.roblox.com/asset/?id=616008087",
        Walk    = "http://www.roblox.com/asset/?id=616013216",
        Run     = "http://www.roblox.com/asset/?id=616010382",
        Jump    = "http://www.roblox.com/asset/?id=616008936",
        Fall    = "http://www.roblox.com/asset/?id=616005863",
        Climb   = "http://www.roblox.com/asset/?id=616003713",
        Swim    = "http://www.roblox.com/asset/?id=910028158",
        SwimIdle= "http://www.roblox.com/asset/?id=910030921"
    },
    ["Run Animation 7"] = {
        Idle1   = "http://www.roblox.com/asset/?id=1083195517",
        Idle2   = "http://www.roblox.com/asset/?id=1083214717",
        Walk    = "http://www.roblox.com/asset/?id=1083178339",
        Run     = "http://www.roblox.com/asset/?id=1083216690",
        Jump    = "http://www.roblox.com/asset/?id=1083218792",
        Fall    = "http://www.roblox.com/asset/?id=1083189019",
        Climb   = "http://www.roblox.com/asset/?id=1083182000",
        Swim    = "http://www.roblox.com/asset/?id=910028158",
        SwimIdle= "http://www.roblox.com/asset/?id=910030921"
    },
    ["Run Animation 8"] = {
        Idle1   = "http://www.roblox.com/asset/?id=616136790",
        Idle2   = "http://www.roblox.com/asset/?id=616138447",
        Walk    = "http://www.roblox.com/asset/?id=616146177",
        Run     = "http://www.roblox.com/asset/?id=616140816",
        Jump    = "http://www.roblox.com/asset/?id=616139451",
        Fall    = "http://www.roblox.com/asset/?id=616134815",
        Climb   = "http://www.roblox.com/asset/?id=616133594",
        Swim    = "http://www.roblox.com/asset/?id=910028158",
        SwimIdle= "http://www.roblox.com/asset/?id=910030921"
    },
    ["Run Animation 9"] = {
        Idle1   = "http://www.roblox.com/asset/?id=616088211",
        Idle2   = "http://www.roblox.com/asset/?id=616089559",
        Walk    = "http://www.roblox.com/asset/?id=616095330",
        Run     = "http://www.roblox.com/asset/?id=616091570",
        Jump    = "http://www.roblox.com/asset/?id=616090535",
        Fall    = "http://www.roblox.com/asset/?id=616087089",
        Climb   = "http://www.roblox.com/asset/?id=616086039",
        Swim    = "http://www.roblox.com/asset/?id=910028158",
        SwimIdle= "http://www.roblox.com/asset/?id=910030921"
    },
    ["Run Animation 10"] = {
        Idle1   = "http://www.roblox.com/asset/?id=910004836",
        Idle2   = "http://www.roblox.com/asset/?id=910009958",
        Walk    = "http://www.roblox.com/asset/?id=910034870",
        Run     = "http://www.roblox.com/asset/?id=910025107",
        Jump    = "http://www.roblox.com/asset/?id=910016857",
        Fall    = "http://www.roblox.com/asset/?id=910001910",
        Climb   = "http://www.roblox.com/asset/?id=616086039",
        Swim    = "http://www.roblox.com/asset/?id=910028158",
        SwimIdle= "http://www.roblox.com/asset/?id=910030921"
    },
    ["Run Animation 11"] = {
        Idle1   = "http://www.roblox.com/asset/?id=742637544",
        Idle2   = "http://www.roblox.com/asset/?id=742638445",
        Walk    = "http://www.roblox.com/asset/?id=742640026",
        Run     = "http://www.roblox.com/asset/?id=742638842",
        Jump    = "http://www.roblox.com/asset/?id=742637942",
        Fall    = "http://www.roblox.com/asset/?id=742637151",
        Climb   = "http://www.roblox.com/asset/?id=742636889",
        Swim    = "http://www.roblox.com/asset/?id=910028158",
        SwimIdle= "http://www.roblox.com/asset/?id=910030921"
    },
    ["Run Animation 12"] = {
        Idle1   = "http://www.roblox.com/asset/?id=616111295",
        Idle2   = "http://www.roblox.com/asset/?id=616113536",
        Walk    = "http://www.roblox.com/asset/?id=616122287",
        Run     = "http://www.roblox.com/asset/?id=616117076",
        Jump    = "http://www.roblox.com/asset/?id=616115533",
        Fall    = "http://www.roblox.com/asset/?id=616108001",
        Climb   = "http://www.roblox.com/asset/?id=616104706",
        Swim    = "http://www.roblox.com/asset/?id=910028158",
        SwimIdle= "http://www.roblox.com/asset/?id=910030921"
    },
    ["Run Animation 13"] = {
        Idle1   = "http://www.roblox.com/asset/?id=657595757",
        Idle2   = "http://www.roblox.com/asset/?id=657568135",
        Walk    = "http://www.roblox.com/asset/?id=657552124",
        Run     = "http://www.roblox.com/asset/?id=657564596",
        Jump    = "http://www.roblox.com/asset/?id=658409194",
        Fall    = "http://www.roblox.com/asset/?id=657600338",
        Climb   = "http://www.roblox.com/asset/?id=658360781",
        Swim    = "http://www.roblox.com/asset/?id=910028158",
        SwimIdle= "http://www.roblox.com/asset/?id=910030921"
    },
    ["Run Animation 14"] = {
        Idle1   = "http://www.roblox.com/asset/?id=616158929",
        Idle2   = "http://www.roblox.com/asset/?id=616160636",
        Walk    = "http://www.roblox.com/asset/?id=616168032",
        Run     = "http://www.roblox.com/asset/?id=616163682",
        Jump    = "http://www.roblox.com/asset/?id=616161997",
        Fall    = "http://www.roblox.com/asset/?id=616157476",
        Climb   = "http://www.roblox.com/asset/?id=616156119",
        Swim    = "http://www.roblox.com/asset/?id=910028158",
        SwimIdle= "http://www.roblox.com/asset/?id=910030921"
    },
    ["Run Animation 15"] = {
        Idle1   = "http://www.roblox.com/asset/?id=845397899",
        Idle2   = "http://www.roblox.com/asset/?id=845400520",
        Walk    = "http://www.roblox.com/asset/?id=845403856",
        Run     = "http://www.roblox.com/asset/?id=845386501",
        Jump    = "http://www.roblox.com/asset/?id=845398858",
        Fall    = "http://www.roblox.com/asset/?id=845396048",
        Climb   = "http://www.roblox.com/asset/?id=845392038",
        Swim    = "http://www.roblox.com/asset/?id=910028158",
        SwimIdle= "http://www.roblox.com/asset/?id=910030921"
    },
    ["Run Animation 16"] = {
        Idle1   = "http://www.roblox.com/asset/?id=782841498",
        Idle2   = "http://www.roblox.com/asset/?id=782845736",
        Walk    = "http://www.roblox.com/asset/?id=782843345",
        Run     = "http://www.roblox.com/asset/?id=782842708",
        Jump    = "http://www.roblox.com/asset/?id=782847020",
        Fall    = "http://www.roblox.com/asset/?id=782846423",
        Climb   = "http://www.roblox.com/asset/?id=782843869",
        Swim    = "http://www.roblox.com/asset/?id=18537389531",
        SwimIdle= "http://www.roblox.com/asset/?id=18537387180"
    },
    ["Run Animation 17"] = {
        Idle1   = "http://www.roblox.com/asset/?id=891621366",
        Idle2   = "http://www.roblox.com/asset/?id=891633237",
        Walk    = "http://www.roblox.com/asset/?id=891667138",
        Run     = "http://www.roblox.com/asset/?id=891636393",
        Jump    = "http://www.roblox.com/asset/?id=891627522",
        Fall    = "http://www.roblox.com/asset/?id=891617961",
        Climb   = "http://www.roblox.com/asset/?id=891609353",
        Swim    = "http://www.roblox.com/asset/?id=18537389531",
        SwimIdle= "http://www.roblox.com/asset/?id=18537387180"
    },
    ["Run Animation 18"] = {
        Idle1   = "http://www.roblox.com/asset/?id=750781874",
        Idle2   = "http://www.roblox.com/asset/?id=750782770",
        Walk    = "http://www.roblox.com/asset/?id=750785693",
        Run     = "http://www.roblox.com/asset/?id=750783738",
        Jump    = "http://www.roblox.com/asset/?id=750782230",
        Fall    = "http://www.roblox.com/asset/?id=750780242",
        Climb   = "http://www.roblox.com/asset/?id=750779899",
        Swim    = "http://www.roblox.com/asset/?id=18537389531",
        SwimIdle= "http://www.roblox.com/asset/?id=18537387180"
    },
}

-------------------------------------------------------------
-----| FUNCTION RUN ANIMATION |-----
local OriginalAnimations = {}
local CurrentPack = nil

local function SaveOriginalAnimations(Animate)
    OriginalAnimations = {}
    for _, child in ipairs(Animate:GetDescendants()) do
        if child:IsA("Animation") then
            OriginalAnimations[child] = child.AnimationId
        end
    end
end

local function ApplyAnimations(Animate, Humanoid, AnimPack)
    Animate.idle.Animation1.AnimationId = AnimPack.Idle1
    Animate.idle.Animation2.AnimationId = AnimPack.Idle2
    Animate.walk.WalkAnim.AnimationId   = AnimPack.Walk
    Animate.run.RunAnim.AnimationId     = AnimPack.Run
    Animate.jump.JumpAnim.AnimationId   = AnimPack.Jump
    Animate.fall.FallAnim.AnimationId   = AnimPack.Fall
    Animate.climb.ClimbAnim.AnimationId = AnimPack.Climb
    Animate.swim.Swim.AnimationId       = AnimPack.Swim
    Animate.swimidle.SwimIdle.AnimationId = AnimPack.SwimIdle
    Humanoid.Jump = true
end

local function RestoreOriginal()
    for anim, id in pairs(OriginalAnimations) do
        if anim and anim:IsA("Animation") then
            anim.AnimationId = id
        end
    end
end

local function SetupCharacter(Char)
    local Animate = Char:WaitForChild("Animate")
    local Humanoid = Char:WaitForChild("Humanoid")
    SaveOriginalAnimations(Animate)
    if CurrentPack then
        ApplyAnimations(Animate, Humanoid, CurrentPack)
    end
end

Players.LocalPlayer.CharacterAdded:Connect(function(Char)
    task.wait(1)
    SetupCharacter(Char)
end)

if Players.LocalPlayer.Character then
    SetupCharacter(Players.LocalPlayer.Character)
end

-------------------------------------------------------------
-----| TOGGLES RUN ANIMATION |-----
for i = 1, 18 do
    local name = "Run Animation " .. i
    local pack = RunAnimations[name]

    RunAnimationTab:CreateToggle({
        Name = name,
        CurrentValue = false,
        Flag = name .. "Toggle",
        Callback = function(Value)
            if Value then
                CurrentPack = pack
            elseif CurrentPack == pack then
                CurrentPack = nil
                RestoreOriginal()
            end

            local Char = Players.LocalPlayer.Character
            if Char and Char:FindFirstChild("Animate") and Char:FindFirstChild("Humanoid") then
                if CurrentPack then
                    ApplyAnimations(Char.Animate, Char.Humanoid, CurrentPack)
                else
                    RestoreOriginal()
                end
            end
        end,
    })
end
-------------------------------------------------------------
-- RUN ANIMATION - END
-------------------------------------------------------------



-------------------------------------------------------------
-- UPDATE SCRIPT
-------------------------------------------------------------
-----| UPDATE SCRIPT VARIABLES |-----
-- Variables to control the update process
local updateEnabled = false
local stopUpdate = {false}

-------------------------------------------------------------

-----| MENU 1 > UPDATE SCRIPT STATUS |-----
-- Label to display the status of checking JSON files
local Label = UpdateTab:CreateLabel("Pengecekan file...")

-- Task for checking JSON files during startup
task.spawn(function()
    for i, f in ipairs(jsonFiles) do
        local ok = EnsureJsonFile(f)
        Label:Set((ok and "✔ Proses Cek File: " or "❌ Gagal: ").." ("..i.."/"..#jsonFiles..")")
        task.wait(0.5)
    end
    Label:Set("✔ Semua file aman")
end)

-------------------------------------------------------------

-----| MENU 2 > UPDATE SCRIPT TOGGLE |-----
-- Toggle to start the script update process (redownload all JSON)
UpdateTab:CreateToggle({
    Name = "Mulai Update Script",
    CurrentValue = false,
    Callback = function(state)
        if state then
            updateEnabled = true
            stopUpdate[1] = false
            task.spawn(function()
                Label:Set("🔄 Proses update file...")
                
                -- Delete all existing JSON files
                for _, f in ipairs(jsonFiles) do
                    local savePath = jsonFolder .. "/" .. f
                    if isfile(savePath) then
                        delfile(savePath)
                    end
                end
                
                -- Re-download all JSON files
                for i, f in ipairs(jsonFiles) do
                    if stopUpdate[1] then break end
                    
                    Rayfield:Notify({
                        Title = "Update Script",
                        Content = "Proses Update " .. " ("..i.."/"..#jsonFiles..")",
                        Duration = 2,
                        Image = "file",
                    })
                    
                    local ok, res = pcall(function() return game:HttpGet(baseURL..f) end)
                    if ok and res and #res > 0 then
                        writefile(jsonFolder.."/"..f, res)
                        Label:Set("📥 Proses Update: ".. " ("..i.."/"..#jsonFiles..")")
                    else
                        Rayfield:Notify({
                            Title = "Update Script",
                            Content = "❌ Update script gagal",
                            Duration = 3,
                            Image = "file",
                        })
                        Label:Set("❌ Gagal: ".. " ("..i.."/"..#jsonFiles..")")
                    end
                    task.wait(0.3)
                end
                
                -- Update result notification
                if not stopUpdate[1] then
                    Rayfield:Notify({
                        Title = "Update Script",
                        Content = "Telah berhasil!",
                        Duration = 5,
                        Image = "check-check",
                    })
                else
                    Rayfield:Notify({
                        Title = "Update Script",
                        Content = "❌ Update canceled",
                        Duration = 3,
                        Image = 4483362458,
                    })
                end
				
                -- Re-check all files after updating
                for i, f in ipairs(jsonFiles) do
                    local ok = EnsureJsonFile(f)
                    Label:Set((ok and "✔ Cek File: " or "❌ Failed: ").." ("..i.."/"..#jsonFiles..")")
                    task.wait(0.3)
                end
                Label:Set("✔ Semua file aman")
            end)
        else
            updateEnabled = false
            stopUpdate[1] = true
        end
    end,
})
-------------------------------------------------------------
-- UPDATE SCRIPT - END
-------------------------------------------------------------



-------------------------------------------------------------
-- CREDITS
-------------------------------------------------------------
local Section = CreditsTab:CreateSection("Credits List")

-- Credits: 1
CreditsTab:CreateLabel("UI: Rayfield Interface")
-- Credits: 2
CreditsTab:CreateLabel("Dev: RullzsyHUB")
-------------------------------------------------------------
-- CREDITS - END
-------------------------------------------------------------

