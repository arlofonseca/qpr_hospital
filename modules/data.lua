locations = {
	vector3(294.540649, -1448.413208, 28.953857),
	vector3(-448.101105, -340.813171, 33.486450),
	vector3(357.138458, -593.472534, 27.774414),
	--[[
	vector3(0, 0, 0),
	vector3(0, 0, 0),
	--]]
}

local entity = {}
local npcs = {
	{
		name = "hospital-1",
		model = config.npc.model,
		coords = vector3(294.540649, -1448.413208, 28.953857),
		heading = 320.314972,
		gender = "male",
	},
	{
		name = "hospital-2",
		model = config.npc.model,
		coords = vector3(-448.101105, -340.813171, 33.486450),
		heading = 79.370079,
		gender = "male",
	},
	{
		name = "hospital-3",
		model = config.npc.model,
		coords = vector3(357.138458, -593.472534, 27.774414),
		heading = 249.448822,
		gender = "male",
	},
	--[[
	{
		name = "hospital-4",
		model = config.npc.model,
		coords = vector3(0, 0, 0),
		heading = 0,
		gender = "male",
	},
	{
		name = "hospital-5",
		model = config.npc.model,
		coords = vector3(0, 0, 0),
		heading = 0,
		gender = "male",
	},
	--]]
}

for i = 1, #npcs do
	local zones = lib.points.new(npcs[i].coords, 30, { zone = k, data = npcs[i] })

	function zones:onEnter()
		lib.requestModel(self.data.model)
		if self.data.gender == "male" then
			gender = 4
		elseif self.data.gender == "female" then
			gender = 5
		end

		entity[i] = CreatePed(
			gender,
			self.data.model,
			self.data.coords.x,
			self.data.coords.y,
			self.data.coords.z,
			self.data.heading,
			false,
			false
		)

		FreezeEntityPosition(entity[i], true)
		SetEntityInvincible(entity[i], true)
		SetBlockingOfNonTemporaryEvents(entity[i], true)
	end

	function zones:onExit()
		DeletePed(entity[i])
	end
end

local blips = {
	{
		title = "Central Los Santos Medical Center",
		color = 23,
		id = 61,
		size = 0.7,
		x = 294.540649,
		y = -1448.413208,
		z = 28.953857,
	},
	{
		title = "Mount Zonah Medical Center",
		color = 23,
		id = 61,
		size = 0.7,
		x = -448.101105,
		y = -340.813171,
		z = 33.486450,
	},
	{
		title = "Pillbox Hill Medical Center",
		color = 23,
		id = 61,
		size = 0.7,
		x = 357.138458,
		y = -593.472534,
		z = 27.774414,
	},
	--[[
	{
		title = "hospital-4",
		color = 23,
		id = 61,
		size = 0.7,
		x = 0,
		y = 0,
		z = 0,
	},
	{
		title = "hospital-5",
		color = 23,
		id = 61,
		size = 0.7,
		x = 0,
		y = 0,
		z = 0,
	},
	--]]
}

CreateThread(function()
	for _, info in pairs(blips) do
		info.blip = AddBlipForCoord(info.x, info.y, info.z)
		SetBlipSprite(info.blip, info.id)
		SetBlipDisplay(info.blip, 4)
		SetBlipScale(info.blip, info.size)
		SetBlipColour(info.blip, info.color)
		SetBlipAsShortRange(info.blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(info.title)
		EndTextCommandSetBlipName(info.blip)
	end
end)