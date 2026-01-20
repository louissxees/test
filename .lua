if not UserKey then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "LS Hub - Error",
        Text = "Define UserKey first! Example: UserKey = 'LS_123456'",
        Duration = 5
    })
    error("UserKey not defined!")
end

-- Services
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local currentUsername = player.Name

-- URLs
local KEY_DB_URL = "https://raw.githubusercontent.com/louissxees/test/refs/heads/main/.json"
local MAIN_SCRIPT_URL = "https://raw.githubusercontent.com/louissxe/Lua/refs/heads/main/light.lua"

-- Fetch Key Database dari JSON
local function FetchKeyDatabase()
    local success, response = pcall(function()
        local json = game:HttpGet(KEY_DB_URL)
        return HttpService:JSONDecode(json)
    end)
    
    if success then
        return response
    else
        return {
            ["LS_86td2ni6c3r4tb4387xj78ocr4"] = {
                users = ["Louissxe"],
                expiry = os.time() + 2592000,
                tier = "premium",
                active = true
            }
        }
    end
end

-- Validasi Key berdasarkan Username
local function ValidateKey(key, keyDB)
    local keyData = keyDB[key]
    
    -- 1. Cek key
    if not keyData then
        return false, "Key tidak ditemukan"
    end
    
    -- 2. Cek active status
    if not keyData.active then
        return false, "Key dinonaktifkan"
    end
    
    -- 3. Cek expiry
    if os.time() > keyData.expiry then
        local expiredDays = math.floor((os.time() - keyData.expiry) / 86400)
        return false, "Key expired " .. expiredDays .. " hari lalu"
    end
    
    -- 4. 🔥 VALIDASI USERNAME ROBLOX 🔥
    local usernameValid = false
    
    if keyData.users == "*" then
        -- * = semua username boleh pakai
        usernameValid = true
    else
        -- Loop melalui semua username yang diizinkan
        for _, allowedUser in ipairs(keyData.users) do
            if allowedUser:lower() == currentUsername:lower() then
                usernameValid = true
                break
            end
        end
    end
    
    if not usernameValid then
        local allowedUsers = ""
        if keyData.users == "*" then
            allowedUsers = "semua user"
        else
            allowedUsers = table.concat(keyData.users, ", ")
        end
        return false, "Key hanya untuk: " .. allowedUsers
    end
    
    -- Success!
    local daysLeft = math.floor((keyData.expiry - os.time()) / 86400)
    return true, {
        tier = keyData.tier,
        daysLeft = daysLeft,
        allowedUsers = keyData.users
    }
end

-- Tampilkan Error UI
local function ShowErrorUI(errorMsg)
    local ScreenGui = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    Frame.Size = UDim2.new(0, 400, 0, 250)
    Frame.Position = UDim2.new(0.5, -200, 0.5, -125)
    Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = Frame
    
    -- Header
    local Header = Instance.new("TextLabel")
    Header.Size = UDim2.new(1, 0, 0, 60)
    Header.Position = UDim2.new(0, 0, 0, 0)
    Header.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    Header.Text = "KEY VALIDATION FAILED"
    Header.TextColor3 = Color3.fromRGB(255, 255, 255)
    Header.Font = Enum.Font.GothamBold
    Header.TextSize = 20
    Header.Parent = Frame
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 8)
    HeaderCorner.Parent = Header
    
    -- Error Message
    local ErrorMsg = Instance.new("TextLabel")
    ErrorMsg.Size = UDim2.new(1, -40, 0, 100)
    ErrorMsg.Position = UDim2.new(0, 20, 0, 70)
    ErrorMsg.BackgroundTransparency = 1
    ErrorMsg.Text = "Username: " .. currentUsername .. "\n\nKey: " .. UserKey .. "\n\nError: " .. errorMsg
    ErrorMsg.TextColor3 = Color3.fromRGB(220, 220, 220)
    ErrorMsg.Font = Enum.Font.Gotham
    ErrorMsg.TextSize = 16
    ErrorMsg.TextWrapped = true
    ErrorMsg.Parent = Frame
    
    -- Discord Button
    local DiscordBtn = Instance.new("TextButton")
    DiscordBtn.Size = UDim2.new(0.7, 0, 0, 40)
    DiscordBtn.Position = UDim2.new(0.15, 0, 0, 180)
    DiscordBtn.BackgroundColor3 = Color3.fromHex("#5865F2")
    DiscordBtn.Text = "Get Valid Key @ Discord"
    DiscordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    DiscordBtn.Font = Enum.Font.GothamBold
    DiscordBtn.TextSize = 16
    DiscordBtn.Parent = Frame
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = DiscordBtn
    
    DiscordBtn.MouseButton1Click:Connect(function()
        local discordLink = "https://discord.gg/s9v49dwV"
        if setclipboard then
            setclipboard(discordLink)
            DiscordBtn.Text = "Link Copied!"
            task.wait(1)
            DiscordBtn.Text = "Get Valid Key @ Discord"
        end
    end)
end

-- Fetch key database
local keyDB = FetchKeyDatabase()

-- Validasi
local isValid, result = ValidateKey(UserKey, keyDB)

if isValid then
    
    -- Load main script
    loadstring(game:HttpGet(MAIN_SCRIPT_URL))()
    
    -- Welcome message
    task.spawn(function()
        task.wait(2)
        if WindUI then
            WindUI:Notify({
                Title = "LS Hub Premium",
                Content = "Welcome " .. currentUsername .. "!\nTier: " .. result.tier .. " (" .. result.daysLeft .. " days left)",
                Duration = 5,
                Icon = "check"
            })
        end
    end)
    
else
    -- Show error
    ShowErrorUI(tostring(result))
    error("Key validation failed: " .. tostring(result))
end
