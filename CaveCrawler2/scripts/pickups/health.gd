extends Pickup

var health_particles = load("res://scenes/particles/health_picked.tscn")
var sfx_pickup = preload("res://audio/sfx/health_pickup.ogg")

var picked_up := false

@export var spawn_offset : Vector2

func _ready():
	$Animator.play("Bob")

func picked(body):
	if !picked_up:
		if body.health != body.max_health:
			super.picked(body)
			body.health += 1
			picked_up = true
			picked_anim()
			AudioHandler.play_sfx(sfx_pickup)

#func disable():
	#$Area/Collider.disabled = true

func picked_anim():
	if OptionsHandler.particles_enabled == true:
		var hp = health_particles.instantiate()
		get_tree().get_root().add_child(hp)
		hp.position = global_position
	
	$Animator.play("Picked")

func _on_animator_animation_finished(anim_name):
	if anim_name == "Picked":
		call_deferred("queue_free")

func get_level_editor_offset() -> Vector2:
	return spawn_offset
