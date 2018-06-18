<<<<<<< HEAD
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
    local startDateDatePicker = ZLM_DatePicker:new(1,"Start Date","ScoreboardStartDateTime",2018,date("%Y"),true,callbacks.DateChanged,defaultValues.StartDate,AceGUI,false);
    local endDateDatePicker = ZLM_DatePicker:new(1,"End Date","ScoreboardEndDateTime",2018,date("%Y"),true,callbacks.DateChanged,defaultValues.EndDate,AceGUI,false);
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
=======
ZLM_Scoreboard = {
    Title = "ZLM - Scoreboard",
    StructureArray = {
        Rank = { Width = 0.1, Type = "Label" },
        Name = { Width = 0.35, Type = "Label" },
        Points = { Width = 0.25, Type = "Label" },
        Min = { Width = 0.15, Type = "Label" },
        Max = { Width = 0.15, Type = "Label" },
    };
    new = function(self,AceGUI)
>>>>>>> pr/2
        if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
        local frame = self:__CreateFrame(AceGUI);
        frame.ButtonContainer = self:__CreateButtonContainer(AceGUI);
        frame:AddChild(frame.ButtonContainer);
        frame.Table =  self:__CreateTable(AceGUI);
        frame:AddChild(frame.Table);
        frame.AddRow = self:__AddRow;
        return frame;
    end,
    __CreateFrame = function(self,AceGUI)
        if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
        local frame = AceGUI:Create("Frame");
        frame:SetLayout("Flow");
        frame:SetTitle(self.Title);
        return frame;
    end,
    __CreateButtonContainer = function(self,AceGUI)
        if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
        local container = AceGUI:Create("SimpleGroup");
        container:SetLayout("Flow");
        container:SetRelativeWidth(0.35);
        container:AddChild(self.__CreatePreviousWeekButton(AceGUI));
        container:AddChild(self.__CreateLastFourWeeksButton(AceGUI));
        container:AddChild(self.__CreatePreviousMonthButton(AceGUI));
        container:AddChild(self.__CreateSinceLastDrawingButton(AceGUI));
        return container;
    end,
    __CreatePreviousMonthButton = function(self,AceGUI)
        return ZLib.Button:new(AceGUI,0.5,"Previous Month",{ OnClick = ZLM_Scoreboard.__SetDatePickersToPreviousMonth });
    end,
    __CreateLastFourWeeksButton = function(self,AceGUI)
        return ZLib.Button:new(AceGUI,0.5,"Last 28 Days",{ OnClick = ZLM_Scoreboard.__SetDatePickersToLastFourWeeks });
    end,
    __CreatePreviousWeekButton = function(self,AceGUI)
        return ZLib.Button:new(AceGUI,0.5,"Previous Week",{ OnClick = ZLM_Scoreboard.__SetDatePickersToPreviousWeek });
    end,
    __CreateSinceLastDrawingButton = function(self,AceGUI)
        return ZLib.Button:new(AceGUI,0.5,"Since Last Drawing",{ OnClick = ZLM_Scoreboard.__SetDatePickersToPreviousWeek });
    end,
    __CreateDatePickerContainer = function(self,AceGUI)
        if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
        local container = AceGUI:Create("SimpleGroup");
        container:SetLayout("Flow");
        container:RelativeWidth(0.65);
        container.StartDateTimePicker = ZLib.DateTimePicker:new(AceGUI,1,{ Multiline = true, DefaultValue = ZLM.db.global.Reporting.Scoreboard.StartDateTime },{ OnValueChanged = self.__StartDateTimeChangedCallback });
        container.EndDateTimePicker = ZLib.DateTimePicker:new(AceGUI,1,{ Multiline = true, DefaultValue = ZLM.db.global.Reporting.Scoreboard.EndDateTime },{ OnValueChanged = self.__EndDateTimeChangedCallback });
        container:AddChild(container.StartDateTimePicker);
        container:AddChild(container.EndDateTimePicker);
        return container;
    end,
    __CreateTable = function(self,AceGUI)
        if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
        return ZLib.Table:new(AceGUI,1,self.StructureArray)
    end,
    __StartDateTimeChangedCallback = function(picker,dtObject,key,value,error)
        if ZLib:IsStringValid(error) then ZLM:Debug(error,4); return false; end
        ZLM.db.Global.Reporting.Scoreboard.StartDateTime = dtObject;
    end,
    __EndDateTimeChangedCallback = function(picker,dtObject,key,value,error)
        if ZLib:IsStringValid(error) then ZLM:Debug(error,4); return false; end
        ZLM.db.Global.Reporting.Scoreboard.EndDateTime = dtObject;
    end,
    __AddRow = function(self,AceGUI,oData)
        if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
        local rowObj = {
            Rank = {
                Text = oData.Rank,
                Width = ZLM_Scoreboard.StructureArray.Rank.Width;
            },
            Name = {
                Text = oData.Name,
                Width = ZLM_Scoreboard.StructureArray.Name.Width;
            },
            Points = {
                Text = oData.Points,
                Width = ZLM_Scoreboard.StructureArray.Points.Width;
            },
            Min = {
                Text = oData.Min,
                Width = ZLM_Scoreboard.StructureArray.Min.Width;
            },
            Max = {
                Text = oData.Max,
                Width = ZLM_Scoreboard.StructureArray.Max.Width;
            }
        };
        self.Table:AddRow(AceGUI,rowObj);
    end,
    __SetDatePickersToPreviousMonth = function(self)
        local daysInMonth = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
        local d = date("*t");
        d.month = d.month -1;
        if d.month == 0 then d.month = 12; d.year = d.year - 1; end
        d.day = 1;
        d.hour = 0;
        d.minute = 0;
        d.sec = 0;
        self.StartDatePicker:SetValue(d);
        d.day = daysInMonth[d.month];
        d.hour = 23;
        d.minute = 59;
        d.sec = 59;
        self.EndDatePicker:SetValue(d)
    end,
    __SetDatePickersToLastFourWeeks = function(self)
        self.StartDateTimePicker:SetDatePast({ day = 28, DayState = 0});
        self.EndDateTimePicker:SetDatePast({ day = 1, DayState = 1});
    end,
    __SetDatePickersToPreviousWeek = function(self)
        local d = date("%w");
        d = d - 2;
        if d < 0 then d = d + 7; end
        self.StartDateTimePicker:SetDatePast({ day = d + 7, DayState = 0; });
        self.EndDateTimePicker:SetDatePast({ day = d + 1, DayState = 1});
    end,
    __SetDatePickersToLastDrawing = function(self)
        local dateObj = ZLM.db.global.LastDrawing;
        if dateObj == nil then dateObj = { year = 2018, month = 1, day = 1, hour = 0, minute = 0, sec = 0}; end
        self.StartDateTimePicker:SetValue(dateObj);
        self.EndDateTimePicker:SetValue(date("*t"));
    end
};
function ZLM_Scoreboard:new(title,callbacks,defaultValues,AceGUI)
    if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
    --END: Creating Table
    datepickerContainer:AddChild(startDateDatePicker);
    datepickerContainer:AddChild(endDateDatePicker);

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