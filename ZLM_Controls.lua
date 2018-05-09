ZLM_Controls = {};
ZLM_Label = {};
function ZLM_Label:new(text,width,AceGUI)
    if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
    local label = AceGUI:Create("Label");
    label:SetText(text);
    label:SetRelativeWidth(width);
    return label;
end
ZLM_Controls["Label"] = ZLM_Label;

ZLM_Heading = {};
function ZLM_Heading:new(text,AceGUI)
    if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
    local heading = AceGUI:Create("Heading");
    ZLM:Debug("Heading " .. text,1);
    heading:SetText(text);
    heading:SetFullWidth(true);
    return heading;
end
ZLM_Controls["Heading"] = ZLM_Heading;

ZLM_InteractiveLabel = {};
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
ZLM_Controls["InteractiveLabel"] = ZLM_InteractiveLabel;

ZLM_Button = {};
function ZLM_Button:new(text,func,width,AceGUI)
    if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
    if not width then width = 1; end
    local button = AceGUI:Create("Button");
    button:SetText(text);
    button:SetCallback("OnClick",func);
    button:SetRelativeWidth(width);
    return button;
end
ZLM_Controls["Button"] = ZLM_Button;

ZLM_Range = {};
function ZLM_Range:new(label,min,max,step,width,callback,AceGUI,defaultValue)
    if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
    if not not defaultValue then defaultValue = math.floor(((min + max) / 2) / step) * step; end
    local range = AceGUI:Create("Slider");
    if not not label then
        range:SetLabel(label);
    end
    range:SetSliderValues(min,max,step);
    range:SetValue(defaultValue);
    range:SetCallback("OnValueChanged",callback);
    range:SetRelativeWidth(width);
    return range;
end
ZLM_Controls["Range"] = ZLM_Range;

ZLM_Input = {};
function ZLM_Input:new(width,callback,AceGUI,defaultValue)
    if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
    if not not defaultValue then defaultValue = ""; end
    local input = AceGUI:Create("EditBox");
    input:SetRelativeWidth(width);
    input:SetText(defaultValue);
    input:SetCallback("OnEnterPressed",callback);
end

ZLM_Dropdown = {};
function ZLM_Dropdown:new(width,values,valuesOrder,callback,AceGUI,defaultValue)
    if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
    if not not defaultValue then defaultValue = valuesOrder[1]; end
    local dropdown = AceGUI:Create("Dropdown");
    dropdown:SetList(values,valuesOrder);
    dropdown:SetRelativeWidth(width);
    dropdown:SetValue(defaultValue);
    dropdown:SetCallback("OnValueChanged",callback);
end

ZLM_Checkbox = {};
function ZLM_Checkbox:new(width,callback,AceGUI,defaultValue)
    if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
    if not not defaultValue then defaultValue = false; end
    local toggle = AceGUI:Create("Checkbox");
    toggle:SetRelativeWidth(width);
    toggle:SetValue(defaultValue);
    toggle:SetCallback("OnValueChanged",callback);
    return toggle;
end