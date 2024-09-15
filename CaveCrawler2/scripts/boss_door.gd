extends Area2D
class_name BossDoor

@export var boss : CharacterBody2D

@export var open := false
@export var locked := true 

@onready var open_position = $OpenPosition.position

@export var boss_music : AudioStream

var sfx_open = preload("res://audio/sfx/stalactite_fall.ogg")

var frame = 0

func _ready():
	
	if open == true:
		$Sprite.position = open_position
	else:
		$Sprite.position = Vector2.ZERO
	
	if boss == null:
		locked = false

func _physics_process(delta):
	if boss == null:
		frame += 1
		locked = false
		
		if frame == 1:
			AudioHandler.play_music(get_parent().music, false)
	
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
			if boss_music:
				AudioHandler.play_music(boss_music, false)
		else:
			open = true
			animate(open_position)

func animate(pos):
	var sprite = $Sprite
	AudioHandler.play_sfx(sfx_open)
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "position", pos, .25).set_trans(Tween.TRANS_LINEAR)
