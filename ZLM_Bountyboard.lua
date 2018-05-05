ZLM_Bountyboard = {};
function ZLM_Bountboard:new(title,callbacks,defaultValues,AceGUI)
    if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
    local topContainer = AceGUI:Create("Frame");
    topContainer:SetLayout("Flow");
    topContainer:SetTitle(title);
    topContainer:SetCallback("OnClose",function(widget)
        ZLM.bountboard = nil;
        widget:ReleaseChildren();
        AceGUI:Release(widget);
    end);
    topContainer.Table = ZLM_Table:new({
        ItemId = 0.15,
        Name = 0.3,
        Need = 0.1,
        OnHand = 0.1,
        Points = 0.1,
        HotItem = 0.1,
        Delete = 0.15,
    },{"ItemId","Name","Need","OnHand","Points","HotItem","Delete"},AceGUI);
    function topContainer:AddRow(dataObj,AceGUI)
        if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end

        --TO DO: Restructure incoming DataObj to include correct content and callbackArgs.
        self.Table.DataFrame:AddRow(dataObj,AceGUI);
    end
    topContainer:AddChild(topContainer.Table.MainFrame);

    local buttonContainer = AceGUI:Create("SimpleGroup");
    buttonContainer:SetRelativeWidth(1);
    buttonContainer:SetLayout("Flow");

    buttonContainer:AddChild(ZLM_Button:new("Add New Donation",callbacks.AddNewDonation,0.25,AceGUI));

    return topContainer;
end
