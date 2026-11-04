local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")
local VIM = game:GetService("VirtualInputManager")

local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LP:GetMouse()

local S = {
    AutoParry = false,
    Aimbot = false,
    MegaJump = false,
    JumpPower = 80,
    ESP = false,
    Tracers = false,
    InfJump = false,
    Fly = false,
    FlySpeed = 50,
}

local GuiOpen = true
local flyBV = nil
local highlights = {}
local tracerLines = {}
local hue = 0

local function char()
    return LP.Character
end

local function hrp()
    local c = char()
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function hum()
    local c = char()
    return c and c:FindFirstChild("Humanoid")
end

local SG = Instance.new("ScreenGui")
SG.Name = "CWMenu"
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() SG.Parent = CoreGui end)
if not SG.Parent then SG.Parent = LP:WaitForChild("PlayerGui") end

local Skull = Instance.new("TextButton")
Skull.Size = UDim2.new(0, 50, 0, 50)
Skull.Position = UDim2.new(1, -66, 0.5, -25)
Skull.BackgroundColor3 = Color3.fromRGB(40, 10, 60)
Skull.BackgroundTransparency = 0.3
Skull.Text = "⚔"
Skull.TextSize = 24
Skull.TextColor3 = Color3.fromRGB(200, 120, 255)
Skull.Visible = false
Skull.ZIndex = 50
Skull.Parent = SG
Instance.new("UICorner", Skull).CornerRadius = UDim.new(1, 0)

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 480, 0, 580)
Main.Position = UDim2.new(0.5, -240, 0.5, -290)
Main.BackgroundColor3 = Color3.fromRGB(30, 5, 45)
Main.BackgroundTransparency = 0.2
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = SG
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)
local ms = Instance.new("UIStroke", Main)
ms.Color = Color3.fromRGB(160, 60, 255)
ms.Thickness = 1.5
ms.Transparency = 0.3

local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(40, 10, 60)
Header.BackgroundTransparency = 0.25
Header.BorderSizePixel = 0
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 16)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -90, 1, 0)
Title.Position = UDim2.new(0, 18, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "COMBAT WARRIORS"
Title.TextColor3 = Color3.fromRGB(200, 130, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left

local Close = Instance.new("TextButton", Header)
Close.Size = UDim2.new(0, 34, 0, 34)
Close.Position = UDim2.new(1, -44, 0, 8)
Close.BackgroundColor3 = Color3.fromRGB(80, 20, 100)
Close.BackgroundTransparency = 0.2
Close.Text = "×"
Close.TextColor3 = Color3.new(1,1,1)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 20
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 8)

Close.MouseButton1Click:Connect(function()
    Main.Visible = false
    GuiOpen = false
    Skull.Visible = true
end)
Skull.MouseButton1Click:Connect(function()
    Main.Visible = true
    GuiOpen = true
    Skull.Visible = false
end)

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -24, 1, -70)
Scroll.Position = UDim2.new(0, 12, 0, 58)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 4
Scroll.ScrollBarImageColor3 = Color3.fromRGB(160, 80, 255)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 900)

local function AddToggle(y, text, key, default)
    S[key] = default
    local row = Instance.new("Frame", Scroll)
    row.Size = UDim2.new(1, -8, 0, 44)
    row.Position = UDim2.new(0, 0, 0, y)
    row.BackgroundColor3 = Color3.fromRGB(45, 15, 65)
    row.BackgroundTransparency = 0.35
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)

    local lab = Instance.new("TextLabel", row)
    lab.Size = UDim2.new(0.7, 0, 1, 0)
    lab.Position = UDim2.new(0, 14, 0, 0)
    lab.BackgroundTransparency = 1
    lab.Text = text
    lab.TextColor3 = Color3.fromRGB(220, 190, 255)
    lab.Font = Enum.Font.GothamMedium
    lab.TextSize = 15
    lab.TextXAlignment = Enum.TextXAlignment.Left

    local btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(0, 60, 0, 28)
    btn.Position = UDim2.new(1, -74, 0.5, -14)
    btn.BackgroundColor3 = default and Color3.fromRGB(140, 50, 220) or Color3.fromRGB(50, 20, 70)
    btn.BackgroundTransparency = 0.15
    btn.Text = default and "ON" or "OFF"
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    btn.MouseButton1Click:Connect(function()
        S[key] = not S[key]
        btn.Text = S[key] and "ON" or "OFF"
        TweenService:Create(btn, TweenInfo.new(0.12), {
            BackgroundColor3 = S[key] and Color3.fromRGB(140, 50, 220) or Color3.fromRGB(50, 20, 70)
        }):Play()
    end)
