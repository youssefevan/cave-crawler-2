extends Enemy
class_name Boss3

@onready var animator = $Animator
@onready var states = $StateManager
@onready var idle = $StateManager/Idle

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
		$Boss.flip_h = false
		$Sprite.scale.x = 1
	else:
		$Boss.flip_h = true
		$Sprite.scale.x = -1
