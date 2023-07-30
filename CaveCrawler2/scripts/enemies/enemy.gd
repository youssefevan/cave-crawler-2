extends CharacterBody2D
class_name Enemy

@export var max_health : int

var current_health : int

func _ready():
	current_health = max_health

func get_hurt(hitstun_weight):
	current_health -= 1
	
	if current_health == 0:
		die()
	
	set_physics_process(false)
	await get_tree().create_timer(hitstun_weight).timeout
	set_physics_process(true)

func die():
	call_deferred("queue_free")

func _on_hurtbox_area_entered(area):
	if area.is_in_group("Player"):
		get_hurt(area.hitstun_weight)
