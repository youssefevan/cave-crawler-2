extends Enemy
class_name Boss1

var speed := 200.0
var movement_direction : Vector2

@onready var animator = $Animator

@onready var states = $StateManager
@onready var idle = $StateManager/Idle
@onready var adjust = $StateManager/Adjust
@onready var slam = $StateManager/Slam
@onready var swoop = $StateManager/Swoop

var reset_position : Vector2

func _ready():
	super._ready()
	reset_position = global_position
	$Sprite.frame = 0
	
	states.init(self)

func _physics_process(delta):
	super._physics_process(delta)
	states.physics_update(delta)
	face_player()
	
	move_and_slide()

func face_player():
	if (global_position.x - player.global_position.x) > 0:
		$Sprite.flip_h = false
	else:
		$Sprite.flip_h = true

func get_hurt(hitstun_weight):
	super.get_hurt(hitstun_weight)
	
	if current_health < (.66 * max_health) and current_health > (.33 * max_health):
		$Sprite.frame = 1
	elif current_health < (.33 * max_health):
		$Sprite.frame = 2
