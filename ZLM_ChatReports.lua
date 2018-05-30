ZLM.ChatReplyWords = { "^![Ll][Oo][Tt][Tt][Oo]", "^![Ll][Oo][Tt][Tt][Ee][Rr][Yy]","^![Zz][Ll][Mm]" };
ZLM.ChatReplyTestWord = "^!lottotest";
ZLM_OptionDefaults.profile.Reporting = {
    maxReportsResults = 5,
    guildReply = true,
    guildReplyCooldown = 4
}
ZLM_OptionsTable.args.Reporting = {
    name = "Reporting",
    type = "group",
    order = 1,
    args = {

        maxReportResults = {
            name = "Number to show.",
            desc = "The number of top spots on the scoreboard to reply with. Number one, to number ?",
            type = "range",
            min = 1,
            max = 10,
            step = 1,
            bigStep = 1,
            set = "SetMaxReportResults",
            get = "GetMaxReportResults",
            order = 1,
            descStyle="inline"
        },
        guildReply = {
            name = "Reply in Guild",
            desc = "Reply to !lotto scoreboard queries in guild chat",
            type = "toggle",
            set = "SetGuildReply",
            get = "GetGuildReply",
            order = 2,
            descStyle="inline"
        },

        guildReplyCooldown = {
            name = "Guild Reply Cooldown (in minutes)",
            desc = "Cooldown for Guild scoreboard spam.",
            type = "range",
            min = 0,
            max = 10,
            step = 0.5,
            bigStep = 0.5,
            set = "SetGuildReplyCooldown",
            get = "GetGuildReplyCooldown",
            order = 3,
            descStyle="inline"
        },
    }
};
function ZLM:SetMaxReportResults(_,value)
    self.db.profile.Reporting.maxReportResults = value;
end
function ZLM:GetMaxReportResults(_)
    return self.db.profile.Reporting.maxReportResults;
end
function ZLM:SetGuildReply(_,value)
    self.db.profile.Reporting.guildReply = value;
end
function ZLM:GetGuildReply(_)
    return self.db.profile.Reporting.guildReply;
end
function ZLM:SetGuildReplyCooldown(_,value)
    self.db.profile.Reporting.guildReplyCooldown = value;
end
function ZLM:GetGuildReplyCooldown(_)
    return self.db.profile.Reporting.guildReplyCooldown;
end
ZLM.GuildChatCooldown = false;
-- Primarily used like caps()/upper() etc. to take names and make them a uniform no-space name-realm combo regardless of source.
function ZLM:PlayerName(player)
    if not string.match(player,"-") then
        local realm = GetRealmName();
        player = player.."-"..realm;

    end
    --Remove Spaces
    player = string.gsub(player,"%s", "")
    return player;
end
function ZLM:GetPlayerRank(player)
    local rank = 0;
    for i,v in ipairs(ZLM_ScoreboardData) do
        --print(ZLM:PlayerName(v.Name).." "..player);
        if ZLM:PlayerName(v.Name) == ZLM:PlayerName(tostring(player)) then
            -- Insert personalized report.
            rank = i;
        end
    end
    return rank;
end
function ZLM:GetScoreByRank(rank)
    if not not ZLM_ScoreboardData[rank] then
        return  ZLM_ScoreboardData[rank];
    end
    return 0;
end
function ZLM:Announce(message,channel,player)
    if channel == "BATTLE.NET" then
        BNSendWhisper(player,message);
    else
        SendChatMessage(message, channel, nil, player);
    end
