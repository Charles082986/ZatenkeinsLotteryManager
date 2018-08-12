ZLib.Heading = {
    new = function(self,AceGUI,dWidth,sText)
        if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
        local heading = AceGUI:Create("Heading");
        ZLM:Debug("Heading " .. sText,1);
        heading:SetText(sText);
        heading:SetRelativeWidth(dWidth);
        return heading;
    end
};
ZLib.Controls["Heading"] = ZLib.Heading;