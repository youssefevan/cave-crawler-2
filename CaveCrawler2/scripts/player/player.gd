extends CharacterBody2D
class_name Player

# Nodes
@onready var states = $StateManager
@onready var animator = $Animator
@onready var camera = $Camera
@onready var gun = $Gun
@onready var muzzle = $Gun/Muzzle
@export var bullet : PackedScene

# Particles
@export var muzzle_flash : PackedScene
@export var particles_death : PackedScene
@export var jump_dust : PackedScene

# States
@onready var idle = $StateManager/Idle
@onready var run = $StateManager/Run
@onready var jump = $StateManager/Jump
@onready var fall = $StateManager/Fall
@onready var bounce = $StateManager/Bounce

# Sounds
var sfx_jump = preload("res://audio/sfx/player/player_jump.ogg")
var sfx_hit = preload("res://audio/sfx/player/player_hit.ogg")
var sfx_shoot = preload("res://audio/sfx/player/player_shoot.ogg")

# Horizontal movement variables
var speed := 85.0
var normal_speed := 85.0
var slope_speed := 118.5 # normal_speed * (1*sqrt(2))
var acceleration_ground := 14.0
var acceleration_air := 7.0
var deceleration_ground := 13.5
var deceleration_air := 1.4
var movement_input : float
var speed_modifier := 1.0

# Vertical movement variables
var jump_velocity := 208.0
var release_jump_velocity = 90
var jump_buffer := 0.075
var jump_was_pressed := false
var can_coyote_jump := false
var gravity_up := 600.0
var gravity_down := 1400.0
var max_fall_speed := 250.0
var bouncing := false
var bounce_force

# Health
@export var max_health := 4
var health : int

# Hurt
var can_get_hurt := true
var invincibility_length := 2.0 # in seconds

# Gun varaibles
var can_fire : bool
var fire_rate := 0.25

# Camera variables
var camera_speed := 6.0
var large_y_limits := false

var level_editor_offset := Vector2(4, -8)

var level_end := false

func _ready() -> void:
	states.init(self)
	can_fire = true
	health = max_health
	
	if Global.checkpoint_passed == true:
		global_position = Global.checkpoint_position

func _physics_process(delta) -> void:
	states.physics_update(delta)
	
	handle_camera(delta)
	handle_oneway_collision()
	jump_buffering()
	
	if Input.is_action_pressed("shoot") and can_fire:
		shoot()
	
	$GUI/HealthBar.frame = health
	move_and_slide()

func handle_input() -> void:
	movement_input = Input.get_action_strength("right") - Input.get_action_strength("left")
	if movement_input > 0:
		$Sprite.flip_h = false
		$Gun.scale.x = 1
	if movement_input < 0:
		$Sprite.flip_h = true
		$Gun.scale.x = -1
	
	if Input.is_action_pressed("look_up"):
		if $Sprite.flip_h == false:
			gun.rotation_degrees = -90
		else:
			gun.rotation_degrees = 90
	else:
		gun.rotation_degrees = 0

func apply_movement(delta) -> void:
	if is_on_floor():
		if get_floor_normal() != Vector2(0, -1):
			speed = slope_speed * speed_modifier
		else:
			speed = normal_speed * speed_modifier
	else:
		speed = normal_speed * speed_modifier
	
	if movement_input != 0:
		var acceleration
		if is_on_floor():
			acceleration = acceleration_ground
		else:
			acceleration = acceleration_air
		
		velocity.x = lerp(velocity.x, movement_input * speed, acceleration * delta)
	else:
		var deceleration
		if is_on_floor():
			deceleration = deceleration_ground
		else:
			deceleration = deceleration_air
			
		velocity.x = lerp(velocity.x, 0.0, deceleration * delta)
		
		if abs(velocity.x) < 0.05:
			velocity.x = 0

func jump_buffering() -> void:
	if Input.is_action_just_pressed("jump"):
		jump_was_pressed = true
		await get_tree().create_timer(jump_buffer).timeout
		jump_was_pressed = false

func coyote_time() -> void:
	can_coyote_jump = true
	await get_tree().create_timer(jump_buffer).timeout
	can_coyote_jump = false

