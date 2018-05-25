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

    if ZLM_TestBackupData then
        ZLM:PurgeDonationLog(date("*t",GetServerTime()));
        print("Generating random data.")
        ZLM_ScoreboardData = {};
        ZLM.db.profile.Bounties = {};
        ZLM.db.global.Donations = {};
        ZLM.db.profile.ScoreboardStartDateTimeDatePicker = {
            year = 2018,
            month = 1,
            day = 1,
            hour = 0,
            minute = 0,
            sec = 0
        };
        ZLM.db.profile.ScoreboardEndDateTimeDatePicker = date("*t", GetServerTime());
        for i = 1, ZLM:GetTotalTestRecords() do
            local randomNum = math.random(count);
            ZLM:LogDonation("Bob"..i.."-ShadowCouncil",ZLM_TestItems[randomNum],randomNum);
        end
        for i, v in ipairs(ZLM_TestItems) do
            local randomNum = math.random(50);
            ZLM.db.profile.Bounties[i] = {};
            ZLM.db.profile.Bounties[i].ItemId = v;
            ZLM.db.profile.Bounties[i].Name = select(2,GetItemInfo(v));
            ZLM.db.profile.Bounties[i].Points = randomNum;
            ZLM.db.profile.Bounties[i].HotItem = false;
        end
        ZLM:UpdateScoreboard();
    else
        print("Click Backup Current Data First.")
    end



end

-- backup code

-- generate random data

ZLM_OptionsTable.args.TestSuite = {
    name = "Test Data",
    type = "group",
    desc = "Generate random data to test ZLM's features.",
    order = 1,
    args = {
        totalRecords = {
            name = "Total Test Records.",
            desc = "The number of records in your test table",
            descStyle = "inline",
            type = "range",
            min = 1,
            max = 100,
            step = 1,
            bigStep = 1,
            set = "SetTotalTestRecords",
            get = "GetTotalTestRecords",
            order =4,
            descStyle="inline"
        },
        backupData = {
            name = "1. Backup Current Data",
            type = "execute",
            func = function()
                if not ZLM_TestBackupData then
                    ZLM_TestBackupData = ZLM_ScoreboardData;
                    ZLM_TestBackupBounties = ZLM.db.profile.Bounties;
                    ZLM_TestBackupDonations = ZLM.db.global.Donations;
                    print("ZLM_ScoreboardData, donations, and bounties stored. Click Restore Backup before logout or reload to keep backed up data.")
                else
                    print("Backup data already stored. Click Restore Backup to restore.")
                end
            end,
            order = 0
        },
        restoreData = {
            name = "3. Restore Backup",
            type = "execute",
            func = function()
                if ZLM_TestBackupData then
                    ZLM_ScoreboardData = ZLM_TestBackupData;
                    ZLM.db.profile.Bounties = ZLM_TestBackupBounties;
                    ZLM.db.global.Donations = ZLM_TestBackupDonations;
                    ZLM_TestBackupData = nil;
                    ZLM_TestBackupBounties = nil;
                    ZLM_TestBackupDonations = nil;
                    print("ZLM_ScoreboardData, donations, and bounties restored.")
                else
                    print("No backup data stored.")
                end
            end,
            order = 3
        },

        generateData = {
            name = "2. Generate Test Data",
            type = "execute",
            func = function()
                ZLM_GenerateTestData();

            end,
            order = 2
        },
        printDataSummary = {
            name = "Print ZLM Data summary.",
            type = "execute",
            func = function()
                ZLM:PrintDataSummary();
            end,
            order = 5

        }

    }
}


function ZLM:PrintDataSummary()
    local bountiesCount = 0;
    local scoreboardCount = 0;
    local donationsCount = 0;
    if self.db.profile.Bounties then bountiesCount = #self.db.profile.Bounties; end
    if ZLM_ScoreboardData then scoreboardCount = #ZLM_ScoreboardData; end
    if self.db.global.Donations then donationsCount = #self.db.global.Donations; end;
    local bountyverdict = "Bounties healthy.";
    local scoreboardverdict = "Scoreboard healthy.";
    local donationsverdict = "Donations healthy."
    print(bountiesCount.." bounties, "..scoreboardCount.." scoreboard entries. "..donationsCount.." donations logged.")

    if type(self.db.profile.Bounties) == "table" then
        for k,v in pairs(self.db.profile.Bounties) do
            if not v.Name or not v.Points or not v.ItemId then bountyverdict = "Bounties missing things."; end
        end
    else
        bountyverdict = "Bounties table not found."
    end
    if type(ZLM_ScoreboardData) == "table" then
        for k,v in pairs(ZLM_ScoreboardData) do
            if not v.Name or not v.Points then scoreboardverdict = "Scoreboard missing things."; end
        end
    else
        scoreboardverdict = "Scoreboard table not found."
    end
    if type(ZLM.db.global.Donations) == "table" then
        for k,v in pairs(ZLM.db.global.Donations) do
            if not v.Name or not v.ItemId or not v.Quantity or not v.ItemName or not v.ItemLink or not v.Timestamp then
                donationsverdict = "Donations missing something";
            end
        end
    else
        donationsverdict = "Donations table not found."
    end

    print(scoreboardverdict);
    print(bountyverdict);
end

