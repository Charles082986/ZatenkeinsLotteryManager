ZLib.DateTimePicker = {
    new = function(self,AceGUI,dWidth,oOptions,oCallbacks)
        ZLib.Debug:Print('Creating DateTimePicker');
        if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
        oOptions = self:__ValidateOptions(oOptions);
        oCallbacks = self:__ValidateCallbacks(oCallbacks);
        ZLib.Debug:Print('Creating DateTimePicker Frame.');
        local frame = AceGUI:Create("SimpleGroup");
        ZLib.Debug:Print('Setting DateTimePicker Width');
        frame:SetRelativeWidth(dWidth);
        ZLib.Debug:Print('Setting Default Value');
        frame.__DateTime = oOptions.DefaultValue;
        ZLib.Debug:Print('Setting Set Handler');
        frame.SetValue = self.__SetValueHandler;
        ZLib.Debug:Print('Setting Get Handler');
        frame.GetValue = self.__GetValueHandler;
        ZLib.Debug:Print('Setting Multiline Widths');
        local pickerWidth = 0.5;
        if oOptions.Multiline then pickerWidth = 1; end
        ZLib.Debug:Print('Setting Value Changed Handler');
        frame.OnValueChanged = self:__BuildValueChangedHandler(oCallbacks);
        ZLib.Debug:Print('Creating DatePicker Component of DateTimePicker');
        frame:AddChild(ZLib.DatePicker:new(AceGUI,pickerWidth,oOptions,{ OnValueChanged = frame.OnValueChanged }));
        ZLib.Debug:Print('Creating TimePicker Component of DateTimePicker');
        frame:AddChild(ZLib.TimePicker:new(AceGUI,pickerWidth,oOptions,{ OnValueChanged = frame.OnValueChanged }));
        frame.DatePicker = frame.children[1];
        frame.TimePicker = frame.children[2];
        ZLib.Debug:Print('DateTimePicker created');
        return frame;
    end,
    __BuildValueChangedHandler = function(self,oCallbacks)
        return function(self,picker,dtObject,key,value,error)
            self.__DateTime[key] = dtObject[key];
            oCallbacks.OnValueChanged(self,picker,self.__DateTime,key,value,error);
        end
    end,
    __GetValueHandler = function(self) return self.__DateTime end,
    __SetValueHandler = function(self,value)
        if ZLib.IsTimeValid(value) then self.TimePicker:SetValue(value); end
        if ZLib.IsDateValid(value) then self.DatePicker:SetValue(value); end
    end,
    __ValidateOptions = function(self,oOptions)
        ZLib.Debug:Print('Validating DateTimePicker.Options.');
        if not oOptions then oOptions = {}; end
        if not oOptions.Multiline then oOptions.Multiline = false; end
        if not ZLib:IsDateTimeValid(oOptions.DefaultValue) then oOptions.DefaultValue = date("*t"); end
        ZLib.Debug:Print('Options validated.');
        return oOptions;
    end,
    __ValidateCallbacks = function(self,oCallbacks)
        ZLib.Debug:Print('Validating Callbacks');
        if not oCallbacks then oCallbacks = {}; end
        if not oCallbacks.OnValueChanged then oCallbacks.OnVlaueChanged = function() end end;
        ZLib.Debug:Print('Callbacks Validated');
        return oCallbacks;
    end,
    __SetDatePast = function(self,oDate)
        local multipliers = {
            sec = 1,
            minute = 60,
            hour = 3600,
            day = 86400
        }
        local d = date("*t");
        local t = time(d);
        for k,v in pairs(oDate) do
            local m = multipliers[k];
            if not not m then
                t = t - (m * v);
            end
        end
        d = date("*t",t);
        if oDate.DayState ~= nil then
            if oDate.DayState == 0 then
                d.sec = 0; d.minute = 0; d.hour = 0;
            else
                d.sec = 59; d.minute = 59; d.hour = 23;
            end
        end
        self:SetValue(d);
    end
};
ZLib.Controls["DateTimePicker"] = ZLib.DateTimePicker;
