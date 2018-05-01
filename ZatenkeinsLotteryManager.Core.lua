ZLM_LotteryManager = {
	Scoreboard = {},
	TotalPoints = 0,
	RollLimit = 0,
	LotteryMethod = {
		Competition = "Competition",
		Roll = "Roll"
	}
};

function ZLM_LotteryManager:RunLottery(startTime,endTime)
	ZLM_LotteryManager:UpdateScoreboard(startTime,endTime);	
	local lotteryMethod = ZLM_Options.LotteryMethod;
	local lotteryWinnerCount = ZLM_Options.NumberOfWinners;
	local winners = {};
	if lotteryMethod == ZLM_LotteryManager.LotteryMethod.Competition then
		winners = self:GetCompetitionWinners(lotteryWinnerCount)
	elseif lotteryMethod == ZLM_LotteryManager.LotteryMethod.Roll then
		winners = self:GetRollWinners(lotteryWinnersCount);
	end
	ZLM_LotteryManager:AnnounceWinners(startTime,endTime,winners,lotteryMethod);
end

function ZLM_LotteryManager:UpdateScoreboard(startTime,endTime)
	local donations = ZLM_TallyWhacker:GetDonationsWithinTimeframe(startTime,endTime);
	local scoreboard = {};
	for i = 1,#(donations),1 do
		local donation = donations[i];
		if scoreboard[donation.Name] ~= nil then
			scoreboard[donation.Name].Points = scoreboard[donation.Name].Points + donation.TotalPoints;
		else
			scoreboard[donation.Name] = { Name = dontaion.Name, Points = donation.TotalPoints };
		end
	end
	ZLM_LotteryManager.Scoreboard = {};
	ZLM_LotteryManager.ScoreboardTotal = 0;
	for _,v in pairs(scoreboard) do
		ZLM_LotteryManager.TotalPoints = ZLM_LotteryManager.TotalPoints + v.Points;
		tinsert(ZLM_LotteryManager.Scoreboard,v);
	end
	sort(ZLM_LotteryManager.Scoreboard,ZLM_SortScoreboard);
end
function ZLM_LotteryManager:GetRollWinners(winnersCount,exclusiveWinners)
	local winners = {};
	if exclusiveWinners == nil then exclusiveWinners = true; end
	while #(winners) < winnersCount do
		local roll = math.random(ZLM_LotteryManager.TotalPoints);
		local base = 0;
		for i = 1,#(ZLM_LotteryManager.Scoreboard) do
			local ticket = ZLM_LotteryManager.Scoreboard[i];
			if roll > base and roll <= (ticket.Points + base) then
				if exclusiveWinners and ZLM_Contains(winners,"Name",ticket.Name) then
					tinsert(winners,{ Roll = roll, Name = ticket.Name });
					break;
				end
			end
		end
	end
	return winners;
end
function ZLM_LotteryManager:GetCompetitionWinners(winnersCount)
	local winners = {};
	for i = 1,winnersCount do
		tinsert(winners,ZLM_Scoreboard[i]);
	end
	return winners;
end
function ZLM_LotteryManager:AnnounceWinners(startTime,endTime,winners,lotteryMethod)
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
	elseif lotteryMethod == ZLM_LotteryManager.LotteryMethod.Roll then
		for i,v in ipairs(winners) do
			local message = i..": "..v.Name .. " (Roll: " .. v.Roll .. ")";
			if ZLM_Debug then
				print(message);
			else
				SendChatMessage(message,ZLM_Options.OutputChatType,nil,ZLM_Options.OutputChatChannel);
			end
		end
	end
end
function ZLM_SortScoreboard(a,b)
	if a == b then
		return a.Name < b.Name --Sort names alphabetically if scores are equal
	else
		return a.Points > b.Points; --Sort scores from largest to smallest.
	end
end


function ZLM_ConverteStringToTime(str)
	local day,month,year,hour,min,sec=str:match(ZLM_DateStringPattern);
	local MON={Jan=1,Feb=2,Mar=3,Apr=4,May=5,Jun=6,Jul=7,Aug=8,Sep=9,Oct=10,Nov=11,Dec=12};
	local month=MON[month];
	local offset=time()-time(date("!*t"));
	return time({day=day,month=month,year=year,hour=hour,min=min,sec=sec}) + offset;
end


function ZLM_Contains(table,property,value)
	for z = 1,#(table) do
		if table[z][property] == value then return true; end
	end
	return false;
end

function ZLM_GetTieResults(winners)
	local pendingResults = {};
	for _,v in ipairs(winners) do
        local record = pendingResults[v.Points];
        if not not record then
            pendingResults[v.Points] = v.Name;
        else
            pendingResults[v.Points] = record .. ", " .. v.Name
        end
    end
    return pendingResults;
end

