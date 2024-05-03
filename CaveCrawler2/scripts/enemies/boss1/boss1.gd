extends Enemy
class_name Boss1

var speed := 50.0
var movement_direction : Vector2

@onready var animator = $Animator

@onready var states = $StateManager
@onready var idle = $StateManager/Idle
@onready var adjust = $StateManager/Adjust

func _ready():
	super._ready()
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
