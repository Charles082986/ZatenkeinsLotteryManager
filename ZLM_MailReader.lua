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
    self._args = ...;
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
                self:_callback(self._args);
            end
        end
    end
end

function ZLM:FullName(name)
    -- Sinderion -> Sinderion-ShadowCouncil (add server name to same-server sender);   Xaionics-BlackwaterRaiders -> Xaionics-BlackwaterRaiders (no change if it's already full)
    if type(name) ~= "string" then
        return nil;
    end
    if string.match(name," ") then
        name = nil;  -- not a character, skip it.
    elseif string.match(name,"-") then -- Name already full, do nothing :)
    else
        name = name .. "-" .. GetRealmName(); -- Name needs some TLC. Might accidentally get NPC's with one name. Oh well lol.
    end
    --ZLM:Debug(name, 2);
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
        if sender then
            sender = ZLM:FullName(sender); -- Returns name-server, of whatever you feed it. Nil if there's a space.
        end
        if hasItem and hasItem > 0 and not not sender then
            return { index = i, sender = sender };
        end
    end
    return nil;
end

function ZLM:EmptyLetterContents(mailIndex,snapshot)
    ZLM.MailSemaphore:renew(12,ZLM_SemaphoreCallback_EmptyLetterContents,mailIndex,snapshot)
    for i = 1,12 do
        ZLM:Wait(i / 10,ZLM_WaitFunction_TakeInboxItem,mailIndex,i);
    end
    return true;
end

ZLM_WaitFunction_TakeInboxItem = function(mailIndex,itemIndex)
    ZLM:Debug("Taking inbox item " .. itemIndex.. " from letter " .. mailIndex, 1);
    TakeInboxItem(mailIndex,itemIndex);
    ZLM.MailSemaphore:Itterate();
end

ZLM_SemaphoreCallback_EmptyLetterContents = function(self,innerMailIndex,snapshot)
    ZLM:Debug("Semaphore Callback Triggered! innerMailIndex: "..tostring(innerMailIndex), 1);
    CheckInbox();
    ZLM:Wait(0.1,ZLM_WaitFunction_EmptyLetterContents,innerMailIndex,snapshot)
end

ZLM_WaitFunction_EmptyLetterContents = function(innerMailIndex2,snapshot)
    ZLM:Debug("Semaphore Callback Wait Return Triggered! innerMailIndex2: "..tostring(innerMailIndex2), 1);
    local packageIcon, stationeryIcon, sender, subject, money, CODAmount, daysLeft, hasItem, wasRead, wasReturned,
    textCreated, canReply, isGM = GetInboxHeaderInfo(innerMailIndex2);
    if hasItem and hasItem > 0 and ZLM.MailState == ZLM.MailStateOptions.Open then
        ZLM:Debug("Attempting to restart semaphore...",1)
        ZLM:EmptyLetterContents(innerMailIndex2,snapshot);
    else
        ZLM:EndGetMailItems(sender,snapshot);
    end
end

function ZLM:BeginGetMailItems()
    if ZLM.MailWorker == ZLM.MailWorkerStates.Available then
        ZLM.MailWorker = ZLM.MailWorkerStates.Working;
        local mailInfo = self:GetNextMailData();
        if not not mailInfo then
            local initialSnapshot = self:GetInventorySnapshot();
            ZLM:EmptyLetterContents(mailInfo.index,initialSnapshot)
        end
    end
end

function ZLM:EndGetMailItems(sender,initialSnapshot)
    local mailContents = self:CompareSnapshots(self:GetInventorySnapshot(),initialSnapshot);
    for k,v in pairs(mailContents) do
        sender = ZLM:FullName(sender)
        if v > 0 then ZLM:LogDonation(sender,k,v,time()); end
    end
    ZLM.MailWorker = ZLM.MailWorkerStates.Available;
    ZLM:BeginGetMailItems();
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