end
function ZLM:ChatReport(player,test,channel)
    channel = channel or "WHISPER"
    local requestorRank,_ = ZLM:GetPlayerRank(player);  -- returns number
    local reportLimit = ZLM:GetMaxReportResults();
    local numRecords = #ZLM_ScoreboardData;
    local printAtEnd = false;
    local prefix;
    local prefixpattern;
    if test then
        --prefixpattern = "don'tmatchme";
        prefix = "[test]"
    else
        --prefixpattern = "%[ZLM\]";
        prefix = "[ZLM]";
    end
    if requestorRank > reportLimit then reportLimit = reportLimit - 1; printAtEnd = true; end
    if reportLimit > 0 then
        local firstTrailLength = 12
        local firstPadding = "............";
        ZLM:Announce(prefix.." Place....Score.......Name", channel, player);
        for i = 1,reportLimit do
            if i > numRecords then break; end
            local rankLength = math.floor(math.log10(i)+1)
            local score = ZLM:GetScoreByRank(i);
            local scoreLength =math.floor(math.log10(score.Points)+1)
            local padding1 = string.sub(firstPadding,1,firstTrailLength - rankLength);
            local padding2 = string.sub(firstPadding,1,firstTrailLength - scoreLength);
            if ZLM:PlayerName(player)== ZLM:PlayerName(score.Name) then
                ZLM:Announce(prefix.."*"..i .. padding1 .. score.Points .. padding2 .. score.Name.." <--", channel, player);
            else
                 ZLM:Announce(prefix.." "..i .. padding1 .. score.Points .. padding2 .. score.Name, channel, player);
            end
        end
        if printAtEnd then
            local rankLength = math.floor(math.log10(requestorRank)+1)
            local score = ZLM:GetScoreByRank(requestorRank);
            local scoreLength =math.floor(math.log10(score.Points)+1)
            local padding1 = string.sub(firstPadding,1,firstTrailLength - rankLength);
            local padding2 = string.sub(firstPadding,1,firstTrailLength - scoreLength);
                ZLM:Announce(prefix.."*"..requestorRank .. padding1 .. score.Points .. padding2 .. score.Name.. " <--", channel, player);
        end
    end
    if channel == "WHISPER" then
        print("Lottery scoreboard info requested by, and sent to: "..player)
    end
end
function ZLM.ChatEvent(event, message, author, _, _, arg5, flag, _,_,_,arg10,_,_,id)
    local words = ZLM.ChatReplyWords;
    local gchat = nil;
    local channel = "WHISPER";
    if event == "CHAT_MSG_GUILD" then
        gchat = true;
        channel = "GUILD";
    end
    if gchat and ZLM.GuildChatCooldown or not ZLM:GetGuildReply()then return; end
    if event == "CHAT_MSG_BN_WHISPER" then
        channel = "BATTLE.NET";
        author = id;
    end
    if not not string.match(message,"^%(") and not not string.match(message,"%)") then
        message = string.gsub(message,"^(.*): ","") -- Removes incognito type main names from message.
    end
    for k, v in pairs(words) do
        if not not string.match(message,v) then
            local test = not not string.match(message,ZLM.ChatReplyTestWord);
            ZLM:ChatReport(author,test, channel);
            if gchat then
                ZLM.GuildChatCooldown = true;
                ZLM:Wait(ZLM:GetGuildReplyCooldown() * 30,
                    function()
                        if ZLM:GetGuildReplyCooldown() > 0 then
                            --print("Guild Cooldown Reset.");
                        end
                        ZLM.GuildChatCooldown = false;
                    end);
            end
        end
    end
end
function ZLM_ChatFilter(self,event,myChatMessage, author,...)
    local words = ZLM.ChatReplyWords;
    local prefixpattern = "%[ZLM\]";
    if type(myChatMessage) == "string" then
    --Hide whisper if it's our prefix
        if not not string.match(myChatMessage,prefixpattern) then
            --print("It's a prefix!"..myChatMessage.." == "..ZLMPrefix);
            return true, myChatMessage, author, ...;
        end
    --Hide whisper if it's one of our words.
        for k, v in pairs(words) do
            if not not string.match(myChatMessage,v) then
               -- SendChatMessage("True now!", "WHISPER", nil, author);
                return true, myChatMessage, author, ...;

            end
        end
    end
    return false, myChatMesssage, author,...
end
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER",ZLM_ChatFilter);
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM",ZLM_ChatFilter);
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER",ZLM_ChatFilter);
ZLM:RegisterEvent("CHAT_MSG_WHISPER",ZLM.ChatEvent);
ZLM:RegisterEvent("CHAT_MSG_GUILD",ZLM.ChatEvent);
ZLM:RegisterEvent("CHAT_MSG_BN_WHISPER",ZLM.ChatEvent);
--[[ZLM:RegisterEvent("CHAT_MSG_WHISPER",function(...) ZLM.ChatEvent("CHAT_MSG_WHISPER",...) end);
ZLM:RegisterEvent("CHAT_MSG_GUILD",function(...) ZLM.ChatEvent("CHAT_MSG_GUILD",...) end);
ZLM:RegisterEvent("CHAT_MSG_BN_WHISPER",function(...) ZLM:ChatEvent("CHAT_MSG_BN_WHISPER",...); end);
]]


