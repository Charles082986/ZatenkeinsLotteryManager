ZLM_Table = {};
function ZLM_Table:new(headerWidthArray,orderArray,AceGUI)
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
        tableTitleContainer:AddChild(ZLM_Label:new(v,headerWidthArray[v],AceGUI));
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
    scrollContainer.HeaderWidthArray = headerWidthArray;
    scrollContainer.OrderArray = orderArray;
    function scrollContainer:AddRow(dataObj, AceGUI)
        if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
        local headerWidthArray = self.HeaderWidthArray;
        local orderArray = self.OrderArray;
        for _,v in ipairs(orderArray) do
            self.RowContainer:AddChild(ZLM_InteractiveLabel:new(dataObj[v],headerWidthArray[v],
                function(_,_,button)
                    print(button);
                end,nil,nil,AceGUI));
        end
        self:DoLayout();
    end
    scrollContainer.RowContainer = rowContainer;
    scrollContainer:AddChild(rowContainer);
    tableDataContainer:AddChild(scrollContainer);
    tableContainer:AddChild(tableDataContainer);
    return { MainFrame = tableContainer, DataFrame = scrollContainer };
end