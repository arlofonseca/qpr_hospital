--[[ FX Information ]]--
fx_version "cerulean"
game "gta5"
lua54 "yes"

--[[ Resource Information ]]--
name "qpr_hospital"
version "0.0.6"
description "Hospital system for overextended framework"
author "Qpr"
repository "https://github.com/arlofonseca/qpr_hospital"

--[[ Manifest ]]--
dependencies {
	"/onesync",
	"ox_core",
	"ox_lib",
	"ox_inventory",
}

shared_scripts {
	"@ox_lib/init.lua",
	"modules/init.lua",
}

client_scripts {
	"modules/data.lua",
	"client/*.lua",
}

server_scripts {
	"@oxmysql/lib/MySQL.lua",
	"@ox_core/imports/server.lua",
	"server/*.lua",
}

files {
	"modules/config.json",
}