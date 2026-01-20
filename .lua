if not UserKey then
    error("UserKey tidak ditemukan!")
end
local KEY_DB_URL = ""
local function ValidateKey(key)
    local success, keyDB = pcall(function()
        local json = game:HttpGet(KEY_DB_URL)
        return game:GetService("HttpService"):JSONDecode(json)
    end)
    if not success then
        warn("Gagal load key")
        keyDB = {
            ["Admin_123456"] = {valid = true, tier = "premium"}
        }
    end
    return keyDB[key] or false
end

-- Main
if ValidateKey(UserKey) then
    loadstring(game:HttpGet(""))()
else
    warn("Key invalid!")
end
