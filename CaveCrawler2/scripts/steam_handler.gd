extends Node

var app_id = "3000490"

func _init():
	OS.set_environment("SteamAppID", app_id)
	OS.set_environment("SteamGameID", app_id)

func _ready():
	Steam.steamInit()
	var is_steam_running = Steam.isSteamRunning()
	
	if !is_steam_running:
		print("error -> Steam not running")
		return
	
	print("Steam is running")
