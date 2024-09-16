extends Bullet

var throw := false

var player

func _ready():
	$Animator.play("Spin")
	$Collider.disabled = true

func _physics_process(delta):
	if player != null:
		$Animator.stop()
		look_at(player.global_position + Vector2(0, 4))
		
		if global_position.y > player.global_position.y:
			player = null
	
	if throw == true:
		$Collider.disabled = false
		super._physics_process(delta)

func _on_area_entered(area):
	if area.get_collision_layer_value(7):
		if area.get_parent().is_in_group("Player"):
			explode()

func _on_area_exited(_area):
	pass

func _on_visible_on_screen_notifier_2d_screen_exited():
	pass
