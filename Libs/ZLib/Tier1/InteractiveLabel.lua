ZLib.InteractiveLabel = {
    new = function(self, AceGUI, dWidth, sText, oCallbacks)
        if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
        oCallbacks = self:__ValidateCallbacks(oCallbacks);
        local label = AceGUI:Create("InteractiveLabel");
        label:SetText(sText);
        label:SetRelativeWidth(dWidth);
        label:SetCallback("OnClick",oCallbacks.OnClick);
        label:SetCallback("OnEnter",oCallbacks.OnEnter);
        label:SetCallback("OnLeave",oCallbacks.OnLeave);
        return label;
    end,
    __ValidateCallbacks = function(self,oCallbacks) 
        if not oCallbacks then oCallbacks = {}; end
        if not oCallbacks.OnClick then oCallbacks.OnClick = ZLib.EmptyFunction; end
        if not oCallbacks.OnEnter then oCallbacks.OnEnter = ZLib.EmptyFunction; end
        if not oCallbacks.OnLeave then oCallbacks.OnLeave = ZLib.EmptyFunction; end
        return oCallbacks;
    end
};
ZLib.Controls["InteractiveLabel"] = ZLib.InteractiveLabel;