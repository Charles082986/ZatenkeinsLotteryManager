ZLM_DatePicker = {};
function ZLM_DatePicker:new(name,controlKey,minYear,maxYear,includeTime,onValueChangedCallback,defaultValue,AceGUI)
    if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
    --BEGIN: Create Parent Frame
    local frame = AceGUI:Create("SimpleGroup");
    local dateFrame = AceGUI:Create("SimpleGroup");
    dateFrame:SetRelativeWidth(1);
    dateFrame:SetLayout("Flow");
    frame:SetLayout("Flow");
    frame:SetRelativeWidth(0.5);
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
    local baseSize = 0.23;
    local yearsDropdown = ZLM_DatePicker:CreateDropDown(years,yearsOrder,baseSize,controlKey,"year",onValueChangedCallback,defaultValue.year);
    local monthsDropdown = ZLM_DatePicker:CreateDropDown(months,monthsOrder,baseSize,controlKey,"month",onValueChangedCallback,defaultValue.month);
    local daysDropdown = ZLM_DatePicker:CreateDropDown(days,daysOrder,baseSize,controlKey,"day",onValueChangedCallback,defaultValue.day);
    --END: CREATE DROPDOWNS
    --BEGIN: ADD DROPDOWNS TO PARENT
    frame:AddChild(ZLM_Heading:new(name,AceGUI));
    dateFrame:AddChild(ZLM_Label:new(" Yr:",0.1,AceGUI));
    dateFrame:AddChild(yearsDropdown);
    dateFrame:AddChild(ZLM_Label:new(" Mth:",0.1,AceGUI));
    dateFrame:AddChild(monthsDropdown);
    dateFrame:AddChild(ZLM_Label:new(" Day:",0.1,AceGUI));
    dateFrame:AddChild(daysDropdown);
    --END: ADD DROPDOWNS TO PARENT
    frame:AddChild(dateFrame);
    if not not includeTime then
        local timeFrame = AceGUI:Create("SimpleGroup");
        timeFrame:SetRelativeWidth(1);
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
            sixty[i] = i;
            tinsert(sixtyOrder,i);
        end
        local hoursDropdown = ZLM_DatePicker:CreateDropDown(hours,hoursOrder,baseSize,controlKey,"hour",onValueChangedCallback, defaultValue.hour);
        local minutesDropdown = ZLM_DatePicker:CreateDropDown(sixty,sixtyOrder,baseSize,controlKey,"minute",onValueChangedCallback, defaultValue.minute);
        local secondsDropdown = ZLM_DatePicker:CreateDropDown(sixty,sixtyOrder,baseSize,controlKey,"sec",onValueChangedCallback, defaultValue.sec);
        --END: CREATE TIME DROPDOWNS
        --BEGIN: ADD TIME DROPDOWNS TO PARENT
        timeFrame:AddChild(ZLM_Label:new(" Hr:",0.1,AceGUI));
        timeFrame:AddChild(hoursDropdown);
        timeFrame:AddChild(ZLM_Label:new(" Min:",0.1,AceGUI));
        timeFrame:AddChild(minutesDropdown);
        timeFrame:AddChild(ZLM_Label:new(" Sec:",0.1,AceGUI));
        timeFrame:AddChild(secondsDropdown);
        --END: ADD TIME DROPDOWNS TO PARENT
        frame:AddChild(timeFrame);
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
    datepicker:SetCallback("OnValueChanged",function(_,_,key,_)
        callback(controlKey,callbackKey,key);
    end);
    return datepicker;
end