CASSETTE_TAPE = {};

-- Initialize cassette item by assigning a random tape number
function InitCassetteItem(player, item)

	local data = item:getModData();

	data.num = ZombRand(#CASSETTE_TAPE) + 1;
	data.track = 1;

	return data;
end

function getCassetteName(num)
	return CASSETTE_TAPE[num].tape_name;
end
