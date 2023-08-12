extends CharacterBody2D
class_name Enemy

@export var max_health : int
@export var gravity := 800.0

var current_health : int
var can_get_hurt : bool

func _ready():
	$Sprite.material.set_shader_parameter("enabled", false)
	current_health = max_health
	can_get_hurt = true

func get_hurt(hitstun_weight):
	if can_get_hurt:
		can_get_hurt = false
		
		current_health -= 1
		
		if current_health == 0:
			die()
		
		$Sprite.material.set_shader_parameter("enabled", true)
		set_physics_process(false)
		await get_tree().create_timer(hitstun_weight).timeout
		set_physics_process(true)
		$Sprite.material.set_shader_parameter("enabled", false)
		
		can_get_hurt = true

func die():
	call_deferred("queue_free")

func _on_hurtbox_area_entered(area):
	if area.is_in_group("Player"):
		get_hurt(area.hitstun_weight)
	elif area.is_in_group("Hazard"):
		get_hurt(0.1)

func _on_hurtbox_body_entered(body):
	### NOTE: currently only used for killzones because tilemaps dont have get_collision_layer_value
	current_health = 0
	die()
