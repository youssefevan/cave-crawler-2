extends Enemy
class_name Rat

@export var print_states : bool

# Nodes
@onready var states = $StateManager
@onready var animator = $Animator

# States
@onready var idle = $StateManager/Idle
@onready var anticipate = $StateManager/Anticipate
@onready var jump = $StateManager/Jump
@onready var fall = $StateManager/Fall
@onready var land = $StateManager/Land

# Variables
var jump_velocity_x := 100.0
var jump_velocity_y := 200.0
var anticipate_length := 0.3 # in seconds
var land_length := 1.0 # in seconds
var deceleration := 10.0

var move_direction := 0

# Checks
var player : Player

func _ready():
	super._ready()
	states.init(self)

func _physics_process(delta):
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
	if not is_on_floor():
		velocity.y += gravity * delta

func apply_friction(delta):
	if is_on_floor():
		velocity.x = lerpf(velocity.x, 0, deceleration * delta)


func _on_attack_range_body_entered(body):
	if body.collision_layer == 2:
		player = body

func _on_attack_range_body_exited(body):
	if body == player:
		player = null

#func _on_camera_room_detector_area_exited(area):
#	if area.get_collision_layer_value(5):
#		call_deferred("queue_free")
