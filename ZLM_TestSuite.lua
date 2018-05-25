--list of items
ZLM_OptionDefaults.profile.TestSuite = {
    totalTestRecords = 15;
}


-- config pane

function ZLM:SetTotalTestRecords(_,value)
    self.db.profile.TestSuite.totalTestRecords = value;
end

function ZLM:GetTotalTestRecords(_)
    return self.db.profile.TestSuite.totalTestRecords;
end


function ZLM_GenerateTestData()
    local ZLM_TestItems = {
        "142117",
        "127856",
        "132212",
        "21213",
        "133570",
        "129158",
        "124115",
        "133680",
        "123919",
        "123918",
        "124110"};
    --[[
    "142117"="Potion of Prolonged Power",
"127856" = "Left shark",
"132212" = "Frothing Essence",
"21213" = "Preserved Holly",
"133570" = "The Hungry Magister",
"129158" = "Starlight Rosedust",
"124115" = "Stormscale",
"133680" = "Slice of Bacon",
"123919" = "Felslate",
"123918" = "Leystone Ore",
"124110" = "Stormray"
]]--

    local count = #ZLM_TestItems;

    for i = 1, ZLM:GetTotalTestRecords() do
        local randomNum = math.random(count);
        ZLM:LogDonation("Bob"..i.."-ShadowCouncil",ZLM_TestItems[randomNum],randomNum);
    end
    ZLM:UpdateScoreboard();
end

-- backup code

-- generate random data

ZLM_OptionsTable.args.TestSuite = {
    name = "Test Data",
    type = "group",
    order = 1,
    args = {
        totalRecords = {
            name = "Total Test Records.",
            desc = "The number of records in your test table",
            type = "range",
            min = 1,
            max = 100,
            step = 1,
            bigStep = 1,
            set = "SetTotalTestRecords",
            get = "GetTotalTestRecords",
            order = 1,
            descStyle="inline"
        },
        backupData = {
            name = "Backup Current Data",
            type = "execute",
            func = function()
                if not ZLM_TestBackupData then
                    ZLM_TestBackupData = ZLM_ScoreboardData;
                end
            end,
            order = 0
        },
        restoreData = {
            name = "Restore Backup",
            type = "execute",
            func = function()
                if ZLM_TestBackupData then
                    ZLM_ScoreboardData = ZLM_TestBackupData;
                    ZLM_TestBackupData = nil;
                end
            end,
            order = 0
        },

        generateData = {
            name = "Generate Test Data",
            type = "execute",
            func = function() ZLM_GenerateTestData(); end,
            order = 0
        }
    }
}


