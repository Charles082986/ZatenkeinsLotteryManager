ZLib.TimePicker = {
    new = function(self,AceGUI,dWidth,oOptions,oCallbacks)
        ZLib.Debug:Print('Creating Time Picker');
        if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
        oOptions = self:__ValidateOptions(oOptions);
        oCallbacks = self:__ValidateCallbacks(oCallbacks);
        ZLib.Debug:Print('Creating TimePicker Frame.');
        local root = AceGUI:Create("SimpleGroup");
        root:SetRelativeWidth(dWidth);
        root:SetLayout("Flow");
        ZLib.Debug:Print('Setting Default Time Value.');
        root.__Time = oOptions.DefaultValue;
        ZLib.Debug:Print('Setting OVC Callback.');
        root.OnValueChanged = self:__BuildValueChangedCallback(oCallbacks);
        ZLib.Debug:Print('Setting SetValue Handler.');
        root.SetValue = self:__BuildSetValueHandler();
        ZLib.Debug:Print('Setting GetValue Handler.');
        root.GetValue = self:__BuildGetValueHandler();
        ZLib.Debug:Print('Creating Hours Dropdown.');
        root.HourDropdown = self:__CreateHoursDropdown(AceGUI,oOptions.DefaultValue.hour,root.OnValueChanged);
        ZLib.Debug:Print('Creating Mins Dropdown.');
        root.MinDropdown = self:__CreateMinsDropdown(AceGUI,oOptions.DefaultValue.min,root.OnValueChanged);
        ZLib.Debug:Print('Creating Secs Dropdown.');
        root.SecDropdown = self:__CreateSecsDropdown(AceGUI,oOptions.DefaultValue.sec,root.OnValueChanged);
        root:AddChild(root.HourDropdown);
        root:AddChild(root.MinDropdown);
        root:AddChild(root.SecDropdown);
        ZLib.Debug:Print('TimePicker Created.');
        return root;
    end,
    __BuildValueChangedCallback = function(self,oCallbacks)
        ZLib.Debug:Print(tostring(oCallbacks));
        return function(self,timeKey,value)
            local t = time(self.__Time);
            self.__Time[timeKey] = value;
            if not ZLib:IsTimeValid(self.__Time) then
                self.__Time = date("*t",t);
                oCallbacks.OnValueChanged(self,self.__Date,timeKey,value,"Error: Time Not Valid");
            else
                oCallbacks.OnValueChanged(self,self.__Date,timeKey,value);
            end
        end
    end,
    __BuildSetValueHandler = function()
        return function(self,value)
            if ZLib:IsTimeValid(value) then
                self.HourDropdown:SetValue(value.hour);
                self.MinDropdown:SetValue(value.min);
                self.SecDropdown:SetValue(value.sec);
            end
        end
    end,
    __BuildGetValueHandler = function()
        return function(self)
            return self.__Time;
        end
    end,
    __CreateHoursDropdown = function(self,AceGUI,iDefaultValue,callback)
        ZLib.Debug:Print(tostring(iDefaultValue));
        ZLib.Debug:Print(tostring(callback));
        local oOptions = {};
        local oCallbacks = {};
        oOptions.Values = ZLib:CreateIntegerList(0,23);
        oOptions.DefaultValue = iDefaultValue;
        oCallbacks.OnValueChanged = function(me,_,key,checked) callback("hour",key); end;
        return ZLib.Dropdown:new(AceGUI,0.33,oOptions,oCallbacks);
    end,
    __CreateMinsDropdown = function(self,AceGUI,iDefaultValue,callback)
        local oOptions = {};
        local oCallbacks = {};
        oOptions.Values = ZLib:CreateIntegerList(0,59);
        oOptions.DefaultValue = iDefaultValue;
        oCallbacks.OnValueChanged = function(me,_,key,checked) callback("min",key); end;
        return ZLib.Dropdown:new(AceGUI,0.34,oOptions,oCallbacks);
    end,
    __CreateSecsDropdown = function(self,AceGUI,iDefaultValue,callback)
        local oOptions = {};
        local oCallbacks = {};
        oOptions.Values = ZLib:CreateIntegerList(0,59);
        oOptions.DefaultValue = iDefaultValue;
        oCallbacks.OnValueChanged = function(me,_,key,checked) callback("sec",key); end;
        return ZLib.Dropdown:new(AceGUI,0.33,oOptions,oCallbacks);
    end,
    __ValidateOptions = function(self,oOptions)
        ZLib.Debug:Print('Validating Options: '.. tostring(oOptions));
        if oOptions == nil then oOptions = {}; end
        ZLib.Debug:Print('Setting Military Time if needed.');
        if oOptions.MilitaryTime == nil then oOptions.MilitaryTime = false; end
        ZLib.Debug:Print('Checking Default Time Value.');
        if not ZLib:IsTimeValid(oOptions.DefaultValue) then
            ZLib.Debug:Print('Time not valid.');
            oOptions.DefaultValue = date("*t");
            oOptions.DefaultValue.day = nil;
            oOptions.DefaultValue.month = nil;
            oOptions.DefaultValue.year = nil;
        end
        ZLib.Debug:Print('Default Time Value: ' .. tostring(oOptions.DefaultValue));
        ZLib.Debug:Print('Default Time Value: ' .. tostring(oOptions.DefaultValue.hour));
        ZLib.Debug:Print('Default Time Value: ' .. tostring(oOptions.DefaultValue.min));
        ZLib.Debug:Print('Default Time Value: ' .. tostring(oOptions.DefaultValue.sec));
        ZLib.Debug:Print('Options Validated.');
        return oOptions;
    end,
    __ValidateCallbacks = function(self,oCallbacks)
        ZLib.Debug:Print('Validating Callbacks: '.. tostring(oCallbacks));
        if oCallbacks == nil then oCallbacks = {}; end
        if not oCallbacks.OnValueChanged then oCallbacks.OnValueChanged = ZLib.EmptyFunction; end
        ZLib.Debug:Print('Callbacks Validated.');
        return oCallbacks;
    end
};
ZLib.Controls.TimePicker = ZLib.TimePicker;
