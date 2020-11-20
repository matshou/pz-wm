Walkman = {};

-- return available mod data or newly initialized mod data
-- helper method to prevent items spawned through command having no data
function Walkman.getOrInitData(item)
	return item:hasModData() and item:getModData() or Walkman.Init(getSpecificPlayer(0), item);
end

function Walkman.isCassetteInserted(data)
	return data and data.tape_num > 0;
end

function Walkman.Init(player, item)

	local data = item:getModData();

	data.power_state = false;
	data.tape_state = 1;

	data.tape_num = 0;
	data.track_num = 0;

	return data;
end
