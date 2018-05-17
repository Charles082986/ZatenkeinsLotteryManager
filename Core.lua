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
        },
        GuildRanksElligible = {
            false,
            false,
            false,
            false,
            true,
            true,
            true,
            true,
            true,
            true
        },
        OutputChatType = "GUILD",
        OutputChannel = "",
    },
    global = {
        Donations = {},
        Prizes = {},
    }
};
function ZLM_SortScoreboard(a,b)
    if a.Points == b.Points then
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
                outputChatType = {
                    name = "Output Chat",
                    desc = "The chat type to use for lottery announcements. (GUILD, WHISPER, etc)",
                    type = "select",
                    values = { GUILD = "GUILD",  SAY = "SAY", WHISPER = "WHISPER" },
                    get = "GetOutputChatType",
                    set = "SetOutputChatType"
                },
                outputChatChannel = {
                    name = "Output Channel",
                    desc = "The channel or whisper target you wish to send lottery announcements too.",
                    type = "input",
                    get = "GetOutputChannel",
                    set = "SetOutputChannel"
                }
            },
        },
        scoreboard = {
            name = "Scoreboard",
            type = "execute",
            func = function()
                ZLM:ShowScoreboard();
                ZLM:Debug("Showing Scoreboard",1);
            end,
            order = 0
        },
        bountyboard = {
            name = "Bountyboard",
            type = "execute",
            func = function()
                ZLM:ShowBountyboard();
                ZLM:Debug("Showing Bountyboard",1)
            end
        }
    }
};
function ZLM:Debug(message,severity)
    --if self.db.profile.PrintLevel < severity then
        self:Print(message);
    --end
end
ZLM.WaitTable = {};
ZLM.WaitFrame = nil;
function ZLM:Wait(delay,func,...)
    if(type(delay)~="number" or type(func)~="function") then
        return false;
    end
    if(waitFrame == nil) then
        ZLM.WaitFrame = CreateFrame("Frame","WaitFrame", UIParent);
        ZLM.WaitFrame:SetScript("onUpdate",function (self,elapse)
            local count = #ZLM.WaitTable;
            local i = 1;
            while(i<=count) do
                local waitRecord = tremove(ZLM.WaitTable,i);
                local d = tremove(waitRecord,1);
                local f = tremove(waitRecord,1);
                local p = tremove(waitRecord,1);
                if(d>elapse) then
                    tinsert(ZLM.WaitTable,i,{d-elapse,f,p});
                    i = i + 1;
                else
                    count = count - 1;
                    f(unpack(p));
                end
            end
        end);
    end
    tinsert(ZLM.WaitTable,{delay,func,{...}});
    return true;
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
    if not self.db.profile.Settings then self.db.profile.Settings = {}; end
end
function ZLM:OnEnable()
    --Register events here.
end
function ZLM:OnDisable()
    --Unregister events here.
end
function ZLM:SetEnabled(_,value)
    self.db.profile.Settings.Enabled = value;
    ZLM:Debug("Setter Event - Property: Enabled, Value: " .. string.format("%s",value),1);
end
function ZLM:GetEnabled(_)
    return self.db.profile.Settings.Enabled;
end
function ZLM:SetPrintLevel(_,value)
    self.db.profile.Settings.PrintLevel = value;
    ZLM:Debug("Setter Event - Property: PrintLevel, Value: " .. string.format("%s",value),1);
end
function ZLM:GetPrintLevel(_)
    return self.db.profile.Settings.PrintLevel;
end
function ZLM:SetLotteryMethod(_,value)
    self.db.profile.Settings.LotteryMethod = value;
    ZLM:Debug("Setter Event - Property: LotteryMethod, Value: " .. string.format("%s",value),1);
end
function ZLM:GetLotteryMethod(_)
    return self.db.profile.Settings.LotteryMethod;
end
function ZLM:SetWinnerCount(_, value)
    self.db.profile.Settings.NumberOfWinners = value;
    ZLM:Debug("Setter Event - Property: WinnerCount, Value: " .. string.format("%s",value),1);
end
function ZLM:GetWinnerCount(_)
    return self.db.profile.Settings.NumberOfWinners;
end
function ZLM:SetExclusiveWinners(_, value)
    self.db.profile.Settings.ExclusiveWinners = value;
    ZLM:Debug("Setter Event - Property: ExclusiveWinners, Value: " .. string.format("%s",value),1);
end
function ZLM:GetExclusiveWinners(_)
    return self.db.profile.Settings.ExclusiveWinners;
end
function ZLM:SetOutputChannel(_,value) 
    self.db.profile.Settings.OutputChannel = value;
end
function ZLM:GetOutputChannel(_) 
    return self.db.profile.Settings.OutputChannel;
end
function ZLM:SetOutputChatType(_,value)
    self.db.profile.Settings.OutputChatType = value;
end
function ZLM:GetOutputChatType(_)
    return self.db.profile.Settings.OutputChatType;
end

