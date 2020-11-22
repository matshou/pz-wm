--- Font used by mod for UI tooltips
--- @type UIFont
local TT_FONT = UIFont.Small;

--- Height of custom tooltip line
local TT_LINE_HEIGHT = 15;

--- Used to adjust tooltip width
local TT_WIDTH_OFFSET = 25;

--- Tooltip colors in RGB format (0-100)
--- @class TooltipColor
TooltipColor = {
	blue = { 0.4, 0.7, 1 },
	grey = { 0.5, 0.5, 0.5 },
	orange = { 1, 0.6, 0.2 },
}
--- Cassette player tape state
local TAPE_STATE = {
	[1] = { "Ready", TooltipColor.blue },
	[2] = { "Playing", TooltipColor.orange },
}

--- Helper function to measure string width in pixels
---
--- @param text string @text to measure
--- @param font UIFont @font used by text
--- @return int @text width along x-axis for given text
function getTextWidth(font, text)
	return getTextManager():MeasureStringX(font, text);
end

local old_render = ISToolTipInv.render;
function ISToolTipInv:render()

	local item_name = self.item:getType();
	local data = self.item:getModData();

	if item_name == "Walkman" and self.item:hasModData() then

		local tape_state = TAPE_STATE[data.play_state + 1];
		local tt_lines, tt_title, tt_state, tt_color;

		if Walkman.isPoweredOn(data) then
			tt_color = TooltipColor.blue
			if Walkman.isCassetteInserted(data) then
				tt_title = tostring("Tape: " .. Cassette.getTape(data.tape_num));
				tt_state = tostring(tape_state[1] .. ": Track " .. data.track_num);
				tt_lines = 2;
			else
				tt_lines, tt_title = 1, "Insert cassette tape";
			end
		else
			tt_lines, tt_color = 1, TooltipColor.grey;
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
		local old_setWidth = self.setWidth
		self.setWidth = function(self, num, ...)
			if stage == 2 then
				local text_width = getTextWidth(TT_FONT, tt_title);
				stage, num = 3, math.max(num, text_width + TT_WIDTH_OFFSET);
			end
			return old_setWidth(self, num, ...);
		end

		local old_drawRectBorder = self.drawRectBorder
		self.drawRectBorder = function(self, ...)
			if stage == 3 then
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
				stage = 4;
			end
			return old_drawRectBorder(self, ...);
		end
	elseif item_name == "Cassette" and self.item:hasModData() then

		local tt_color = TooltipColor.orange;

		local tt_text_artist = tostring("Artist: " .. Cassette.getArtist(data.num));
		local tt_text_album = tostring("Album: " .. Cassette.getAlbum(data.num));

		local stage, height = 1, 0;
		local tt_height = 2 * TT_LINE_HEIGHT;

		local old_setHeight = self.setHeight
		self.setHeight = function(self, num, ...)
			if stage == 1 then
				stage, height = 2, num;
				num = num + tt_height;
			end
			return old_setHeight(self, num, ...);
		end
		local old_setWidth = self.setWidth
		self.setWidth = function(self, num, ...)
			if stage == 2 then
				local text_width = math.max(
						getTextWidth(TT_FONT, tt_text_artist),
						getTextWidth(TT_FONT, tt_text_album)
				);
				stage, num = 3, math.max(num, text_width + TT_WIDTH_OFFSET);
			end
			return old_setWidth(self, num, ...);
		end

		local old_drawRectBorder = self.drawRectBorder
		self.drawRectBorder = function(self, ...)
			if stage == 3 then
				local r, g, b = tt_color[1], tt_color[2], tt_color[3];
				-- artist name
				self.tooltip:DrawText(TT_FONT, tt_text_artist, 5, height-4, r, g, b, 1);
				-- album title
				self.tooltip:DrawText(TT_FONT, tt_text_album, 5, height+11, r, g, b, 1);
				-- end drawing tooltip
				stage = 4;
			end
			return old_drawRectBorder(self, ...);
		end
	end
	return old_render(self);
end