ZLM_DatePicker = {};
function ZLM_DatePicker:new(width,name,controlKey,minYear,maxYear,includeTime,onValueChangedCallback,defaultValue,AceGUI,multiline)
    multiline = multiline or false;
    if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
    --BEGIN: Create Parent Frame
    local frame = AceGUI:Create("SimpleGroup");
    local dateFrame = AceGUI:Create("SimpleGroup");
    if multiline then dateFrame:SetRelativeWidth(1); else dateFrame:SetRelativeWidth(0.49); end
    dateFrame:SetLayout("Flow");
    frame:SetLayout("Flow");
    frame:SetRelativeWidth(width);
    --END: Create Parent Frame
    --BEGIN: Create Dropdowns
    local years = {};
    local yearsOrder = {};
    for i = minYear,maxYear do
        years[i] = i;
        tinsert(yearsOrder,i);
    end;

    local months = {
        "JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"
    };
    local monthsOrder = {
        1,2,3,4,5,6,7,8,9,10,11,12
    };
    local days = {};
    local daysOrder = {};
    for i = 1,31 do
        days[i] = i;
        tinsert(daysOrder,i);
    end
    local baseSize = 1/3;
    local yearsDropdown = ZLM_DatePicker:CreateDropDown(years,yearsOrder,baseSize * 1.1,controlKey,"year",onValueChangedCallback,defaultValue.year,AceGUI);
    local monthsDropdown = ZLM_DatePicker:CreateDropDown(months,monthsOrder,baseSize * 1.1,controlKey,"month",onValueChangedCallback,defaultValue.month,AceGUI);
    local daysDropdown = ZLM_DatePicker:CreateDropDown(days,daysOrder,baseSize * 0.8,controlKey,"day",onValueChangedCallback,defaultValue.day,AceGUI);
    --END: CREATE DROPDOWNS
    --BEGIN: ADD DROPDOWNS TO PARENT
    if not not name then
        frame:AddChild(ZLM_Heading:new(name,AceGUI));
    end
    --dateFrame:AddChild(ZLM_Label:new(" Mth:",0.1,AceGUI));
    dateFrame:AddChild(monthsDropdown);
    --dateFrame:AddChild(ZLM_Label:new(" Day:",0.1,AceGUI));
    dateFrame:AddChild(daysDropdown);
    --dateFrame:AddChild(ZLM_Label:new(" Yr:",0.1,AceGUI));
    dateFrame:AddChild(yearsDropdown);
    --END: ADD DROPDOWNS TO PARENT
    frame:AddChild(dateFrame);
    frame.picker = {};
    frame.picker.year = yearsDropdown;
    frame.picker.month = monthsDropdown;
    frame.picker.day = daysDropdown;
    function frame:SetDate(dateObj)
        for k,v in pairs(dateObj) do
            local p = self.picker[k];
            if not not p then
                p:SetValue(v);
                onValueChangedCallback(controlKey,k,v);
            end
        end
    end
    function frame:SetDateCurrent()
        self:SetDate(date("*t"));
    end
    function frame:SetDatePast(dateObj)
        local multipliers = {
            sec = 1,
            minute = 60,
            hour = 3600,
            day = 86400
        }
        local d = date("*t");
        local t = time(d);
        for k,v in pairs(dateObj) do
            local m = multipliers[k];
            if not not m then
                t = t - (m * v);
            end
        end
        d = date("*t",t);
        if dateObj.DayState ~= nil then
            if dateObj.DayState == 0 then
                d.sec = 0; d.minute = 0; d.hour = 0;
            else
                d.sec = 59; d.minute = 59; d.hour = 23;
            end
        end
        self:SetDate(d);
    end
    if not not includeTime then
        local timeFrame = AceGUI:Create("SimpleGroup");
        if multiline then timeFrame:SetRelativeWidth(1); else timeFrame:SetRelativeWidth(0.49); end
        timeFrame:SetLayout("Flow");
        --BEGIN: CREATE TIME DROPDOWNS
        local hours = {};
        local hoursOrder = {};
        local sixty = {};
        local sixtyOrder = {};
        for i = 0,59 do
            if i < 24 then
                hours[i] = i;
                tinsert(hoursOrder,i);
            end
            if i < 10 then
                sixty[i] = ":0"..i;
            else
                sixty[i] = ":"..i;
            end
            tinsert(sixtyOrder,i);
        end
        local hoursDropdown = ZLM_DatePicker:CreateDropDown(hours,hoursOrder,baseSize,controlKey,"hour",onValueChangedCallback, defaultValue.hour);
        local minutesDropdown = ZLM_DatePicker:CreateDropDown(sixty,sixtyOrder,baseSize,controlKey,"minute",onValueChangedCallback, defaultValue.min);
        local secondsDropdown = ZLM_DatePicker:CreateDropDown(sixty,sixtyOrder,baseSize,controlKey,"sec",onValueChangedCallback, defaultValue.sec);
        --END: CREATE TIME DROPDOWNS
        --BEGIN: ADD TIME DROPDOWNS TO PARENT
        --timeFrame:AddChild(ZLM_Label:new(" Hr:",0.1,AceGUI));
        timeFrame:AddChild(hoursDropdown);
        --timeFrame:AddChild(ZLM_Label:new(" Min:",0.1,AceGUI));
        timeFrame:AddChild(minutesDropdown);
        --timeFrame:AddChild(ZLM_Label:new(" Sec:",0.1,AceGUI));
        timeFrame:AddChild(secondsDropdown);
        --END: ADD TIME DROPDOWNS TO PARENT
        frame:AddChild(timeFrame);
        frame.picker.hour = hoursDropdown;
        frame.picker.minute = minutesDropdown;
        frame.picker.sec = secondsDropdown;
    end
    return frame;
end

function ZLM_DatePicker:CreateDropDown(values,order,width,controlKey,callbackKey,callback,defaultValue)
    local AceGUI = LibStub("AceGUI-3.0");
    local datepicker = AceGUI:Create("Dropdown");
    if not not order then
        datepicker:SetList(values,order);
    else
        datepicker:SetList(values);
    end
    if not not defaultValue then
        datepicker:SetValue(defaultValue);
    end
    datepicker:SetRelativeWidth(width);
    datepicker:SetCallback("OnValueChanged",function(me,_,key,_)
        callback(controlKey,callbackKey,key,me);
    end);
    return datepicker;
end
ZLM_Controls["DatePicker"] = ZLM_DatePicker;
ZLM_Table.Table.Types.DatePicker = "DatePicker";