ZLib.Table = {
    new = function(self,AceGUI,dWidth,oTableStructure,oOptions)
        ZLib.Debug:Print('Creating ZLib.Table');
        if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
        ZLib.Debug:Print('Creating Table Frame.');
        local root = AceGUI:Create("SimpleGroup");
        root:SetRelativeWidth(dWidth);
        root:SetLayout("Flow");
        ZLib.Debug:Print('Creating Header Row.');
        root.Header = self:__BuildHeaderRow(AceGUI,oTableStructure);
        ZLib.Debug:Print('Creating Table Data.');
        root.Data = self:__BuildTableData(AceGUI,oTableStructure);
        ZLib.Debug:Print('Creating Add Row Function.');
        root.AddRow = self:__BuildAddRowFunction();
        ZLib.Debug:Print('Creating Remove Row Function.');
        root.RemoveRow = self:__BuildRemoveRowFunction();
        ZLib.Debug:Print('Add/Remove Row Functions Built.');
        root:AddChild(root.Header);
        root:AddChild(root.Data);
        root.Clear = self.__Clear;
        ZLib.Debug:Print('ZLib.Table created.')
        return root;
    end,
    __BuildCell = function(self,AceGUI,type,oCellOptions)
        if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
        local container = AceGUI:Create("InlineFrame");
        container:SetRelativeWidth(oCellOptions.Width);
        container:SetLayout("Flow");
        local control;
        if type == "Button" then
            control = ZLib.Button:new(AceGUI,1,oCellOptions.Text,oCellOptions.Callbacks);
        elseif type == "CheckBox" then
            control = ZLib.CheckBox:new(AceGUI,oCellOptions.DefaultValue,oCellOptions.Callbacks);
        elseif type == "DatePicker" then
            control = ZLib.DatePicker:new(AceGUI,1,oCellOptions,oCellOptions.Callbacks);
        elseif type == "DateTimePicker" then
            control = ZLib.DateTimePicker:new(AceGUI,1,oCellOptions,oCellOptions.Callbacks);
        elseif type == "Dropdown" then
            control = ZLib.Dropdown:new(AceGUI,1,oCellOptions,oCellOptions.Callbacks);
        elseif type == "EditBox" then
            control = ZLib.EditBox:new(AceGUI,1,oCellOptions.DefaultValue,oCellOptions.Callbacks);
        elseif type == "Heading" then
            control = ZLib.Heading:new(AceGUI,1,oCellOptions.Text);
        elseif type == "InteractiveLabel" then
            control = ZLib.InteractiveLabel:new(AceGUI,1,oCellOptions.Text,oCellOptions.Callbacks);
        elseif type == "Label" then
            control = ZLib.Label:new(AceGUI,1,oCellOptions.Text);
        elseif type == "Slider" then
            control = ZLib.Slider:new(AceGUI,1,oCellOptions,oCellOptions.Callbacks)
        elseif type == "TimePicker" then
            control = ZLib.TimePicker:new(AceGUI,1,oCellOptions,oCellOptions.Callbacks);
        end
        container:AddChild(control);
        return container;
    end,
    __BuildAddRowFunction = function()
        return function(self,AceGUI,values)
            if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
            local row = AceGUI:Create("SimpleGroup");
            for i,v in ipairs(self.__TableStructure) do
                v.DefaultValue = values[i];
                row:AddChild(ZLib.Table:__BuildCell(AceGUI,v.Type,v));
            end
            self.Data.ScrollContainer.RowsContainer:AddChild(row);
            return row;
        end
    end,
    __BuildHeaderRow = function(self,AceGUI,oTableStructure)
        if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
        local header = AceGUI:Create("SimpleGroup");
        header:SetRelativeWidth(1);
        header:SetLayout("Flow");
        for i,v in ipairs(oTableStructure) do
            header:AddChild(ZLib.Label:new(AceGUI,v.Width,v.Title));
        end
        return header;
    end,
    __BuildTableData = function(self,AceGUI,oTableStructure)
        if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
        local data = AceGUI:Create("SimpleGroup");
        data:SetRelativeWidth(1);
        data:SetFullHeight(true);
        data:SetLayout("Flow");
        ZLib.Debug:Print('Building Table Scroll Container.');
        data.ScrollContainer = self:__BuildScrollContainer(AceGUI);
        data:AddChild(data.ScrollContainer);
        ZLib.Debug:Print('Table data built.');
        return data;
    end,
    __BuildScrollContainer = function(self,AceGUI)
        if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
        local scroll = AceGUI:Create("ScrollFrame");
        scroll:SetLayout("List");
        scroll:SetFullWidth(true);
        scroll:SetFullHeight(true);
        ZLib.Debug:Print('Building Table Row Container.');
        local rows = self:__BuildRowContainer(AceGUI);
        scroll:AddChild(rows);
        scroll.RowsContainer = rows;
        ZLib.Debug:Print('Scroll Container Built.');
        return scroll;
    end,
    __BuildRowContainer = function(self,AceGUI)
        if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
        local rows = AceGUI:Create("InlineGroup");
        rows:SetFullWidth(true);
        rows:SetFullHeight(true);
        rows:SetLayout("Flow");
        return rows;
    end,
    __BuildRemoveRowFunction = function()
        return function(self,rowIndex)
            self.Data.ScrollContainer.RowsContainer.children[rowIndex]:ReleaseWidget();
            --tremove(self.Data.ScrollContainer.RowsContainer.children,rowIndex);
            self.Data:DoLayout();
        end
    end,
    __Clear = function(self)
        self.Data.ScrollContainer.RowsContainer:ReleaseChildren();
    end
}

