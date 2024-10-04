extends Enemy

@export var bullet_scene : PackedScene

@onready var gun = $Gun
@onready var muzzle = $Gun/Muzzle

var sfx_shoot = preload("res://audio/sfx/enemy_shoot.ogg")

@export var fire_rate := 0.4
var can_fire := true

var player_height_offset := 4

func _ready():
	super._ready()

func _physics_process(delta):
	super._physics_process(delta)
	
	if player:
		$LineOfSight.look_at(player.global_position)
		var losTarget = $LineOfSight.get_collider()
		if losTarget == player:
			var player_offset_x = 0.0
			if player.velocity.x > 65:
				player_offset_x = 72.0
			elif player.velocity.x < -65:
				player_offset_x = -72.0
			else:
				player_offset_x = 0.0
			
			var target = Vector2(player.global_position.x + player_offset_x, player.global_position.y - player_height_offset)
			gun.rotation = lerp_angle(gun.rotation, get_angle_to(target), 5 * delta)
			
			$Animator.play("fire")
			fire()
		else:
			$Animator.stop()
	else:
		$Animator.stop()
	
	if $Rays/Down.is_colliding():
		$Sprite.rotation_degrees = 0
	elif $Rays/Up.is_colliding():
		$Sprite.rotation_degrees = 180
	elif $Rays/Left.is_colliding():
		$Sprite.rotation_degrees = 90
	elif $Rays/Right.is_colliding():
		$Sprite.rotation_degrees = -90


func fire():
	if can_fire == true:
		var b = bullet_scene.instantiate()
		get_tree().get_root().add_child(b)
		b.position = muzzle.global_position
		b.rotation = gun.rotation
		
		AudioHandler.play_sfx(sfx_shoot)
		
		can_fire = false
		await get_tree().create_timer(fire_rate).timeout
		can_fire = true
