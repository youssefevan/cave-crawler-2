extends Enemy

@export var bullet_scene : PackedScene

@onready var gun = $Gun
@onready var muzzle = $Gun/Muzzle

var fire_rate := 0.4
var can_fire := true

var player_height_offset := 10.0

var player : Player

func _physics_process(delta):
	if player != null:
		gun.look_at(Vector2(player.global_position.x, player.global_position.y - player_height_offset))
		$Animator.play("fire")
		fire()

func fire():
	if can_fire == true:
		var b = bullet_scene.instantiate()
		get_tree().get_root().add_child(b)
		b.position = muzzle.global_position
		b.rotation = gun.rotation
		
		can_fire = false
		await get_tree().create_timer(fire_rate).timeout
		can_fire = true

func _on_player_detection_body_entered(body):
	if body is Player:
		player = body

func _on_player_detection_body_exited(body):
	if body is Player:
		player = null
