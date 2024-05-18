extends Pickup

var health_particles = load("res://scenes/particles/health_picked.tscn")
var sfx_pickup = preload("res://audio/sfx/health_pickup.ogg")

func _ready():
	$Animator.play("Bob")

func picked(body):
	super.picked(body)
	call_deferred("disable")
	if body.health != body.max_health:
		body.health += 1
		picked_anim()
		AudioHandler.play_sfx(sfx_pickup)

func disable():
	$Area/Collider.disabled = true

func picked_anim():
	if OptionsHandler.particles_enabled == true:
		var hp = health_particles.instantiate()
		get_tree().get_root().add_child(hp)
		hp.position = global_position
	
	$Animator.play("Picked")

func _on_animator_animation_finished(anim_name):
	if anim_name == "Picked":
		call_deferred("queue_free")
