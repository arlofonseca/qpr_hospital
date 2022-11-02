CState = {}
player = {}

function CState:get(entityId, stateBag)
	local player = Player(entityId)
	return player.state[stateBag]
end

function CState:set(entityId, stateBag, bool, replicated)
	local player = Player(entityId)

	if replicated == nil then
		replicated = false
	end

	player.state:set(stateBag, bool, replicated)
end

player.playerStates = { "isBleeding" }

for i = 1, #player.playerStates do
	local state = player.playerStates[i]
	AddStateBagChangeHandler(state, false, function(bagName, key, value, source, replicated)
		print("bagName: [" .. key .. "] value: [" .. tostring(value) .. "] replicated: [" .. tostring(replicated) .. "]")
	end)
end

AddEventHandler("ox:playerLoaded", function(source, userid, charid)
	local player = Ox.GetPlayer(source)
	local result = MySQL.single.await("SELECT metadata FROM characters WHERE charid = ?", { charid })
	if not result or not player then end
	print(player, result)
end)

AddEventHandler("ox:playerLogout", function(source, userid, charid)
	local player = Ox.GetPlayer(source)
	if not player then print("player not found in ox_core?") end
end)