func shoot() -> void:
	if OptionsHandler.particles_enabled == true:
		var mf = muzzle_flash.instantiate()
		muzzle.add_child(mf)
	
	var b = bullet.instantiate()
	get_tree().get_root().add_child(b)
	b.position = muzzle.global_position
	b.rotation = gun.rotation
	if gun.scale.x == -1:
		b.speed = -b.speed
	
	AudioHandler.play_sfx(sfx_shoot)
	
	can_fire = false
	await get_tree().create_timer(fire_rate).timeout
	can_fire = true

func _on_hurtbox_area_entered(area):
	if area.is_in_group("Enemy") or area.is_in_group("Hazard"):
		# Make sure player doesn't get hurt by the slug when its in the shield state (bounce mode thing)
		if area.get_parent() is Slug and area.get_parent().states.current_state == area.get_parent().shield_state:
			area.get_parent().states.change_state(area.get_parent().shield_state)
		else:
			get_hurt()

func _on_hurtbox_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is TileMap:
		var cell_pos = body.get_coords_for_body_rid(body_rid)
		var cell_data = body.get_cell_tile_data(0, cell_pos)
			
		if cell_data.get_custom_data("killzone") == true:
			health = 0
			die()
		elif cell_data.get_custom_data("does_damage") == true:
			get_hurt()
			
		if cell_data.get_custom_data("speed_modifier") != 0.0:
			speed_modifier = cell_data.get_custom_data("speed_modifier")

func _on_hurtbox_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body is TileMap:
		speed_modifier = 1.0

func get_hurt() -> void:
	if can_get_hurt == true:
		can_get_hurt = false
		
		health -= 1
		
		AudioHandler.play_sfx(sfx_hit)
		
		if health == 0:
			$GUI/HealthBar.frame = 0
			die()
		else:
			$Sprite.material.set_shader_parameter("enabled", true)
			set_physics_process(false)
			await get_tree().create_timer(.05).timeout
			$Sprite.material.set_shader_parameter("enabled", false)
			
			if health != 0:
				set_physics_process(true)
			
			hit_flash()
			await get_tree().create_timer(invincibility_length, false).timeout
			can_get_hurt = true

func hit_flash() -> void:
	while not can_get_hurt:
		$Sprite.visible = false
		await get_tree().create_timer(0.1, false).timeout
		$Sprite.visible = true
		await get_tree().create_timer(0.1, false).timeout

func die() -> void:
	if OptionsHandler.particles_enabled == true:
		var particles = particles_death.instantiate()
		get_tree().get_root().add_child(particles)
		particles.position = global_position
	
	can_get_hurt = false
	set_physics_process(false)
	visible = false
	
	$GUI/MenuDeath.visible = true
	if OptionsHandler.cursor_visible == false:
		$GUI/MenuDeath.focus_button.grab_focus()
	get_tree().paused = true

func _on_camera_room_detector_area_entered(area):
	if area.get_collision_layer_value(5):
		camera.limit_top = area.global_position.y
		camera.limit_left = area.global_position.x
		camera.limit_bottom = area.global_position.y + area.scale.y
		camera.limit_right = area.global_position.x + area.scale.x
		
		if (camera.limit_bottom - camera.limit_top) > 144:
			large_y_limits = true
		else:
			large_y_limits = false

func handle_camera(delta) -> void:
	# Since the player's center is offset 6 units up from it's pivot,
	# the camera needs to be offset by the same amount in rooms with
	# large y limits. However, the camera's built in offset property
	# moves it up by 6 units at all times, making the floor of the room
	# seem lower. To fix this, I manually apply the offset when lerping
	# the camera's y position.
	var offset_y := 6.0
	
	camera.top_level = true
	
	if large_y_limits == true:
		camera.drag_vertical_enabled = true
		camera.global_position.x = global_position.x
		camera.global_position.y = lerp(camera.global_position.y, global_position.y - offset_y, camera_speed * delta)
	else:
		camera.drag_vertical_enabled = false
		camera.global_position = global_position

func get_level_editor_offset() -> Vector2:
	return level_editor_offset

func handle_oneway_collision() -> void:
	if is_on_floor() and Input.is_action_pressed("drop_through"):
		set_collision_mask_value(10, false)
		await get_tree().create_timer(0.1).timeout
		set_collision_mask_value(10, true)

func end_level() -> void:
	level_end = true
	$GUI/MenuLevelEnd.visible = true
	if OptionsHandler.cursor_visible == false:
		$GUI/MenuLevelEnd.focus_button.grab_focus()
	
	Global.checkpoint_passed = false
	get_tree().paused = true

func enter_bounce(bf) -> void:
	bouncing = true
	bounce_force = bf
