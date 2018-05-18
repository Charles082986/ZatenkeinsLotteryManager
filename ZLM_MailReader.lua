ZLM.MailSemaphore = {}
ZLM.MailStateOptions = {
    Closed = 0,
    Open = 1
};
ZLM.MailState = ZLM.MailStateOptions.Closed;
ZLM.MailWorkerStates = {
    Working = 0;
    Available = 1;
}
ZLM.MailWorker = ZLM.MailWorkerStates.Available;
function ZLM.MailSemaphore:renew(count,callback,...)
    self.Count = count;
    self.Itterations = 0;
    self._callback = callback;
    self._args = {...};
    if not self.AddCount then
        function self:AddCount(increase)
            increase = increase or 1;
            self.Count = self.Count + increase;
        end
    end
    if not self.Itterate then
        function self:Itterate(increase)
            increase = increase or 1;
            self.Itterations = self.Itterations + increase;
            if self.Itterations >= self.Count then
                self:_callback(unpack(self._args));
            end
        end
    end
end

function ZLM:FullName(name)
    -- Sinderion -> Sinderion-ShadowCouncil (add server name to same-server sender);   Xaionics-BlackwaterRaiders -> Xaionics-BlackwaterRaiders (no change if it's already full)
    ZLM:Debug("FullName - 1 - Name: ".. tostring(name), 1);
    if type(name) ~= "string" then
        return nil;
    end
    if string.match(name," ") then
        name = nil;  -- not a character, skip it.
    elseif string.match(name,"-") then -- Name already full, do nothing :)
    else
        name = name .. "-" .. GetRealmName(); -- Name needs some TLC. Might accidentally get NPC's with one name. Oh well lol.
    end
    ZLM:Debug("FullName - 2 - Name: ".. tostring(name), 1);
    return name;
end

function ZLM:GetInventorySnapshot()
    local Snapshot = {};
    for i= 1, 5 do
        local numberOfSlots = GetContainerNumSlots(i);
        for j = 1, numberOfSlots do
            local itemId = GetContainerItemID(i, j);
            if not not itemId then
                Snapshot[itemId] = (Snapshot[itemId] or 0) + select(2, GetContainerItemInfo(i,j)); -- select the 2nd return value (itemcount)
            end
        end
    end
    ZLM:Debug("Getting inventory snapshot. " .. tostring(Snapshot), 1);
    return Snapshot;
end

function ZLM:CompareSnapshots(currentSnapshot,initialSnapshot)
    local results = {};
    for k,v in pairs(currentSnapshot) do
        results[k] = v - (initialSnapshot[k] or 0);
    end
    for k,v in pairs(initialSnapshot) do
        if not not currentSnapshot[k] then results[k] = 0 - v; end
    end
    return results;
end

function ZLM:GetNextMailData()
    local inbox_items, total_items = GetInboxNumItems();
    for i = 1, inbox_items do
        local packageIcon, stationeryIcon, sender, subject, money, CODAmount, daysLeft, hasItem, wasRead, wasReturned,
        textCreated, canReply, isGM = GetInboxHeaderInfo(i);
        ZLM:Debug("GetNextMailData - Sender: " .. sender);
        if sender then
            sender = ZLM:FullName(sender); -- Returns name-server, of whatever you feed it. Nil if there's a space.
        end
        if hasItem and hasItem > 0 and not not sender then
            return { index = i, sender = sender };
        end
    end
    return nil;
end

function ZLM:EmptyLetterContents(mailIndex,sender,snapshot)
    ZLM:Debug("Beginning EmptyLetterContents - mailIndex: " .. mailIndex .. " snapshot: " .. tostring(snapshot), 1);
    ZLM.MailSemaphore:renew(12,ZLM_SemaphoreCallback_EmptyLetterContents,mailIndex,sender,snapshot);
    for i = 1,12 do
        ZLM:Wait(i / 10,ZLM_WaitFunction_TakeInboxItem,mailIndex,i);
    end
    return true;
end

ZLM_WaitFunction_TakeInboxItem = function(mailIndex,itemIndex)
    --ZLM:Debug("Taking inbox item " .. itemIndex.. " from letter " .. mailIndex, 1);
    TakeInboxItem(mailIndex,itemIndex);
    ZLM.MailSemaphore:Itterate();
end

ZLM_SemaphoreCallback_EmptyLetterContents = function(self,innerMailIndex,sender,snapshot)
    ZLM:Debug("Semaphore Callback Triggered! innerMailIndex: "..tostring(innerMailIndex) .. "  Snapshot: " .. tostring(snapshot), 1);
    CheckInbox();
    ZLM:Wait(0.1,ZLM_WaitFunction_EmptyLetterContents,innerMailIndex,sender,snapshot)
end

ZLM_WaitFunction_EmptyLetterContents = function(innerMailIndex2,sender,snapshot)
    local _;
    ZLM:Debug("Semaphore Callback Wait Return Triggered! innerMailIndex2: "..tostring(innerMailIndex2) .. " Snapshot: " .. tostring(snapshot), 1);
    local _, _, newSender , _, _, _, _, itemCount, _, _, _, _, _ = GetInboxHeaderInfo(innerMailIndex2);
    if not not itemCount and itemCount > 0 and not not newSender and newSender == sender then
        --ZLM:Debug("Attempting to restart semaphore...",1)
        ZLM:EmptyLetterContents(innerMailIndex2,sender,snapshot);
    else
        ZLM:EndGetMailItems(sender,snapshot);
    end
end

function ZLM:BeginGetMailItems()
    if ZLM.MailWorker == ZLM.MailWorkerStates.Available then
        ZLM.MailWorker = ZLM.MailWorkerStates.Working;
        local mailInfo = self:GetNextMailData();
        if not not mailInfo then
            ZLM:EmptyLetterContents(mailInfo.index,mailInfo.sender,self:GetInventorySnapshot())
        end
    end
end

function ZLM:EndGetMailItems(sender,initialSnapshot)
    ZLM:Debug("Ending Current Mail and calculating differences...",1);
    ZLM:Debug("Sender: " .. sender .. ", InitialSnapshot: " .. tostring(initialSnapshot));
    local mailContents = self:CompareSnapshots(self:GetInventorySnapshot(),initialSnapshot);
    for k,v in pairs(mailContents) do

        if v > 0 then ZLM:LogDonation(sender,k,v,time()); end
    end
    ZLM.MailWorker = ZLM.MailWorkerStates.Available;
    if ZLM.MailState == ZLM.MailStateOptions.Open then ZLM:BeginGetMailItems(); end
end

ZLM:RegisterEvent("MAIL_SHOW",function()
    ZLM.MailState = ZLM.MailStateOptions.Open;
    ZLM:Debug("Getting Mail Items...",3);
    ZLM:Wait(1,function() ZLM:BeginGetMailItems() end);
end)

ZLM:RegisterEvent("MAIL_CLOSED",function()
    ZLM.MailState = ZLM.MailStateOptions.Closed;
    ZLM:Debug("No longer getting mail items.",3);
end)

