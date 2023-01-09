local playerPed = cache.ped
local targetEye = exports.ox_target
local oxTarget = GetConvar("ox_enableTarget", "false") == "true"

if not oxTarget then
	for i = 1, #locations do
		local hospitalLocations = locations[i]
		local hospitalPoints = lib.points.new(hospitalLocations, 1.5)

		function hospitalPoints:onEnter()
			lib.showTextUI("[E] - Access hospital")
		end

		function hospitalPoints:onExit()
			lib.hideTextUI()
		end

		function hospitalPoints:nearby()
			if self.currentDistance < 2 and IsControlJustReleased(0, 38) then
				hospitalMenu()
			end
		end
	end
else
	targetEye:addModel(config.npc.model, {
		{
			name = "target_menu",
			icon = "fas fa-sign-in-alt",
			label = "Access hospital",
			onSelect = function()
				hospitalMenu()
			end,
		},
	})
end

hospitalMenu = function()
	lib.registerContext({
		id = "HospitalContext",
		title = "Medical Center",
		options = {
			{
				title = "Medical Treatment",
				description = "A procedure, or regimen, such as a drug, surgery, or exercise, in an attempt to cure or mitigate a disease, condition, or injury.",
				metadata = { "You will feel dizzy, and nauseous for a short period of time after the procedure." },
				onSelect = function(args)
					requestTreatment()
				end,
			},
			{
				title = "Need a bandage?",
				description = "Buy a strip of material used to bind a wound or to protect an injured part of the body.",
				metadata = { "This seems like a better idea, yea?" },
				onSelect = function(args)
					purchaseBandage()
				end,
			},
		},
	})

	lib.showContext("HospitalContext")
end

requestTreatment = function()
	if config.treatment.enabled then
		lib.callback("qpr_hospital:server:treatment", false, function(success)
			if success then
				if
					lib.progressCircle({
						duration = 5000,
						position = "bottom",
						label = "",
						disable = { move = true },
						anim = { dict = config.treatment.dict, clip = config.treatment.clip },
					})
				then
					SetEntityHealth(playerPed, 200)
					lib.defaultNotify({
						status = "success",
						title = "",
						position = "top",
						description = "You have successfully been treated and can go on your way",
					})
				end
			end
		end)
	end
end

purchaseBandage = function()
	lib.callback("qpr_hospital:server:bandage", false, function(success)
		print("bandage purchased")
	end)
end

playerBleeding = function()
	local playerHealth = GetEntityHealth(playerPed)

	if playerHealth <= 150 then
		LocalPlayer.state:set("isBleeding", true, true)
		SetEntityHealth(playerPed, playerHealth - 1)

		lib.defaultNotify({
			status = "error",
			title = "",
			position = "top",
			description = "You need medical attention, visit the Medical Center.",
		})

		lib.requestAnimSet(config.bleeding.anim)
		SetPedMovementClipset(playerPed, config.bleeding.anim, true)
		ShakeGameplayCam(config.bleeding.effect, config.bleeding.intensity)

		DoScreenFadeOut(500)

		while not IsScreenFadedOut() do
			Wait(100)
		end

		DoScreenFadeIn(500)
	elseif playerHealth >= 175 then
		LocalPlayer.state:set("isBleeding", false, true)
		ResetPedMovementClipset(playerPed, 0)
		ResetPedStrafeClipset(playerPed, 0)
		StopAllScreenEffects(playerPed)
	end
end

if config.bleeding.enabled then
	SetInterval(function()
		playerBleeding()
		Wait(2600)
	end)
end

-- debug
if config.general.debug then
	RegisterCommand("debug:bleed", function()
		SetEntityHealth(playerPed, 130)
		print("health set to 130")
	end)
end

if config.general.debug then
	RegisterCommand("debug:heal", function()
		SetEntityHealth(playerPed, 200)
		print("health set to 200")
	end)
end