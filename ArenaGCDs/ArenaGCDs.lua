local addonName, addon = ...
local instantCastBuffsTable = addon.instantCastBuffsTable
local hasteBuffsTable = addon.hasteBuffsTable
local spellTable = addon.spellTable
local createArrowButton = addon.createArrowButton
local playTestAnimation = addon.playTestAnimation
local UnitClass = UnitClass
local GetShapeshiftForm = GetShapeshiftForm
local UnitAura = UnitAura
local arenaFrames = {}

local unitClasses = {
    ["arena1"] = "",
    ["arena2"] = "",
    ["arena3"] = "",
    ["arena4"] = "",
    ["arena5"] = ""
}

local function clearUnitClasses()
    for arenaUnit in pairs(unitClasses) do
        unitClasses[arenaUnit] = ""
    end
end

local function getUnitClass(unitId)
    if unitClasses[unitId] ~= "" then
        return unitClasses[unitId]
    end
    local unitClass = UnitClass(unitId)
    unitClasses[unitId] = unitClass
    return unitClass
end

local function determineGCD(unitClass, spellName, unitId)
    if unitClass == "Hunter" then 
        if spellName == "Readiness" then
            return 1.0
        end
        return 1.5
    end

    if unitClass == "Shaman" then
        if spellName == "Lava Lash" or spellName == "Stormstrike" then
            return 1.5
        end
    end

    if unitClass == "Warrior" then
        if spellName == "Overpower" or spellName == "Revenge" then
            return 1.0
        end
        return 1.5
    end

    if unitClass == "Rogue" or (unitClass == "Druid" and GetShapeshiftForm(unitId) == 3) then
        return 1.0 -- Rogues and Cats have a 1s GCD
    end 

    if unitClass == "Warlock" and spellName == "Shadowfury" then
        return 0.5
    end

    if unitClass == "Paladin" then
        if spellName:match("^Judgement") or spellName == "Shield of Righteousness" then
            return 1.5
        end
    end

    local isHeroismActive = hasteBuffsTable["Heroism"][unitId]
    if isHeroismActive then
      return 1.0 
    end 

    local hasteBuffs = hasteBuffsTable[unitClass]

    if hasteBuffs then
        for buffName, buffData in pairs(hasteBuffs) do
            if type(buffData) == "table" and buffData.spells then
                if buffData.spells[spellName] and buffData[unitId] then
                    return 1.0 -- GCD 1 sec for specific spells
                end
            elseif buffData[unitId] then
                if unitClass == "Paladin" then return 1.2 end
                return 1.0 -- GCD 1 sec for all spells of this buff
            end
        end
    end

    if unitClass == "Death Knight" then 
        return 1.5 -- Death Knight without Unholy Presence has a default GCD of 1.5 seconds. If the player were in Unholy Presence, the hasteBuffs loop would have detected it.
    end

     -- Default GCD for everyone else
     return 1.3 -- Default GCD value, assuming BIS gear.
end

local function startCooldownShading(arenaFrame, gcdDuration)
    arenaFrame:Show()
    local startTime = GetTime()
    local endTime = startTime + gcdDuration

    arenaFrame.cooldownOverlay:SetCooldown(startTime, gcdDuration)
    arenaFrame.cooldownOverlay:SetAlpha(ArenaGCDsConfig.cooldownSwipeAlpha)
    
    local lastUpdate = 0
    arenaFrame.timerFrame:Show() -- Must show the frame to start the OnUpdate script
    arenaFrame.timerFrame:SetScript("OnUpdate", function(self, elapsed)
        lastUpdate = lastUpdate + elapsed
        if lastUpdate >= 0.1 then
            local timeLeft = endTime - GetTime()
            if timeLeft > 0 then
                arenaFrame.countdownText:SetText(string.format("%.1f", timeLeft)) 
            else
                arenaFrame:Hide() 
                arenaFrame.countdownText:SetText("") 
                arenaFrame.timerFrame:Hide() 
                arenaFrame.timerFrame:SetScript("OnUpdate", nil) -- Delete the timer
            end
            lastUpdate = 0
        end
    end)
end

local function onSpellCastSucceeded(self, event, unitId, spellName, spellRank)  
    if not spellName then
        return
    end
    
    local unitClass = getUnitClass(unitId)

    -- Find the spellId from the lookup table (make sure spellName matches)
    local spellData = spellTable[unitClass][spellName]

    if not spellData then
        return
    end
    
    local classInstantBuffs  = instantCastBuffsTable[unitClass]
    local isInstantCast = false

    if classInstantBuffs then 
        for buffs, data in pairs(classInstantBuffs) do 
            local isInstantSpell = data.spells[spellName] and data[unitId] 
            isInstantCast = isInstantSpell and true or false
            if isInstantCast then break end
        end
    end
   
    local icon = spellData.icon
    local castTime = spellData.castTime
    
    if isInstantCast then
        castTime = 0
    end

    if castTime > 0 then 
        return 
    end

    local gcdDuration = determineGCD(unitClass, spellName, unitId)
    
    local arenaFrame = arenaFrames[unitId]
    if not arenaFrame then return end

    arenaFrame.icon:SetTexture(icon)

    startCooldownShading(arenaFrame, gcdDuration)
