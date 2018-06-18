<<<<<<< HEAD
ZLM_Bountyboard = {};
ZLM_Bountyboard.StructureArray = {
    ItemId = { Type = ZLM_Table.Types.Input, Width = 0.1 },
    Name = { Type = ZLM_Table.Types.InteractiveLabel, Width = 0.35 },
    --Need = { Type = ZLM_Table.Types.Input, Width = 0.1 },
    --OnHand = { Type = ZLM_Table.Types.Input, Width = 0.1 },
    Points = { Type = ZLM_Table.Types.Input, Width = 0.1 },
    HotItem = { Type = ZLM_Table.Types.Toggle, Width = 0.1 },
    Delete = { Type = ZLM_Table.Types.Button, Width = 0.25 },
};
function ZLM_Bountyboard:new(title,callbacks,AceGUI)
    if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
    local topContainer = AceGUI:Create("Frame");
    topContainer:SetLayout("Flow");
    topContainer:SetTitle(title);
    topContainer:SetCallback("OnClose",function(widget)
        ZLM.FrameState.Bountyboard = ZLM_FrameStateOptions.Hidden;
    end);
    function topContainer:Terminate()
        ZLM.FrameState.Bountyboard = ZLM_FrameStateOptions.Hidden;
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
        ZLM:Debug("Adding Row to Bountyboard:");
        for k,v in pairs(dataObj) do
            ZLM:Debug(tostring(k) .. ": " .. tostring(v));
        end
        local rowObj = {};
        rowObj.ItemId = {
            Value = dataObj.ItemId
            , OnEnterPressed = ZLM_Bountyboard_ItemIdChangeCallback
        };

        rowObj.Name = { Content = dataObj.Name, OnClick = function() end, OnEnter = ZLM_BountyBoard_MakeTooltip, OnLeave = ZLM.ClearTooltip };
        rowObj.Points = { Value = dataObj.Points,
            OnEnterPressed = ZLM_Bountyboard_PointsChangeCallback
        };
        rowObj.HotItem = {
            State = dataObj.HotItem,
            OnValueChanged = ZLM_Bountyboard_HotItemChangeCallback
        };
        rowObj.Delete = {
            Content = "Delete Bounty",
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
    ZLM:Debug("ItemId Changed - Wait Function - " .. tostring(text) .. " - " .. tostring(itemLink));
    local index = -1;
    for i,v in ipairs(ZLM.db.profile.Bounties) do
        if tostring(v.ItemId) == text then index = i; break; end
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
    ZLM:Debug("ItemId Changed - Wait Function - " .. tostring(ZLM.db.profile.Bounties[index].Name));
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
    ZLM:Debug("Updating Points Value - Value: " .. tostring(text) .. ", ItemId: " .. tostring(itemId));
    if not not itemId and not not text then
        text = tonumber(text);
        for i,v in ipairs(ZLM.db.profile.Bounties) do
            ZLM:Debug("Checking bounty " .. tostring(v.ItemId));
            if tostring(v.ItemId) == itemId then v.Points = text; break; end
        end
    end
end
function ZLM_Bountyboard_HotItemChangeCallback(me,_,value)
    local itemId = me.parent.children[1]:GetText();
    if not not itemId then
        for i,v in ipairs(ZLM.db.profile.Bounties) do
            ZLM:Debug("Checking bounty " .. tostring(v.ItemId));
            if tostring(v.ItemId) == itemId then v.HotItem = value; break; end
        end
    end
end
function ZLM_Bountyboard_DeleteCallback(me)
    local itemId = me.parent.children[1]:GetText();
    ZLM:Debug("Removing Item - " .. itemId);
    if not not itemId then
        ZLM:Debug("There are currently " .. tostring(#(ZLM.db.profile.Bounties)) .. " bounties.");
        for i = #(ZLM.db.profile.Bounties),1,-1 do
            ZLM:Debug("Checking deleteId " .. itemId .. " against Bounty " .. i .. " with id " .. ZLM.db.profile.Bounties[i].ItemId .. " : " .. tostring(ZLM.db.profile.Bounties[i].ItemId == itemId));
            if tostring(ZLM.db.profile.Bounties[i].ItemId) == itemId then
                ZLM:Debug("Removing index " .. tostring(i) .. " from bounties.");
                tremove(ZLM.db.profile.Bounties,i);
                break;
            end
        end
        ZLM:Debug("There are currently " .. tostring(#(me.parent.parent.children)) .. " records.");
        for i = #(me.parent.parent.children),1,-1 do
            ZLM:Debug("Checkting deleteId " .. itemId .. " against " .. me.parent.parent.children[i].children[1]:GetText())
            if me.parent.parent.children[i].children[1]:GetText() == itemId then
                ZLM:Debug("Removing index " .. tostring(i) .. " from UI.");
                me.parent.parent.children[i]:Release();
                tremove(me.parent.parent.children,i);
            end
        end
    end
    me.parent.parent:DoLayout();
