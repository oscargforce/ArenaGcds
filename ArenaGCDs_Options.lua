local function round(value)
    local power = 10 ^ 1
    return math.floor(value * power + 0.5) / power
end

local function createOptionsMenu()
    local panel = CreateFrame("Frame", "ArenaGCDsOptionsPanel", InterfaceOptionsFramePanelContainer)
    panel.name = "Arena GCDs"
    InterfaceOptions_AddCategory(panel)

    local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("Arena GCDs Options")

    local testModeLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    testModeLabel:SetPoint("BOTTOMLEFT", title, "BOTTOMLEFT", 0, -35)  -- Adjusted positioning
    testModeLabel:SetText("Enable Test Mode")
    
    local enableTestModeCheckbox = CreateFrame("CheckButton", "ArenaGCDsEnableTestMode", panel, "UICheckButtonTemplate" )
    enableTestModeCheckbox:SetPoint("TOPLEFT", testModeLabel, "BOTTOMLEFT", 0, -2)  -- Position the checkbox below the title
    enableTestModeCheckbox:SetChecked(ArenaGCDsConfig.enableTestMode)  -- Set the initial checked state from your config
    enableTestModeCheckbox:SetScript("OnClick", function(self)
        ArenaGCDsConfig.enableTestMode = self:GetChecked() == 1 -- Update the config when the checkbox is clicked
        ArenaGCDFramesContainer:EnableTestMode()  -- Apply the new config (if needed)
    end)
    enableTestModeCheckbox:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText("Allows you to drag and reposition the frame while\nproviding a visual representation of your current\nconfiguration settings.", 1, 1, 1, true)
        GameTooltip:Show()
    end)
    enableTestModeCheckbox:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end) 

    local shadingLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    shadingLabel:SetPoint("BOTTOMLEFT", enableTestModeCheckbox, "BOTTOMLEFT", 0, -35)
    shadingLabel:SetText("Reversed Cooldown Shading")

    local shadingCheckbox = CreateFrame("CheckButton", "ArenaGCDsShading", panel, "UICheckButtonTemplate" )
    shadingCheckbox:SetPoint("TOPLEFT", shadingLabel, "BOTTOMLEFT", 0, -2)
    shadingCheckbox:SetChecked(ArenaGCDsConfig.enableCooldownReverse)
    shadingCheckbox:SetScript("OnClick", function(self)
        ArenaGCDsConfig.enableCooldownReverse = self:GetChecked() == 1 
        ArenaGCDFramesContainer:UpdateIconConfig()
    end)
    shadingCheckbox:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText("Sets the direction of the gcd cooldown\ndisplayed on the icons.", 1, 1, 1, true)
        GameTooltip:Show()
    end)
    shadingCheckbox:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end) 

    local iconSizeSlider = CreateFrame("Slider", "ArenaGCDsIconSizeSlider", panel, "OptionsSliderTemplate")
    local iconSizeInputBox = CreateFrame("EditBox", "ArenaGCDsIconSizeInputBox", panel, "InputBoxTemplate")
    iconSizeSlider:SetWidth(200)
    iconSizeSlider:SetMinMaxValues(30, 100)
    iconSizeSlider:SetValueStep(1)
    iconSizeSlider:SetPoint("TOPLEFT", shadingCheckbox, "BOTTOMLEFT", 0, -25)
    iconSizeSlider:SetValue(ArenaGCDsConfig.iconSize)
    iconSizeSlider:SetScript("OnValueChanged", function(self, value)
        ArenaGCDsConfig.iconSize = value
        ArenaGCDFramesContainer:UpdateIconConfig()
        ArenaGCDsIconSizeSliderText:SetText("Icon Size: " .. math.floor(value))
        iconSizeInputBox:SetText(math.floor(value))
    end)
    ArenaGCDsIconSizeSliderText:SetText("Icon Size: " .. math.floor(ArenaGCDsConfig.iconSize))

    iconSizeInputBox:SetSize(40, 20)
    iconSizeInputBox:SetPoint("CENTER", iconSizeSlider, "CENTER", 0, -20)
    iconSizeInputBox:SetAutoFocus(false)
    iconSizeInputBox:SetNumeric(true)
    iconSizeInputBox:SetScript("OnEnterPressed", function(self)
        local value = tonumber(self:GetText())
        if value then
            -- Clamp the value to the slider's range
            local minValue, maxValue = iconSizeSlider:GetMinMaxValues()
            value = math.max(minValue, math.min(value, maxValue))
            self:SetText(value)  
            iconSizeSlider:SetValue(value)  -- Update the slider
        else
            self:SetText(math.floor(slider:GetValue()))
        end
        self:ClearFocus()
    end)
    
    local yIconsPosSlider = CreateFrame("Slider", "ArenaGCDsYIconsPosSlider", panel, "OptionsSliderTemplate")
    local iconYPosInputBox = CreateFrame("EditBox", "ArenaGCDsIconYPosInputBox", panel, "InputBoxTemplate")
    yIconsPosSlider:SetWidth(200)
    yIconsPosSlider:SetMinMaxValues(0, 198)
    yIconsPosSlider:SetValueStep(1)
    yIconsPosSlider:SetPoint("TOPLEFT", iconSizeSlider, "BOTTOMLEFT", 0, -40)
    yIconsPosSlider:SetValue(ArenaGCDsConfig.iconsPosition.y)
    yIconsPosSlider:SetScript("OnValueChanged", function(self, value)
        ArenaGCDsConfig.iconsPosition.y = value
        ArenaGCDFramesContainer:UpdateIconConfig()
        ArenaGCDsYIconsPosSliderText:SetText("Y Icons Position: " .. math.floor(value))
        iconYPosInputBox:SetText(math.floor(value))
    end)
    ArenaGCDsYIconsPosSliderText:SetText("Y Icons Position: " .. math.floor(ArenaGCDsConfig.iconsPosition.y))

    iconYPosInputBox:SetSize(40, 20)
    iconYPosInputBox:SetPoint("CENTER", yIconsPosSlider, "CENTER", 0, -20)
    iconYPosInputBox:SetAutoFocus(false)
    iconYPosInputBox:SetNumeric(true)
    iconYPosInputBox:SetScript("OnEnterPressed", function(self)
        local value = tonumber(self:GetText())
        if value then
            -- Clamp the value to the slider's range
            local minValue, maxValue = yIconsPosSlider:GetMinMaxValues()
            value = math.max(minValue, math.min(value, maxValue))
            self:SetText(value)  
            yIconsPosSlider:SetValue(value)  -- Update the Y icons pos slider
        else
            self:SetText(math.floor(slider:GetValue()))
        end
        self:ClearFocus()
    end)

    local fontSizeSlider = CreateFrame("Slider", "ArenaGCDsFontSizeSlider", panel, "OptionsSliderTemplate")
    local fontSizeInputBox = CreateFrame("EditBox", "ArenaGCDsFontSizeInputBox", panel, "InputBoxTemplate")
    fontSizeSlider:SetWidth(200)
    fontSizeSlider:SetMinMaxValues(1, 32)
    fontSizeSlider:SetValueStep(1)
    fontSizeSlider:SetPoint("TOPLEFT", yIconsPosSlider, "BOTTOMLEFT", 0, -40)
    fontSizeSlider:SetValue(ArenaGCDsConfig.fontSize)
    fontSizeSlider:SetScript("OnValueChanged", function(self, value)
        ArenaGCDsConfig.fontSize = value
        ArenaGCDFramesContainer:UpdateIconConfig()
        ArenaGCDsFontSizeSliderText:SetText("Font-Size: " .. math.floor(value))
        fontSizeInputBox:SetText(math.floor(value))
    end)
    ArenaGCDsFontSizeSliderText:SetText("Font-Size: " .. math.floor(ArenaGCDsConfig.fontSize))

    fontSizeInputBox:SetSize(40, 20)
    fontSizeInputBox:SetPoint("CENTER", fontSizeSlider, "CENTER", 0, -20)
    fontSizeInputBox:SetAutoFocus(false)
    fontSizeInputBox:SetNumeric(true)
    fontSizeInputBox:SetScript("OnEnterPressed", function(self)
        local value = tonumber(self:GetText())
        if value then
            -- Clamp the value to the slider's range
            local minValue, maxValue = fontSizeSlider:GetMinMaxValues()
            value = math.max(minValue, math.min(value, maxValue))
            self:SetText(value)  
            fontSizeSlider:SetValue(value)  -- Update the Y icons pos slider
        else
            self:SetText(math.floor(slider:GetValue()))
        end
        self:ClearFocus()
    end)

    local cooldownSwipeAlphaSlider = CreateFrame("Slider", "ArenaGCDsCooldownSwipeAlphaSlider", panel, "OptionsSliderTemplate")
    local swipeAlphaInputBox = CreateFrame("EditBox", "ArenaGCDsSwipeAlphaInputBox", panel, "InputBoxTemplate")
    cooldownSwipeAlphaSlider:SetWidth(200)
    cooldownSwipeAlphaSlider:SetMinMaxValues(0, 1)
    cooldownSwipeAlphaSlider:SetValueStep(0.1)
    cooldownSwipeAlphaSlider:SetPoint("TOPLEFT", fontSizeSlider, "BOTTOMLEFT", 0, -40)
    cooldownSwipeAlphaSlider:SetValue(ArenaGCDsConfig.cooldownSwipeAlpha)
    cooldownSwipeAlphaSlider:SetScript("OnValueChanged", function(self, value)
        local roundedValue = round(value)
        ArenaGCDsConfig.cooldownSwipeAlpha = roundedValue
        ArenaGCDFramesContainer:UpdateIconConfig()
        ArenaGCDsCooldownSwipeAlphaSliderText:SetText("Set opacity on cooldown swipe: " .. roundedValue)
        swipeAlphaInputBox:SetText(roundedValue)
    end)
    ArenaGCDsCooldownSwipeAlphaSliderText:SetText("Cooldown Swipe Opacity: " .. ArenaGCDsConfig.cooldownSwipeAlpha)

    swipeAlphaInputBox:SetSize(40, 20)
    swipeAlphaInputBox:SetPoint("CENTER", cooldownSwipeAlphaSlider, "CENTER", 0, -20)
    swipeAlphaInputBox:SetAutoFocus(false)
    --swipeAlphaInputBox:SetNumeric(true)
    swipeAlphaInputBox:SetScript("OnEnterPressed", function(self)
        local value = tonumber(self:GetText())
        if value then
            -- Clamp the value to the slider's range
            local minValue, maxValue = cooldownSwipeAlphaSlider:GetMinMaxValues()
            value = math.max(minValue, math.min(value, maxValue))
            local roundedValue = round(value)
            self:SetText(roundedValue)  
            cooldownSwipeAlphaSlider:SetValue(roundedValue)  -- Update the Y icons pos slider
        else
            self:SetText(math.floor(slider:GetValue()))
        end
        self:ClearFocus()
    end)
