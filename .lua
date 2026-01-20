
if not UserKey then error("❌ Define UserKey first!") end

local player = game.Players.LocalPlayer
local currentUser = player.Name:lower()

-- Key Database (bisa dipindah ke external file nanti)
local KeyDB = {
    ["LS_123456"] = {
        users = {"Louissxe", "admin123"},
        expiry = os.time() + 2592000, -- 30 hari
        tier = "premium"
    },
    ["TRIAL_789012"] = {
        users = "*", -- Semua user bisa
        expiry = os.time() + 86400, -- 1 hari
        tier = "trial"
    },
    ["VIP_345678"] = {
        users = {"vipuser1", "vipuser2", "vipuser3"},
        expiry = os.time() + 604800, -- 7 hari
        tier = "vip"
    }
}

-- Validasi Username
local function ValidateKey(key)
    local keyData = KeyDB[key]
    if not keyData then return false, "Key tidak ditemukan" end
    
    -- Cek expiry
    if os.time() > keyData.expiry then
        return false, "Key sudah expired"
    end
    
    -- Cek username
    if keyData.users == "*" then
        return true, keyData.tier
    end
    
    for _, allowedUser in ipairs(keyData.users) do
        if allowedUser:lower() == currentUser then
            return true, keyData.tier
        end
    end
    
    return false, "Key hanya untuk: " .. table.concat(keyData.users, ", ")
end

-- Main
local isValid, tierOrError = ValidateKey(UserKey)

if isValid then
    
    -- Load main script
    loadstring(game:HttpGet("https://raw.githubusercontent.com/louissxe/Lua/refs/heads/main/light.lua"))()
    
    -- Welcome notification
    task.spawn(function()
        task.wait(2)
        if WindUI then
        end
    end)
    
else
    error("" .. tierOrError)
end
