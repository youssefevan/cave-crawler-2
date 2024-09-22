extends Control

@onready var focus_button = $Buttons/Retry

func _ready() -> void:
	if Global.custom_level == false:
		$Buttons/Edit.visible = false
	else:
		$Buttons/Edit.visible = true
	visible = false

func _on_options_pressed():
	Global.entering_sub_menu()
	var o = Global.options_scene.instantiate()
	get_parent().add_child(o)
	o.btn_fullscreen.grab_focus()

func _on_main_menu_pressed():
	visible = false
	get_tree().paused = false
	get_tree().change_scene_to_packed(Global.main_menu_scene)

func _on_retry_pressed():
	visible = false
	print(get_tree())
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_edit_pressed():
	visible = false
	print(get_tree())
	Global.creating_new_level = false
	get_tree().paused = false
	get_tree().change_scene_to_packed(Global.level_editor_scene)
