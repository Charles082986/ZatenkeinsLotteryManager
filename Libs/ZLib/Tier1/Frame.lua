ZLib.Frame = {
    new = function(self,AceGUI,sLayout,sTitle,oCallbacks)
        if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
        if not sLayout then sLayout = "Flow"; end
        if not sTitle then sTitle = "ZLib Frame"; end
        oCallbacks = self:__ValidateCallbacks(oCallbacks);
        local frame = AceGUI:Create("Frame");
        frame:SetLayout(sLayout);
        frame:SetTitle(sTitle);
        frame.Toggle = self.__FrameToggle;
        return frame;
    end,
    __ValidateCallbacks = function(self,oCallbacks)
        if not oCallbacks then oCallbacks = {}; end
        return oCallbacks;
    end,
    __FrameToggle = function(self)
        if self:IsVisible() then self:Hide(); else self:Show(); end
    end
};
ZLib.Controls["Frame"] = ZLib.Frame;
