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
            return i;
        end
    end
    return nil;
end

function ZLM:EmptyLetterContents(mailIndex)
    local packageIcon, stationeryIcon, sender, subject, money, CODAmount, daysLeft, hasItem, wasRead, wasReturned,
    textCreated, canReply, isGM = GetInboxHeaderInfo(mailIndex);
    while hasItem and hasItem > 0 do
        for i = 1,12 do
            TakeInboxItem(mailIndex,i);
        end
        packageIcon, stationeryIcon, sender, subject, money, CODAmount, daysLeft, hasItem, wasRead, wasReturned,
        textCreated, canReply, isGM = GetInboxHeaderInfo(mailIndex);
    end
    return true;
end

function ZLM:GetMailItems

