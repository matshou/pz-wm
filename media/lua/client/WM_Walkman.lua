--- Static class for handling walkman data
--- @class Walkman
Walkman = {};

--- Helper method to prevent spawned items having no data
---
--- @param item InventoryItem @item to get mod data for
--- @return KahluaTable @available or newly initialized mod data
function Walkman.getOrInitData(item)
	return item:hasModData() and item:getModData() or Walkman.init(getSpecificPlayer(0), item);
end

--- @param data KahluaTable @item mod data table
--- @return boolean @true if cassette tape is inserted
function Walkman.isCassetteInserted(data)
	return data and data.tape_num > 0;
end

--- @param data KahluaTable @item mod data table
--- @return boolean @true if currently playing music
function Walkman.isPlaying(data)
	return data and data.play_state == 1;
end

--- @param data KahluaTable @item mod data table
--- @return boolean @true if device is currently turned on
function Walkman.isPoweredOn(data)
	return data and data.power_state == 1;
end

--- Initialize (or re-initialize) device mod data
---
--- @param item InventoryItem @item to initialize
--- @return KahluaTable @initialized mod data
function Walkman.init(_, item)

	local data = item:getModData();

	data.power_state = 0;
	data.play_state = 0;

	data.tape_num = 0;
	data.track_num = 0;

	return data;
end
