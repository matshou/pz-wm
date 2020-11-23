--- Add context options to inventory menu
---
--- @param player IsoPlayer
--- @param context ISContextMenu
local function addContextOption(player, context, item)

    if not item:hasModData() then
        if item:getType() == "Walkman" then
            context:addOption(getText("IGUI_invpanel_Inspect"), player, Walkman.init, item);
        elseif item:getType() == "Cassette" then
            context:addOption(getText("IGUI_invpanel_Inspect"), player, Cassette.init, item);
        end
    end
end

Events.OnFillInventoryObjectContextMenu.Add(function(player, context, worldobjects)

    for _,k in pairs(worldobjects) do
        if instanceof(k, "InventoryItem") then
            addContextOption(player, context, k);
        elseif k.items and #k.items > 1 then
            addContextOption(player, context, k.items[1]);
        end
    end
end);