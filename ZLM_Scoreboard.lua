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
        if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
        local frame = self:__CreateFrame(AceGUI);
        frame:Hide();
        frame.DateTimePickerContainer = self:__CreateDateTimePickerContainer(AceGUI);
        frame:AddChild(frame.DatePickerContainer);
        frame.ButtonContainer = self:__CreateButtonContainer(AceGUI);
        frame:AddChild(frame.ButtonContainer);
        frame.Table =  self:__CreateTable(AceGUI);
        frame:AddChild(frame.Table);
        frame.AddRow = self.__AddRow;
        frame.Update = self.__Update;
        frame.__GetDonationsWithinTime = self.__GetDonationsWithinTime;
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
    __CreateDateTimePickerContainer = function(self,AceGUI)
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
    end,
    __CalculatePointsTable = function(bounties)
        local pointsTable = {};
        for _,v in ipairs(bounties) do
            if v.HotItem then
                pointsTable[v.ItemId] = v.Points * 2;
            else
                pointsTable[v.ItemId] = v.Points;
            end
        end
        return pointsTable;
    end,
    __GetDonationsWithinTime = function(self,aDonations)
        local iStart = time(self.DateTimePickerContainer.StartDateTimePicker:GetValue());
        local iEnd = time(self.DateTimPickerContainer.EndDateTimePicker:GetValue());
        local output = {};
        for _,v in ipairs(aDonations) do
            if time(v.Timestamp) >= iStart and time(v.Timestamp) <= iEnd then tinsert(output,v) end
        end
        return output;
    end,
    __GetWinner = function(self)
        local roll = math.random()
    end,
    __AnnounceScoreboard = function(self,iAnnounceCount)

    end,
    __Update = function(self,aDonations,aBounties)
        local tTempPoints = {};
        local aFilteredDonations = self:__GetDonationsWithinTime(aDonations);
        local tPoints = ZLM_Scoreboard.__CalculatePointsTable(aBounties);
        if #tPoints > 0 then
            for _,v in ipairs(aFilteredDonations) do
                tTempPoints[v.Name] = (tTempPoints[v.Name] or 0) + (tPoints[v.ItemId] * v.Quantity);
            end
            self:FillScoreboard(tTempPoints);
            self.Lottery Data
        end
    end,
    __FillScoreboard = function(self,tRowSource)
        local AceGUI = LibStub("AceGUI-3.0");
        self:ClearScoreboard();
        local i,min = 0,1;
        for k,v in tRowSource do
            i = i + 1;
            v.Name = k;
            v.Rank = i;
            v.Min = min;
            v.Max = min + v.Points - 1;
            self:AddRow(AceGUI,v)
            min = v.Max + 1;
        end
    end,
    __ClearScoreboard = function(self)
        self.Table:Clear();
    end,
};
ZLM_ScoreboardData = {};