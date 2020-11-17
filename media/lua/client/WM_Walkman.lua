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
