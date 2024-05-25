extends Area2D
class_name BossDoor

@export var boss : CharacterBody2D

@export var open := false
@export var locked := true 

@onready var open_position = $OpenPosition.position


func _ready():
	if open == true:
		$Sprite.position = open_position
	else:
		$Sprite.position = Vector2.ZERO
	
	if boss == null:
		locked = false

func _physics_process(delta):
	if boss == null:
		locked = false
	
	if open:
		$Wall/Collider.disabled = true
	else:
		$Wall/Collider.disabled = false
	
	if locked == true:
		$Sprite.frame = 0
	else:
		$Sprite.frame = 1

func _on_body_entered(body):
	if body is Player and not locked:
		if open == true:
			open = false
			locked = true
			animate(Vector2.ZERO)
		else:
			open = true
			animate(open_position)

func animate(pos):
	var sprite = $Sprite
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "position", pos, .25).set_trans(Tween.TRANS_LINEAR)
