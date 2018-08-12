ZLib.Dropdown = {
    new = function(self,AceGUI,dWidth,oOptions,oCallbacks)
        ZLib.Debug:Print('Creating Dropdown');
        if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
        oCallbacks = self:__ValidateCallbacks(oCallbacks);
        oOptions = self:__ValidateOptions(oOptions);
        local dropdown = AceGUI:Create("Dropdown");
        ZLib.Debug:Print('Setting List');
        dropdown:SetList(oOptions.Values,oOptions.ValuesOrder);
        dropdown:SetRelativeWidth(dWidth);
        ZLib.Debug:Print('Setting Value');
        dropdown:SetValue(oOptions.DefaultValue);
        ZLib.Debug:Print('Setting OVC Handler');
        dropdown:SetCallback("OnValueChanged",oCallbacks.OnValueChanged);
        ZLib.Debug:Print('Conditionally Setting Enter/Leave Handlers');
        if oCallbacks.OnEnter then dropdown:SetCallback("OnEnter",oCallbacks.OnEnter); end
        if oCallbacks.OnLEave then dropdown:SetCallback("OnLeave",oCallbacks.OnLeave); end
        ZLib.Debug:Print('Dropdown Created');
        return dropdown;
    end,
    __ValidateCallbacks = function(self,oCallbacks)
        ZLib.Debug:Print('Validating Callbacks: ' .. tostring(oCallbacks));
        for k,v in pairs(oCallbacks) do
            ZLib.Debug:Print(k .. ': ' .. tostring(v));
        end
        if not oCallbacks then oCallbacks = {}; end
        if not oCallbacks.OnValueChanged then oCallbacks.OnValueChanged = ZLib.EmptyFunction; end
        return oCallbacks;
    end,
    __ValidateOptions = function(self,oOptions)
        ZLib.Debug:Print('Validating Options: ' .. tostring(oOptions));
        for k,v in pairs(oOptions) do
            ZLib.Debug:Print(k .. ': ' .. tostring(v));
        end
        if not oOptions then oOptions = {}; end
        if not ZLib:IsTableValid(oOptions.Values) then
            ZLib.Debug:Print('Values Table Invalid');
            oOptions.Values = {};
            for i = 1,10 do
                oOptions[i] = i;
            end
        end
        if not ZLib:IsTableValid(oOptions.ValuesOrder) then
            ZLib.Debug:Print('ValuesOrder Table Invalid');
            oOptions.ValuesOrder = {};
            for k,v in pairs(oOptions.Values) do
                ZLib.Debug:Print('Setting ValuesOrder: ' .. tostring(k) .. ' - ' .. tostring(v));
                tinsert(oOptions.ValuesOrder,v);
            end
            ZLib.Debug:Print('Setting ValuesOrder Complete');
        end
        ZLib.Debug:Print('Setting Default Value if Needed');
        if oOptions.DefaultValue == nil then oOptions.DefaultValue = oOptions.ValuesOrder[1]; end
        ZLib.Debug:Print('Dropdown Options Validated');
        return oOptions;
    end
};
ZLib.Controls["Dropdown"] = ZLib.Dropdown;