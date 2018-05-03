ZLM_Label = {};
function ZLM_Label:new(text,width,AceGUI)
    if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
    local label = AceGUI:Create("Label");
    label:SetText(text);
    label:SetRelativeWidth(width);
    return label;
end

ZLM_Header = {};
function ZLM_Header:new(text,AceGUI)
    if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
    local heading = AceGUI:Create("Heading")
    heading:setText(text);
    return heading;
end