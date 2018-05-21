ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER",ZLM.ChatFilter);
ZLM:RegisterEvent("CHAT_MSG_WHISPER");
local words = {
    -- add words to respond to
    "^lotto",
    "^!lotto" ,
    "^!lottery",
    "^lottery"

};
local MyPrefix = "[Lotto]";
local caseInsensitiveWords = {};
for k,v in pairs(words) do
    -- replaces "words" with "[Ww][Oo][Rr][Dd][Ss]"
    caseInsensitiveWords[v],_ = string.gsub(v,"%a",function(a) return "["..a:upper()..a:lower().."]" end);
end;


function ZLM:ChatReport(player)
    -- ***** Add prefix after testing
    SendChatMessage("This is a test reply!", "WHISPER", nil, player);
    SendChatMessage("More of a test reply!", "WHISPER", nil, player);
end


function ZLM:CHAT_MSG_WHISPER(event, message, author,...)
        for k, v in pairs(caseInsensitiveWords) do
            if not not string.match(message,v) then
                ZLM:ChatReport(author);
            end
        end
end




function ZLM:ChatFilter(self,event,myChatMessage, author,...)
    --Hide whisper if it's our prefix
    if string.match(myChatMessage,MyPrefix) then
        return true, event, myChatMessage, author, ...;
    end
    --Hide whisper if it's one of our words.
    for k, v in pairs(caseInsensitiveWords) do
        if not not string.match(myChatMessage,v) then
            return true, myChatMessage, author, ...;
        end
    end
    return false, myChatMesssage, author,...
end






