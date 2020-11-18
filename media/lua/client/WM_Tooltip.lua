-- height of custom tooltip line
local TT_LINE_HEIGHT = 15;

-- tooltip colors in RGB format (0-100)
local TT_COLOR = {
	[1] = { 0.4, 0.7, 1 },		-- blue
	[2] = { 0.5, 0.5, 0.5 },	-- grey
	[3] = { 1, 0.6, 0.2 },		-- orange
}
-- cassette player tape state
local TAPE_STATE = {
	[1] = { "Ready", 0.4, 0.7, 1 },
	[2] = { "Playing", 1, 0.6, 0.2 },
}
local old_render = ISToolTipInv.render;
function ISToolTipInv:render()

	local item_name = self.item:getType();
	local data = self.item:getModData();

	if item_name == "Walkman" then

		local tape_state = TAPE_STATE[data.tape_state];
		local tt_lines, tt_title, tt_state;

		if data.power_state then
			tt_color = TT_COLOR[1];
			if isCassetteInserted(data) then
				tt_title = tostring("Tape: " .. getCassetteName(data.tape_num));
				tt_state = tostring(tape_state[1] .. ": Track " .. data.track_num);
				tt_lines = 2;
			else
				tt_lines, tt_title = 1, "Insert cassette tape";
			end
		else
			tt_lines, tt_color = 1, TT_COLOR[2];
			tt_title = "Turned off";
		end

		local stage, height = 1, 0;
		local old_setHeight = self.setHeight
		self.setHeight = function(self, num, ...)
			if stage == 1 then
				stage, height = 2, num;
				num = num + (tt_lines * TT_LINE_HEIGHT);
			end
			return old_setHeight(self, num, ...);
		end

		local old_drawRectBorder = self.drawRectBorder
		self.drawRectBorder = function(self, ...)
			if stage == 2 then
				local r, g, b = tt_color[1], tt_color[2], tt_color[3];
				-- tape name
				if tt_lines >= 1 then
					self.tooltip:DrawText(UIFont.Small, tt_title, 5, height-4, r, g, b, 1);
				end
				-- track name
				if tt_lines >= 2 then
					r, g, b = tape_state[2], tape_state[3], tape_state[4];
					self.tooltip:DrawText(UIFont.Small, tt_state, 5, height+11, r, g, b, 1);
				end
				-- end drawing tooltip
				stage = 3;
			end
			return old_drawRectBorder(self, ...);
		end
	end
	return old_render(self);
end