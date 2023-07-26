extends CharacterBody2D
class_name Player

@export var print_states : bool

# Nodes
@onready var states = $StateManager
@onready var animator = $Animator
@onready var gun = $Gun
@onready var muzzle = $Gun/Muzzle
@export var bullet : PackedScene

@onready var camera = $Camera

# States
@onready var idle = $StateManager/Idle
@onready var run = $StateManager/Run
@onready var jump = $StateManager/Jump
@onready var fall = $StateManager/Fall

# Horizontal movement variables
var speed := 85.0
var acceleration_ground := 14.0
var acceleration_air := 7.0
var deceleration_ground := 13.5
var deceleration_air := 1.4
var movement_input : float

# Vertical movement variables
var jump_velocity := 208.0
var release_jump_velocity = 90
var jump_buffer := 0.075
var jump_was_pressed := false
var can_coyote_jump := false
var gravity_up := 600.0
var gravity_down := 1400.0
var max_fall_speed := 250.0

# Gun varaibles
var can_fire : bool
var fire_rate := 0.25

func _ready():
	states.init(self)
	can_fire = true

func _physics_process(delta):
	states.physics_update(delta)
	jump_buffering()
	
	if Input.is_action_pressed("shoot") and can_fire:
		shoot()
	
	move_and_slide()

func handle_input():
	movement_input = Input.get_action_strength("right") - Input.get_action_strength("left")
	if movement_input > 0:
		$Sprite.flip_h = false
		$Gun.scale.x = 1
	if movement_input < 0:
		$Sprite.flip_h = true
		$Gun.scale.x = -1

func apply_movement(delta):
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

func jump_buffering():
	if Input.is_action_just_pressed("jump"):
		jump_was_pressed = true
		await get_tree().create_timer(jump_buffer).timeout
		jump_was_pressed = false

func coyote_time():
	can_coyote_jump = true
	await get_tree().create_timer(jump_buffer).timeout
	can_coyote_jump = false

func shoot():
	var b = bullet.instantiate()
	get_tree().get_root().add_child(b)
	b.position = muzzle.global_position
	if gun.scale.x == -1:
		b.speed = -b.speed
	
	can_fire = false
	await get_tree().create_timer(fire_rate).timeout
	can_fire = true

func _on_camera_room_detector_area_entered(area):
	if area.get_collision_layer_value(5):
		camera.limit_top = area.global_position.y
		camera.limit_left = area.global_position.x
		camera.limit_bottom = area.global_position.y + area.scale.y
		camera.limit_right = area.global_position.x + area.scale.x
