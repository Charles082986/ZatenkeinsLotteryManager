ZLM_Scoreboard = {};
function ZLM_Scoreboard:new(title,recalculateCallback,getWinnersCallback,dateChangeCallback,AceGUI)
    if not AceGUI then AceGUI = LibStub("AceGUI-3.0"); end
    --BEGIN: Creating the primary Scoreboard frame.
    local topContainer = AceGUI:Create("Frame");
    topContainer:SetLayout("Flow");
    topContainer:SetTitle(title);
    topContainer:SetCallback("OnClose",function(widget) AceGUI:Release(widget); end);
    --END: Creating the primary Scoreboard frame.
    --BEGIN: Creating the button container.
    local buttonContainer = AceGUI:Create("SimpleGroup");
    buttonContainer:SetLayout("Flow");
    buttonContainer:SetFullWidth(true);
    --END: Creating the button container.
    --BEGIN: Creating the buttons.
    local recalculateButton = AceGUI:Create("Button");
    recalculateButton:SetText("Calculate Scoreboard");
    recalculateButton:SetCallback("OnClick",recalculateCallback);
    recalculateButton:SetRelativeWidth(0.5);

    local getWinnersButton = AceGUI:Create("Button");
    getWinnersButton:SetText("Get Winners");
    getWinnersButton:SetCallback("OnClick",getWinnersCallback);
    getWinnersButton:SetRelativeWidth(0.5);
    --END: Creating the buttons.
    --BEGIN: Creating Datepickers
    local startDateDatePicker = ZLM_DatePicker:new("ScoreboardStartDate",2018,date("%Y"),true,dateChangeCallback);
    local endDateDatePicker = ZLM_DatePicker:new("ScoreboardEndDate",2018,date("%Y"),true,dateChangeCallback);
    --END: Creating Datepickers
    buttonContainer:AddChild(startDateDatePicker);
    buttonContainer:AddChild(endDateDatePicker);
    buttonContainer:AddChild(recalculateButton);
    buttonContainer:AddChild(getWinnersButton);
    topContainer:AddChild(buttonContainer);
    return topContainer;
end
function ZLM_Scoreboard:AddRow(characterName,pointTotal)

end