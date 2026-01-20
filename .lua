if not UserKey then
    error("UserKey tidak ditemukan!")
end
local KEY_DB_URL = "https://raw.githubusercontent.com/ayangacem-netizen/test/refs/heads/main/.json"
local function ValidateKey(key)
    local success, keyDB = pcall(function()
        local json = game:HttpGet(KEY_DB_URL)
        return game:GetService("HttpService"):JSONDecode(json)
    end)
    if not success then
        warn("Gagal load key")
        keyDB = {
            ["Admin_8743fegh472frgu729428743"] = {valid = true, tier = "premium"}
        }
    end
    return keyDB[key] or false
end

-- Main
if ValidateKey(UserKey) then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/louissxe/Lua/refs/heads/main/light.lua"))()
else
    warn("Key invalid!")
end
