-- return available mod data or newly initialized mod data
-- helper method to prevent items spawned through command having no data
function getOrInitWalkmanData(item)
	return item:hasModData() and item:getModData() or InitWalkmanItem(getSpecificPlayer(0), item);
end

function isCassetteInserted(data)
	return data and data.tape_num > 0;
end

function InitWalkmanItem(player, item)

	local inventory = player:getInventory();

	inventory:DoRemoveItem(item);
	item = inventory:AddItem("WM.Walkman");

	local data = item:getModData();

	data.power_state = false;
	data.tape_state = 1;

	data.tape_num = 0;
	data.track_num = 0;

	return data;
end
