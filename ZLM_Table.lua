ZLM_Table = {};
function ZLM_Table:new(headerWidthArray,AceGUI)
    if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
    local tableContainer = AceGUI:Create("SimpleGroup");
    tableContainer:SetLayout("Flow");
    tableContainer:SetFullWidth(true);

--BEGIN: Create Title Row
    local tableTitleContainer = AceGUI:Create("SimpleGroup");
    tableTitleContainer:SetLayout("Flow");
    tableTitleContainer:SetFullWidth(true);
    for k,v in pairs(headerWidthArray) do
        local columnHeader = AceGUI:Create("Label");
        columnHeader:SetText(k);
        columnHeader:SetRelativeWidth(v);
        tableTitleContainer:AddChild(columnHeader);
    end
    tableContainer:AddChild(tableTitleContainer);
--END: Create Title Row

    local scrollContainer = AceGUI:Create("ScrollFrame");
    scrollContainer:SetLayout("List");
    scrollContainer.HeaderWidthArray = headerWidthArray;
    function scrollContainer:AddRow(dataObj, AceGUI)
        if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
        local rowContainer = AceGUI:Create("InlineGroup");
        for k,v in pairs(self.HeaderWidthArray) do
            rowContainer:AddChild(ZLM_InteractiveLabel:new(dataObj[k],v,
                function(button)
                    print(button);
                end,nil,nil,AceGUI));
        end
    end
    return { MainFrame = tableContainer, DataFrame = scrollContainer };
end