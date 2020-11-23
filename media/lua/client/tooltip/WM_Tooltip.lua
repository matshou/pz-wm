---@class Tooltip
Tooltip = {}

--- Font used by mod for UI tooltips
--- @type UIFont
Tooltip.font = UIFont.Small;

--- Height of custom tooltip line
Tooltip.line_height = 15;

--- Used to adjust tooltip width
Tooltip.width_offset = 25;

--- Tooltip colors in RGB format (0-100)
--- @class TooltipColor
TooltipColor = {
	blue = { 0.4, 0.7, 1 },
	grey = { 0.5, 0.5, 0.5 },
	orange = { 1, 0.6, 0.2 },
}

---@class TooltipText
TooltipText = {
	--- @type TooltipColor
	color = nil;
}

---@return TooltipText
function TooltipText:new(color)
	local o = {};
	setmetatable(o, self);
	o.color = color;
	o.lines = 0;
	return o;
end

--- @class TooltipTextLine
TooltipTextLine = {
	text = "",
	---@type table | int
	color = {},
}

--- @return TooltipTextLine
function TooltipTextLine:new(text, color)
	local o = {};
	setmetatable(o, self);
	o.text, o.color = text, color;
	return o;
end

--- @param text string
--- @param color TooltipColor
function TooltipText:addLine(text, color)

	color = color and color or self.color;
	table.insert(self, TooltipTextLine:new(text, color));
	self.lines = self.lines + 1;
end

--- @return TooltipTextLine
function TooltipText:getLine(n)
	return self[n];
end

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
		Tooltip.renderWalkman(self, data);
	elseif item_name == "Cassette" and self.item:hasModData() then
		Tooltip.renderCassette(self, data);
	end
	return old_render(self);
end