extends Enemy
class_name Boss2

@onready var animator = $Animator
@onready var states = $StateManager
@onready var idle = $StateManager/Idle
@onready var chase = $StateManager/Chase
@onready var sleep = $StateManager/Sleep

@onready var vines_particles = load("res://scenes/particles/boss_vines.tscn")

var speed := 200.0
var acceleration := 1.0

var move_direction := -1

func _ready():
	super._ready()
	states.init(self)

func _physics_process(delta):
	super._physics_process(delta)
	states.physics_update(delta)
	apply_gravity(delta)
	
	move_and_slide()

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func vines():
	var v = vines_particles.instantiate()
	add_child(v)
	v.global_position = global_position + Vector2(0, -8)
