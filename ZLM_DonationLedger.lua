ZLM_Ledger = {
    Title = "ZLM - Ledger",
    StructureArray = {
        Index = { Type = "Label", Width = 0.05 },
        Name = { Type = "Label", Width = 0.25 },
        ItemId = { Type = "Label", Width = 0.1 },
        ItemName = { Type = "InteractiveLabel", Width = 0.3 },
        Quantity = { Type = "Label", Width = 0.1 },
        Timestamp = { Type = "Label", Width = 0.2 }
    },
    new = function(self,AceGUI)
        if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
        local frame = self:__CreateFrame(AceGUI);
        frame.Table = self.__CreateTable(self,AceGUI);
        frame:AddChild(frame.Table);
        frame.AddRow = self:__AddRow;
        for _,v in ipairs(initialRecords) do
            frame:AddRow(AceGUI,v);
        end
        return frame;
    end,
    __CreateFrame = function(self,AceGUI)
        if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
        local frame = AceGUI:Create("Frame");
        frame:SetLayout("Flow");
        frame:SetTitle(self.Title);
        return frame;
    end,
    __CreateTable = function(self,AceGUI)
        return ZLib.Table:new(AceGUI,1,self.StructureArray);
    end,
    __AddRow = function(self,AceGUI,oData)
        ZLM:Debug("Adding Row - " .. tostring(dataObj.ItemId));
        if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
        ZLM:Debug("Adding Row to Bountyboard:");
        for k,v in pairs(oData) do
            ZLM:Debug(tostring(k) .. ": " .. tostring(v));
        end
        local rowObj = {
            Index = { Width = ZLM_Ledger.StructureArray.Index.Width, Text = oData.Index };
            Name = { Width = ZLM_Ledger.StructureArray.Name.Width, Text = oData.Name };
            ItemId = { Width = ZLM_Ledger.StructureArray.ItemId.Width, Text = oData.ItemId };
            ItemName = { Width = ZLM_Ledger.StructureArray.ItemName.Width, Text = oData.ItemName, Callbacks = { OnEnter = ZLM_Ledger.ShowTooltip, OnLeave = ZLib.ClearTooltip } };
            Quantity = { Width = ZLM_Ledger.StructureArray.Qauntity.Width, Text = oData.Quantity };
            Timestamp = { Width = ZLM_Ledger.StructureArray.Timestamp.Width, Text = date("%Y-%m-%d %H:%M:%S",time(oData.Timestamp)) };
        }
        self.Table:AddRow(AceGUI,rowObj);
    end
}