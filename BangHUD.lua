
BangHUD = BangHUD or {}
if not BangHUD.setup then

	BangHUD._path = ModPath
	BangHUD._lua_path = ModPath .. "Lua/"
	BangHUD._data_path = SavePath .. "BangHUD.json"
	BangHUD._data = {}
	BangHUD._hook_files = {
		["lib/managers/menumanager"] = "MenuManager",
		["lib/managers/localizationmanager"] = "LocalizationManager",
		["lib/managers/hudmanagerpd2"] = "HUDManagerPD2",
		["lib/managers/group_ai_states/groupaistatebase"] = "GroupAIStateBase",
		["lib/units/beings/player/playerdamage"] = "PlayerDamage"
	}

	function BangHUD:Save()
		local file = io.open(self._data_path, "w+")
		if file then
			file:write(json.encode(self._data))
			file:close()
		end
	end

	function BangHUD:Load()
		self:LoadDefaults()
		local file = io.open(self._data_path, "r")
		if file then
			local configt = json.decode(file:read("*all"))
			file:close()
			for k,v in pairs(configt) do
				self._data[k] = v
			end
		end
		self:Save()
	end

	function BangHUD:GetOption(id)
		return self._data[id]
	end

	function BangHUD:OptionChanged()
		self:Save()
		if managers and managers.hud and managers.hud._hud_banghud then
			managers.hud._hud_banghud:update()
		end
	end

	function BangHUD:LoadDefaults()
		local default_file = io.open(self._path .. "default_values.json")
		self._data = json.decode(default_file:read("*all"))
		default_file:close()
	end

	function BangHUD:DoLuaFile(fileName)
		dofile(BangHUD._lua_path .. fileName .. ".lua")
	end

	BangHUD:Load()
	BangHUD.setup = true
end

if RequiredScript then
	local requiredScript = RequiredScript:lower()
	if BangHUD._hook_files[requiredScript] then
		BangHUD:DoLuaFile(BangHUD._hook_files[requiredScript])
	end
end