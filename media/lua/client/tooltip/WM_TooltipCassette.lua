
function Tooltip.renderCassette(self, data)

    local tt_text = TooltipText:new(TooltipColor.orange);

    tt_text:addLine(tostring("Artist: " .. Cassette.getArtist(data.num)));
    tt_text:addLine(tostring("Artist: " .. Cassette.getAlbum(data.num)));

    local stage, height = 1, 0;
    local tt_height = 2 * Tooltip.line_height;

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
                    getTextWidth(Tooltip.font, tt_text:getLine(1).text),
                    getTextWidth(Tooltip.font, tt_text:getLine(2).text)
            );
            stage, num = 3, math.max(num, text_width + Tooltip.width_offset);
        end
        return old_setWidth(self, num, ...);
    end

    local old_drawRectBorder = self.drawRectBorder
    self.drawRectBorder = function(self, ...)
        if stage == 3 then
            local r, g, b = tt_text.color[1], tt_text.color[2], tt_text.color[3];
            -- artist name
            self.tooltip:DrawText(Tooltip.font, tt_text:getLine(1).text, 5, height-4, r, g, b, 1);
            -- album title
            self.tooltip:DrawText(Tooltip.font, tt_text:getLine(2).text, 5, height+11, r, g, b, 1);
            -- end drawing tooltip
            stage = 4;
        end
        return old_drawRectBorder(self, ...);
    end
end