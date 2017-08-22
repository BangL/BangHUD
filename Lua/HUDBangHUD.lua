
HUDBangHUD = HUDBangHUD or class()

function HUDBangHUD:init(hud)
	self._hud_panel = hud.panel

	if self._hud_panel:child("banghud_panel") then
		self._hud_panel:remove(self._hud_panel:child("banghud_panel"))
	end

	self._banghud_panel = self._hud_panel:panel({
		name = "banghud_panel",
		alpha = 0,
		layer = 1
	})
	self._banghud_panel:set_size(self._banghud_panel:parent():w(), self._banghud_panel:parent():h())
	self._banghud_panel:set_center(self._banghud_panel:parent():w() / 2, self._banghud_panel:parent():h() / 2)

	self._texture_sidelen = 512
	local armor_texture = "guis/textures/trial_diamondheist"
	local health_texture = "guis/textures/trial_slaughterhouse"
	local border_texture = "guis/textures/trial_street"

	self._armor_panel = self._banghud_panel:bitmap({
		name = "armor_panel",
		texture = armor_texture,
		color = Color(1, 1, 1, 1),
		w = self._texture_sidelen,
		h = self._texture_sidelen,
		blend_mode = "add",
		render_template = "VertexColorTexturedRadial",
		layer = 1
	})
	self._health_panel = self._banghud_panel:bitmap({
		name = "health_panel",
		texture = health_texture,
		color = Color(1, 1, 1, 1),
		w = self._texture_sidelen,
		h = self._texture_sidelen,
		blend_mode = "add",
		render_template = "VertexColorTexturedRadial",
		layer = 1
	})
	self._armor_bg = self._banghud_panel:bitmap({
		name = "armor_bg",
		texture = border_texture,
		color = Color(1, 1, 1, 1),
		w = self._texture_sidelen,
		h = self._texture_sidelen,
		blend_mode = "normal"
	})
	self._health_bg = self._banghud_panel:bitmap({
		name = "health_bg",
		texture = border_texture,
		color = Color(1, 1, 1, 1),
		w = self._texture_sidelen,
		h = self._texture_sidelen,
		blend_mode = "normal"
	})

	self.health_value = 1
	self.armor_value = 1

	self:update()
end

function HUDBangHUD:update()
	local swap = BangHUD:GetOption("swap_bars")
	local scale = BangHUD:GetOption("bars_scale") / 3
	local margin = BangHUD:GetOption("center_margin")
	local alpha = BangHUD:GetOption("bars_alpha")
	local bg_alpha = BangHUD:GetOption("background_alpha")

	self._armor_panel:set_size(self._texture_sidelen * scale, self._texture_sidelen * scale)
	self._health_panel:set_size(self._texture_sidelen * scale, self._texture_sidelen * scale)
	self._armor_bg:set_size(self._texture_sidelen * scale, self._texture_sidelen * scale)
	self._health_bg:set_size(self._texture_sidelen * scale, self._texture_sidelen * scale)

	if swap then
		self._health_panel:set_center_x(self._banghud_panel:w() / 2 - margin / 2)
		self._armor_panel:set_center_x(self._banghud_panel:w() / 2 + margin / 2)
		self._armor_panel:set_texture_rect(self._texture_sidelen, 0, -self._texture_sidelen, self._texture_sidelen)
		self._health_panel:set_texture_rect(0, 0, self._texture_sidelen, self._texture_sidelen)
		self._armor_bg:set_texture_rect(self._texture_sidelen, 0, -self._texture_sidelen, self._texture_sidelen)
		self._health_bg:set_texture_rect(0, 0, self._texture_sidelen, self._texture_sidelen)
	else
		self._armor_panel:set_center_x(self._banghud_panel:w() / 2 - margin / 2)
		self._health_panel:set_center_x(self._banghud_panel:w() / 2 + margin / 2)
		self._health_panel:set_texture_rect(self._texture_sidelen, 0, -self._texture_sidelen, self._texture_sidelen)
		self._armor_panel:set_texture_rect(0, 0, self._texture_sidelen, self._texture_sidelen)
		self._health_bg:set_texture_rect(self._texture_sidelen, 0, -self._texture_sidelen, self._texture_sidelen)
		self._armor_bg:set_texture_rect(0, 0, self._texture_sidelen, self._texture_sidelen)
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
	self:update_visbility()
end

function HUDBangHUD:_update_health()
	self._health_panel:set_color(Color(1, 0.5 + self.health_value * 0.5, 1, 1))
	self:update_visbility()
end

function HUDBangHUD:_update_armor()
	self._armor_panel:set_color(Color(1, 0.5 + self.armor_value * 0.5, 1, 1))
	self:update_visbility()
end

function HUDBangHUD:update_visbility()
	local hide = BangHUD:GetOption("hide_in_stealth") and managers.groupai and managers.groupai:state() and managers.groupai:state():whisper_mode()
	if not hide and BangHUD:GetOption("hide_when_full") and self.health_value >= 0.99 and self.armor_value >= 0.99 then
		hide = true
	end
	if hide and BangHUD:GetOption("always_show_when_hurt") and (self.health_value < 0.99 or self.armor_value < 0.99) then
		hide = false
	end
	if not hide then
		self._banghud_panel:stop()
		self._banghud_panel:set_alpha(1)
	elseif self._banghud_panel:alpha() == 1 then
		self._banghud_panel:stop()
		self._banghud_panel:animate(callback(self, self, "_fade_out_animation"))
	end
end

function HUDBangHUD:_fade_out_animation(panel)
	local duration = BangHUD:GetOption("fade_out_time")
	local t = duration
	panel:set_alpha(1)
	while t > 0 do
		t = t - coroutine.yield()
		panel:set_alpha(math.clamp(t / duration, 0, 1))
	end
	panel:set_alpha(0)
end

function HUDBangHUD:set_health(value)
	self.health_value = value
	self:_update_health()
end

function HUDBangHUD:set_armor(value)
	self.armor_value = value
	self:_update_armor()
end
