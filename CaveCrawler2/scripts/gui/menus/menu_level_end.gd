extends Control

@onready var focus_button = $Buttons/Next
@onready var focus_button_custom = $Buttons/Edit
@onready var focus_button_end = $Buttons/Replay

func _ready() -> void:
	if Global.custom_level == false:
		$Buttons/Edit.visible = false
		$Buttons/Next.visible = true
	else:
		$Buttons/Edit.visible = true
		$Buttons/Next.visible = false
		focus_button = focus_button_custom
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

func _on_replay_pressed():
	Global.checkpoint_passed = false
	visible = false
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_next_pressed():
	visible = false
	get_tree().paused = false
	get_tree().change_scene_to_packed(Global.next_level)

func _on_edit_pressed():
	visible = false
	Global.creating_new_level = false
	get_tree().paused = false
	get_tree().change_scene_to_packed(Global.level_editor_scene)
