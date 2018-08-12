ZLib.Slider = {
    new = function(self,AceGUI,dWidth,oOptions,oCallbacks)
        if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
        oCallbacks = self:__ValidateCallbacks(oCallbacks);
        oOptions = self:__ValidateOptions(oOptions);
        local slider = AceGUI:Create("Slider");
        slider:SetLabel(oOptions.Label);
        slider:SetSliderValues(oOptions.Min,oOptions.Max,oOptions.Step);
        slider:SetValue(oOptions.DefaultValue);
        slider:SetCallback("OnValueChanged",oCallbacks.OnValueChanged);
        slider:SetRelativeWidth(dWidth);
        return slider;
    end,
    __ValidateCallbacks = function(self,oCallbacks)
        if not oCallbacks then oCallbacks = {}; end
        if not oCallbacks.OnValueChanged then oCallbacks.OnValueChanged = ZLib.EmptyFunction; end
        return oCallbacks;
    end,
    __ValidateOptions = function(self,oOptions)
        if oOptions == nil then oOptions = {}; end
        if oOptions.Label == nil then oOptions.Label = "Slider-Label"; end
        if not ZLib:IsNumberValid(oOptions.Min) then oOptions.Min = 0; end
        if not ZLIb:IsNumberValid(oOptions.Max) then oOptions.Max = 10; end
        if not ZLib:IsNumberValid(oOptions.Step) then oOptions.Step = 1; end
        if not ZLib:IsNumberValid(oOptions.DefaultValue) then oOptions.DefaultValue = oOptions.Min; end
        return oOptions;
    end
};
ZLib.Controls["Slider"] = ZLib.Slider;