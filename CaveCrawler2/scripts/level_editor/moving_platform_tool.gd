extends Node2D
class_name MovingPlatformTool

var size : Vector2
var remove_from_array : bool
var target_button : Button

@export var start : Button
@export var end : Button

func _ready():
	$Start/Delete.visible = false

func _input(event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and event is InputEventMouseMotion:
		if target_button:
			target_button.global_position = get_global_mouse_position().snapped(Vector2(8, 8))

func _physics_process(delta):
	$Line2D.set_point_position(0, $Start.position + Vector2(16, 4))
	$Line2D.set_point_position(1, $End.position + Vector2(16, 4))
	
	#print($Start.global_position)

func _on_start_button_down():
	target_button = $Start

func _on_start_button_up():
	target_button = null

func _on_end_button_down():
	target_button = $End

func _on_end_button_up():
	target_button = null

func set_active():
	$Start/Delete.visible = true

func set_inactive():
	$Start/Delete.visible = false

func _on_delete_pressed():
	call_deferred("queue_free")

func _on_start_toggled(toggled_on):
	if toggled_on:
		set_active()
	else:
		set_inactive()
