ZLib.Button = {
    new = function(self,AceGUI,dWidth,sText,oCallbacks)
        if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
        if not dWidth then dWidth = 1; end
        oCallbacks = self:__ValidateCallbacks(oCallbacks);
        local button = AceGUI:Create("Button");
        button:SetText(sText);
        button:SetCallback("OnClick", oCallbacks.OnClick);
        if oCallbacks.OnEnter then button:SetCallback("OnEnter",oCallbacks.OnEnter); end
        if oCallbacks.OnLeave then button:SetCallback("OnLeave",oCallbacks.OnLeave); end
        button:SetRelativeWidth(dWidth);
        return button;
    end,
    __ValidateCallbacks = function(self,oCallbacks)
        if not oCallbacks then oCallbacks = {}; end
        if not oCallbacks.OnClick then oCallbacks.OnClick = ZLib.EmptyFunction; end
        return oCallbacks;
    end
};
ZLib.Controls["Button"] = ZLib.Button;
