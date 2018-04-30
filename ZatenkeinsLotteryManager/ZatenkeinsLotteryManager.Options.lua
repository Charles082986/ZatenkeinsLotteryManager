ZLM_OptionsTable = {
	type = "group",
	args = {
		enable = {
			name = "Enable",
			desc = "Enables/disables the addon",
			type = "toggle",
			set = function(info,val) ZLM_Options.Enabled = val; end,
			get = function(info) return ZLM_Options.Enabled; end
		},
		debug = {
			name = "Debug",
			desc = "Sends addon output to chat frame as print statements instead of to your selected channel.",
			type = "toggle",
			set = function(info,val) ZLM_Options.Debug = val; end,
			get = function(info) return ZLM_Options.Debug; end
		},
		LotteryItems = {
			name = "Lottery Items",
			type = "group",
			args = {
				LotteryItem1 = {
					
				}
			}
		}
	}
}

ZLM_Options = ZLM_Options or {
	Enabled = true,
	LotteryItems = {
		
	}
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
