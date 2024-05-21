extends Enemy

@export var bullet_scene : PackedScene

@onready var gun = $Gun
@onready var muzzle = $Gun/Muzzle

@export var fire_rate := 0.4
var can_fire := true

var player_height_offset := 4

func _ready():
	super._ready()

func _physics_process(delta):
	super._physics_process(delta)
#	apply_gravity(delta)
#	move_and_slide()
	
	if player:
		var player_offset_x = 0.0
		if player.velocity.x > 65:
			player_offset_x = 64.0
		elif player.velocity.x < -65:
			player_offset_x = -64.0
		else:
			player_offset_x = 0.0
		
		var target = Vector2(player.global_position.x + player_offset_x, player.global_position.y - player_height_offset)
		gun.rotation = lerp_angle(gun.rotation, get_angle_to(target), 5 * delta)
		
		$Animator.play("fire")
		fire()
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

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if is_on_floor():
		velocity.y = 1
	
	velocity.y = clampf(velocity.y, -250.0, 250.0)

func fire():
	if can_fire == true:
		var b = bullet_scene.instantiate()
		get_tree().get_root().add_child(b)
		b.position = muzzle.global_position
		b.rotation = gun.rotation
		
		can_fire = false
		await get_tree().create_timer(fire_rate).timeout
		can_fire = true
