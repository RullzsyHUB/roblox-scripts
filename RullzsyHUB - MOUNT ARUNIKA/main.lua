	-------------------------------------------------------------
-- LOAD LIBRARY UI
-------------------------------------------------------------
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts/refs/heads/main/UI%20Liblary/Rayfield.lua'))()

-------------------------------------------------------------
-- WINDOW PROCESS
-------------------------------------------------------------
local Window = Rayfield:CreateWindow({
   Name = "RullzsyHUB | MOUNT ARUNIKA",
   Icon = "braces",
   LoadingTitle = "Created By RullzsyHUB",
   LoadingSubtitle = "Follow Tiktok: @rullzsy99",
})

-------------------------------------------------------------
-- TAB MENU
-------------------------------------------------------------
local AccountTab = Window:CreateTab("Account", "user")
local AutoWalkTab = Window:CreateTab("Auto Walk", "bot")
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



-------------------------------------------------------------
-- FILE SYSTEM CONFIGURATION
-------------------------------------------------------------
-- Check if authenticated
if not getgenv().AuthComplete then
    warn("[MAIN] Not authenticated! Please run auth script first.")
    return
end

-------------------------------------------------------------
-- ACCOUNT TAB
-------------------------------------------------------------
local API_CONFIG = {
    base_url = "https://monotonal-unhoneyed-rita.ngrok-free.dev",
    get_user_endpoint = "/get_user.php",
}

local FILE_CONFIG = {
    folder = "RullzsyHUB",
    subfolder = "auth",
    filename = "token.dat"
}

local function getAuthFilePath()
    return FILE_CONFIG.folder .. "/" .. FILE_CONFIG.subfolder .. "/" .. FILE_CONFIG.filename
end

local function loadTokenFromFile()
    if not isfile then
        return nil
    end
    
    local success, result = pcall(function()
        if not isfile(getAuthFilePath()) then
            return nil
        end
        
        local content = readfile(getAuthFilePath())
        local data = HttpService:JSONDecode(content)
        
        if data.username == LocalPlayer.Name then
            return data.token
        end
        return nil
    end)
    
    return success and result or nil
end

local function getToken()
    local fileToken = loadTokenFromFile()
    if fileToken and fileToken ~= "" then
        return fileToken
    end
    
    local envToken = getgenv().UserToken
    if envToken and envToken ~= "" then
        return tostring(envToken)
    end
    
    return nil
end

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

local userData = {
    username = "Guest",
    role = "Member",
    expire_timestamp = os.time()
}

local updateConnection = nil

AccountTab:CreateSection("Informasi Akun")
local InfoParagraph = AccountTab:CreateParagraph({
    Title = "📊 Status Akun",
    Content = "🔄 Memuat data...\n⏳ Tunggu sebentar..."
})

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
    elseif remaining <= 86400 then
        emoji = "🟠"
    elseif remaining <= 259200 then
        emoji = "🟡"
    end

    return emoji, formatTimeRealtime(remaining)
end

local function updateAccountInfo()
    local savedToken = getToken()
    
    if not savedToken or savedToken == "" then
        InfoParagraph:Set({
            Title = "🚫 Token Error",
            Content = "❌ Token tidak ditemukan.\nSilakan restart dan login ulang."
        })
        return
    end

    InfoParagraph:Set({
        Title = "🔄 Memuat Data",
        Content = "⏳ Menghubungkan ke server..."
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
            Content = "❌ Gagal terhubung ke server.\n" .. tostring(res)
        })
        return
    end

    local okDecode, data = pcall(function() return HttpService:JSONDecode(res) end)
    if not okDecode or type(data) ~= "table" then
        InfoParagraph:Set({
            Title = "🔐 Server Error",
            Content = "❌ Format response tidak valid."
        })
        return
    end

    if data.status ~= "success" then
        InfoParagraph:Set({
            Title = "🔐 Authentication Failed",
            Content = "❌ " .. tostring(data.message or "Error")
        })
        return
    end

    userData.username = tostring(data.name or "Unknown")
    userData.role = tostring(data.role or "Member")
    userData.expire_timestamp = tonumber(data.expire_timestamp) or (os.time() + 86400)

    if updateConnection then
        updateConnection:Disconnect()
    end

    updateConnection = RunService.Heartbeat:Connect(function()
        local emoji, timeStr = getExpiryStatusRealtime(userData.expire_timestamp)
        InfoParagraph:Set({
            Title = "👨🏻‍💼 Welcome, " .. userData.username,
            Content = string.format(
                "🏷️  Role       : %s\n⏰  Expire     : %s %s\n\n✅ Status: Aktif",
                userData.role,
                emoji, timeStr
            )
        })
    end)
    
    Rayfield:Notify({
        Title = "✅ Data Loaded",
        Content = "Welcome, " .. userData.username .. "!",
        Duration = 3
    })
