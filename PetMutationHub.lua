
-- ✅ Combined Script Hub GUI with Pet Detection, Mutation, and Full Functionality
-- Works with KRNL, Delta, Synapse. GUI now parents to PlayerGui for full compatibility.

-- Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Mutation List
local Mutations = {
    "Tranquil", "Ascended", "Radiant", "Rainbow", "Shocked",
    "IronSkin", "Tiny", "Mega", "Golden", "Frozen",
    "Windy", "Inverted", "Shiny"
}

-- Get random mutation
local function getRandomMutation()
    return Mutations[math.random(1, #Mutations)]
end

-- Get held pet model
local function getHeldPet()
    local char = player.Character or player.CharacterAdded:Wait()
    for _, obj in pairs(char:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChild("Head") then
            return obj
        end
    end
    return nil
end

-- Apply mutation
local function applyMutationToHeldPet()
    local pet = getHeldPet()
    if not pet then
        warn("No held pet detected.")
        PetNameLabel.Text = "No Pet Held"
        return
    end

    PetNameLabel.Text = "Pet: " .. pet.Name

    local existing = pet:FindFirstChild("MutationTag")
    if existing then existing:Destroy() end

    local chosen = getRandomMutation()
    local part = pet:FindFirstChild("Head") or pet:FindFirstChildWhichIsA("BasePart")
    if not part then warn("No part found") return end

    local tag = Instance.new("BillboardGui")
    tag.Name = "MutationTag"
    tag.Size = UDim2.new(0, 100, 0, 40)
    tag.Adornee = part
    tag.AlwaysOnTop = true
    tag.StudsOffset = Vector3.new(0, 2.5, 0)
    tag.Parent = pet

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 0)
    label.Font = Enum.Font.GothamBold
    label.Text = chosen
    label.TextScaled = true
    label.TextStrokeTransparency = 0.5
    label.Parent = tag

    print("Mutation applied:", chosen)
end

-- GUI Elements
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local PetNameLabel = Instance.new("TextLabel")
local MutateButton = Instance.new("TextButton")
local PlaceholderLabel = Instance.new("TextLabel")

ScreenGui.Name = "ScriptHubGUI"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Name = "MainFrame"
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Position = UDim2.new(0.2, 0, 0.2, 0)
Frame.Size = UDim2.new(0, 250, 0, 220)
Frame.Active = true

Title.Name = "Title"
Title.Parent = Frame
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Pet Mutation Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 22

PetNameLabel.Name = "PetNameLabel"
PetNameLabel.Parent = Frame
PetNameLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
PetNameLabel.Position = UDim2.new(0.1, 0, 0.3, 0)
PetNameLabel.Size = UDim2.new(0.8, 0, 0, 40)
PetNameLabel.Font = Enum.Font.SourceSans
PetNameLabel.Text = "Pet: None"
PetNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PetNameLabel.TextSize = 18

MutateButton.Name = "MutateButton"
MutateButton.Parent = Frame
MutateButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MutateButton.Position = UDim2.new(0.1, 0, 0.55, 0)
MutateButton.Size = UDim2.new(0.8, 0, 0, 40)
MutateButton.Font = Enum.Font.SourceSans
MutateButton.Text = "Randomize Mutation"
MutateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MutateButton.TextSize = 18
MutateButton.MouseButton1Click:Connect(function()
    applyMutationToHeldPet()
end)

PlaceholderLabel.Name = "PlaceholderLabel"
PlaceholderLabel.Parent = Frame
PlaceholderLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
PlaceholderLabel.Position = UDim2.new(0.1, 0, 0.8, 0)
PlaceholderLabel.Size = UDim2.new(0.8, 0, 0, 40)
PlaceholderLabel.Font = Enum.Font.SourceSans
PlaceholderLabel.Text = "Script 3 (Unused)"
PlaceholderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PlaceholderLabel.TextSize = 18

-- Draggable Support
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)
