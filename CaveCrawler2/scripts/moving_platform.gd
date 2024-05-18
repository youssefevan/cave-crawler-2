extends CharacterBody2D

signal tween_complete

var start_position : Vector2
var end_position : Vector2
var returning := false
var distance
var speed := 60.0
var target_position

func _ready():
	start_position = global_position
	end_position = $Endpoint.global_position
	distance = start_position.distance_to(end_position)
	$Endpoint/Sprite.visible = false
	target_position = end_position
	returning = false
	move()

func move():
	if get_tree() != null:
		await get_tree().create_timer(1).timeout
	var tween = get_tree().create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(self, "position", target_position, distance/speed).set_trans(Tween.TRANS_LINEAR)
	await tween.finished
	emit_signal("tween_complete")

func _on_tween_complete():
	if returning == true:
		target_position = end_position
		returning = false
		move()
	else:
		target_position = start_position
		returning = true
		move()