end

AccountTab:CreateSection("Quick Actions")

AccountTab:CreateButton({
    Name = "🔄 Refresh Akun",
    Callback = function()
        updateAccountInfo()
    end
})

AccountTab:CreateButton({
    Name = "🛒 Beli/Perpanjang Key",
    Callback = function()
        local discordLink = "https://discord.gg/KEajwZQaRd"
        if setclipboard then
            setclipboard(discordLink)
            Rayfield:Notify({
                Title = "📋 Copied!",
                Content = "Discord link copied!",
                Duration = 3
            })
        end
    end
})

AccountTab:CreateParagraph({
    Title = "💡 Info",
    Content = "Untuk perpanjang key, silahkan buat ticket di Discord."
})

-- Auto load account info
task.spawn(function()
    task.wait(1)
    updateAccountInfo()
end)
-------------------------------------------------------------
-- ACCOUNT TAB - END
-------------------------------------------------------------


-------------------------------------------------------------
-- AUTO WALK - ENHANCED VERSION (FIXED)
-------------------------------------------------------------
-----| AUTO WALK VARIABLES |-----
-- Setup folder save file json
local mainFolder = "RullzsyHUB"
local jsonFolder = mainFolder .. "/json_mount_arunika"
if not isfolder(mainFolder) then
    makefolder(mainFolder)
end
if not isfolder(jsonFolder) then
    makefolder(jsonFolder)
end

-- Server URL and JSON checkpoint file list
local baseURL = "https://raw.githubusercontent.com/RullzsyHUB/roblox-scripts-json/refs/heads/main/json_mount_arunika/"
local jsonFiles = {
    "spawnpoint.json",
    "checkpoint_1.json",
    "checkpoint_2.json",
    "checkpoint_3.json",
    "checkpoint_4.json",
    "checkpoint_5.json",
}

-- Variables to control auto walk status
local isPlaying = false
local playbackConnection = nil
local autoLoopEnabled = false
local currentCheckpoint = 0

-- Variables for pause and resume features
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

-- Avatar Size Compensation Variables
local recordedHipHeight = nil
local currentHipHeight = nil
local hipHeightOffset = 0

-- Speed Control Variables
local playbackSpeed = 1.0
local lastFootstepTime = 0
local footstepInterval = 0.35
local leftFootstep = true

-- FIXED: Area Check Variables
local maxDistanceToCheckpoint = 30
local autoRespawnEnabled = false
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

-- Function to calculate HipHeight offset
local function calculateHipHeightOffset()
    if not humanoid then return 0 end
    
    currentHipHeight = humanoid.HipHeight
    
    if not recordedHipHeight then
        recordedHipHeight = 2.0
    end
    
    hipHeightOffset = recordedHipHeight - currentHipHeight
    
    return hipHeightOffset
end

-- Function to adjust position based on avatar size
local function adjustPositionForAvatarSize(position)
    if hipHeightOffset == 0 then return position end
    
    return Vector3.new(
        position.X,
        position.Y - hipHeightOffset,
        position.Z
    )
end

-- Function to play footstep sounds
local function playFootstepSound()
    if not humanoid or not character then return end
    
    pcall(function()
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local rayOrigin = hrp.Position
        local rayDirection = Vector3.new(0, -5, 0)
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {character}
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        
        local rayResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
        
        if rayResult and rayResult.Instance then
            local sound = Instance.new("Sound")
            sound.Volume = 0.8
            sound.RollOffMaxDistance = 100
            sound.RollOffMinDistance = 10
            sound.SoundId = "rbxasset://sounds/action_footsteps_plastic.mp3"
            sound.Parent = hrp
            sound:Play()
            
            game:GetService("Debris"):AddItem(sound, 1)
        end
    end)
end

-- Function to simulate natural movement for footsteps
local function simulateNaturalMovement(moveDirection, velocity)
    if not humanoid or not character then return end
    
    local horizontalVelocity = Vector3.new(velocity.X, 0, velocity.Z)
    local speed = horizontalVelocity.Magnitude
    
    local onGround = false
    pcall(function()
        local state = humanoid:GetState()
        onGround = (state == Enum.HumanoidStateType.Running or 
                   state == Enum.HumanoidStateType.RunningNoPhysics or 
                   state == Enum.HumanoidStateType.Landed)
    end)
    
    if speed > 0.5 and onGround then
        local currentTime = tick()
        local speedMultiplier = math.clamp(speed / 16, 0.3, 2)
        local adjustedInterval = footstepInterval / (speedMultiplier * playbackSpeed)
        
        if currentTime - lastFootstepTime >= adjustedInterval then
            playFootstepSound()
            lastFootstepTime = currentTime
            leftFootstep = not leftFootstep
        end
    end
