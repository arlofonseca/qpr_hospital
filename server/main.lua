local ox_inventory = exports.ox_inventory

lib.callback.register("qpr_hospital:server:treatment", function(source)
	local player = Ox.GetPlayer(source)
	if not player then return end

	local entityId = source
	local playerState = CState:get(entityId, "isBleeding")

	if not playerState then
		TriggerClientEvent("ox_lib:defaultNotify", source, {
			status = "error",
			title = "Medical Center",
			position = "top",
			description = "You do not need medical attention at the moment",
		})

		return
	end

	local src = source
	local cache = nil

	if ox_inventory:GetItem(src, config.treatment.item).count >= config.treatment.price then
		TriggerClientEvent("ox_lib:defaultNotify", source, {
			status = "success",
			title = "Medical Center",
			position = "top",
			description = "You were billed by the Medical Center.",
		})
		ox_inventory:RemoveItem(src, config.treatment.item, config.treatment.price)
		cache = true
	else
		TriggerClientEvent("ox_lib:defaultNotify", source, {
			status = "error",
			title = "Medical Center",
			position = "top",
			description = "You do not have enough cash, please visit the local bank.",
		})
		cache = false
	end

	while cache == nil do
		Wait(50)
	end

	return cache
end)

lib.callback.register("qpr_hospital:server:bandage", function(source)
	local player = Ox.GetPlayer(source)
	if not player then return end

	local src = source
	local cache = nil

	if ox_inventory:GetItem(src, config.treatment.item).count >= 300 then
		ox_inventory:RemoveItem(src, config.treatment.item, config.bandage.price)
		TriggerClientEvent("ox_lib:defaultNotify", source, {
			status = "success",
			title = "Medical Center",
			position = "top",
			description = "You have successfully purchased a bandage.",
		})
		ox_inventory:AddItem(src, config.bandage.item, 1)
		cache = true
	else
		TriggerClientEvent("ox_lib:defaultNotify", source, {
			status = "error",
			title = "Medical Center",
			position = "top",
			description = "You do not have enough cash, please visit the local bank.",
		})
		cache = false
	end

	while cache == nil do
		Wait(50)
	end

	return cache
end)