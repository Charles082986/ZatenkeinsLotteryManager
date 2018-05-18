ZLM_Bountyboard = {};
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
    topContainer.Table = ZLM_Table:new({
        ItemId = { Type = ZLM_Table.Types.Input, Width = 0.2 },
        Name = { Type = ZLM_Table.Types.InteractiveLabel, Width = 0.35 },
        --Need = { Type = ZLM_Table.Types.Input, Width = 0.1 },
        --OnHand = { Type = ZLM_Table.Types.Input, Width = 0.1 },
        Points = { Type = ZLM_Table.Types.Input, Width = 0.2 },
        HotItem = { Type = ZLM_Table.Types.Toggle, Width = 0.1 },
        Delete = { Type = ZLM_Table.Types.Button, Width = 0.15 },
    },{"ItemId"
        ,"Name"
        --,"Need"
        --,"OnHand"
        ,"Points"
        ,"HotItem"
        ,"Delete"},AceGUI);
    function topContainer:AddRow(dataObj,AceGUI)
        -- dataObj structure: { ItemId = number, ItemLink = string, Points = number, HotItem = bool }
        if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
        local rowObj = {};
        rowObj.ItemId = {
            Value = dataObj.ItemId
            , OnEnterPressed = ZLM_Bountyboard_ItemIdChangeCallback
        };
        rowObj.Name = { Value = dataObj.ItemLink, OnEnter = ZLM_Bountyboard_ItemLinkMouseOverCallback, OnLeave = ZLM.ClearTooltip };
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
        local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(text);
        ZLM:Wait(
            1
            ,function(text,itemLink,me)
            text = tonumber(text);
            local index = -1;
            for i,v in ipairs(ZLM.db.profile.Bounties) do
                if v.ItemId == text then index = i; break; end
            end
            if index < 1 then
                index = #(ZLM.db.profile.Bounties) + 1;
                ZLM.db.profile.Bounties[index] = {};
            end
            ZLM.db.profile.Bounties[index].ItemId = text;
            ZLM.db.profile.Bounties[index].ItemLink = itemLink;
            ZLM.db.profile.Bounties[index].Points = me.parent.children[5]:GetText();
            ZLM.db.profile.Bounties[index].HotItem = me.parent.children[6]:GetValue();
            me.parent.children[2]:SetText(itemLink);
            me.parent.children[2]:SetCallback("OnEnter",function() ZLM:MakeTooltip(itemLink) end);
            me.parent.children[2]:SetCallback("OnLeave",function() ZLM:ClearTooltip() end)
        end
            ,text
            ,itemLink
            ,me
        );
    end
end
function ZLM_Bountyboard_ItemLinkMouseOverCallback(me, _)
    local txt = me.GetText();
    if not not txt then
        ZLM:MakeTooltip(txt);
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