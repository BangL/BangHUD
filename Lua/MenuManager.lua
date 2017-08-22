
Hooks:Add("MenuManagerInitialize", "MenuManagerInitialize_BangHUD", function(menu_manager)

	MenuCallbackHandler.callback_swap_bars = function(self, item)
		BangHUD._data.swap_bars = (item:value() == "on")
		BangHUD:OptionChanged()
	end
	MenuCallbackHandler.callback_bars_scale = function(self, item)
		BangHUD._data.bars_scale = item:value()
		BangHUD:OptionChanged()
	end
	MenuCallbackHandler.callback_center_margin = function(self, item)
		BangHUD._data.center_margin = item:value()
		BangHUD:OptionChanged()
	end
	MenuCallbackHandler.callback_bars_alpha = function(self, item)
		BangHUD._data.bars_alpha = item:value()
		BangHUD:OptionChanged()
	end
	MenuCallbackHandler.callback_backgorund_alpha = function(self, item)
		BangHUD._data.backgorund_alpha = item:value()
		BangHUD:OptionChanged()
	end

	BangHUD:Load()
	MenuHelper:LoadFromJsonFile(BangHUD._path .. "Menu/menu.json", BangHUD, BangHUD._data)
end)
