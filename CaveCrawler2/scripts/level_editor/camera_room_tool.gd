extends Node2D
class_name CameraRoomTool

@onready var button = $Button
@onready var outline = $Outline
@onready var width = $Width
@onready var height = $Height
@onready var delete = $Delete

var size : Vector2
var remove_from_array : bool
var button_being_pressed_down := false

func _ready():
	set_inactive()
	remove_from_array = false

func _process(delta):
	outline.set_size(Vector2(width.value * 8, height.value * 8))
	size.x = width.value * 8
	size.y = height.value * 8

func _on_button_toggled(button_pressed):
	if button_pressed:
		set_active()
	else:
		set_inactive()

func _on_delete_pressed():
	remove_from_array = true
	call_deferred("queue_free")

func _input(event):
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if button_being_pressed_down:
			global_position = get_global_mouse_position().snapped(Vector2(8, 8))

func _on_button_button_down():
	button_being_pressed_down = true

func _on_button_button_up():
	button_being_pressed_down = false

func set_active():
	outline.visible = true
	width.visible = true
	height.visible = true
	delete.visible = true

func set_inactive():
	outline.visible = false
	width.visible = false
	height.visible = false
	delete.visible = false
