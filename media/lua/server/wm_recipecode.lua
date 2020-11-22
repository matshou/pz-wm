---------------- Recipe Helper Functions ----------------

--- Copy walkman data from first to second table
---
--- @param from KahluaTable @table to copy data from
--- @param to KahluaTable @table to copy data to
--- @return KahluaTable @copied mod data table
local function copyWalkmanData(from, to)

	to:CopyModData(Walkman.getOrInitData(from));
	to:setUsedDelta(from:getUsedDelta());

	return to:getModData();
end

----------------- Recipe TEST Functions -----------------

--- @param sourceItem InventoryItem @Walkman or Battery item
--- @return boolean @true if sourceItem has no battery power left or itself is a battery item
function Recipe_InsertBatteryIntoCassettePlayer_TestIsValid(sourceItem, _)

	if sourceItem:getType() == "Walkman" then
		return sourceItem:getUsedDelta() == 0;
	else
		return true; -- the battery
	end
end

--- @param sourceItem InventoryItem @Walkman item
--- @return boolean @true if sourceItem has battery power
function Recipe_RemoveBatteryFromCassettePlayer_TestIsValid(sourceItem, _)
	return sourceItem:getUsedDelta() > 0;
end

--- @param sourceItem InventoryItem @Walkman item
--- @return boolean @true if sourceItem has battery power and is powered on
function Recipe_TurnOnCassettePlayer_TestIsValid(sourceItem, _)

	local data = Walkman.getOrInitData(sourceItem);
	return sourceItem:getUsedDelta() > 0 and not Walkman.isPoweredOn(data);
end

--- @param sourceItem InventoryItem @Walkman item
--- @return boolean true if sourceItem is powered on
function Recipe_TurnOffCassettePlayer_TestIsValid(sourceItem, _)

	local data = Walkman.getOrInitData(sourceItem);
	return Walkman.isPoweredOn(data);
end

--- @param sourceItem InventoryItem @Walkman item
--- @return boolean true if sourceItem is powered on, cassette is inserted and is currently playing
function Recipe_PlayCassettePlayer_TestIsValid(sourceItem, _)

	local data = Walkman.getOrInitData(sourceItem);
	return Walkman.isPoweredOn(data) and
			Walkman.isCassetteInserted(data) and
			not Walkman.isPlaying(data);
end

--- @param sourceItem InventoryItem @Walkman item
--- @return boolean true if sourceItem is currently playing
function Recipe_StopCassettePlayer_TestIsValid(sourceItem, _)
	return Walkman.getOrInitData(sourceItem).play_state == 1;
end

--- Test if cassette player has no tape inserted
---
--- @param sourceItem InventoryItem @Walkman or Battery item
--- @return boolean true if sourceItem has no cassette inserted or itself is a cassette item
function Recipe_InsertCassetteIntoCassettePlayer_TestIsValid(sourceItem, _)

	if sourceItem:getType() == "Walkman" then
		local data = Walkman.getOrInitData(sourceItem);
		return not Walkman.isCassetteInserted(data);
	else
		return true; -- the cassette
	end
end

--- @param sourceItem InventoryItem @Walkman item
--- @return boolean true if sourceItem has cassette inserted
function Recipe_EjectCassetteFromCassettePlayer_TestIsValid(sourceItem, _)

	local data = Walkman.getOrInitData(sourceItem);
	return Walkman.isCassetteInserted(data);
end

------------------- Recipe Functions -------------------

--- @param items ArrayList @Battery(D) and Walkman(D) item
--- @param result InventoryItem @new instance of Walkman item
function Recipe_InsertBatteryIntoCassettePlayer(items, result, _)

	local battery, device = items:get(0), items:get(1);

	-- copy mod data from ingredient to result
	copyWalkmanData(device, result);

	-- transfer battery power to cassette player
	device:setUsedDelta(battery:getUsedDelta());
end

--- @param items ArrayList @Walkman(K) item
--- @param result InventoryItem @Battery item
function Recipe_RemoveBatteryFromCassettePlayer(items, result, _)

	local device = items:get(0);

	-- transfer power from cassette player to battery
	result:setUsedDelta(device:getUsedDelta());
	device:setUsedDelta(0);
end

--- @param items ArrayList @Walkman(D) item
--- @param result InventoryItem @new instance of Walkman item
function Recipe_TurnOnCassettePlayer(items, result, _)
	copyWalkmanData(items:get(0), result).power_state = 1;
end

--- @param items ArrayList @Walkman(D) item
--- @param result InventoryItem @new instance of Walkman item
function Recipe_TurnOffCassettePlayer(items, result, _)

	local data = copyWalkmanData(items:get(0), result);
	data.power_state, data.play_state = 0, 0;
end

--- @param items ArrayList @Walkman(D) item
--- @param result InventoryItem @new instance of Walkman item
function Recipe_PlayCassettePlayer(items, result, _)
	copyWalkmanData(items:get(0), result).play_state = 1;
end

--- @param items ArrayList @Walkman(D) item
--- @param result InventoryItem @new instance of Walkman item
function Recipe_StopCassettePlayer(items, result, _)
	copyWalkmanData(items:get(0), result).play_state = 0;
end

--- @param items ArrayList @Cassette(D) and Walkman(D) item
--- @param result InventoryItem @new instance of Walkman item
function Recipe_InsertCassetteIntoCassettePlayer(items, result, _)

	local wm_data = copyWalkmanData(items:get(1), result);
	local tape_data = Cassette.getOrInitData(items:get(0));

	wm_data.tape_num = tape_data.num;
	wm_data.track_num = tape_data.track;
end

--- @param items ArrayList @Walkman(K) item
--- @param result InventoryItem @new instance of Cassette item
function Recipe_EjectCassetteFromCassettePlayer(items, result, _)

	local deviceData = Walkman.getOrInitData(items:get(0));
	local casData = result:getModData();

	casData.num = deviceData.tape_num;
	casData.track = deviceData.track_num;

	deviceData.tape_num = 0;
	deviceData.track_num = 0;
	deviceData.play_state = 0;
end

--- @param items ArrayList @CassetteCaseFull(D) item
--- @param result InventoryItem @new instance of Cassette item
function Recipe_RemoveCassetteFromCase(_, result, player)

	player:getInventory():AddItem("WM.CassetteCaseEmpty");
	Cassette.Init(result);
end