local function AddContextOption(player, context, item)

    if not item:hasModData() then
        if item:getType() == "Walkman" then
            context:addOption(getText("IGUI_invpanel_Inspect"), player, Walkman.Init, item);
        elseif item:getType() == "Cassette" then
            context:addOption(getText("IGUI_invpanel_Inspect"), player, Cassette.Init, item);
        end
    end
end

local inspectContextMenu = function(player, context, worldobjects)

    local playerObj = getSpecificPlayer(player);

    for _,k in pairs(worldobjects) do
		-- inventory item list
        if instanceof(k, "InventoryItem") then
            AddContextOption(playerObj, context, k);
		elseif k.items and #k.items > 1 then
            AddContextOption(playerObj, context, k.items[1]);
        end
    end
end

Events.OnFillInventoryObjectContextMenu.Add(inspectContextMenu);