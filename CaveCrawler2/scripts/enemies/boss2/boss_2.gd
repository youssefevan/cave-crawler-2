extends Enemy
class_name Boss2

var speed := 160.0
var acceleration := 1.0

var move_direction := -1

@onready var states = $StateManager
@onready var idle = $StateManager/Idle
@onready var chase = $StateManager/Chase

func _ready():
	super._ready()
	states.init(self)
	$Animator.play("Chase")

func _physics_process(delta):
	super._physics_process(delta)
	states.physics_update(delta)
	apply_gravity(delta)
	
	move_and_slide()

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * speed_modifier * delta
