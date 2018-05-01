ZLM_Debug =  function(message,severity)
    if ZLM_Options.PrintLevel > severity then
        print(message);
    end
end
ZLM_OptionsTable = {
	type = "group",
    chidlGroups = "tab",
	args = {
        config = {
            name = "Config",
            type="group",
            args = {
                enable = {
                    name = "Enable",
                    desc = "Enables/disables the addon",
                    type = "toggle",
                    set = function(_,val) ZLM_Options.Enabled = val; end,
                    get = function(_) return ZLM_Options.Enabled; end
                },
                debug = {
                    name = "Debug",
                    desc = "Displays addon output messages.  Lower values show only urgent messages.  Higher values show all messages.",
                    type = "range",
                    min = 0,
                    max = 4,
                    step = 1,
                    bigStep = 1,
                    set = function(_,val) ZLM_Options.PrintLevel = val; end,
                    get = function(_) return ZLM_Options.PrintLevel; end
                }
            }
        },
		LotteryItems = {
			name = "Lottery Items",
			type = "group",
			args = {
				addNew = {
					name = "Add New",
					desc = "Add a new lottery item.",
					type = "execute",
					func = ZLM_Options:addNewLotteryItem();
				},
				sort = {
					name="Sort",
					desc = "Sorts the lottery items by ItemID",
					type="execute",
					func = ZLM_Options:sortLotteryItems();
				},
				list = {
					name = "List",
					desc = "List of lottery items.",
					type = "group",
                    childGroups = "inline",
					args = {

					}
				}
			}
		}
	}
}

ZLM_Options = ZLM_Options or {
	Enabled = true,
    PrintLevel = 0
}

ZLM_LotteryItem = {};
function ZLM_LotteryItem:new()
	local entry = {};
	entry.WoWItemId = 0;
	entry.ItemName = "";
	entry.Active = false;
	entry.HotItem = false;
	entry.Multiplier = false;
	entry.PointValue = 0;
	return entry;
end

ZLM_Ace3LotteryItem = {};
function ZLM_Ace3LotteryItem:new()
	local entry = {};
	entry.args = {
		wowItemId = ZLM_Ace3Input:new("WoW Item Id","%d")
    };
	return entry;
end

ZLM_Ace3NewInput = {};
function ZLM_Ace3Input:new(name,set,get,pattern)
	return {
		name = name,
		type = "input",
		pattern = pattern,
		set = set,
		get = get
	};
end

ZLM_DefaultLotteryItemSetter = function(info,value)
    ZLM_Options.LotteryItems.List[info[#info-1]][info[#info]] = value;
    ZLM_Debug("Setting Value: ZLM_Options.LotteryItems.List." .. info[#info-1] .. "." .. info[#info] .. " = " .. value,3);
end
ZLM_DefaultLotteryItemGetter = function(info)
    return ZLM_Options.LotteryItems.List[info[#info-1]][info[#info]];
end