end

local function detectInstantProcs(unitClass, unitId)
    local classBuffs = instantCastBuffsTable[unitClass]
    if not classBuffs then return end

    for buffName, arenaUnits in pairs(classBuffs) do
        local auraName, _, _, stackCount, _, buffDuration = UnitAura(unitId, buffName)

        if unitClass == "Shaman" then
            if auraName == "Maelstrom Weapon" then
                arenaUnits[unitId] = (stackCount == 5) and true or false
                break
            elseif auraName == "Elemental Mastery" then
                arenaUnits[unitId] = (buffDuration == 30) and true or false
                break
            end
        end

        arenaUnits[unitId] = auraName and true or false
        if arenaUnits[unitId] then break end
    end
end

local function detectHasteProcs(unitClass, unitId)
    local hasHeroBuff = UnitAura(unitId, "Heroism") or UnitAura(unitId, "Bloodlust")
    hasteBuffsTable["Heroism"][unitId] = hasHeroBuff and true or false

    if hasHeroBuff then return end
    
    local classBuffs = hasteBuffsTable[unitClass]
    if not classBuffs then return end

    for buffName, arenaUnits in pairs(classBuffs) do
        local auraName = UnitAura(unitId, buffName)

        arenaUnits[unitId] = auraName and true or false
        if arenaUnits[unitId] then break end
    end
end

local function onUnitAura(self, unitId)
    local unitClass = getUnitClass(unitId)
    detectInstantProcs(unitClass, unitId)
    detectHasteProcs(unitClass, unitId)
end

local function createArenaFrames()
    local iconSize = ArenaGCDsConfig.iconSize
    local y = ArenaGCDsConfig.iconsPosition.y
    local isReversed = ArenaGCDsConfig.enableCooldownReverse
    local fontSize = ArenaGCDsConfig.fontSize

    for i=1, 5 do
        -- Create the main frame
        local ArenaGcdFrame = CreateFrame("Frame", "ArenaGcdFrame"..i, ArenaGCDFramesContainer)
        ArenaGcdFrame:SetSize(iconSize, iconSize) 
        ArenaGcdFrame:SetPoint("CENTER", ArenaGCDFramesContainer, "CENTER", 0, (3 - i) * y) -- Position the frames vertically, third frame wont move
        ArenaGcdFrame:Hide() 
         
        -- Add a texture to the frame
        local iconTexture = ArenaGcdFrame:CreateTexture("$parentIcon", "ARTWORK")
        iconTexture:SetTexture("Interface/Icons/Spell_Nature_StarFall") 
        iconTexture:SetSize(iconSize, iconSize) 
        iconTexture:SetPoint("CENTER", ArenaGcdFrame, "CENTER") 
        ArenaGcdFrame.icon = iconTexture 

        -- Add a font string to display the remaining time
        local countdownFrame = CreateFrame("Frame", "$parentCountdownFrame", ArenaGcdFrame)
        countdownFrame:SetAllPoints(ArenaGcdFrame)
        countdownFrame:SetFrameLevel(4) 
        local countdownText = countdownFrame:CreateFontString("$parentCountdown", "OVERLAY", "GameFontNormalLarge")
        countdownText:SetPoint("CENTER", countdownFrame, "CENTER", 0, 0)
        countdownText:SetFont("Fonts\\FRIZQT__.TTF", fontSize)
        countdownText:SetText("") 
        countdownText:SetTextColor(1, 1, 1, 1)  
        ArenaGcdFrame.countdownText = countdownText 
        
        -- Add a cooldown texture to create the shading effect
        local cooldownOverlay = CreateFrame("Cooldown", "$parentCooldown", ArenaGcdFrame, "CooldownFrameTemplate")
        cooldownOverlay:SetAllPoints(iconTexture) 
        cooldownOverlay:SetReverse(isReversed)
        cooldownOverlay:SetFrameLevel(3)
        cooldownOverlay.noCooldownCount = true -- Disables OmniCC 
        ArenaGcdFrame.cooldownOverlay = cooldownOverlay 

        -- Create a frame to start the timer for the GCD
        local timerFrame = CreateFrame("Frame")
        timerFrame:Hide()
        ArenaGcdFrame.timerFrame = timerFrame

        -- Register base event and filter in handler
        ArenaGcdFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
        ArenaGcdFrame:RegisterEvent("UNIT_AURA")
        ArenaGcdFrame:SetScript("OnEvent", function(self, event, unitId, ...)
            if unitId == "arena" .. i then
                if event == "UNIT_SPELLCAST_SUCCEEDED" then
                    onSpellCastSucceeded(self, event, unitId, ...)
                elseif event == "UNIT_AURA" then
                    onUnitAura(self, unitId)   
                end
              
            end
        end)

        arenaFrames["arena"..i] = ArenaGcdFrame
    end
