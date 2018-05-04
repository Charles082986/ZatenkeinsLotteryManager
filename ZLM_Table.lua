ZLM_Table = {};
function ZLM_Table:new(structureArray,orderArray,AceGUI)
    if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
    local tableContainer = AceGUI:Create("SimpleGroup");
    tableContainer:SetLayout("Flow");
    tableContainer:SetFullWidth(true);
    tableContainer:SetFullHeight(true);
--BEGIN: Create Title Row
    local tableTitleContainer = AceGUI:Create("SimpleGroup");
    tableTitleContainer:SetLayout("Flow");
    tableTitleContainer:SetRelativeWidth(0.95);
    for _,v in ipairs(orderArray) do
        tableTitleContainer:AddChild(ZLM_Label:new(v,structureArray[v].Width,AceGUI));
    end
    tableContainer:AddChild(ZLM_Label:new(" ",0.025,AceGUI));
    tableContainer:AddChild(tableTitleContainer);
--END: Create Title Row
    local tableDataContainer = AceGUI:Create("SimpleGroup");
    tableDataContainer:SetLayout("Fill");
    tableDataContainer:SetFullHeight(true);
    tableDataContainer:SetFullWidth(true);
    local scrollContainer = AceGUI:Create("ScrollFrame");
    scrollContainer:SetLayout("List");
    scrollContainer:SetFullWidth(true);
    scrollContainer:SetFullHeight(true);
    local rowContainer = AceGUI:Create("InlineGroup");
    rowContainer:SetFullWidth(true);
    rowContainer:SetFullHeight(true);
    rowContainer:SetLayout("Flow");
    scrollContainer.StructureArray = structureArray;
    scrollContainer.OrderArray = orderArray;
    function scrollContainer:AddRow(dataObj, AceGUI)
        if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
        local structureArray = self.StructureArray;
        local orderArray = self.OrderArray;
        for _,v in ipairs(orderArray) do
            local type = structureArray[v].Type;
            local data = dataObj[v];
            local item = {};
            local width = structureArray[v].Width;
            if type == "InteractiveLabel" then
                item = ZLM_InteractiveLabel:new(data.Content, width, data.ClickFunc, data.EnterFunc, data.LeaveFunc, AceGUI)
            elseif type == "Label" then
                item = ZLM_Label:new(data.Content,width,AceGUI);
            elseif type == "Button" then
                item = ZLM_Button:new(data.Content, data.Func, width, AceGUI);
            elseif type == "Input" then
                item = ZLM_Input:new(data.Update, width, AceGUI);
            end
            self.RowContainer:AddChild(item)
        end
        self:DoLayout();
    end
    scrollContainer.RowContainer = rowContainer;
    scrollContainer:AddChild(rowContainer);
    tableDataContainer:AddChild(scrollContainer);
    tableContainer:AddChild(tableDataContainer);
    return { MainFrame = tableContainer, DataFrame = scrollContainer };
end