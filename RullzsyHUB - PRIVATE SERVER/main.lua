local bit = bit32
math.randomseed(os.time())

local MD5_T_CONSTANTS = {
  0xd76aa478,0xe8c7b756,0x242070db,0xc1bdceee,0xf57c0faf,0x4787c62a,0xa8304613,0xfd469501,
  0x698098d8,0x8b44f7af,0xffff5bb1,0x895cd7be,0x6b901122,0xfd987193,0xa679438e,0x49b40821,
  0xf61e2562,0xc040b340,0x265e5a51,0xe9b6c7aa,0xd62f105d,0x02441453,0xd8a1e681,0xe7d3fbc8,
  0x21e1cde6,0xc33707d6,0xf4d50d87,0x455a14ed,0xa9e3e905,0xfcefa3f8,0x676f02d9,0x8d2a4c8a,
  0xfffa3942,0x8771f681,0x6d9d6122,0xfde5380c,0xa4beea44,0x4bdecfa9,0xf6bb4b60,0xbebfbc70,
  0x289b7ec6,0xeaa127fa,0xd4ef3085,0x04881d05,0xd9d4d039,0xe6db99e5,0x1fa27cf8,0xc4ac5665,
  0xf4292244,0x432aff97,0xab9423a7,0xfc93a039,0x655b59c3,0x8f0ccc92,0xffeff47d,0x85845dd1,
  0x6fa87e4f,0xfe2ce6e0,0xa3014314,0x4e0811a1,0xf7537e82,0xbd3af235,0x2ad7d2bb,0xeb86d391
}
local MD5_SHIFTS = {7,12,17,22,5,9,14,20,4,11,16,23,6,10,15,21}

local function calculateMD5(message)
    local h0,h1,h2,h3 = 0x67452301,0xefcdab89,0x98badcfe,0x10325476
    local padded = message .. "\128"
    while #padded % 64 ~= 56 do padded = padded .. "\0" end
    local bitlen = #message * 8
    for i = 0,7 do padded = padded .. string.char(bit.band(bit.rshift(bitlen, i*8), 0xFF)) end

    for i = 1, #padded, 64 do
        local chunk = padded:sub(i, i+63)
        local w = {}
        for j = 0,15 do
            local b1,b2,b3,b4 = chunk:byte(j*4+1, j*4+4)
            w[j] = bit.bor(b1, bit.lshift(b2,8), bit.lshift(b3,16), bit.lshift(b4,24))
        end

        local a,b,c,d = h0,h1,h2,h3
        for j = 0,63 do
            local f,k,shift_index
            if j < 16 then
                f = bit.bor(bit.band(b,c), bit.band(bit.bnot(b), d)); k = j; shift_index = j % 4
            elseif j < 32 then
                f = bit.bor(bit.band(d,b), bit.band(c, bit.bnot(d))); k = (1 + 5*j) % 16; shift_index = 4 + (j % 4)
            elseif j < 48 then
                f = bit.bxor(b,c,d); k = (5 + 3*j) % 16; shift_index = 8 + (j % 4)
            else
                f = bit.bxor(c, bit.bor(b, bit.bnot(d))); k = (7 * j) % 16; shift_index = 12 + (j % 4)
            end

            local temp = bit.band(a + f + w[k] + MD5_T_CONSTANTS[j+1], 0xFFFFFFFF)
            local shift = MD5_SHIFTS[shift_index + 1]
            temp = bit.bor(bit.lshift(temp, shift), bit.rshift(temp, 32 - shift))
            local new_b = bit.band(b + temp, 0xFFFFFFFF)
            a,b,c,d = d, new_b, b, c
        end

        h0 = bit.band(h0 + a, 0xFFFFFFFF)
        h1 = bit.band(h1 + b, 0xFFFFFFFF)
        h2 = bit.band(h2 + c, 0xFFFFFFFF)
        h3 = bit.band(h3 + d, 0xFFFFFFFF)
    end

    local out = ""
    for _,hv in ipairs({h0,h1,h2,h3}) do
        for i = 0,3 do out = out .. string.char(bit.band(bit.rshift(hv, i*8), 0xFF)) end
    end
    return out
end

local function calculateHMAC(key, message, hashFunction)
    if #key > 64 then key = hashFunction(key) end
    local oPad, iPad = "", ""
    for i = 1, 64 do
        local b = (i <= #key) and string.byte(key, i) or 0
        oPad = oPad .. string.char(bit.bxor(b, 0x5C))
        iPad = iPad .. string.char(bit.bxor(b, 0x36))
    end
    return hashFunction(oPad .. hashFunction(iPad .. message))
end

local function encodeBase64(data)
    local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local res = ((data:gsub(".", function(c)
        local b = c:byte()
        local s = ""
        for i = 8,1,-1 do s = s .. ((b % 2^i - b % 2^(i-1) > 0) and "1" or "0") end
        return s
    end) .. "0000"):gsub("%d%d%d%d%d%d", function(s)
        if #s < 6 then return "" end
        local v = 0
        for i = 1,6 do if s:sub(i,i) == "1" then v = v + 2^(6-i) end end
        return alphabet:sub(v+1, v+1)
    end) .. ({ "", "==", "=" })[#data % 3 + 1])
    return res
end

local function generateAuthCode(placeId)
    -- GUID v4 (raw bytes + formatted hex)
    local uuidBytes = {}
    for i = 1, 16 do uuidBytes[i] = math.random(0,255) end
    uuidBytes[7] = bit.bor(bit.band(uuidBytes[7], 0x0F), 0x40) -- version 4
    uuidBytes[9] = bit.bor(bit.band(uuidBytes[9], 0x3F), 0x80) -- variant

    local uuidRaw = ""
    for i = 1,16 do uuidRaw = uuidRaw .. string.char(uuidBytes[i]) end
    local formattedGUID = string.format(
      "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x",
      table.unpack(uuidBytes)
    )

    local placeBytes = ""
    local n = placeId
    for i = 1,8 do
        placeBytes = placeBytes .. string.char(n % 256)
        n = math.floor(n / 256)
    end

    local payload = uuidRaw .. placeBytes
    local secretKey = "e4Yn8ckbCJtw2sv7qmbg"
    local signature = calculateHMAC(secretKey, payload, calculateMD5)

    local combined = signature .. payload
    local auth = encodeBase64(combined)
    -- make URL-safe and append padding count (as original)
    auth = auth:gsub("+", "-"):gsub("/", "_")
    local padCount = 0
    auth = auth:gsub("=", function() padCount = padCount + 1; return "" end)
    auth = auth .. tostring(padCount)

    return auth, formattedGUID
end

local placeId = game.PlaceId or 0
local authCode, guid = generateAuthCode(placeId)
if setclipboard then
    setclipboard(authCode)
end

-- Fire server event (sama seperti sebelumnya)
local success, err = pcall(function()
    local rs = game:GetService("RobloxReplicatedStorage")
    if rs and rs:FindFirstChild("ContactListIrisInviteTeleport") then
        rs.ContactListIrisInviteTeleport:FireServer(placeId, "", authCode)
    end
end)

spawn(function()
    wait(2)
    if setclipboard then setclipboard(authCode) end
end)

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
]])
