ZLM_DatePicker = {};
function ZLM_DatePicker:new(controlKey,minYear,maxYear,includeTime,onValueChangedCallback,AceGUI)
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
    local yearsDropdown = ZLM_DatePicker:CreateDropDown(years,yearsOrder,baseSize,controlKey,"year",onValueChangedCallback);
    local monthsDropdown = ZLM_DatePicker:CreateDropDown(months,monthsOrder,baseSize,controlKey,"month",onValueChangedCallback);
    local daysDropdown = ZLM_DatePicker:CreateDropDown(days,daysOrder,baseSize,controlKey,"day",onValueChangedCallback);
    --END: CREATE DROPDOWNS
    --BEGIN: ADD DROPDOWNS TO PARENT
    dateFrame:AddChild(ZLM_Header:new("Start Date",AceGUI));
    dateFrame:AddChild(ZLM_Label:new("Year:",0.1,AceGUI));
    dateFrame:AddChild(yearsDropdown);
    dateFrame:AddChild(ZLM_Label:new("Month:",0.1,AceGUI));
    dateFrame:AddChild(monthsDropdown);
    dateFrame:AddChild(ZLM_Label:new("Date:",0.1,AceGUI));
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
        local hoursDropdown = ZLM_DatePicker:CreateDropDown(hours,hoursOrder,baseSize,controlKey,"hour",onValueChangedCallback);
        local minutesDropdown = ZLM_DatePicker:CreateDropDown(sixty,sixtyOrder,baseSize,controlKey,"minute",onValueChangedCallback);
        local secondsDropdown = ZLM_DatePicker:CreateDropDown(sixty,sixtyOrder,baseSize,controlKey,"sec",onValueChangedCallback);
        --END: CREATE TIME DROPDOWNS
        --BEGIN: ADD TIME DROPDOWNS TO PARENT
        dateFrame:AddChild(ZLM_Label:new("H:",0.1,AceGUI));
        timeFrame:AddChild(hoursDropdown);
        dateFrame:AddChild(ZLM_Label:new("M:",0.1,AceGUI));
        timeFrame:AddChild(minutesDropdown);
        dateFrame:AddChild(ZLM_Label:new("S:",0.1,AceGUI));
        timeFrame:AddChild(secondsDropdown);
        --END: ADD TIME DROPDOWNS TO PARENT
        frame:AddChild(timeFrame);
    end
    return frame;
end

function ZLM_DatePicker:CreateDropDown(values,order,width,controlKey,callbackKey,callback)
    local AceGUI = LibStub("AceGUI-3.0");
    local datepicker = AceGUI:Create("Dropdown");
    if not not order then
        datepicker:SetList(values,order);
    else
        datepicker:SetList(values);
    end
    datepicker:SetRelativeWidth(width);
    datepicker:SetCallback("OnValueChanged",function(_,_,key,_)
        callback(controlKey,callbackKey,key);
    end);
    return datepicker;
end