end

-- Function to ensure the JSON file is available
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

-- FIXED: Function to check if player is within checkpoint area
local function isPlayerNearCheckpoint(checkpointData)
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return false, 999999
    end
    
    if not checkpointData or #checkpointData == 0 then
        return false, 999999
    end
    
    local hrp = character.HumanoidRootPart
    local playerPos = hrp.Position
    local startPos = tableToVec(checkpointData[1].position)
    
    local distance = (playerPos - startPos).Magnitude
    
    return distance <= maxDistanceToCheckpoint, distance
end

-- FIXED: Function to respawn player
local function respawnPlayer()
    if not player or not player.Character then return end
    
    Rayfield:Notify({
        Title = "Auto Respawn",
        Content = "Respawning player...",
        Duration = 2,
        Image = "refresh-cw"
    })
    
    local success = pcall(function()
        player.Character:BreakJoints()
    end)
    
    if not success then
        pcall(function()
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.Health = 0
            end
        end)
    end
end

-- Function to stop auto walk playback
local function stopPlayback()
    isPlaying = false
    isPaused = false
    pausedTime = 0
    accumulatedTime = 0
    lastPlaybackTime = 0
    lastFootstepTime = 0
    recordedHipHeight = nil
    hipHeightOffset = 0
    
    if humanoid then
        humanoid.WalkSpeed = 16
    end
    
    if playbackConnection then
        playbackConnection:Disconnect()
        playbackConnection = nil
    end
end

