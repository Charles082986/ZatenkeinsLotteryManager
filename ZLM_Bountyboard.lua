ZLM_Bountyboard = {};
ZLM_Bountyboard.StructureArray = {
    ItemId = { Type = ZLM_Table.Types.Input, Width = 0.2 },
    Name = { Type = ZLM_Table.Types.InteractiveLabel, Width = 0.35 },
    --Need = { Type = ZLM_Table.Types.Input, Width = 0.1 },
    --OnHand = { Type = ZLM_Table.Types.Input, Width = 0.1 },
    Points = { Type = ZLM_Table.Types.Input, Width = 0.2 },
    HotItem = { Type = ZLM_Table.Types.Toggle, Width = 0.1 },
    Delete = { Type = ZLM_Table.Types.Button, Width = 0.15 },
};
function ZLM_Bountyboard:new(title,callbacks,AceGUI)
    if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
    local topContainer = AceGUI:Create("Frame");
    topContainer:SetLayout("Flow");
    topContainer:SetTitle(title);
    topContainer:SetCallback("OnClose",function(widget)
        ZLM.bountyboard = nil;
        widget:ReleaseChildren();
        AceGUI:Release(widget);
    end);
    function topContainer:Terminate()
        ZLM.bountyboard = nil;
        self:ReleaseChildren();
        self:Release();
    end
    topContainer.Table = ZLM_Table:new(self.StructureArray,{"ItemId"
        ,"Name"
        --,"Need"
        --,"OnHand"
        ,"Points"
        ,"HotItem"
        ,"Delete"},AceGUI);
    function topContainer:AddRow(dataObj,AceGUI)
        ZLM:Debug("Adding Row - " .. tostring(dataObj.ItemId));
        -- dataObj structure: { ItemId = number, ItemLink = string, Points = number, HotItem = bool }
        if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
        local rowObj = {};
        rowObj.ItemId = {
            Value = dataObj.ItemId
            , OnEnterPressed = ZLM_Bountyboard_ItemIdChangeCallback
        };
        rowObj.Name = { Value = dataObj.ItemLink, OnEnter = ZLM_BountyBoard_MakeTooltip, OnLeave = ZLM.ClearTooltip };
        rowObj.Points = { Value = dataObj.Points,
            OnEnterPressed = ZLM_Bountyboard_PointsChangedCallback
        };
        rowObj.HotItem = {
            State = dataObj.HotItem,
            OnValueChanged = ZLM_Bountyboard_HotItemChangeCallback
        };
        rowObj.Delete = {
            Content = "Delete",
            OnClick = ZLM_Bountyboard_DeleteCallback
        };
        self.Table.DataFrame:AddRow(rowObj,AceGUI);
    end
    local buttonContainer = AceGUI:Create("SimpleGroup");
    buttonContainer:SetRelativeWidth(1);
    buttonContainer:SetLayout("Flow");
    buttonContainer:AddChild(ZLM_Button:new("Add Bounty",callbacks.AddBounty,0.25,AceGUI));
    topContainer:AddChild(buttonContainer);
    topContainer:AddChild(topContainer.Table.MainFrame);
    for _,v in ipairs(ZLM.db.profile.Bounties) do
        topContainer:AddRow(v,AceGUI)
    end
    return topContainer;
end
function ZLM_Bountyboard_ItemIdChangeCallback(me,_,text)
    if not not text then
        ZLM:Debug("ItemId Changed - " .. text);
        local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(text);
        ZLM:Wait(
            0.25
            ,ZLM_Bountyboard_WaitFunction_ItemIdChangeCallback
            ,text
            ,itemLink
            ,me
        );
    end
end
function ZLM_Bountyboard_WaitFunction_ItemIdChangeCallback(text,itemLink,me)
    ZLM:Debug("ItemId Changed - Wait Function - " .. text .. " - " .. itemLink);
    local index = -1;
    for i,v in ipairs(ZLM.db.profile.Bounties) do
        if v.ItemId == text then index = i; break; end
    end
    if index < 1 then
        index = #(ZLM.db.profile.Bounties) + 1;
        ZLM.db.profile.Bounties[index] = {};
    end
    ZLM:Debug("ItemId Changed - Wait Function - " .. index);
    ZLM.db.profile.Bounties[index].ItemId = text;
    ZLM.db.profile.Bounties[index].Name = itemLink;
    ZLM.db.profile.Bounties[index].Points = me.parent.children[3]:GetText();
    ZLM.db.profile.Bounties[index].HotItem = me.parent.children[4]:GetValue();
    ZLM:Debug("ItemId Changed - Wait Function - " .. ZLM.db.profile.Bounties[index].ItemLink);
    me.parent.children[2]:SetText(itemLink);
end
function ZLM_Bountyboard_MakeTooltip(me,_,itemLink)
    itemLink = itemLink or me.parent.children[2]:GetText();
    ZLM:Debug("Making Bountyboard Tooltip - " .. tostring(itemLink));
    if not not itemLink then
        ZLM:MakeTooltip(itemLink);
    end
end
function ZLM_Bountyboard_PointsChangeCallback(me,_,text)
    local itemId = me.parent.children[1]:GetText();
    if not not itemId and not not text then
        text = tonumber(text);
        for i,v in ipairs(ZLM.db.profile.Bounties) do
            if v.ItemId == itemId then ZLM.db.profile.Bounties[i].Points = text; break; end
        end
    end
end
function ZLM_Bountyboard_HotItemChangeCallback(me,_,value)
    local itemId = me.parent.children[1].GetText();
    if not not itemId then
        for i,v in ipairs(ZLM.db.profile.Bounties) do
            if v.itemId == itemId then ZLM.db.profile.Bounties[i].HotItem = value; break; end
        end
    end
end
function ZLM_Bountyboard_DeleteCallback(me)
    local itemId = me.parent.children[1].GetText();
    if not not itemId then
        for i,v in ipairs(ZLM.db.profile.Bounties) do
            if v.itemId == itemId then
                tremove(ZLM.db.profile.Bounties,i);
                break;
            end
        end
        for i,v in ipairs(me.parent.parent.children) do
            if v.children[1]:GetText() == itemId then
                tremove(me.parent.parent.children,i);
            end
        end
    end
end