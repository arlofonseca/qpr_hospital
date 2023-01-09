player = {}

getCurrentState = function(entityId, stateBag)
	local player = Player(entityId)
	return player.state[stateBag]
end

player.playerStates = { "isBleeding" }

for i = 1, #player.playerStates do
	local state = player.playerStates[i]
	AddStateBagChangeHandler(state, nil, function(bagName, key, value, unused, replicated)
		if value == nil then return end

		print("BagName: " .. bagName)
		print("Key: " .. key)
		print("Value: " .. tostring(value))
		print("Unused: " .. tostring(unused))
		print("Replicated: " .. tostring(replicated))
	end)
end

AddEventHandler("ox:playerLoaded", function(source, userid, charid)
	local playerLoaded = Ox.GetPlayer(source)

	-- Linden didn't like metadata :(

	if not playerLoaded then
		print("What's going on?")
	end
end)

AddEventHandler("ox:playerLogout", function(source, userid, charid)
	local playerLogout = Ox.GetPlayer(source)

	-- Linden didn't like metadata :(

	if not playerLogout then
		print("Player not found in ox_core?")
	end
end)