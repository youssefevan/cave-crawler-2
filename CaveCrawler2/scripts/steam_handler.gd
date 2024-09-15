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

func set_achievement(ach_name):
	var status = Steam.getAchievement(ach_name)
	
	if status["achieved"]:
		print("already unlocked: ", ach_name)
		return
	else:
		print("unlocked: ", ach_name)
		Steam.setAchievement(ach_name)
