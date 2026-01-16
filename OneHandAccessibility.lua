local addonName, addonTable =...
local frame = CreateFrame("Frame")

-- Spec-aware Macro Dictionary (S-Tier Accessibility Specs)
local SpecMacros = {
     = [[/targetenemy [noharm][dead]
/stopmacro [channeling]
/cast [mod:shift] Bloodshed
/cast Single-Button Assistant
/use 13
/use 14
/petattack]], -- Beast Mastery Hunter

     = [[/targetenemy [noharm][dead]
/stopmacro [channeling]
/cast [mod:shift] Metamorphosis
/cast Single-Button Assistant
/use 13
/use 14]], -- Havoc Demon Hunter

     = [[/targetenemy [noharm][dead]
/stopmacro [channeling]
/cast [mod:shift] Howling Blast
/cast Single-Button Assistant
/use 13
/use 14]], -- Frost Death Knight

     = [[/targetenemy [noharm][dead]
/stopmacro [channeling]
/cast [mod:shift] Avenging Wrath
/cast Single-Button Assistant
/use 13
/use 14]] -- Retribution Paladin
}

-- Create the Secure Action Button [5, 6]
local actionButton = CreateFrame("Button", "OneHandSecureButton", UIParent, "SecureActionButtonTemplate")
actionButton:SetAttribute("type", "macro")
actionButton:SetSize(80, 80) -- Large for accessibility
actionButton:SetPoint("CENTER", 0, -150)
actionButton:RegisterForClicks("AnyUp", "AnyDown") -- Required for modern casting [7]

-- Button Visuals
actionButton.tex = actionButton:CreateTexture(nil, "BACKGROUND")
actionButton.tex:SetAllPoints()
actionButton.tex:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
actionButton:SetNormalTexture(actionButton.tex)

-- Function to Update the Macro Logic (Out of Combat Only)
local function UpdateOneHandMacro()
    if InCombatLockdown() then return end
    
    local specIndex = C_SpecializationInfo.GetSpecialization()
    if not specIndex then return end
    
    local specID, name, _, icon = C_SpecializationInfo.GetSpecializationInfo(specIndex)
    local macroBody = SpecMacros or "/cast Single-Button Assistant"
    
    actionButton:SetAttribute("macrotext", macroBody)
    actionButton.tex:SetTexture(icon)
end

-- Event Handling
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
frame:RegisterEvent("PLAYER_REGEN_ENABLED")

frame:SetScript("OnEvent", function(self, event,...)
    if event == "PLAYER_ENTERING_WORLD" then
        SetCVar("ActionButtonUseKeyDown", 1) -- Enable 11.2.7 Hold-to-Cast [4]
        UpdateOneHandMacro()
    elseif event == "PLAYER_SPECIALIZATION_CHANGED" or event == "PLAYER_REGEN_ENABLED" then
        UpdateOneHandMacro()
    end
end)

-- Slash Command to Unlock/Lock Position
SLASH_ONEHAND1 = "/onehand"
SlashCmdList = function()
    if not actionButton:IsMouseEnabled() then
        actionButton:EnableMouse(true)
        actionButton:SetMovable(true)
        actionButton:RegisterForDrag("LeftButton")
        actionButton:SetScript("OnDragStart", actionButton.StartMoving)
        actionButton:SetScript("OnDragStop", actionButton.StopMovingOrSizing)
        print("|cFF00FF00OneHandButton:|r Unlocked (Drag to move, type /onehand to lock)")
    else
        actionButton:EnableMouse(false)
        print("|cFFFF0000OneHandButton:|r Locked")
    end
end
