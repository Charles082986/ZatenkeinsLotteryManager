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
        Scoreboard = {}

    }
};
ZLM_FrameStateOptions = {
    Hidden = 0;
    Shown = 1;
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
                recordDonations = {
                    name = "Record Donations",
                    desc = "Record Mail Items as Donations",
                    type = "toggle",
                    set = "SetRecordDonations",
                    get = "GetRecordDonations",
                    order = 1,
                    descStyle="inline"
                },
                debug = {
                    name = "Debug Print Level",
                    desc = "Displays addon output messages.  Lower values show only urgent messages.  Higher values show all messages.",
                    type = "range",
                    min = 0,
                    max = 3,
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
        },
        ledger = {
            name = "Donation Ledger",
            type = "execute",
            func = function()
                ZLM:ShowLedger();
                ZLM:Debug("Showing Ledger");
            end
        }
    }
};
function ZLM:Debug(message,severity)
    --print(tostring(ZLM.db.profile.PrintLevel).." - " ..tostring(severity) .. " - " .. message);
    severity = severity or 1;
    if (ZLM.db.profile.Settings.PrintLevel or 3) < severity then
        self:Print(message);
    end
end

function ZLM:OnInitialize()
    self.CharacterName = UnitName("player");
    self.RealmName = GetRealmName();
    self.CharacterIdentity = self.CharacterName .. "-" .. self.RealmName;
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
    self.db.profile.Settings = self.db.profile.Settings or {}; -- The Settings Profile
    self.db.profile.Lottery = self.db.profile.Lottery or {}; -- The Lottery Profile
    self.db.profile.Lottery.Bounties = self.db.profile.Lottery.Bounties or {}; -- Contains a list of all currently accepted bounty items.
    self.db.global.Characters = self.db.global.Characters or {}; -- Contains a list of all characters on the account and whether or not each character is a designated collector.
    self.db.global.Reporting = self.db.global.Reporting or {}; -- Contains a roll-up of calculations of donations.
    self.db.global.Reporting.Scoreboard = self.db.global.Reporting.Scoreboard or {}; -- Contains the currently active Scoreboard.
    self.db.global.Donations = self.db.global.Dontaions or {}; -- Contains a list of all donations received.
    self.db.global.Characters[self.CharacterIdentity] = self.db.global.Characters[self.CharacterIdentity] or {};
    self.FrameState = { Scoreboard = ZLM_FrameStateOptions.Hidden, Bountyboard = ZLM_FrameStateOptions.Hidden };
    ZLM:UpdateScoreboard();
    ZLM:Debug("ZLM instantiated.",1);
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
function ZLM:SetRecordDonations(_,value)
    self.db.global.Characters[self.CharacterIdentity].RecordDonations = value;
end
function ZLM:GetRecordDonations(_)
    return self.db.global.Characters[self.CharacterIdentity].RecordDonations or false;
end

ZLM.RunLottery = function(self)
	ZLM.Scoreboard.Update(ZLM.db.global.Donations,ZLM.db.profile.Bounties);
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
function ZLM:GetDonationsWithinTimeframe()
    local time1 = time(self.db.profile.ScoreboardStartDateTimeDatePicker);
    local time2 = time(self.db.profile.ScoreboardEndDateTimeDatePicker);
    local output = {};
    for i = 1,#(self.db.global.Donations),1 do
        local logItem = self.db.global.Donations[i];
        if time(logItem.Timestamp) >= time1 and time(logItem.Timestamp) <= time2 then
            tinsert(output,logItem);
        end
    end
    return output;
end

