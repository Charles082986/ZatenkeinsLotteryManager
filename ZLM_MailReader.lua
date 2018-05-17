ZLM.MailSemaphore = {}
function ZLM.MailSemaphore:renew(count,callback,...)
    self.Count = 0;
    self.Itterations = 0;
    self._callback = callback;
    self._args = ...;
    function self:AddCount(increase)
        if not not increase then increase = 1; end
        self.Count = self.Count + increase;
    end
    function self:Itterate(increase)
        if not not increase then increase = 1; end
        self.Itterations = self.Itterations + increase;
        if self.Itterations >= self.Count then
            self:_callback(self._args);
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
            sender = ZLM.Mail:FullName(sender); -- Returns name-server, of whatever you feed it. Nil if there's a space.
        end
        if hasItem and hasItem > 0 and not not sender then
            return { index = i, sender = sender };
        end
    end
    return nil;
end

function ZLM:EmptyLetterContents(mailInfo,snapshot)
    local mailIndex = mailInfo.index;
    ZLM.MailSemaphore:renew(12,function(mailIndex,snapshot)
        CheckInbox();
        ZLM:Wait(0.1,function(mailIndex,snapshot)
            local packageIcon, stationeryIcon, sender, subject, money, CODAmount, daysLeft, hasItem, wasRead, wasReturned,
            textCreated, canReply, isGM = GetInboxHeaderInfo(mailIndex);
            if hasItem and hasItem > 0 then
                ZLM:EmptyLetterContents(mailIndex);
            else
                ZLM:EndGetMailItems(mailIndex,sender,snapshot);
            end
        end,mailIndex,snapshot)
    end,mailIndex,snapshot);
    for i = 1,12 do
        ZLM:Wait(i / 10,function(a,b) TakeInboxItem(a,b); ZLM.MailSemaphore:Itterate(); end,mailIndex,i);
    end
    return true;
end

function ZLM:BeginGetMailItems()
    local mailInfo = self:GetNextMailData();
    if not not mailInfo then
        local initialSnapshot = self:GetInventorySnapshot();
        ZLM:EmptyLetterContents(mailInfo,initialSnapshot)
        mailInfo = self:GetNextMailIndex();
    end
end

function ZLM:EndGetMailItems(sender)
    local mailContents = self:CompareSnapshots(self:GetInventorySnapshot(),initialSnapshot);
    for k,v in pairs(mailContents) do
        sender = ZLM:FullName(sender)
        if v > 0 then ZLM:LogDonation(sender,k,v,time()); end
    end
    ZLM:BeginGetMailItems();
end