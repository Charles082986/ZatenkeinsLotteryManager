ZLM_LotteryMethod = {
    Competition = "Competition",
    Raffle = "Raffle"
};
ZLM_OptionDefaults = {
    profile = {
        Enabled = true,
        PrintLevel = 0,
        LotteryItems = {},
        LotteryMethod = ZLM_LotteryMethod.Raffle,
        NumberOfWinners = 1,
        ExclusiveWinners = true,
        ScoreboardStartDateTimeDatePicker = {
            year = 2018,
            month = 1,
            day = 1,
            hour = 0,
            minute = 0,
            sec = 0
        },
        ScoreboardStartDateTime = 0,
        ScoreboardEndDateTime = 0,
        ScoreboardEndDateTimeDatePicker = {
            year = 2018,
            month = 1,
            day = 1,
            hour = 0,
            minute = 0,
            sec = 0
        }
    },
    --[[records = {
        Donations = {},
        Scoreboard = {},
        ScoreboardTotal = 0,
        TotalPoints = 0,
        RollLimit = 0
    }]]
};
function ZLM_SortScoreboard(a,b)
    if a == b then
        return a.Name < b.Name --Sort names alphabetically if scores are equal
    else
        return a.Points > b.Points; --Sort scores from largest to smallest.
    end
end

ZLM = LibStub("AceAddon-3.0"):NewAddon("ZatenkeinsLotteryManager", "AceConsole-3.0", "AceEvent-3.0");
ZLM_OptionsTable = {
    type = "group",
    handler = ZLM,
    args = {
        config = {
            name = "Config",
            type="group",
            order = 0,
            args = {
                enable = {
                    name = "Enable",
                    desc = "Enables/disables the addon",
                    type = "toggle",
                    set = "SetEnabled",
                    get = "GetEnabled",
                    order = 1,
                    descStyle="inline"
                },
                debug = {
                    name = "Debug Print Level",
                    desc = "Displays addon output messages.  Lower values show only urgent messages.  Higher values show all messages.",
                    type = "range",
                    min = 0,
                    max = 4,
                    step = 1,
                    bigStep = 1,
                    set = "SetPrintLevel",
                    get = "GetPrintLevel",
                    order = 2,
                    descStyle= "inline"
                },
                lotteryMethod = {
                    name = "Lottery Method",
                    desc = "The method of determining the winners.  Raffle assigns a proportional chance of winning based on total points.  Competition determines winner exclusively by point values.",
                    type = "select",
                    set = "SetLotteryMethod",
                    get = "GetLotteryMethod",
                    values = ZLM_LotteryMethod,
                    order = 3,
                    descStyle="inline"
                },
                numberOfWinners = {
                    name = "Number of Winners",
                    desc = "The number of winners you wish to get.",
                    type = "range",
                    min = 1,
                    max = 100,
                    step = 1,
                    bigStep = 1,
                    set = "SetWinnerCount",
                    get = "GetWinnerCount",
                    order = 4,
                    descStyle="inline"
                },
                exclusiveWinners = {
                    name = "Exclusive Winners",
                    desc = "[Raffle Method Only]Can the same person win more than once per drawing?",
                    type = "toggle",
                    set = "SetExclusiveWinners",
                    get = "GetExclusiveWinners",
                    order = 5,
                    descStyle="inline"
                },
            },
        },
        bounties = {
            name = "Bounties",
            type = "group",
            args = {

            }
        },
        scoreboard = {
            name = "Scoreboard",
            type = "execute",
            func = function()
                ZLM:ShowScoreboard();
                ZLM:Debug("Showing Scoreboard");
            end,
            order = 0
        },
        donations = {
            name = "Donations",
            type = "group",
            args = {
                addDonation = {
                    name="Add Donation",
                    type="execute",
                    func = function()
                        ZLM:Debug("Adding Donation!");
                    end
                },
            }
        },

    }
};
function ZLM:Debug(message,severity)
    --if self.db.profile.PrintLevel < severity then
        self:Print(message);
    --end
end

ZLM:Debug("ZLM instantiated.",1);
function ZLM:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("ZatenkeinsLotteryManagerDB", ZLM_OptionDefaults, true);
    if not not self.db then
        self:Debug("DB Created.",1);
    else
        self:Debug("DB Failed!",4);
    end
    LibStub("AceConfig-3.0"):RegisterOptionsTable("ZatenkeinsLotteryManager", ZLM_OptionsTable, {"zlm"});
    self:Debug("Options Table Registered..",1);
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("ZatenkeinsLotteryManager", "ZLM");
    self:Debug("OptionsFrame added to BlizOptions.",1);
    self:Print("ZLM Loaded");
