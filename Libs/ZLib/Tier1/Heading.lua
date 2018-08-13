ZLib.Heading = {
    new = function(self,AceGUI,dWidth,sText)
        ZLib.Debug:Print('Creating heading.');
        if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
        local heading = AceGUI:Create("Heading");
        ZLib.Debug:Print("Heading " .. sText);
        heading:SetText(sText);
        heading:SetRelativeWidth(dWidth);
        ZLib.Debug:Print('Heading Created.');
        return heading;
    end
};
ZLib.Controls["Heading"] = ZLib.Heading;