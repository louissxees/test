if not UserKey then error("Define UserKey first!") end

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
    
    return false, "Key tidak valid untuk user ini"
end

-- Animasi error dengan efek menarik
local function ShowErrorAnimation(message)
    local sg = Instance.new("ScreenGui")
    sg.Name = "KeyErrorUI"
    sg.Parent = player:WaitForChild("PlayerGui")
    sg.ResetOnSpawn = false
    
    -- Main frame dengan efek glow
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "ErrorFrame"
    mainFrame.Size = UDim2.new(0, 400, 0, 250)
    mainFrame.Position = UDim2.new(0.5, -200, 0.3, -125)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    mainFrame.BorderSizePixel = 0
    mainFrame.BackgroundTransparency = 1
    mainFrame.ClipsDescendants = true
    
    -- Gradient background
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 50, 50)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 40, 40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 30, 30))
    })
    gradient.Rotation = 45
    gradient.Parent = mainFrame
    
    -- Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- Stroke
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 100, 100)
    stroke.Thickness = 3
    stroke.Transparency = 0.8
    stroke.Parent = mainFrame
    
    -- Error icon
    local icon = Instance.new("ImageLabel")
    icon.Name = "ErrorIcon"
    icon.Size = UDim2.new(0, 80, 0, 80)
    icon.Position = UDim2.new(0.5, -40, 0.2, -40)
    icon.AnchorPoint = Vector2.new(0.5, 0.5)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://3926305904"
    icon.ImageRectOffset = Vector2.new(524, 764)
    icon.ImageRectSize = Vector2.new(36, 36)
    icon.ImageColor3 = Color3.fromRGB(255, 100, 100)
    icon.ScaleType = Enum.ScaleType.Fit
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(0.8, 0, 0, 40)
    title.Position = UDim2.new(0.1, 0, 0.45, 0)
    title.BackgroundTransparency = 1
    title.Text = "KEY ERROR"
    title.Font = Enum.Font.GothamBold
    title.TextColor3 = Color3.fromRGB(255, 200, 200)
    title.TextSize = 24
    title.TextWrapped = true
    
    -- Message
    local msg = Instance.new("TextLabel")
    msg.Name = "Message"
    msg.Size = UDim2.new(0.8, 0, 0, 60)
    msg.Position = UDim2.new(0.1, 0, 0.65, 0)
    msg.BackgroundTransparency = 1
    msg.Text = message .. "\n\nGet key: discord.gg/s9v49dwV"
    msg.Font = Enum.Font.Gotham
    msg.TextColor3 = Color3.fromRGB(255, 180, 180)
    msg.TextSize = 18
    msg.TextWrapped = true
    
    -- Timer label
    local timerLabel = Instance.new("TextLabel")
    timerLabel.Name = "Timer"
    timerLabel.Size = UDim2.new(0, 100, 0, 30)
    timerLabel.Position = UDim2.new(0.5, -50, 0.92, -15)
    timerLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    timerLabel.BackgroundTransparency = 1
    timerLabel.Text = "Closing in 3"
    timerLabel.Font = Enum.Font.GothamMedium
    timerLabel.TextColor3 = Color3.fromRGB(255, 150, 150)
    timerLabel.TextSize = 16
    
    -- Particle effects
    local particles = Instance.new("Frame")
    particles.Name = "Particles"
    particles.Size = UDim2.new(1, 0, 1, 0)
    particles.BackgroundTransparency = 1
    particles.Parent = mainFrame
    
    -- Parent semua elemen
    icon.Parent = mainFrame
    title.Parent = mainFrame
    msg.Parent = mainFrame
    timerLabel.Parent = mainFrame
    mainFrame.Parent = sg
    
    -- Animasi masuk
    local tweenService = game:GetService("TweenService")
    
    local enterAnim = tweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0,
        Position = UDim2.new(0.5, -200, 0.35, -125)
    })
    
    local iconAnim = tweenService:Create(icon, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 100, 0, 100),
        Position = UDim2.new(0.5, -50, 0.2, -50)
    })
    
    enterAnim:Play()
    iconAnim:Play()
    
    -- Buat partikel
    for i = 1, 8 do
        task.spawn(function()
            local particle = Instance.new("Frame")
            particle.Size = UDim2.new(0, 4, 0, 4)
            particle.AnchorPoint = Vector2.new(0.5, 0.5)
            particle.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
            particle.BorderSizePixel = 0
            
            local particleCorner = Instance.new("UICorner")
            particleCorner.CornerRadius = UDim.new(1, 0)
            particleCorner.Parent = particle
            
            local angle = math.rad((i / 8) * 360)
            local radius = 50
            
            particle.Position = UDim2.new(0.5, math.cos(angle) * radius, 0.5, math.sin(angle) * radius)
            particle.Parent = particles
            
            -- Animasi partikel
            local tween = tweenService:Create(particle, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.new(0, 0, 0, 0),
                BackgroundTransparency = 1
            })
            
            tween:Play()
            tween.Completed:Connect(function()
                particle:Destroy()
            end)
        end)
        task.wait(0.1)
    end
    
    -- Animasi pulsing icon
    local pulseAnim = tweenService:Create(icon, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        ImageColor3 = Color3.fromRGB(255, 150, 150)
    })
    pulseAnim:Play()
    
    -- Countdown timer
    for i = 3, 1, -1 do
        timerLabel.Text = "Closing in " .. i
        local scaleAnim = tweenService:Create(timerLabel, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            TextSize = 22
        })
        scaleAnim:Play()
        scaleAnim.Completed:Wait()
        
        local scaleBack = tweenService:Create(timerLabel, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            TextSize = 16
        })
        scaleBack:Play()
        task.wait(0.8)
    end
    
    -- Animasi keluar
    local exitAnim = tweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = UDim2.new(0.5, -200, 0.2, -125),
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 0, 0)
    })
    
    exitAnim:Play()
    exitAnim.Completed:Wait()
    sg:Destroy()
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
            -- Your welcome notification code here
        end
    end)
else
    -- Tampilkan error di output
    warn("[Key System] " .. tierOrError)
    
    -- Tampilkan UI error dengan animasi
    ShowErrorAnimation(tierOrError)
end
