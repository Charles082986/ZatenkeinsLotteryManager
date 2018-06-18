ZLM_Bountyboard = {
    Title = "ZLM - Bountyboard",
    new = function(self,AceGUI,initialRows)
        if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
        local topContainer = self:__CreateFrame(AceGUI);
        topContainer.Table = ZLib.Table:new(AceGUI,1,self.StructureArray);
        topContainer:AddChild(topContainer.Table);
        topContainer.AddRow = self.__AddRow;
        topContainer:AddChild(self:__CreateButtonContainer(AceGUI));
        for _,v in ipairs(initialRows) do
            topContainer:AddRow(AceGUI,v)
        end
        return topContainer;
    end,
    __CreateFrame = function(self,AceGUI)
        local frame = AceGUI:Create("Frame");
        frame:SetLayout("Flow");
        frame:SetTitle(self.Title);
        return frame;
    end,
    __CreateButtonContainer = function(self,AceGUI)
        local buttonContainer = AceGUI:Create("SimpleGroup");
        buttonContainer:SetRelativeWidth(1);
        buttonContainer:SetLayout("Flow");
        buttonContainer:AddChild(ZLib.Button:new(AceGUI,1,"Add Bounty",self.__AddBounty));
        return buttonContainer;
    end,
    __AddBounty = function() end,
    __AddRow = function(self,AceGUI,oData)
        oData = ZLM_Bountyboard:__ValidateData(oData);
        ZLM:Debug("Adding Row - " .. tostring(oData.ItemId));
        if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
        local rowObj = {
            ItemId = {
                DefaultValue = oData.ItemId,
                Width = ZLM_Bountyboard.StructureArray.ItemId.Width,
                Callbacks = {
                    OnEnterPressed = ZLM_Bountyboard.__ItemIdChangeCallback;
                }
            },
            Name = {
                Text = oData.Name,
                Width = ZLM_Bountyboard.StructureArray.Name.Width,
                Callbacks = {
                    OnEnter = ZLM_Bountyboard.__MakeTooltip,
                    OnLeave = ZLib.ClearTooltip
                }
            },
            Points = {
                DefaultValue = oData.Points,
                Width = ZLM_Bountyboard.StructureArray.Points.Width,
                Callbacks = {
                    OnEnterPressed = ZLM_Bountyboard.__PointsChangeCallback;
                }
            },
            HotItem = {
                Width = ZLM_Bountyboard.StructureArray.HotItem.Width,
                DefaultValue = oData.HotItem,
                Callbacks = {
                    OnValueChanged = ZLM_Bountyboard.__HotItemChangeCallback;
                }
            },
            Delete = {
                Text = "Delete",
                Width = ZLM_Bountyboard.StructureArray.Delete.Width,
                Callbacks = {
                    OnClick = ZLM_Bountyboard.__DeleteClickCallback;
                }
            }
        };
        self.Table:AddRow(AceGUI,oData);
    end,
    __ValidateData = function(self,oData)
        if not oData then oData = {}; end
        if not ZLib:IsNumberValid(oData.ItemId) then oData.ItemId = 46002; end -- Worthless Piece of Violet Glass
        local itemName, itemLink, _, _, _, _, _, _, _, _, _ = GetItemInfo(oData.ItemId);
        if not ZLib:IsStringValid(oData.Name) then oData.Name = itemLink; end
        if not ZLib:IsNumberValid(oData.Points) then oData.Points = 0; end;
        if oData.HotItem == nil then oData.HotItem = false; end
        return oData;
    end,
    __ItemIdChangeCallback = function(me,_,text)
        if not not text then
            ZLM:Debug("ItemId Changed - " .. text);
            local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(text);
            ZLM:Wait(
                0.25
                ,ZLM_Bountyboard.__Await.ItemIdChangeCallback
                ,text
                ,itemLink
                ,me
            );
        end
    end,
    __Await = {
        ItemIdChangeCallback = function(text,itemLink,me)
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
    },
    __MakeTooltip = function(me,_,itemLink)
        itemLink = itemLink or me.parent.children[2]:GetText();
        ZLM:Debug("Making Bountyboard Tooltip - " .. tostring(itemLink));
        if not not itemLink then
            ZLib:MakeTooltip(itemLink);
        end
    end,
    __PointsChangeCallback = function(me,_,text)
        local itemId = me.parent.children[1]:GetText();
        if not not itemId and not not text then
            text = tonumber(text);
            for i,v in ipairs(ZLM.db.profile.Bounties) do
                if v.ItemId == itemId then ZLM.db.profile.Bounties[i].Points = text; break; end
            end
        end
    end,
    __HotItemChangeCallback = function(me_,value)
        local itemId = me.parent.children[1].GetText();
        if not not itemId then
            for i,v in ipairs(ZLM.db.profile.Bounties) do
                if v.itemId == itemId then ZLM.db.profile.Bounties[i].HotItem = value; break; end
            end
        end
    end,
    __DeleteClickCallback = function(me)
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
    end,
    StructureArray = {
        ItemId = { Type = "EditBox", Width = 0.05 },
        Name = { Type = "InteractiveLabel", Width = 0.35 },
        Points = { Type = "EditBox", Width = 0.1 },
        HotItem = { Type = "CheckBox", Width = 0.05 },
        Delete = { Type = "Button", Width = 0.15 },
    },
};