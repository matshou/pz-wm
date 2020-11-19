local function AddContextOption(player, context, item)

	if item:getType() == "CassettePlayer" then
		context:addOption(getText("IGUI_invpanel_Inspect"), player, Walkman.Init, item);
	elseif item:getType() == "Cassette" and not item:hasModData() then
		context:addOption(getText("IGUI_invpanel_Inspect"), player, Cassette.Init, item);
	end
end

local inspectContextMenu = function(player, context, worldobjects)

    local playerObj = getSpecificPlayer(player);

    for i,k in pairs(worldobjects) do
		-- inventory item list
        if instanceof(k, "InventoryItem") then
            AddContextOption(playerObj, context, k);
		elseif k.items and #k.items > 1 then
            AddContextOption(playerObj, context, k.items[1]);
        end
    end
end

Events.OnFillInventoryObjectContextMenu.Add(inspectContextMenu);