extends State

var end := false
var anim_end := false

func enter():
	super.enter()
	
	anim_end = false
	end = false
	await get_tree().create_timer(2).timeout
	end = true

func physics_update(delta):
	super.physics_update(delta)
	
	if end == true:
		entity.animator.play("Transform")
		if anim_end == true:
			return entity.chase

func _on_animator_animation_finished(anim_name):
	if anim_name == "Transform":
		anim_end = true