end

local function setDefaultConfig()
    if not ArenaGCDsConfig then
        ArenaGCDsConfig = {
            enableTestMode = false,
            containerPosition = { point = "CENTER", relativePoint = "CENTER", x = 0, y = 0 },
            iconsPosition = { x = 0, y = 60 },
            iconSize = 50,
            enableCooldownReverse = true,
            showCountdownText = true,
            fontSize = 16,
            cooldownSwipeAlpha = 1
        }
    end
end

function createArenaGcdsArrowButton(parent, direction, x, y)
    local button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    button:SetSize(24, 24)
    button:SetFrameLevel("10")

    if direction == "UP" then
        button:SetPoint("CENTER", parent, "RIGHT", x, y) 
        button:SetText("^")
        button:SetNormalFontObject(GameFontNormalLarge)
    elseif direction == "DOWN" then
        button:SetPoint("CENTER", parent, "RIGHT", x, y)
        button:SetText("v")
    elseif direction == "LEFT" then
        button:SetPoint("BOTTOM", parent, "BOTTOM", x, y)
        button:SetText("<")
    elseif direction == "RIGHT" then
        button:SetPoint("BOTTOM", parent, "BOTTOM", x, y)
        button:SetText(">")
    end

    button:SetScript("OnClick", function()
        local point, _, relPoint, xOffset, yOffset = parent:GetPoint()

        -- Move the frame by 1 pixel in the specified direction
        if direction == "UP" then
            yOffset = yOffset + 1
        elseif direction == "DOWN" then
            yOffset = yOffset - 1
        elseif direction == "LEFT" then
            xOffset = xOffset - 1
        elseif direction == "RIGHT" then
            xOffset = xOffset + 1
        end

        parent:ClearAllPoints()
        parent:SetPoint(point, UIParent, relPoint, xOffset, yOffset)

        -- Save the updated position to your configuration
        ArenaGCDsConfig.containerPosition = { point = point, relativePoint = relPoint, x = xOffset, y = yOffset }
    end)

    return button
end

function playArenaGCDsTestAnimation(arenaFrames, startCooldownShading)
    local timerFrame = CreateFrame("Frame")
    local interval = 1.5
    local timeElapsed = 0

    timerFrame:Show()
  
    local function stopCooldownLoop()
        timerFrame:Hide()
    end
    
    timerFrame:SetScript("OnUpdate", function(self, elapsed)
        timeElapsed = timeElapsed + elapsed
        if timeElapsed >= interval then
            timeElapsed = 0 

            if not ArenaGCDsConfig.enableTestMode then
                stopCooldownLoop() 
                return
            end

            -- Perform the cooldown shading
            for _, arenaFrame in pairs(arenaFrames) do
                startCooldownShading(arenaFrame, interval)
            end
        end
    end)
end


local optionsInitFrame = CreateFrame("Frame")
optionsInitFrame:RegisterEvent("ADDON_LOADED")
optionsInitFrame:SetScript("OnEvent", function(self, event, addonName)
    if addonName == "ArenaGCDs" then
        setDefaultConfig()
        createOptionsMenu()
        self:UnregisterEvent("ADDON_LOADED")
    end
end)
