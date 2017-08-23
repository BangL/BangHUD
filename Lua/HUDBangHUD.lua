BangHUD:SafeDoFile("OutlineText")

function round(val, dec)
	dec = math.pow(10, dec or 0)
	val = val * dec
	val = val >= 0 and math.floor(val + 0.5) or math.ceil(val - 0.5)
	return val / dec
end

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

	self._armor_arc = self._banghud_panel:bitmap({
		name = "armor_arc",
		texture = armor_texture,
		color = Color.white,
		w = self._texture_sidelen,
		h = self._texture_sidelen,
		blend_mode = "add",
		render_template = "VertexColorTexturedRadial",
		layer = 1
	})
	self._health_arc = self._banghud_panel:bitmap({
		name = "health_arc",
		texture = health_texture,
		color = Color.white,
		w = self._texture_sidelen,
		h = self._texture_sidelen,
		blend_mode = "add",
		render_template = "VertexColorTexturedRadial",
		layer = 1
	})
	self._armor_arc_bg = self._banghud_panel:bitmap({
		name = "armor_arc_bg",
		texture = border_texture,
		color = Color.white,
		w = self._texture_sidelen,
		h = self._texture_sidelen,
		blend_mode = "normal"
	})
	self._health_arc_bg = self._banghud_panel:bitmap({
		name = "health_arc_bg",
		texture = border_texture,
		color = Color.white,
		w = self._texture_sidelen,
		h = self._texture_sidelen,
		blend_mode = "normal"
	})

	self._armor_timer = OutlineText:new(self._banghud_panel, {
		text = "0.0s",
		color = Color.white,
		visible = false,
		align = "left",
		vertical = "bottom",
		font = tweak_data.hud_players.name_font,
		font_size = 22,
		layer = 2
	})

	self:update()
end

function HUDBangHUD:update()
	local swap = BangHUD:GetOption("swap_bars")
	local scale = BangHUD:GetOption("bars_scale") / 3
	local margin = BangHUD:GetOption("center_margin")
	local alpha = BangHUD:GetOption("bars_alpha")
	local bg_alpha = BangHUD:GetOption("background_alpha")

	self._armor_arc:set_size(self._texture_sidelen * scale, self._texture_sidelen * scale)
	self._health_arc:set_size(self._texture_sidelen * scale, self._texture_sidelen * scale)
	self._armor_arc_bg:set_size(self._texture_sidelen * scale, self._texture_sidelen * scale)
	self._health_arc_bg:set_size(self._texture_sidelen * scale, self._texture_sidelen * scale)

	if swap then
		self._health_arc:set_center_x(self._banghud_panel:w() / 2 - margin / 2)
		self._armor_arc:set_center_x(self._banghud_panel:w() / 2 + margin / 2)
		self._armor_arc:set_texture_rect(self._texture_sidelen, 0, -self._texture_sidelen, self._texture_sidelen)
		self._health_arc:set_texture_rect(0, 0, self._texture_sidelen, self._texture_sidelen)
		self._armor_arc_bg:set_texture_rect(self._texture_sidelen, 0, -self._texture_sidelen, self._texture_sidelen)
		self._health_arc_bg:set_texture_rect(0, 0, self._texture_sidelen, self._texture_sidelen)
	else
		self._armor_arc:set_center_x(self._banghud_panel:w() / 2 - margin / 2)
		self._health_arc:set_center_x(self._banghud_panel:w() / 2 + margin / 2)
		self._health_arc:set_texture_rect(self._texture_sidelen, 0, -self._texture_sidelen, self._texture_sidelen)
		self._armor_arc:set_texture_rect(0, 0, self._texture_sidelen, self._texture_sidelen)
		self._health_arc_bg:set_texture_rect(self._texture_sidelen, 0, -self._texture_sidelen, self._texture_sidelen)
		self._armor_arc_bg:set_texture_rect(0, 0, self._texture_sidelen, self._texture_sidelen)
	end
	self._armor_arc:set_center_y(self._banghud_panel:h() / 2)
	self._health_arc:set_center_y(self._banghud_panel:h() / 2)
	self._armor_arc_bg:set_center(self._armor_arc:center())
	self._health_arc_bg:set_center(self._health_arc:center())

	self._armor_timer:set_bottom(self._armor_arc:bottom())
	if swap then
		self._armor_timer:set_right(self._armor_arc:right())
		self._armor_timer:set_align("right")
	else
		self._armor_timer:set_left(self._armor_arc:left())
		self._armor_timer:set_align("left")
	end

	self._armor_arc:set_alpha(alpha)
	self._health_arc:set_alpha(alpha)
	self._armor_arc_bg:set_alpha(bg_alpha)
	self._health_arc_bg:set_alpha(bg_alpha)

	self:_update_health()
	self:_update_armor()

	self:update_armor_timer(0)
end

function HUDBangHUD:_health_percentage()
	local value = 1
	if self._health_data then
		value = self._health_data.current / self._health_data.total
		if BangHUD:GetOption("frenzy_relative") then
			value = self._health_data.current / (self._health_data.total * self:_max_health_reduction())
		end
	end
	return math.clamp(value, 0, 1)
end

function HUDBangHUD:_update_health()
	self._health_arc:set_color(Color(1, 0.5 + self:_health_percentage() * 0.5, 1, 1))
	self:update_visbility()
end

function HUDBangHUD:_armor_percentage()
	local value = 1
	if self._armor_data then
		value = self._armor_data.current / self._armor_data.total
	end
	return math.clamp(value, 0, 1)
end

function HUDBangHUD:_update_armor()
	self._armor_arc:set_color(Color(1, 0.5 + self:_armor_percentage() * 0.5, 1, 1))
	self:update_visbility()
end

function HUDBangHUD:update_armor_timer(t)
	if t and t > 0 then
		t = string.format("%.1f", round(t, 1)) .. "s"
		self._armor_timer:set_text(t)
		self._armor_timer:set_visible(true)
	elseif self._armor_timer:visible() then
		self._armor_timer:set_visible(false)
	end
end

function HUDBangHUD:update_visbility()
	local hide = BangHUD:GetOption("hide_in_stealth") and managers.groupai and managers.groupai:state() and managers.groupai:state():whisper_mode()
	local hide_at_frenzy_cap = BangHUD:GetOption("hide_at_frenzy_cap") and not BangHUD:GetOption("frenzy_relative")
	if not hide and BangHUD:GetOption("hide_when_full") and (self:_health_percentage() >= (hide_at_frenzy_cap and (self:_max_health_reduction() - 0.01) or 0.99)) and self:_armor_percentage() >= 0.99 then
		hide = true
	end
	if hide and BangHUD:GetOption("always_show_when_hurt") and ((self:_health_percentage() < (hide_at_frenzy_cap and (self:_max_health_reduction() - 0.01) or 0.99)) or self:_armor_percentage() < 0.99) then
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

function HUDBangHUD:set_health(data)
	self._health_data = data
	self:_update_health()
end

function HUDBangHUD:set_armor(data)
	self._armor_data = data
	self:_update_armor()
end

function HUDBangHUD:_max_health_reduction()
	return managers.player and managers.player:upgrade_value("player", "max_health_reduction", 1) or 1
end