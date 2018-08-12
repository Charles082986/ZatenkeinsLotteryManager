ZLib.CheckBox = {
    new = function(self,AceGUI,dWidth,bDefaultValue,oCallbacks)
        if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
        if not bDefaultValue then bDefaultValue = false; end
        oCallbacks = self:__ValidateCallbacks(oCallbacks);
        local toggle = AceGUI:Create("CheckBox");
        toggle:SetRelativeWidth(dWidth);
        toggle:SetValue(bDefaultValue);
        toggle:SetCallback("OnValueChanged",oCallbacks.OnValueChanged);
        if oCallbacks.OnEnter then toggle:SetCallback("OnEnter",oCallbacks.OnEnter); end
        if oCallbacks.OnLEave then toggle:SetCallback("OnLeave",oCallbacks.OnLeave); end
        return toggle;
    end,
    __ValidateCallbacks = function(self,oCallbacks)
        if not oCallbacks then oCallbacks = {}; end
        if not oCallbacks.OnValueChanged then oCallbacks.OnValueChanged = ZLib.EmptyFunction; end
        return oCallbacks;
    end
};
ZLib.Controls["CheckBox"] = ZLib.CheckBox;