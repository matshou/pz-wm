--- Static class for handling cassette data
--- @class Cassette
Cassette = {};

--- Static table that holds cassette data
--- @type table
CASSETTE_TAPE = {};

--- @param item InventoryItem @cassette item
--- @return KahluaTable @existing or initialized mod data table
function Cassette.getOrInitData(item)
	return item:hasModData() and item:getModData() or Cassette.Init(nil, item);
end

--- Initialize cassette item by assigning random tape number
---
--- @param item InventoryItem @cassette to initialize
--- @return KahluaTable @initialized mod data table
function Cassette.Init(_, item)

	local data = item:getModData();

	data.num = ZombRand(#CASSETTE_TAPE) + 1;
	data.track = 1;

	return data;
end

--- @param num int @cassette tape number
--- @return string @cassette tape name
function Cassette.getTape(num)
	return CASSETTE_TAPE[num].tape_name;
end

--- @param tape int @cassette tape number
--- @return string @artist name for cassette tape
function Cassette.getArtist(tape)
	return CASSETTE_TAPE[tape].artist_name;
end

--- @param tape int @cassette tape number
--- @return string @album name for cassette tape
function Cassette.getAlbum(tape)
	return CASSETTE_TAPE[tape].album_title;
end

end
