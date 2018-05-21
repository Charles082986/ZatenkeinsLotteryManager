ZLM_Scoreboard = {};
function ZLM_Scoreboard:new(title,callbacks,defaultValues,AceGUI)
    if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
    --BEGIN: Creating the primary Scoreboard frame.
    local topContainer = AceGUI:Create("Frame");
    topContainer:SetLayout("Flow");
    topContainer:SetTitle(title);
    topContainer:SetCallback("OnClose",function(widget)
        ZLM.scoreboard = nil;
        widget:ReleaseChildren();
        AceGUI:Release(widget);
    end);
    function topContainer:Terminate()
        ZLM.scoreboard = nil;
        self:ReleaseChildren();
        self:Release();
    end
    --END: Creating the primary Scoreboard frame.
    --BEGIN: Creating the button container.
    local buttonContainer = AceGUI:Create("SimpleGroup");
    buttonContainer:SetLayout("Flow");
    buttonContainer:SetRelativeWidth(0.35);
    --END: Creating the button container.
    --BEGIN: Creating the datepicker container.
    local datepickerContainer = AceGUI:Create("SimpleGroup");
    datepickerContainer:SetLayout("Flow");
    datepickerContainer:SetRelativeWidth(0.65);
    --END: Creating the datepicker container.
    --BEGIN: Creating Datepickers
    local startDateDatePicker = ZLM_DatePicker:new(0.5,"Start Date","ScoreboardStartDateTime",2018,date("%Y"),true,callbacks.DateChanged,defaultValues.StartDate,AceGUI);
    local endDateDatePicker = ZLM_DatePicker:new(0.5,"End Date","ScoreboardEndDateTime",2018,date("%Y"),true,callbacks.DateChanged,defaultValues.EndDate,AceGUI);
    --END: Creating Datepickers
    --BEGIN: Creating Table
    topContainer.Table = ZLM_Table:new({
        Rank = { Width = 0.1, Type = ZLM_Table.Types.Label },
        Name = { Width = 0.35, Type = ZLM_Table.Types.Label },
        Points = { Width = 0.25, Type = ZLM_Table.Types.Label },
        Min = { Width = 0.15, Type = ZLM_Table.Types.Label },
        Max = { Width = 0.15, Type = ZLM_Table.Types.Label },
    },{"Rank","Name","Points","Min","Max"}, AceGUI);
    function topContainer:AddRow(dataObj,AceGUI)
        if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
        local rowObj = {};
        for k,v in pairs(dataObj) do
            rowObj[k] = { Content = v };
        end
        self.Table.DataFrame:AddRow(rowObj,AceGUI);
    end
    topContainer.StartDatePicker = startDateDatePicker;
    topContainer.EndDatePicker = endDateDatePicker;
    function topContainer:SetDatePickersToPreviousMonth()
        local daysInMonth = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
        local d = date("*t");
        d.month = d.month -1;
        if d.month == 0 then d.month = 12; d.year = d.year - 1; end
        d.day = 1;
        d.hour = 0;
        d.minute = 0;
        d.sec = 0;
        self.StartDatePicker:SetDate(d);
        d.day = daysInMonth[d.month];
        d.hour = 23;
        d.minute = 59;
        d.sec = 59;
        self.EndDatePicker:SetDate(d)
    end
    function topContainer:SetDatePickersToLastFourWeeks()
        self.StartDatePicker:SetDatePast({ day = 28, DayState = 0});
        self.EndDatePicker:SetDatePast({ day = 1, DayState = 1});
    end
    function topContainer:SetDatePickersToPreviousWeek()
        local d = date("%w");
        d = d - 2;
        if d < 0 then d = d + 7; end
        self.StartDatePicker:SetDatePast({ day = d + 7, DayState = 0; });
        self.EndDatePicker:SetDatePast({ day = d + 1, DayState = 1});
    end
    function topContainer:SetDatePickersToLastDrawing()
        local dateObj = ZLM.db.global.LastDrawing;
        if dateObj == nil then dateObj = { year = 2018, month = 1, day = 1, hour = 0, minute = 0, sec = 0}; end
        self.StartDatePicker:SetDate(dateObj);
        self.EndDatePicker:SetDate(date("*t"));
    end
    --END: Creating Table
    datepickerContainer:AddChild(startDateDatePicker);
    datepickerContainer:AddChild(endDateDatePicker);
    datepickerContainer:AddChild(ZLM_Button:new("Previous Month",function() topContainer:SetDatePickersToPreviousMonth(); end,1/2,AceGUI));
    datepickerContainer:AddChild(ZLM_Button:new("Last 28 Days",function() topContainer:SetDatePickersToLastFourWeeks(); end,1/2,AceGUI));
    datepickerContainer:AddChild(ZLM_Button:new("Previous Week",function() topContainer:SetDatePickersToPreviousWeek(); end,1/2,AceGUI));
    datepickerContainer:AddChild(ZLM_Button:new("Since Last Drawing",function() topContainer:SetDatePickersToLastDrawing(); end,1/2,AceGUI));
    buttonContainer:AddChild(ZLM_Heading:new("Actions",AceGUI));
    buttonContainer:AddChild(ZLM_Button:new("Calculate Scoreboard",callbacks.UpdateScoreboard,1,AceGUI));
    buttonContainer:AddChild(ZLM_Button:new("Get Winners",callbacks.GetWinners,1,AceGUI));
    buttonContainer:AddChild(ZLM_Button:new("Announce Scoreboard",callbacks.AnnounceScoreboard,1,AceGUI));
    buttonContainer:AddChild(ZLM_Range:new(nil,1,10,1,1,callbacks.AnnounceQuantityChanged,AceGUI,defaultValues.AnnounceQuantity));
    topContainer:AddChild(datepickerContainer);
    topContainer:AddChild(buttonContainer);
    topContainer:AddChild(topContainer.Table.MainFrame);
    --for i = 1,5 do
        topContainer:AddRow({ Rank = 1, Name = "Norbergenson-Alterac Mountains", Points = 50000, Min = 1, Max = 50000 })
    --end
    return topContainer;
end

ZLM_ScoreboardData = {};