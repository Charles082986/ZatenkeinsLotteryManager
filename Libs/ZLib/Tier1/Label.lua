ZLib.Label = {
    new = function(self,AceGUI,dWidth,sText)
        if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
        local label = AceGUI:Create("Label");
        label:SetText(sText);
        label:SetRelativeWidth(dWidth);
        return label;
    end
};
ZLib.Controls["Label"] = ZLib.Label;