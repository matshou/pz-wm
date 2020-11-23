
function Tooltip.renderWalkman(self, data)

    local tt_text = TooltipText:new(TooltipColor.blue);

    if Walkman.isPoweredOn(data) then
        if Walkman.isCassetteInserted(data) then
            tt_text:addLine(tostring("Tape: " .. Cassette.getTape(data.tape_num)));
            if (data.play_state > 0) then
                tt_text:addLine(tostring("Playing: Track " .. data.track_num));
            else
                tt_text:addLine(tostring("Ready: Track " .. data.track_num), TooltipColor.orange);
            end
        else
            tt_text:addLine("Insert cassette tape");
        end
    else
        tt_text:addLine("Turned off", TooltipColor.grey);
    end

    local stage, height = 1, 0;
    local old_setHeight = self.setHeight
    self.setHeight = function(self, num, ...)
        if stage == 1 then
            stage, height = 2, num;
            num = num + (tt_text.lines * Tooltip.line_height);
        end
        return old_setHeight(self, num, ...);
    end
    local old_setWidth = self.setWidth
    self.setWidth = function(self, num, ...)
        if stage == 2 then
            local text_width = getTextWidth(Tooltip.font, tt_text:getLine(1).text);
            stage, num = 3, math.max(num, text_width + Tooltip.width_offset);
        end
        return old_setWidth(self, num, ...);
    end

    local old_drawRectBorder = self.drawRectBorder
    self.drawRectBorder = function(self, ...)
        if stage == 3 then
            -- tape name
            if tt_text.lines >= 1 then
                local line = tt_text:getLine(1);
                local r, g, b = line.color[1], line.color[2], line.color[3];
                self.tooltip:DrawText(Tooltip.font, line.text, 5, height-4, r, g, b, 1);
            end
            -- track name
            if tt_text.lines >= 2 then
                local line = tt_text:getLine(2)
                local r, g, b = line.color[1], line.color[2], line.color[3];
                self.tooltip:DrawText(Tooltip.font, line.text, 5, height+11, r, g, b, 1);
            end
            -- end drawing tooltip
            stage = 4;
        end
        return old_drawRectBorder(self, ...);
    end
end