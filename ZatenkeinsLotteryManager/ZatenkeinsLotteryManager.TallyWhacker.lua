ZLM_TallyWhacker = ZLM_TallyWhacker or {
	DonationLog = {},
	PointsTable = {},
	ParticipantPoints = {}
};

function ZLM_TallyWhacker:GetDonationsWithinTimeframe(startTimeString,endTimeString)
	local time1 = ConvertStringToTime(startTimeString);
	local time2 = ConvretStringToTime(endTimeString);
	local output = {};
	for i = 1,#(self:DonationLog),1 do
		local logItem = self:DonationLog[i];
		if logItem.Timestamp >= time1 and logItem.Timestamp <= time2 then
			tinstert(output,logItem);
		end
	end
	return output;
end

function ZLM_TallyWhacker:RecordDonation(nameRealmCombo,itemId,quantity) -- Add a new record to the donation log.
	local pointsRecord = self.PointsTable[itemId];
	local points = pointsRecord.Value * pointsRecord.Active * (pointsRecord.HotItem + pointsRecord.Multiplier);
	tinsert(self.DonationLog,ZLM_Donation:new(nameRealmCombo,itemId,quantity,points));
end

function ZLM_TallyWhacker:Purge(timeString) -- Purge all DonationLog records before a specific time.
	local purgeTime = 0;
	if not not time then
		purgeTime = ZLM_ConverteStringToTime(timeString);
	else
		purgeTime = GetServerTime();
	end
	for i = #(self.DonationLog),1,-1 do
		local entry = self.DonationLog[i];
		if entry.Timestamp < time then
			tremove(self.DonationLog,i);
		end
	end
end

ZLM_Donation = {
	Name = "Defaultname-Default Realm",
	ItemId = 12345,
	Quantity = 0,
	Timestamp = 0,
	PointsPerItem = 0,
	TotalPoints = 0
}

function ZLM_Donation:new(nameRealmCombo,itemId,quantity,pointsPerItem)
	local donation = {};
	donation.Name = nameRealmCombo;
	donation.ItemId = itemId;
	donation.Quantity = quantity;
	donation.PointsPerItem = pointsPerItem;
	donation.Timestamp = GetServerTime();
	donation.TotalPoints = donation.Quantity * dontaion.PointsPerItem;
	return donation;
end

ZLM_PointsEntry = {
	ItemId = 0,
	ItemName = "<No Name>",
	Active = 0,
	HotItem = 2,
	Multiplier = 1,
	PointValue = 0
}

function ZLM_PointsEntry:new(itemId,itemName,active,hotItem,multiplier,pointValue)
	local entry = {};
	entry.ItemId = itemId;
	entry.ItemName = itemName;
	entry.Active = active;
	entry.HotItem = hotItem;
	entry.Multiplier = multiplier;
	entry.PointValue = pointValue;
	return entry;
end