-- FIXED: FPS-independent playback with proper area check (NO teleport if too far)
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
    
    calculateHipHeightOffset()
    
    if playbackConnection then
        playbackConnection:Disconnect()
        playbackConnection = nil
    end

    -- FIXED: Only teleport to starting point if player is within allowed distance
    local first = data[1]
    if character and character:FindFirstChild("HumanoidRootPart") then
        local hrp = character.HumanoidRootPart
        local firstPos = tableToVec(first.position)
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
            calculateHipHeightOffset()
        end
        
        local currentTime = tick()
        local actualDelta = currentTime - lastPlaybackTime
        lastPlaybackTime = currentTime
        
        actualDelta = math.min(actualDelta, 0.1)
        accumulatedTime = accumulatedTime + (actualDelta * playbackSpeed)
        
        local totalDuration = data[#data].time
        
        if accumulatedTime > totalDuration then
            local final = data[#data]
            if character and character:FindFirstChild("HumanoidRootPart") then
                local hrp = character.HumanoidRootPart
                local finalPos = tableToVec(final.position)
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
        interpPos = adjustPositionForAvatarSize(interpPos)
        
        local interpVel = lerpVector(vel0, vel1, alpha)
        local interpMove = lerpVector(move0, move1, alpha)
        local interpYaw = lerpAngle(yaw0, yaw1, alpha)
        
        local hrp = character.HumanoidRootPart
        local targetCFrame = CFrame.new(interpPos) * CFrame.Angles(0, interpYaw, 0)
        
        local lerpFactor = math.clamp(1 - math.exp(-10 * actualDelta), 0, 1)
        hrp.CFrame = hrp.CFrame:Lerp(targetCFrame, lerpFactor)
        
        pcall(function()
            hrp.AssemblyLinearVelocity = interpVel
        end)
        
        if humanoid then
            humanoid:Move(interpMove, false)
        end
        
        simulateNaturalMovement(interpMove, interpVel)
        
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

-- FIXED: Auto walk sequence with proper area check
local function startAutoWalkSequence()
    -- Check area before starting
    local ok = EnsureJsonFile(jsonFiles[1])
    if not ok then
        Rayfield:Notify({
            Title = "Error",
            Content = "Failed to download checkpoint data",
            Duration = 4,
            Image = "ban"
        })
        return
    end
    
    local firstData = loadCheckpoint(jsonFiles[1])
    if firstData then
        local isNear, distance = isPlayerNearCheckpoint(firstData)
        
        if not isNear then
            Rayfield:Notify({
                Title = "Area Check Failed",
                Content = string.format("Terlalu jauh dari checkpoint awal!\nJarak: %.1f meter (Max: %d meter)", distance, maxDistanceToCheckpoint),
                Duration = 5,
                Image = "alert-triangle"
            })
            autoLoopEnabled = false
            return
        end
    end
    
    currentCheckpoint = 0

    local function playNext()
        if not autoLoopEnabled then return end
        
        currentCheckpoint = currentCheckpoint + 1
        if currentCheckpoint > #jsonFiles then
            if autoRespawnEnabled and currentCheckpoint - 1 == #jsonFiles then
                respawnPlayer()
                task.wait(3)

                if loopingEnabled then
                    Rayfield:Notify({
                        Title = "Auto Walk",
                        Content = "Respawned! Looping dari awal...",
                        Duration = 3,
                        Image = "repeat"
                    })
                    task.wait(1)
                    startAutoWalkSequence()
                else
                    autoLoopEnabled = false
                    Rayfield:Notify({
                        Title = "Auto Walk",
                        Content = "Auto walk selesai setelah respawn!",
                        Duration = 3,
                        Image = "check-check"
                    })
                end
            else
                if loopingEnabled then
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
            return
        end

        local data = loadCheckpoint(checkpointFile)
        if data and #data > 0 then
            if currentCheckpoint == 1 then
                Rayfield:Notify({
                    Title = "Auto Walk (Automatic)",
                    Content = "Auto walk berhasil dijalankan",
                    Duration = 2,
                    Image = "bot"
                })
            end
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
            if autoRespawnEnabled and currentCheckpoint - 1 == #jsonFiles then
                respawnPlayer()
                task.wait(3)

                if loopingEnabled then
                    Rayfield:Notify({
                        Title = "Auto Walk (Manual)",
                        Content = "Respawned! Looping dari checkpoint 1...",
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
                        Content = "Auto walk selesai setelah respawn!",
                        Duration = 2,
                        Image = "check-check"
                    })
                end
            else
                if loopingEnabled then
                    Rayfield:Notify({
                        Title = "Auto Walk (Manual)",
                        Content = "Checkpoint terakhir selesai! Looping dari checkpoint 1...",
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

-- FIXED: Play single checkpoint with proper area check (NO teleport if too far)
local function playSingleCheckpointFile(fileName, checkpointIndex)
    autoLoopEnabled = false
    isManualMode = false
    stopPlayback()
    
    local ok = EnsureJsonFile(fileName)
    if not ok then
        Rayfield:Notify({
            Title = "Error",
            Content = "Failed to download checkpoint",
            Duration = 4,
            Image = "ban"
        })
        return
    end
    
    local data = loadCheckpoint(fileName)
    if not data or #data == 0 then
        Rayfield:Notify({
            Title = "Error",
            Content = "File invalid atau kosong",
            Duration = 4,
            Image = "ban"
        })
        return
    end
    
    -- FIXED: Check if player is within allowed distance
    local isNear, distance = isPlayerNearCheckpoint(data)
    if not isNear then
        Rayfield:Notify({
            Title = "Area Check Failed",
            Content = string.format("Terlalu jauh dari checkpoint!\nJarak: %.1f meter (Max: %d meter)\n\nSilakan mendekati checkpoint terlebih dahulu.", distance, maxDistanceToCheckpoint),
            Duration = 6,
            Image = "alert-triangle"
        })
        return
    end
    
    -- If player is near, proceed with auto walk
    if loopingEnabled then
        Rayfield:Notify({
            Title = "Auto Walk (Manual)",
            Content = "Auto walk berhasil dijalankan dengan looping",
            Duration = 3,
            Image = "bot"
        })
        startManualAutoWalkSequence(checkpointIndex)
    else
        Rayfield:Notify({
            Title = "Auto Walk (Manual)",
            Content = "Auto walk berhasil dijalankan",
            Duration = 3,
            Image = "bot"
        })
        
        startPlayback(data, function()
            if autoRespawnEnabled and fileName == "checkpoint_5.json" then
                respawnPlayer()
                Rayfield:Notify({
                    Title = "Auto Walk (Manual)",
                    Content = "Auto walk selesai! Respawning...",
                    Duration = 2,
                    Image = "check-check"
                })
            else
                Rayfield:Notify({
                    Title = "Auto Walk (Manual)",
                    Content = "Auto walk selesai!",
                    Duration = 2,
                    Image = "check-check"
                })
            end
        end)
    end
end

-- Event listener when the player respawns
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    if isPlaying then stopPlayback() end
end)

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
    end,
})
-------------------------------------------------------------

-----| MENU 1.5 > AUTO WALK LOOPING & RESPAWN |-----
local Section = AutoWalkTab:CreateSection("Auto Walk (Looping & Respawn)")

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

local AutoRespawnToggle = AutoWalkTab:CreateToggle({
   Name = "♻️ Auto Respawn",
   CurrentValue = false,
   Callback = function(Value)
       autoRespawnEnabled = Value
       if Value then
           Rayfield:Notify({
               Title = "Auto Respawn",
               Content = "Auto respawn diaktifkan! Player akan respawn otomatis setelah selesai.",
               Duration = 4,
               Image = "refresh-cw"
           })
       else
           Rayfield:Notify({
               Title = "Auto Respawn",
               Content = "Auto respawn dinonaktifkan!",
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
local CP0Toggle = AutoWalkTab:CreateToggle({
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
-------------------------------------------------------------
-- AUTO WALK - END
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
local Section = UpdateTab:CreateSection("Update Script Menu")

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