end

function ZLM:OnEnable()
    --Register events here.
end
function ZLM:OnDisable()
    --Unregister events here.
end
function ZLM:SetEnabled(_,value)
    self.db.profile.Enabled = value;
    ZLM:Debug("Setter Event - Property: Enabled, Value: " .. string.format("%s",value),1);
end
function ZLM:GetEnabled(_)
    return self.db.profile.Enabled;
end
function ZLM:SetPrintLevel(_,value)
    self.db.profile.PrintLevel = value;
    ZLM:Debug("Setter Event - Property: PrintLevel, Value: " .. string.format("%s",value),1);
end
function ZLM:GetPrintLevel(_)
    return self.db.profile.PrintLevel;
end
function ZLM:SetLotteryMethod(_,value)
    self.db.profile.LotteryMethod = value;
    ZLM:Debug("Setter Event - Property: LotteryMethod, Value: " .. string.format("%s",value),1);
end
function ZLM:GetLotteryMethod(_)
    return self.db.profile.LotteryMethod;
end
function ZLM:SetWinnerCount(_, value)
    self.db.profile.NumberOfWinners = value;
    ZLM:Debug("Setter Event - Property: WinnerCount, Value: " .. string.format("%s",value),1);
end
function ZLM:GetWinnerCount(_)
    return self.db.profile.NumberOfWinners;
end
function ZLM:SetExclusiveWinners(_, value)
    self.db.profile.ExclusiveWinners = value;
    ZLM:Debug("Setter Event - Property: ExclusiveWinners, Value: " .. string.format("%s",value),1);
end
function ZLM:GetExclusiveWinners(_)
    return self.db.profile.ExclusiveWinners;
end
function ZLM:RunLottery(startTime,endTime) -- TO DO: Needs update without params.
	ZLM_LotteryManager:UpdateScoreboard(startTime,endTime);	
	local lotteryMethod = self.db.profile.LotteryMethod;
	local lotteryWinnerCount = self.db.profile.NumberOfWinners;
	local winners = {};
	if lotteryMethod == ZLM_LotteryMethod.Competition then
		winners = self:GetCompetitionWinners(lotteryWinnerCount)
	elseif lotteryMethod == ZLM_LotteryMethod.Raffle then
		winners = self:GetRaffleWinners(lotteryWinnerCount);
	end
	ZLM:AnnounceWinners(startTime,endTime,winners,lotteryMethod);
end
function ZLM:UpdateScoreboard(startTime,endTime)
	local donations = ZLM:GetDonationsWithinTimeframe(startTime,endTime);
	local scoreboard = {};
	for i = 1,#(donations),1 do
		local donation = donations[i];
		if scoreboard[donation.Name] ~= nil then
			scoreboard[donation.Name].Points = scoreboard[donation.Name].Points + donation.TotalPoints;
		else
			scoreboard[donation.Name] = { Name = donation.Name, Points = donation.TotalPoints };
		end
	end
	self.db.records.Scoreboard = {};
	self.db.records.ScoreboardTotal = 0;
	for _,v in pairs(scoreboard) do
		self.db.records.TotalPoints = self.db.records.TotalPoints + v.Points;
		tinsert(self.db.records.Scoreboard,v);
	end
	sort(self.db.records.Scoreboard,ZLM_SortScoreboard);
end -- TO DO: Needs update without params.
function ZLM:GetRaffleWinners(winnersCount,exclusiveWinners)
	local winners = {};
	if exclusiveWinners == nil then exclusiveWinners = true; end
	while #(winners) < winnersCount do
		local roll = math.random(self.db.records.TotalPoints);
		local base = 0;
		for i = 1,#(self.db.records.Scoreboard) do
			local ticket = self.db.records.Scoreboard[i];
			if roll > base and roll <= (ticket.Points + base) then
				if (exclusiveWinners) or (not self.Contains(winners,"Name",ticket.Name)) or (self.Contains(winners,"Name",ticket.Name) and not exclusiveWinners) then
					tinsert(winners,{ Roll = roll, Name = ticket.Name });
					break;
				end
			end
		end
	end
	return winners;
end -- TO DO: Needs update without params.
function ZLM:GetCompetitionWinners(winnersCount)
	local winners = {};
	for i = 1,winnersCount do
		tinsert(winners,self.db.records.Scoreboard[i]);
	end
	return winners;