function ZLM:GetRaffleWinners()
	local winners = {};
	if self.db.profile.ExclusiveWinners == nil then self.db.profile.ExclusiveWinners = true; end
	while #(winners) < ZLM.db.profile.NumberOfWinners do
		local roll = math.random(self.db.Global.TotalPoints);
		local base = 0;
		for i = 1,#(self.db.Global.Scoreboard) do
			local ticket = self.db.Global.Scoreboard[i];
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
        if ZLM.FrameState.Scoreboard == ZLM_FrameStateOptions.Hidden then
            ZLM.scoreboard:Show();
            ZLM.FrameState.Scoreboard = ZLM_FrameStateOptions.Shown;
            ZLM:UpdateScoreboard();
        else
            ZLM.scoreboard:Hide();
            ZLM.FrameState.Scoreboard = ZLM_FrameStateOptions.Hidden;
        end
    else
        ZLM:Debug("Showing Scoreboard.", 1);
        local scoreboard = ZLM_Scoreboard:new();
        ZLM.FrameState.Scoreboard = ZLM_FrameStateOptions.Shown;
        ZLM.scoreboard = scoreboard;
    end

end

function ZLM:ShowBountyboard()
    if not not ZLM.bountyboard then
        if ZLM.FrameState.Bountyboard == ZLM_FrameStateOptions.Hidden then
            ZLM.bountyboard:Show();
            ZLM.FrameState.Bountyboard = ZLM_FrameStateOptions.Shown;
        else
            ZLM.bountyboard:Hide();
            ZLM.FrameState.Bountyboard = ZLM_FrameStateOptions.Hidden;
        end
    else
        ZLM:Debug("Showing Bountyboard",1);
        local bountyBoard = ZLM_Bountyboard:new();
        ZLM.FrameState.Bountyboard = ZLM_FrameStateOptions.Shown;
        ZLM.bountyboard = bountyBoard;
    end
end

function ZLM:ShowLedger()
    if not not ZLM.ledger then
        if ZLM.FrameState.Ledger == ZLM_FrameStateOptions.Hidden then
            ZLM.ledger:Show();
            ZLM.FrameState.Ledger = ZLM_FrameStateOptions.Shown;
        else
            ZLM.ledger:Hide();
            ZLM.FrameState.Ledger = ZLM_FrameStateOptions.Hidden;
        end
    else
        local ledger = ZLM_Ledger:new();
        ZLM.FrameState.Ledger = ZLM_FrameStateOptions.Shown;
        ZLM.ledger = ledger;
    end
end

function ZLM:LogDonation(nameRealmCombo,itemId,quantity) -- Add a new record to the donation log.
    local donationIndex = 0;
    for _,v in ipairs(ZLM.db.global.Donations) do
        if tonumber(v.Index) > donationIndex then donationIndex = tonumber(v.Index) + 1; end
    end
    local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,
    itemEquipLoc, iconFileDataID, itemSellPrice, itemClassID, itemSubClassID, bindType, expacID, itemSetID,
    isCraftingReagent = GetItemInfo(itemId);
    local newItem = {Index = donationIndex, Name = nameRealmCombo, ItemId = itemId, Quantity = quantity, ItemName = itemName, timestamp = date("*t")};
    tinsert(ZLM.db.global.Donations,newItem);
    if ZLM.ledger then ZLM.ledger:AddRow(newItem); end
end
function ZLM:PurgeDonationLog(dateObj) -- Purge all DonationLog records before a specific time.
    local purgeTime = time(dateObj);
    for i = #(self.db.global.Donations),1,-1 do
        local entry = self.db.global.Donations[i];
        if time(entry.Timestamp) < purgeTime then
            tremove(self.db.global.Donations,i);
        end
    end
end

ZLM_Donation = {
    Name = "Defaultname-Default Realm",
    ItemId = 12345,
    Quantity = 0,
    Timestamp = date("*t",1000216740)
}
function ZLM_Donation:new(nameRealmCombo,itemId,quantity)
    local donation = {};
    donation.Name = nameRealmCombo;
    donation.ItemId = itemId;
    donation.Quantity = quantity;
    donation.Timestamp = date("*t",GetServerTime());
    return donation;
end
