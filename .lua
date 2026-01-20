
if not UserKey then error("Define UserKey first!") end

local player = game.Players.LocalPlayer
local currentUser = player.Name:lower()

-- Key Database (bisa dipindah ke external file nanti)
local KeyDB = {
    ["Admin_7tcr637n2t87ctg5y798t2547ty"] = {
        users = {"Louissxe", "admin123"},
        expiry = os.time() + 2592000, -- 30 hari
        tier = "premium"
    },
    ["Test_78tn3c7tr43427trvnt2875342"] = {
        users = "*", -- Semua user bisa
        expiry = os.time() + 86400, -- 1 hari
        tier = "trial"
    },
    ["LS_7n9ty7tcr24rcrcrcrt23r4693r976"] = {
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
    
    return false
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