function ZLM:RunLottery() -- TO DO: Needs update without params.
	ZLM:UpdateScoreboard();
	local lotteryMethod = self.db.profile.Settings.LotteryMethod;
	local lotteryWinnerCount = self.db.profile.Settings.NumberOfWinners;
	local winners = {};
	if lotteryMethod == ZLM_LotteryMethod.Competition then
		winners = self:GetCompetitionWinners(lotteryWinnerCount)
	elseif lotteryMethod == ZLM_LotteryMethod.Raffle then
		winners = self:GetRaffleWinners(lotteryWinnerCount);
	end
	ZLM:AnnounceWinners(winners,lotteryMethod);
end
function ZLM:UpdateScoreboard()
	local donations = GetDonationsWithinTimeFrame();
    local pointsTable = {};
    for _,v in ipairs(ZLM.db.profile.Bounties) do
        if v.HotItem then
            pointsTable[v.ItemId] = v.Points * 2;
        else
            pointsTable[v.ItemId] = v.Points;
        end
    end
    ZLM_ScoreboardData = {};
    local tempPoints = {};
    for _,v in ipairs(donations) do
        local points = pointsTable[v.ItemId] * v.Quantity;
        if not not tempPoints[v.Name] then tempPoints[v.Name] = tempPoints[v.Name] + points; else tempPoints[v.Name] = points; end
    end
    for k,v in pairs(tempPoints) do
        tinsert(ZLM_ScoreboardData,{ Name = k, Points = v });
    end
    sort(ZLM_ScoreboardData,ZLM_SortScoreboard);
    local rangeMin = 1;
    for i,v in ipairs(ZLM_ScoreboardData) do
        v.Rank = i;
        v.Min = rangeMin;
        v.Max = rangeMin + v.Points - 1;
        if not not ZLM.scoreboard then
            ZLM.scoreboard.Table.DataFrame:AddRow(v);
        end
        rangeMin = v.Max + 1;
    end
end
function ZLM:GetRaffleWinners()
	local winners = {};
	if self.db.profile.ExclusiveWinners == nil then self.db.profile.ExclusiveWinners = true; end
	while #(winners) < ZLM.db.profile.NumberOfWinners do
		local roll = math.random(self.db.records.TotalPoints);
		local base = 0;
		for i = 1,#(self.db.records.Scoreboard) do
			local ticket = self.db.records.Scoreboard[i];
			if roll > base and roll <= (ticket.Points + base) then
				if (self.db.profile.ExlusiveWInners) or (not self.Contains(winners,"Name",ticket.Name)) or (self.Contains(winners,"Name",ticket.Name) and not self.db.profile.ExclusiveWinners) then
					tinsert(winners,{ Roll = roll, Name = ticket.Name });
					break;
				end
			end
		end
	end
	return winners;
end
function ZLM:GetCompetitionWinners()
	local winners = {};
	for i = 1,ZLM.db.profile.NumberOfWinners do
		tinsert(winners,self.db.global.Scoreboard[i]);
	end
	return winners;
end
function ZLM:AnnounceWinners(winners)
	local firstMessage ="The Lottery Winners for -"
            .. date("%m/%d/%y %H:%M:%S",time(ZLM.db.profile.ScoreboardStartDateTimeDatePicker))
            .. "- through -"..date("%m/%d/%y %H:%M:%S",time(ZLM.db.profile.ScoreboardEndDateTimeDatePicker)).."- are:";
		SendChatMessage(firstMessage,ZLM.db.profile.OutputChatType,nil,zlm.db.profile.OutputChatChannel);
	if ZLM.db.profile.LotteryMethod == ZLM_LotteryManager.LotteryMethod.Competition then
		local results = ZLM:GetTieResults(winners);
		for i,v in ipairs(results) do
			local message = i..": "..v.Name;
            SendChatMessage(message,ZLM.db.profile.OutputChatType,nil,ZLM.db.profile.OutputChatChannel);
        end
	elseif ZLM.db.profile.LotteryMethod == ZLM_LotteryManager.LotteryMethod.Raffle then
		for i,v in ipairs(winners) do
			local message = i..": "..v.Name .. " (Roll: " .. v.Roll .. ")";
            SendChatMessage(message,ZLM.db.profile.OutputChatType,nil,ZLM.db.profile.OutputChatChannel);
		end
	end
end
function ZLM:Contains(table,property,value)
	for z = 1,#(table) do
		if table[z][property] == value then return true; end
	end
	return false;
end
function ZLM:GetTieResults(winners)
	local pendingResults = {};
    local sortableResults = {};
	for _,v in ipairs(winners) do
        local record = pendingResults[v.Points];
        if not not record then
            pendingResults[v.Points] = v.Name;
        else
            pendingResults[v.Points] = record .. ", " .. v.Name
        end
    end
    for k,v in pairs(pendingResults) do
        tinsert(sortableResults,{ Names = v, Points = k})
    end
    sort(sortableResults,function(a,b)
        return a.Points > b.Points
    end);
    return sortableResults;
