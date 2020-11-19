Cassette = {};
CASSETTE_TAPE = {};

function Cassette.getOrInitData(item)
	return item:hasModData() and item:getModData() or Cassette.Init(nil, item);
end

-- Initialize cassette item by assigning a random tape number
function Cassette.Init(player, item)

	local data = item:getModData();

	data.num = ZombRand(#CASSETTE_TAPE) + 1;
	data.track = 1;

	return data;
end

function Cassette.getName(num)
	return CASSETTE_TAPE[num].tape_name;
end

function Cassette.getArtist(num)
	return CASSETTE_TAPE[num].artist_name;
end

function Cassette.getAlbum(num)
	return CASSETTE_TAPE[num].album_title;
end
