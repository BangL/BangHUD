
Hooks:Add("MenuManagerInitialize", "MenuManagerInitialize_BangHUD", function(menu_manager)

	function MenuCallbackHandler:callback_swap_bars(item)
		BangHUD._data.swap_bars = (item:value() == "on")
		BangHUD:OptionChanged()
	end
	function MenuCallbackHandler:callback_bars_scale(item)
		BangHUD._data.bars_scale = item:value()
		BangHUD:OptionChanged()
	end
	function MenuCallbackHandler:callback_center_margin(item)
		BangHUD._data.center_margin = item:value()
		BangHUD:OptionChanged()
	end
	function MenuCallbackHandler:callback_bars_alpha(item)
		BangHUD._data.bars_alpha = item:value()
		BangHUD:OptionChanged()
	end
	function MenuCallbackHandler:callback_background_alpha(item)
		BangHUD._data.background_alpha = item:value()
		BangHUD:OptionChanged()
	end

	BangHUD:Load()
	MenuHelper:LoadFromJsonFile(BangHUD._path .. "Menu/menu.json", BangHUD, BangHUD._data)
end)
