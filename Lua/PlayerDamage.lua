
local update_original = PlayerDamage.update

function PlayerDamage:update(...)
	update_original(self, ...)
	if managers.hud and managers.hud._hud_banghud then
		managers.hud._hud_banghud:update_armor_timer(self._regenerate_timer or 0)
	end
end
