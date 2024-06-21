extends Control

var level_1_1 = load("res://scenes/levels/world1/level_1_1.tscn")
var level_1_2 = load("res://scenes/levels/world1/level_1_2.tscn")
var level_1_3 = load("res://scenes/levels/world1/level_1_3.tscn")
var level_1_4 = load("res://scenes/levels/world1/level_1_4.tscn")
var level_1_5 = load("res://scenes/levels/world1/level_1_5.tscn")

var level_2_1 = load("res://scenes/levels/world2/level_2_1.tscn")
var level_2_2 = load("res://scenes/levels/world2/level_2_2.tscn")
var level_2_3 = load("res://scenes/levels/world2/level_2_3.tscn")
var level_2_4 = load("res://scenes/levels/world2/level_2_4.tscn")
var level_2_5 = load("res://scenes/levels/world2/level_2_5.tscn")

var level_3_1 = load("res://scenes/levels/world3/level_3_1.tscn")
var level_3_2 = load("res://scenes/levels/world3/level_3_2.tscn")
var level_3_3 = load("res://scenes/levels/world3/level_3_3.tscn")
var level_3_4 = load("res://scenes/levels/world3/level_3_4.tscn")
var level_3_5 = load("res://scenes/levels/world3/level_3_5.tscn")

func _ready():
	if OptionsHandler.cursor_visible == false:
		$Worlds/World1/World1Btn.grab_focus()
	
	Global.checkpoint_passed = false

func _on_options_pressed():
	var o = Global.options_scene.instantiate()
	get_tree().get_root().add_child(o)

func _on_back_pressed():
	get_tree().change_scene_to_packed(Global.main_menu_scene)


func _on_1_1_pressed():
	get_tree().change_scene_to_packed(level_1_1)

func _on_1_2_pressed():
	get_tree().change_scene_to_packed(level_1_2)

func _on_1_3_pressed():
	get_tree().change_scene_to_packed(level_1_3)

func _on_1_4_pressed():
	get_tree().change_scene_to_packed(level_1_4)

func _on_1_5_pressed():
	get_tree().change_scene_to_packed(level_1_5)

func _on_2_1_pressed():
	get_tree().change_scene_to_packed(level_2_1)

func _on_2_2_pressed():
	get_tree().change_scene_to_packed(level_2_2)

func _on_2_3_pressed():
	get_tree().change_scene_to_packed(level_2_3)

func _on_2_4_pressed():
	get_tree().change_scene_to_packed(level_2_4)

func _on_2_5_pressed():
	get_tree().change_scene_to_packed(level_2_5)

func _on_3_1_pressed():
	get_tree().change_scene_to_packed(level_3_1)

func _on_3_2_pressed():
	get_tree().change_scene_to_packed(level_3_2)

func _on_3_3_pressed():
	get_tree().change_scene_to_packed(level_3_3)

func _on_3_4_pressed():
	get_tree().change_scene_to_packed(level_3_4)

func _on_3_5_pressed():
	get_tree().change_scene_to_packed(level_3_5)
