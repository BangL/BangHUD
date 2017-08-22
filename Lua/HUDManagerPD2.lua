BangHUD:SafeDoFile("HUDBangHUD")

local _setup_player_info_hud_pd2_original = HUDManager._setup_player_info_hud_pd2
local set_teammate_health_original = HUDManager.set_teammate_health
local set_teammate_armor_original = HUDManager.set_teammate_armor

function HUDManager:_setup_player_info_hud_pd2(...)
	_setup_player_info_hud_pd2_original(self, ...)
	self._hud_banghud = HUDBangHUD:new(managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2))
end

function HUDManager:set_teammate_health(i, data, ...)
	set_teammate_health_original(self, i, data, ...)
	if i == HUDManager.PLAYER_PANEL then
		self._hud_banghud:set_health(data.current / data.total)
	end
end

function HUDManager:set_teammate_armor(i, data, ...)
	set_teammate_armor_original(self, i, data, ...)
	if i == HUDManager.PLAYER_PANEL then
		self._hud_banghud:set_armor(data.current / data.total)
	end
end