end -- TO DO: Needs update without params.
function ZLM:AnnounceWinners(startTime,endTime,winners,lotteryMethod)
	local firstMessage ="The Lottery Winners for -"..startTime.."- through -"..endTime.."- are:";	
	if ZLM_Debug then	
		print(firstMessage);
	else
		SendChatMessage(firstMessage,ZLM_Options.OutputChatType,nil,ZLM_Options.OutputChatChannel);
	end	
	if lotteryMethod == ZLM_LotteryManager.LotteryMethod.Competition then
		local results = ZLM_GetTieResults;
		for k,v in pairs(results) do
			local message = k..": "..table.concat(v,", ");
			if ZLM_Debug then
				print(message);
			else
				SendChatMessage(message,ZLM_Options.OutputChatType,nil,ZLM_Options.OutputChatChannel);
			end
		end
	elseif lotteryMethod == ZLM_LotteryManager.LotteryMethod.Raffle then
		for i,v in ipairs(winners) do
			local message = i..": "..v.Name .. " (Roll: " .. v.Roll .. ")";
			if ZLM_Debug then
				print(message);
			else
				SendChatMessage(message,ZLM_Options.OutputChatType,nil,ZLM_Options.OutputChatChannel);
			end
		end
	end
end -- TO DO: Needs update without params.
function ZLM:ConverteStringToTime(str)
	local day,month,year,hour,min,sec=str:match(ZLM_DateStringPattern);
	local MON={Jan=1,Feb=2,Mar=3,Apr=4,May=5,Jun=6,Jul=7,Aug=8,Sep=9,Oct=10,Nov=11,Dec=12};
	local month=MON[month];
	local offset=time()-time(date("!*t"));
	return time({day=day,month=month,year=year,hour=hour,min=min,sec=sec}) + offset;
end
function ZLM:Contains(table,property,value)
	for z = 1,#(table) do
		if table[z][property] == value then return true; end
	end
	return false;
end
function ZLM:GetTieResults(winners) --INCOMPLETE
	local pendingResults = {};
	for _,v in ipairs(winners) do
        local record = pendingResults[v.Points];
        if not not record then
            pendingResults[v.Points] = v.Name;
        else
            pendingResults[v.Points] = record .. ", " .. v.Name
        end
    end
    sort(pendingResults,function(a,b)

    end)
    return pendingResults;
end
function ZLM:ShowScoreboard()
    ZLM:Debug("Showing Scoreboard.", 1);
    ZLM_Scoreboard:new("Zatenkein's Lottery Manager - Scoreboard",
        function()
            ZLM:UpdateScoreboard();
        end,
        function()
            ZLM:UpdateScoreboard();
            ZLM:RunLottery();
        end,
        function(controlKey,segmentKey,value)
            ZLM:Debug("Updating DateTime for " .. controlKey .. "DatePicker." .. segmentKey .. " to " .. value .. ".",1)
            ZLM.db.profile[controlKey .. "DatePicker"][segmentKey] = value;
            ZLM.db.profile[controlKey] = time(ZLM.db.profile[controlKey .. "DatePicker"]);
        end)
end
ZLM_LotteryItem = {};
function ZLM_LotteryItem:new()
    local entry = {};
    entry.WoWItemId = 0;
    entry.ItemName = "";
    entry.Active = false;
    entry.HotItem = false;
    entry.Multiplier = false;
    entry.PointValue = 0;
    return entry;
end

function ZLM:GetDonationsWithinTimeframe(startTimeString,endTimeString)
    local time1 = ConvertStringToTime(startTimeString);
    local time2 = ConvretStringToTime(endTimeString);
    local output = {};
    for i = 1,#(self.db.records.Donations),1 do
        local logItem = self.db.records.Donations[i];
        if logItem.Timestamp >= time1 and logItem.Timestamp <= time2 then
            tinstert(output,logItem);
        end
    end
    return output;
end
function ZLM:RecordDonation(nameRealmCombo,itemId,quantity) -- Add a new record to the donation log.

end
function ZLM:PurgeDonationLog(timeString) -- Purge all DonationLog records before a specific time.
    local purgeTime;
    if not not timeString then
        purgeTime = ZLM_ConverteStringToTime(timeString);
    else
        purgeTime = GetServerTime();
    end
    for i = #(self.db.records.Donations),1,-1 do
        local entry = self.db.records.Donations[i];
        if entry.Timestamp < purgeTime then
            tremove(self.db.records.Donations,i);
        end
    end
end

ZLM_Donation = {
    Name = "Defaultname-Default Realm",
    ItemId = 12345,
    Quantity = 0,
    Timestamp = 0,
}
function ZLM_Donation:new(nameRealmCombo,itemId,quantity)
    local donation = {};
    donation.Name = nameRealmCombo;
    donation.ItemId = itemId;
    donation.Quantity = quantity;
    donation.Timestamp = GetServerTime();
    return donation;
end