end
function ZLM:ShowScoreboard()
    if not not ZLM.scoreboard then

    else
        ZLM:Debug("Showing Scoreboard.", 1);
        local scoreboard = ZLM_Scoreboard:new("Zatenkein's Lottery Manager - Scoreboard"
            ,{ GetWinners = function()
                ZLM:UpdateScoreboard();
                ZLM:RunLottery();
            end,
            UpdateScoreboard = function()
                ZLM:UpdateScoreboard();
            end,
            DateChanged = function(controlKey,segmentKey,value)
                ZLM:Debug("Updating DateTime for " .. controlKey .. "DatePicker." .. segmentKey .. " to " .. value .. ".",1)
                ZLM.db.profile[controlKey .. "DatePicker"][segmentKey] = value;
                ZLM.db.profile[controlKey] = time(ZLM.db.profile[controlKey .. "DatePicker"]);
            end,
            AnnounceScoreboard = function() print("beep boop"); end,
            AnnounceQuantityChanged = function() print("doobadee"); end},
            { StartDate = ZLM.db.profile.ScoreboardStartDateTimeDatePicker, EndDate = ZLM.db.profile.ScoreboardEndDateTimeDatePicker, AnnounceQuantity = 5 });
        table.sort(ZLM_ScoreboardData,ZLM_SortScoreboard);
        for i,v in ipairs(ZLM_ScoreboardData) do
            local record = v;
            record.Rank = i;
            scoreboard.Table:AddRow(record);
        end
        ZLM.scoreboard = scoreboard;
    end

end
function ZLM:ShowBountyboard()
    if not not ZLM.bountyboard then
        ZLM.bountyboard:Terminate();
    else
        ZLM:Debug("Showing Bountyboard",1);
        local bountyBoard = ZLM_Bountyboard:new("Zatenkein's Lottery Manager - Bountyboard", {
                AddBounty = function()
                    ZLM.bountyboard.Table:AddRow({ ItemId = nil, ItemLink = "", Points = 0, HotItem = false})
                end
            }
        );
        ZLM.bountyboard = bountyBoard;
    end
end
function ZLM:GetDonationsWithinTimeframe()
    local time1 = time(self.db.profile.ScoreboardStartDateTimeDatePicker);
    local time2 = time(self.db.profile.ScoreboardEndDateTimeDatePicker);
    local output = {};
    for i = 1,#(self.db.records.Donations),1 do
        local logItem = self.db.global.Donations[i];
        if logItem.Timestamp >= time1 and logItem.Timestamp <= time2 then
            tinstert(output,logItem);
        end
    end
    return output;
end
function ZLM:RecordDonation(nameRealmCombo,itemId,quantity) -- Add a new record to the donation log.
    local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,
    itemEquipLoc, iconFileDataID, itemSellPrice, itemClassID, itemSubClassID, bindType, expacID, itemSetID,
    isCraftingReagent = GetItemInfo(itemId);
    tinsert(ZLM.db.global.Donations,{ Name = nameRealmCombo, ItemId = itemId, Quantity = quantity, ItemName = itemName, ItemLink = itemLink});
end
function ZLM:PurgeDonationLog(dateObj) -- Purge all DonationLog records before a specific time.
    local purgeTime = time(dateObj);
    for i = #(self.db.global.Donations),1,-1 do
        local entry = self.db.global.Donations[i];
        if entry.Timestamp < purgeTime then
            tremove(self.db.global.Donations,i);
        end
    end
end

function ZLM:LogLetter(letterIndex)
    local itemList = ZLM:GetListOfLetterItems(letterIndex);
    while #itemList > 0 do
        for k,v in ipairs(itemList) do
            ZLM:TakeItemfromLetter(letterIndex,k);
        end
        itemList = ZLM:GetListOfLetterItems(letterIndex);
    end
end
function ZLM:GetListOfLetterItems(letterIndex)

end
function ZLM:TakeItemFromLetter(letterIndex,itemIndex)

end
function ZLM:LogItemPullAtempt(letterIndex,itemIndex)
    --Code to move item from letter and log it as a "taken item".  Id is yyyy:mm:dd:hh:mm:ss:letterIndex:itemIndex.
    local dateObj = date("*t");
    local id = dateObj.year .. ":" .. dateObj.month .. ":" .. dateObj.day .. ":" .. dateObj.hour  .. ":" .. dateObj.minute  .. ":" .. dateObj.sec  .. ":" .. letterIndex  .. ":" .. itemIndex;
    
end


function ZLM:LogItemReceipt(containerId)
    local snapshot = ZLM:GetContainerSnapshot(containerId)
    local itemGains = ZLM:CompareSnapshotToCurrent(containerId,snapshot);
    local timeStamp = time();
    for k,v in pairs(itemGains) do
        ZLM:TryMatchReceipts(k,v,timeStamp);
    end
end
function ZLM:GetContainerSnapshot(containerId)

end
function ZLM:CompareSnapshotToCurrent(containerId,containerSnapshot)

end

function ZLM:TryMatchReceipts(itemId,quantity,timestamp)

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
