ZLM_DonationLedger = { StructureArray = {
    Index = { Type = ZLM_Table.Types.Label, Width = 0.05 },
    Name = { Type = ZLM_Table.Types.Input, Width = 0.15 },
    ItemId = { Type = ZLM_Table.Types.Input, Width = 0.1 },
    ItemName = { Type = ZLM_Table.Types.InteractiveLabel, Width = 0.15 },
    Quantity = { Type = ZLM_Table.Types.Input, Width = 0.1 },
    Timestamp = { Type = ZLM_Table.Types.DatePicker, Width = 0.4 },
    Delete = { Type = ZLM_Table.Types.Button, Width = 0.1 }
}};
function ZLM_DonationLedger:new(title,AceGUI)
    if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
    local topContainer = AceGUI:Create("Frame");
    topContainer:SetLayout("Flow");
    topContainer:SetTitle(title);
    topContainer:SetCallback("OnClose",function(widget)
        ZLM.FrameState.DonationLedger = ZLM_FrameStateOptions.Hidden;
    end);
    function topContainer:Terminate()
        ZLM.FrameState.DonationLedger = ZLM_FrameStateOptions.Hidden;
    end
    topContainer.Table = ZLM_Table:new(self.StructureArray,{"Index"
        ,"Name"
        ,"ItemId"
        ,"ItemName"
        ,"Quantity"
        ,"Timestamp"
        ,"Delete"},AceGUI);
    function topContainer:AddRow(dataObj,AceGUI)
        ZLM:Debug("Adding Row - " .. tostring(dataObj.ItemId));
        if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
        ZLM:Debug("Adding Row to Bountyboard:");
        for k,v in pairs(dataObj) do
            ZLM:Debug(tostring(k) .. ": " .. tostring(v));
        end
        local rowObj = {};
        rowObj.Index = { Content = dataObj.Index };
        rowObj.Name = { Value = dataObj.Name, OnEnterPressed = ZLM_DonationLedger_NameChangeCallback };
        rowObj.ItemId = { Value = dataObj.ItemId, OnEnterPressed = ZLM_DonationLedger_ItemIdChangeCallback };
        rowObj.ItemName = { Content = dataObj.ItemName, OnClick = function() end, OnEnter = ZLM_DonationLedger_MakeTooltip, OnLeave = ZLM.ClearTooltip };
        rowObj.Quantity = { Value = dataObj.Quantity, OnEnterPressed = ZLM_DonationLedger_QuantityChangeCallback };
        rowObj.Timestamp = { Value = dataObj.Timestamp, OnValueChanged = ZLM_DonationLedger_DateChangeCallback };
        rowObj.Delete = { Content = "Delete", OnClick = ZLM_DonationLedger_DeleteCallback };
        self.Table.DataFrame:AddRow(rowObj,AceGUI);
    end
    local buttonContainer = AceGUI:Create("SimpleGroup");
    buttonContainer:SetRelativeWidth(1);
    buttonContainer:SetLayout("Flow");
    buttonContainer:AddChild(ZLM_Button:new("Create New Donation",ZLM_DonationLedger_CreateNewDonationCallback,0.5,AceGUI));
    topContainer:AddChild(buttonContainer);
    topContainer:AddChild(topContainer.Table.MainFrame);
    for _,v in ipairs(ZLM.db.global.Donations) do
        topContainer:AddRow(v,AceGUI)
    end
    return topContainer;
end

function ZLM_DonationLedger_CreateNewDonationCallback(me)
    local donationIndex = 0;
    for _,v in ipairs(ZLM.db.global.Donations) do
        if tonumber(v.Index) > donationIndex then donationIndex = tonumber(v.Index) + 1; end
    end
    local newItem = { Index = donationIndex, Name = "PlayerName-PlayerRealm", ItemId = 45978, ItemName = "\124cff9d9d9d\124Hitem:45978::::::::110:::::\124h[Solid Gold Coin]\124h\124r", Quantity = 0, Timestamp = date("*t") };
    ZLM.ledger:AddRow(newItem)
    tinsert(ZLM.db.global.Donations,newItem);
end

function ZLM_DonationLedger_NameChangeCallback(me,_,text)
    local index = me.parent.children[1]:GetText();
    if not not index and not not text then
        for i,v in pairs(ZLM.db.global.Donations) do
            ZLM:Debug("Checking donation " .. tostring(v.Index));
            if tostring(v.Index) == index then v.Name = text; break; end
        end
    end
end
function ZLM_DonationLedger_ItemIdChangeCallback(me,_,text)
    local index = me.parent.children[1]:GetText();
    if not not index and not not text then
        text = tonumber(text);
        for i,v in pairs(ZLM.db.global.Donations) do
            ZLM:Debug("Checking donation " .. tostring(v.Index));
            if tostring(v.Index) == index then v.ItemId = text; break; end
        end
        local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(text);
        ZLM:Wait(0.5, ZLM_DonationLedger_WaitFunction_ItemIdChangeCallback,text,itemLink,me);
    end
end
function ZLM_DonationLedger_WaitFunction_ItemIdChangeCallback(text,itemLink,me)
    me.parent.children[3]:SetText(itemLink);
end
function ZLM_DonationLedger_MakeTooltip(me)
    local link = me:GetText();
    ZLM:MakeTooltip(link);
end
function ZLM_DonationLedger_QuantityChangeCallback(me,_,text)
    local index = me.parent.children[1]:GetText();
    if not not index and not not text then
        for i,v in pairs(ZLM.db.global.Donations) do
            ZLM:Debug("Checking donation " .. tostring(v.Index));
            if tostring(v.Index) == index then v.Quantity = tonumber(text); break; end
        end
    end
end
function ZLM_DonationLedger_DateChangeCallback(controlKey,callbackKey,value,me)
    local index = me.parent.parent.children[1]:GetText();
    if not not index and not not value then
        for _,v in pairs(ZLM.db.global.Donations) do
            ZLM:Debug("Checking donation " .. tostring(v.Index));
            if tostring(v.Index) == index then v.Timestamp[callbackKey] = value; end
        end
    end
end
function ZLM_DonationLedger_DeleteCallback(me)
    local index = me.parent.children[1]:GetText();
    if not not index then
        for i = #(ZLM.db.global.Donations),1,-1 do
            if tostring(ZLM.db.global.Donations[i].Index) == index then
                tremove(ZLM.db.global.Donations,i);
                break;
            end
        end
        ZLM:Debug("There are currently " .. tostring(#(me.parent.parent.children)) .. " records.");
        for i = #(me.parent.parent.children),1,-1 do
            if me.parent.parent.children[i].children[1]:GetText() == index then
                me.parent.parent.children[i]:Release();
                tremove(me.parent.parent.children,i);
            end
        end
    end
    me.parent.parent:DoLayout();
end