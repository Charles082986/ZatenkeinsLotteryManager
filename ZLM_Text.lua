ZLM_Label = {};
function ZLM_Label:new(text,width,AceGUI)
    if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
    local label = AceGUI:Create("Label");
    label:SetText(text);
    label:SetRelativeWidth(width);
    return label;
end

ZLM_Heading = {};
function ZLM_Heading:new(text,AceGUI)
    if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
    local heading = AceGUI:Create("Heading");
    ZLM:Debug("Heading " .. text,1);
    heading:SetText(text);
    heading:SetFullWidth(true);
    return heading;
end
function ZLM_InteractiveLabel:new(text,width,onClick,onEnter,onLeave,AceGUI)
    if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
    local label = AceGUI:Create("InteractiveLabel");
    label:SetText(text);
    label:SetRelativeWidth(width);
    if not not onClick then
        label:SetCallback("OnClick",onClick);
    end
    if not not onEnter then
        label:SetCallback("OnEnter",onEnter);
    end
    if not not onLeave then
        label:SetCallback("OnLeave",onLeave);
    end
    return label;
end