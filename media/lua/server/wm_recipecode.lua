----------------- Recipe TEST Functions -----------------

--- Test if cassette player has no battery power left ---
function Recipe_InsertBatteryIntoCassettePlayer_TestIsValid(sourceItem, result)

	if sourceItem:getType() == "Walkman" then
		return sourceItem:getUsedDelta() == 0;
	else
		return true; -- the battery
	end
end

--- Test if cassette player has battery power left ---
function Recipe_RemoveBatteryIntoCassettePlayer_TestIsValid(sourceItem, result)
	return sourceItem:getUsedDelta() > 0;
end

------------------- Recipe Functions -------------------

function Recipe_InsertBatteryIntoCassettePlayer(items, result, player)

	local battery, cPlayer = items:get(0), items:get(1);

	-- transfer battery power to cassette player
	cPlayer:setUsedDelta(battery:getUsedDelta());
end

function Recipe_RemoveBatteryIntoCassettePlayer(items, result, player)

	local cPlayer = items:get(0);

	-- transfer power from cassette player to battery
	result:setUsedDelta(cPlayer:getUsedDelta());
	cPlayer:setUsedDelta(0);
function Recipe_RemoveCassetteFromCase(items, result, player)

	player:getInventory():AddItem("WM.CassetteCaseEmpty");
	InitCassetteItem(result);
end