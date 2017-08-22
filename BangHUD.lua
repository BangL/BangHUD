
BangHUD = BangHUD or {}
if not BangHUD.setup then

	BangHUD._path = ModPath
	BangHUD._lua_path = ModPath .. "Lua/"
	BangHUD._data_path = SavePath .. "BangHUD.json"
	BangHUD._data = {} 
	BangHUD._hook_files = {
		["lib/managers/menumanager"] = "MenuManager",
		["lib/managers/localizationmanager"] = "LocalizationManager",
		["lib/managers/hudmanagerpd2"] = "HUDManagerPD2"
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
		BangHUD:Save()
		if managers and managers.hud and managers.hud._hud_banghud then
			managers.hud._hud_banghud:update()
		end
	end

	function BangHUD:LoadDefaults()
		local default_file = io.open(self._path .. "default_values.json")
		self._data = json.decode(default_file:read("*all"))
		default_file:close()
	end

	function BangHUD:createDirectory(path)
		if not file.DirectoryExists(path) then
			if SystemFS and SystemFS.make_dir then
				SystemFS:make_dir(path) -- windows
			elseif file and file.CreateDirectory then
				file.CreateDirectory(path) -- linux
			end
		end
	end

	function BangHUD:InitExtraUpdate(definition, path, update)
		self:createDirectory(update.install_dir)
		local revPath = ""
		if update.revision:sub(1, 2) == "./" then
			revPath = update.revision:sub(3, update.revision:len())
			local current = ""
			for folder in string.gmatch(revPath, "([^/]*)/") do
				current = current .. folder .. "/"
				self:createDirectory(current)
			end
		else
			local installFolder = update.install_dir .. update.install_folder
			self:createDirectory(installFolder)
			revPath = installFolder .. "/" .. update.revision
		end
		local rev = io.open(revPath, "r")
		if not rev then
			rev = io.open(revPath, "w")
			if rev then
				rev:write("0")
				rev:close()
				LuaModManager:AddUpdateCheck(definition, path, update)
			end
		end
	end

	function BangHUD:SafeDoFile(fileName)
		local fileName = BangHUD._lua_path .. fileName .. ".lua"
		local success, errorMsg = pcall(function()
			if io.file_is_readable(fileName) then
				dofile(fileName)
			end
		end)
		if not success then
			log(error .. "File: " .. fileName .. "\n" .. errorMsg)
		end
	end

	for _, mod in pairs(LuaModManager.Mods) do
		local info = mod.definition
		if info.name == "BangHUD" then
			updates = info.updates or {}
			for _, update in pairs(updates) do
				if update.install_folder and update.install_dir then
					BangHUD:InitExtraUpdate(mod.definition, mod.path, update)
				end
			end
		end
	end

	BangHUD:Load()
	BangHUD.setup = true
end

if RequiredScript then
	local requiredScript = RequiredScript:lower()
	if BangHUD._hook_files[requiredScript] then
		BangHUD:SafeDoFile(BangHUD._hook_files[requiredScript])
	end
end