end

local ArenaGCDFramesContainer = CreateFrame("Frame", "ArenaGCDFramesContainer", UIParent)
ArenaGCDFramesContainer:SetClampedToScreen(true)
ArenaGCDFramesContainer:SetFrameStrata("HIGH")

function ArenaGCDFramesContainer:Init()
    local position = ArenaGCDsConfig.containerPosition
    self:SetSize(150, 400) 
    self:ClearAllPoints()
    self:SetPoint(position.point, UIParent, position.relativePoint, position.x, position.y) 
    self.upArrow = createArrowButton(self, "UP", 0, 15)
    self.downArrow = createArrowButton(self, "DOWN", 0, -15)
    self.leftArrow = createArrowButton(self, "LEFT", -15, 0)
    self.rightArrow = createArrowButton(self, "RIGHT", 15, 0)
    
    -- Initially hide the buttons (if not in test mode)
    self:EnableTestMode()

    createArenaFrames()
end

function ArenaGCDFramesContainer:EnableTestMode()
    if ArenaGCDsConfig.enableTestMode then
        self:SetMovable(true)
        self:EnableMouse(true)
        self:SetBackdrop({
        bgFile = nil,
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border", 
        edgeSize = 12,
        })
        self:SetBackdropBorderColor(1, 0, 0, 1)
        self.upArrow:Show() 
        self.downArrow:Show() 
        self.leftArrow:Show() 
        self.rightArrow:Show() 
        playTestAnimation(arenaFrames, startCooldownShading)
    else 
        self:SetMovable(false)
        self:EnableMouse(false)
        self:SetBackdrop(nil)
        self.upArrow:Hide() 
        self.downArrow:Hide() 
        self.leftArrow:Hide() 
        self.rightArrow:Hide() 
        for _, arenaFrame in pairs(arenaFrames) do
            arenaFrame:Hide()
        end
    end
end

ArenaGCDFramesContainer:SetScript("OnMouseDown", function(self, button)
    if button == "LeftButton" then
        self:StartMoving()
    end
end)

ArenaGCDFramesContainer:SetScript("OnMouseUp", function(self, button)
    if button == "LeftButton" then
        self:StopMovingOrSizing()

        local point, _, relPoint, xOfs, yOfs = self:GetPoint()
       
        ArenaGCDsConfig.containerPosition = { point = point, relativePoint = relPoint, x = xOfs, y = yOfs }
    end
end)

ArenaGCDFramesContainer:RegisterEvent("PLAYER_ENTERING_WORLD")
ArenaGCDFramesContainer:RegisterEvent("ADDON_LOADED")
ArenaGCDFramesContainer:SetScript("OnEvent", function(self, event, addonName)
    if event == "ADDON_LOADED" and addonName == "ArenaGCDs" then
        self:Init()
        self:UnregisterEvent("ADDON_LOADED")
    elseif event == "PLAYER_ENTERING_WORLD" then
            clearUnitClasses()
    end
end)

function ArenaGCDFramesContainer:UpdateIconConfig()
    local y = ArenaGCDsConfig.iconsPosition.y
    local iconSize = ArenaGCDsConfig.iconSize
    local isReversed = ArenaGCDsConfig.enableCooldownReverse
    local fontSize = ArenaGCDsConfig.fontSize
    -- Update icon sizes for all arena frames
    for key, arenaFrame in pairs(arenaFrames) do
        local i = tonumber(key:match("arena(%d+)"))
        arenaFrame:SetSize(iconSize, iconSize)
        arenaFrame.icon:SetSize(iconSize, iconSize)
        arenaFrame:SetPoint("CENTER", self, "CENTER", 0, (3 - i) * y) -- Position the frames vertically, third frame wont move
        arenaFrame.cooldownOverlay:SetReverse(isReversed)
        arenaFrame.countdownText:SetFont("Fonts\\FRIZQT__.TTF", fontSize)
        arenaFrame.cooldownOverlay:SetAlpha(ArenaGCDsConfig.cooldownSwipeAlpha)
    end
end
