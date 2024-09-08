extends Enemy
class_name Rat

# Nodes
@onready var states = $StateManager
@onready var animator = $Animator

# States
@onready var idle = $StateManager/Idle
@onready var anticipate = $StateManager/Anticipate
@onready var jump = $StateManager/Jump
@onready var fall = $StateManager/Fall
@onready var land = $StateManager/Land

@onready var jump_dust = preload("res://scenes/particles/jump.tscn")

var sfx_jump = preload("res://audio/sfx/rat_jump.ogg")

# Variables
var jump_velocity_x := 100.0
var jump_velocity_y := 200.0
var anticipate_length := 0.3 # in seconds
var land_length := 0.5 # in seconds
var deceleration := 10.0

var move_direction := 0

# Checks

func _ready():
	super._ready()
	states.init(self)

func _physics_process(delta):
	super._physics_process(delta)
	states.physics_update(delta)
	
	apply_gravity(delta)
	apply_friction(delta)
	
	if player:
		if global_position.x - player.global_position.x < 0:
			move_direction = 1
			$Sprite.flip_h = true
		elif global_position.x - player.global_position.x > 0:
			move_direction = -1
			$Sprite.flip_h = false
	
	velocity.y = clampf(velocity.y, -250.0, 250.0)
	
	move_and_slide()

func apply_gravity(delta):
	velocity.y += gravity * gravity_multiplier * delta

func apply_friction(delta):
	if is_on_floor():
		velocity.x = lerpf(velocity.x, 0, deceleration * delta)

#func _on_camera_room_detector_area_exited(area):
#	if area.get_collision_layer_value(5):
#		call_deferred("queue_free")
