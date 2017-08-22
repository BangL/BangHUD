
Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_BangHUD", function(loc)
	loc:load_localization_file(BangHUD._path .. "Loc/english.json")
end)
