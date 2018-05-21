

local words = {
    -- add words to respond to
    "^lotto",
    "^!lotto" ,
    "^!lottery",
    "^lottery"

};
local ZLMPrefixPattern = "%[Lotto\]";
local ZLMPrefix = "[Lotto]";
local caseInsensitiveWords = {};
for k,v in pairs(words) do
    -- replaces "words" with "[Ww][Oo][Rr][Dd][Ss]"
    caseInsensitiveWords[v],_ = string.gsub(v,"%a",function(a) return "["..a:upper()..a:lower().."]" end);
end;
function ZLM:ChatReport(player)
    -- ***** Add prefix after testing
    SendChatMessage(ZLMPrefix.."This is a test reply!", "WHISPER", nil, player);
    SendChatMessage(ZLMPrefix.."More of a test reply!", "WHISPER", nil, player);
end
function ZLM:CHAT_MSG_WHISPER(event, message, author,...)
        for k, v in pairs(caseInsensitiveWords) do
            if not not string.match(message,v) then
                ZLM:ChatReport(author);
            end
        end
end
function ZLM_ChatFilter(self,event,myChatMessage, author,...)

    if type(myChatMessage) == "string" then
    --Hide whisper if it's our prefix
    --print("it's a string!");
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
ZLM:RegisterEvent("CHAT_MSG_WHISPER");