end

local function AddSlider(y, text, key, minV, maxV, default)
    S[key] = default
    local row = Instance.new("Frame", Scroll)
    row.Size = UDim2.new(1, -8, 0, 70)
    row.Position = UDim2.new(0, 0, 0, y)
    row.BackgroundColor3 = Color3.fromRGB(45, 15, 65)
    row.BackgroundTransparency = 0.35
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)

    local lab = Instance.new("TextLabel", row)
    lab.Size = UDim2.new(1, -20, 0, 24)
    lab.Position = UDim2.new(0, 14, 0, 6)
    lab.BackgroundTransparency = 1
    lab.Text = text .. ": " .. default
    lab.TextColor3 = Color3.fromRGB(220, 190, 255)
    lab.Font = Enum.Font.GothamMedium
    lab.TextSize = 14
    lab.TextXAlignment = Enum.TextXAlignment.Left

    local barBg = Instance.new("Frame", row)
    barBg.Size = UDim2.new(1, -28, 0, 14)
    barBg.Position = UDim2.new(0, 14, 0, 40)
    barBg.BackgroundColor3 = Color3.fromRGB(30, 10, 45)
    barBg.BackgroundTransparency = 0.2
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", barBg)
    fill.Size = UDim2.new((default - minV) / (maxV - minV), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(160, 70, 255)
    fill.BackgroundTransparency = 0.1
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local dragging = false
    local function update(x)
        local rel = math.clamp((x - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
        local val = math.floor(minV + (maxV - minV) * rel)
        S[key] = val
        fill.Size = UDim2.new(rel, 0, 1, 0)
        lab.Text = text .. ": " .. val
    end

    barBg.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(i.Position.X)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            update(i.Position.X)
        end
    end)
end

AddToggle(0, "Auto Parry", "AutoParry", false)
AddToggle(54, "Aimbot (Bow)", "Aimbot", false)
AddToggle(108, "Mega Jump", "MegaJump", false)
AddSlider(162, "Jump Power", "JumpPower", 1, 150, 80)
AddToggle(244, "ESP Rainbow", "ESP", false)
AddToggle(298, "Tracers", "Tracers", false)
AddToggle(352, "Inf Jump", "InfJump", false)
AddToggle(406, "Fly", "Fly", false)

UIS.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if inp.KeyCode == Enum.KeyCode.RightShift then
        GuiOpen = not GuiOpen
        Main.Visible = GuiOpen
        Skull.Visible = not GuiOpen
    end
end)

local function clearESP()
    for plr, hl in pairs(highlights) do
        if hl then hl:Destroy() end
        highlights[plr] = nil
    end
end

local function clearTracers()
    for _, l in pairs(tracerLines) do
        if l then l:Destroy() end
    end
    tracerLines = {}
end

local function makeTracer(toPos)
    local from = Vector2.new(Camera.ViewportSize.X / 2, 0)
    local to, onScreen = Camera:WorldToViewportPoint(toPos)
    if not onScreen or to.Z < 0 then return end
    local line = Drawing and Drawing.new("Line") or nil
    if line then
        line.From = from
        line.To = Vector2.new(to.X, to.Y)
        line.Color = Color3.fromRGB(255, 40, 40)
        line.Thickness = 1
        line.Transparency = 0.3
        line.Visible = true
        table.insert(tracerLines, line)
    end
end

local lastParry = 0
RunService.Heartbeat:Connect(function()
    hue = (hue + 0.01) % 1
    local rainbow = Color3.fromHSV(hue, 1, 1)

    if S.AutoParry then
        local myRoot = hrp()
        if myRoot then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and p.Character then
                    local ehrp = p.Character:FindFirstChild("HumanoidRootPart")
                    local ehum = p.Character:FindFirstChild("Humanoid")
                    if ehrp and ehum and ehum.Health > 0 then
                        local d = (ehrp.Position - myRoot.Position).Magnitude
                        if d < 12 then
                            local animator = ehum:FindFirstChildOfClass("Animator")
                            if animator then
                                for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                                    local n = string.lower(track.Name)
                                    if string.find(n, "slash") or string.find(n, "swing") or string.find(n, "attack") or string.find(n, "lunge") or string.find(n, "stab") then
                                        if tick() - lastParry > 0.45 then
                                            lastParry = tick()
                                            pcall(function()
                                                VIM:SendKeyEvent(true, Enum.KeyCode.F, false, game)
                                                task.wait(0.05)
                                                VIM:SendKeyEvent(false, Enum.KeyCode.F, false, game)
                                            end)
                                            pcall(function()
                                                VIM:SendKeyEvent(true, Enum.KeyCode.R, false, game)
                                                task.wait(0.05)
                                                VIM:SendKeyEvent(false, Enum.KeyCode.R, false, game)
                                            end)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    if S.Aimbot then
        local tool = char() and char():FindFirstChildOfClass("Tool")
        local isBow = tool and (string.find(string.lower(tool.Name), "bow") or string.find(string.lower(tool.Name), "crossbow") or string.find(string.lower(tool.Name), "archer"))
        if isBow or UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local best, bestD = nil, 9e9
            local myRoot = hrp()
            if myRoot then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character then
                        local head = p.Character:FindFirstChild("Head")
                        local ehum = p.Character:FindFirstChild("Humanoid")
                        if head and ehum and ehum.Health > 0 then
                            local pos, on = Camera:WorldToViewportPoint(head.Position)
                            if on and pos.Z > 0 then
                                local d = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                                if d < bestD and d < 400 then
                                    bestD = d
                                    best = head
                                end
                            end
                        end
                    end
                end
            end
            if best then
                Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, best.Position)
                if UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or isBow then
                    pcall(function()
                        VirtualUser:Button1Down(Vector2.new(), Camera.CFrame)
                        task.wait(0.03)
                        VirtualUser:Button1Up(Vector2.new(), Camera.CFrame)
                    end)
                end
            end
        end
    end

    local h = hum()
    if h then
        if S.MegaJump then
            h.JumpPower = S.JumpPower
            h.UseJumpPower = true
        end
    end

    if S.ESP then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                if not highlights[p] or not highlights[p].Parent then
                    local hl = Instance.new("Highlight")
                    hl.FillTransparency = 0.45
                    hl.OutlineTransparency = 0
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Parent = p.Character
                    highlights[p] = hl
                end
                if highlights[p] then
                    highlights[p].FillColor = rainbow
                    highlights[p].OutlineColor = rainbow
                    if highlights[p].Parent ~= p.Character then
                        highlights[p].Parent = p.Character
                    end
                end
            end
        end
    else
        clearESP()
    end

    clearTracers()
    if S.Tracers then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local t = p.Character:FindFirstChild("HumanoidRootPart") or p.Character:FindFirstChild("Head")
                if t then makeTracer(t.Position) end
            end
        end
    end

    if S.Fly then
        local root = hrp()
        if root then
            if not flyBV or not flyBV.Parent then
                flyBV = Instance.new("BodyVelocity")
                flyBV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                flyBV.Parent = root
            end
            local dir = Vector3.zero
            if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.yAxis end
            if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.yAxis end
            flyBV.Velocity = dir.Magnitude > 0 and dir.Unit * S.FlySpeed or Vector3.zero
        end
    elseif flyBV then
        flyBV:Destroy()
        flyBV = nil
    end
end)

UIS.JumpRequest:Connect(function()
    if S.InfJump then
        local h = hum()
        if h then
            h:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

pcall(function()
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local m = getnamecallmethod()
        if m == "Kick" or m == "kick" then return end
        return old(self, ...)
    end)
    setreadonly(mt, true)
end)

LP.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    flyBV = nil
    clearESP()
end)
