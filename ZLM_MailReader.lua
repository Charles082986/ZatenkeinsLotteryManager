ZLM_Mailman = {
    new = function(self)
        return {
            MailWorker = "Available",
            MailState = "Closed",
            GetInventorySnapshot = self.__GetInventorySnapshot;
            CompareSnapshots = self.__CompareSnapshots;
            GetMailData = self.__GetMailData;
            BeginGetMailItems = self.__BeginGetMailItems;
            EndGetMailItems = self.__EndGetMailItems;
            EmptyLetterContents = self.__EmptyLetterContents;
            SemaphoreCallback = self.__SemaphoreCallback;
            Await = self.__Await;
        };

    end,
    __GetInventorySnapshot = function(self)
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
        local keyCount = 0;
        for _,_ in pairs(Snapshot) do
            keyCount = keyCount + 1;
        end
        return Snapshot;
    end,
    __CompareSnapshots = function(self,currentSnapshot,initialSnapshot)
        ZLM:Debug("Comparing Snapshots: " .. tostring(currentSnapshot) .. " vs " .. tostring(initialSnapshot));
        local results = {};
        for k,v in pairs(currentSnapshot) do
            results[k] = v - (initialSnapshot[k] or 0);
        end
        for k,v in pairs(initialSnapshot) do
            if not currentSnapshot[k] and v > 0 then results[k] = 0 - v; end
        end
        return results;
    end,
    __GetMailData = function(self)
        local inbox_items, total_items = GetInboxNumItems();
        for i = 1, inbox_items do
            local packageIcon, stationeryIcon, sender, subject, money, CODAmount, daysLeft, hasItem, wasRead, wasReturned,
            textCreated, canReply, isGM = GetInboxHeaderInfo(i);
            ZLM:Debug("GetNextMailData - Sender: " .. sender);
            if ZLib:IsStringValid(sender) then
                sender = ZLib:GetFullName(sender); -- Returns name-server, of whatever you feed it. Nil if there's a space.
            end
            if hasItem and hasItem > 0 and not not sender then
                return { index = i, sender = sender };
            end
        end
        return nil;
    end,
    __BeginGetMailItems = function(self)
        if self.MailWorker == "Available" and ZLM.db.global.Characters[ZLM.CharacterIdentity].RecordDonations then
            self.MailWorker = "Working";
            local mailInfo = self:GetNextMailData();
            if not not mailInfo then
                self:EmptyLetterContents(mailInfo.index,mailInfo.sender,self:GetInventorySnapshot())
            end
        end
    end,
    __EndGetMailItems = function(self,sender,initialSnapshot)
        ZLM:Debug("Ending Current Mail and calculating differences...",1);
        ZLM:Debug("Sender: " .. sender .. ", InitialSnapshot: " .. tostring(initialSnapshot));
        local mailContents = self:CompareSnapshots(self:GetInventorySnapshot(),initialSnapshot);
        for k,v in pairs(mailContents) do
            if v > 0 then
                ZLM:LogDonation(sender,k,v,time());
            elseif v < 0 then
                ZLM:Debug("Somehow lost items... ItemId: " ..k .. " Quantity: "..v,3);
            end
        end
        self.MailWorker = "Available";
        if ZLM.MailState == "Open" then self:BeginGetMailItems(); end
    end,
    __EmptyLetterContents = function(self,mailIndex,sender,snapshot)
        ZLM:Debug("Beginning EmptyLetterContents - mailIndex: " .. mailIndex .. " snapshot: " .. tostring(snapshot), 1);
        self.MailSemaphore = ZLib.Semaphore:new(12,self.Semaphore.EmptyLetterContents,self,mailIndex,sender,snapshot);
        for i = 1,12 do
            ZLib.Waiter:Wait(i / 10,self.Await.TakeInboxItem,self,mailIndex,i);
        end
        return true;
    end,
    __SemaphoreCallback = {
        EmptyLetterContents = function(self,me,innerMailIndex,sender,snapshot)
            ZLM:Debug("Semaphore Callback Triggered! innerMailIndex: "..tostring(innerMailIndex) .. "  Snapshot: " .. tostring(snapshot), 1);
            CheckInbox();
            ZLib.Waiter:Wait(0.1,me.Await.EmptyLetterContents,me,innerMailIndex,sender,snapshot)
        end
    },
    __Await = {
        TakeInboxItem = function(self,mailIndex,itemIndex)
            --ZLM:Debug("Taking inbox item " .. itemIndex.. " from letter " .. mailIndex, 1);
            TakeInboxItem(mailIndex,itemIndex);
            me.Semaphore:Itterate();
        end,
        EmptyLetterContents = function(self,innerMailIndex2,sender,snapshot)
            ZLM:Debug("Semaphore Callback Wait Return Triggered! innerMailIndex2: "..tostring(innerMailIndex2) .. " Snapshot: " .. tostring(snapshot), 1);
            local _, _, newSender , _, _, _, _, itemCount, _, _, _, _, _ = GetInboxHeaderInfo(innerMailIndex2);
            if ZLib:IsNumberValid(itemCount) and ZLib:IsStringValid(newSender) and newSender == sender then
                self:EmptyLetterContents(innerMailIndex2,sender,snapshot);
            else
                self:EndGetMailItems(sender,snapshot);
            end
        end
    }

}

ZLM.Mailman = ZLM_Mailman:new();
ZLM:RegisterEvent("MAIL_SHOW",function()
    ZLM.MailState = "Open";
    ZLM:Debug("Getting Mail Items...",3);
    ZLM:Wait(1,ZLM.Mailman:BeginGetMailItems);
end)
ZLM:RegisterEvent("MAIL_CLOSED",function()
    ZLM.MailState = "Closed";
    ZLM:Debug("No longer getting mail items.",3);
end)

