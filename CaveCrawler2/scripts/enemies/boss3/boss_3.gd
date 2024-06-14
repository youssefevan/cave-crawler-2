extends Enemy
class_name Boss3

@onready var states = $StateManager
@onready var idle = $StateManager/Idle

@onready var muzzle = $Muzzle

func _ready():
	super._ready()
	
	states.init(self)

func _physics_process(delta):
	super._physics_process(delta)
	states.physics_update(delta)
	apply_gravity(delta)
	
	muzzle.look_at(player.global_position + Vector2(0, 4))
	
	move_and_slide()

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * 0.1 * delta
