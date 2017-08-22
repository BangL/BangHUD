
HUDBangHUD = HUDBangHUD or class()

function HUDBangHUD:init(hud)
	self._hud_panel = hud.panel

	if self._hud_panel:child("banghud_panel") then
		self._hud_panel:remove(self._hud_panel:child("banghud_panel"))
	end

	self._banghud_panel = self._hud_panel:panel({
		name = "banghud_panel",
		layer = 1
	})
	self._banghud_panel:set_size(self._banghud_panel:parent():w(), self._banghud_panel:parent():h())
	self._banghud_panel:set_center(self._banghud_panel:parent():w() / 2, self._banghud_panel:parent():h() / 2)

	local armor_texture = "guis/textures/trial_diamondheist"
	local health_texture = "guis/textures/trial_slaughterhouse"
	local border_texture = "guis/textures/trial_street"

	self._armor_panel = self._banghud_panel:bitmap({
		name = "armor_panel",
		texture = armor_texture,
		color = Color(1, 1, 1, 1),
		w = 512,
		h = 512,
		blend_mode = "add",
		render_template = "VertexColorTexturedRadial",
		layer = 1
	})
	self._health_panel = self._banghud_panel:bitmap({
		name = "health_panel",
		texture = health_texture,
		color = Color(1, 1, 1, 1),
		w = 512,
		h = 512,
		blend_mode = "add",
		render_template = "VertexColorTexturedRadial",
		layer = 1
	})
	self._armor_bg = self._banghud_panel:bitmap({
		name = "armor_bg",
		texture = border_texture,
		color = Color(1, 1, 1, 1),
		w = 512,
		h = 512,
		blend_mode = "normal"
	})
	self._health_bg = self._banghud_panel:bitmap({
		name = "health_bg",
		texture = border_texture,
		color = Color(1, 1, 1, 1),
		w = 512,
		h = 512,
		blend_mode = "normal"
	})

	self.health_value = 1
	self.armor_value = 1

	self:update()
end

function HUDBangHUD:update()
	local swap = BangHUD:GetOption("swap_bars")
	local scale = BangHUD:GetOption("bars_scale") * 0.3
	local margin = BangHUD:GetOption("center_margin")
	local alpha = BangHUD:GetOption("bars_alpha")
	local bg_alpha = BangHUD:GetOption("background_alpha")

	self._armor_panel:set_size(512 * scale, 512 * scale)
	self._health_panel:set_size(512 * scale, 512 * scale)
	self._armor_bg:set_size(512 * scale, 512 * scale)
	self._health_bg:set_size(512 * scale, 512 * scale)

	if swap then
		self._health_panel:set_center_x(self._banghud_panel:w() / 2 - margin / 2)
		self._armor_panel:set_center_x(self._banghud_panel:w() / 2 + margin / 2)
		self._armor_panel:set_texture_rect(512, 0, -512, 512)
		self._health_panel:set_texture_rect(0, 0, 512, 512)
		self._armor_bg:set_texture_rect(512, 0, -512, 512)
		self._health_bg:set_texture_rect(0, 0, 512, 512)
	else
		self._armor_panel:set_center_x(self._banghud_panel:w() / 2 - margin / 2)
		self._health_panel:set_center_x(self._banghud_panel:w() / 2 + margin / 2)
		self._health_panel:set_texture_rect(512, 0, -512, 512)
		self._armor_panel:set_texture_rect(0, 0, 512, 512)
		self._health_bg:set_texture_rect(512, 0, -512, 512)
		self._armor_bg:set_texture_rect(0, 0, 512, 512)
	end
	self._armor_panel:set_center_y(self._banghud_panel:h() / 2)
	self._health_panel:set_center_y(self._banghud_panel:h() / 2)
	self._armor_bg:set_center(self._armor_panel:center())
	self._health_bg:set_center(self._health_panel:center())

	self._armor_panel:set_alpha(alpha)
	self._health_panel:set_alpha(alpha)
	self._armor_bg:set_alpha(bg_alpha)
	self._health_bg:set_alpha(bg_alpha)

	self:_update_health()
	self:_update_armor()
end

function HUDBangHUD:_update_health()
	self._health_panel:set_color(Color(1, 0.5 + self.health_value * 0.5, 1, 1))
end

function HUDBangHUD:_update_armor()
	self._armor_panel:set_color(Color(1, 0.5 + self.armor_value * 0.5, 1, 1))
end

function HUDBangHUD:set_health(value)
	self.health_value = value
	self:_update_health()
end

function HUDBangHUD:set_armor(value)
	self.armor_value = value
	self:_update_armor()
end
