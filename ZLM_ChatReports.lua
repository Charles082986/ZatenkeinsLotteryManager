local words = {
    -- add words to respond to
    "^lotto",
    "^!lotto" ,
    "^!lottery",
    "^lottery"

};
local ZLMPrefixPattern = "%[ZLM\]";
local ZLMPrefix = "[ZLM]";
local caseInsensitiveWords = {};
for k,v in pairs(words) do
    -- replaces "words" with "[Ww][Oo][Rr][Dd][Ss]"
    caseInsensitiveWords[v],_ = string.gsub(v,"%a",function(a) return "["..a:upper()..a:lower().."]" end);
end;
function ZLM:PlayerName()
    local player, _ = UnitName("player");
    --Try to give back Sinderion-ShadowCouncil style name every time. No spaces, full name-realm.
    --If the name is short, like Sinderion only, add realm.
    if not string.match(player,"-") then
        local realm = GetRealmName();
        player = player.."-"..realm;
        --player = player .."-".. string.gsub(realm,"%s", "");
    end
    --Remove Spaces
    --player = string.gsub(player,"%s", "")
    return player;
end
function ZLM:ChatReport(player,test)
    local output = {};
    local prefix;
    local prefixpattern;
    if test then
     prefixpattern = "don'tmatchme";
        prefix = "[test]"
    else
        prefixpattern = ZLMPrefixPattern;
        prefix = ZLMPrefix;
    end
    SendChatMessage(prefix.." ZLM Standings:", "WHISPER", nil, player);
    --Find if guy messaging is on the Scoreboard.
    for i,v in ipairs(ZLM_ScoreboardData) do
        if v.Name == ZLM:PlayerName() or v.Name == UnitName("player") then
            -- Insert personalized report.
            SendChatMessage(prefix.." Your rank: "..i, "WHISPER", nil, player);
        end
    end
    --Reply with the whole list.
    SendChatMessage(prefix.." Rank--Points--Name", "WHISPER", nil, player);
    for i,v in ipairs(ZLM_ScoreboardData) do
        local rank = i;
        local character = v.Name;
        local points = v.Points;
        SendChatMessage(prefix..rank.." ....... "..points.." ....... "..character, "WHISPER", nil, player);
    end
    SendChatMessage(prefix.."------------------", "WHISPER", nil, player);
    print("Lottery info sent to: "..player)

end
function ZLM:CHAT_MSG_WHISPER(event, message, author,...)
        for k, v in pairs(caseInsensitiveWords) do
            if not not string.match(message,v) then
                local test = not not string.match(message,"^lottotest");
                ZLM:ChatReport(author,test);
            end
        end
end
function ZLM_ChatFilter(self,event,myChatMessage, author,...)
    if type(myChatMessage) == "string" then
    --Hide whisper if it's our prefix
        if not not string.match(myChatMessage,ZLMPrefixPattern) then
            --print("It's a prefix!"..myChatMessage.." == "..ZLMPrefix);
            return true, myChatMessage, author, ...;
        end
    --Hide whisper if it's one of our words.
        for k, v in pairs(caseInsensitiveWords) do
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
ZLM:RegisterEvent("CHAT_MSG_WHISPER");




