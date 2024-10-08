extends Enemy
class_name Bat

var speed := 50.0
var movement_direction : Vector2

@onready var animator = $Animator

@onready var states = $StateManager
@onready var hang = $StateManager/Hang
@onready var fly = $StateManager/Fly

var sfx_chirp = preload("res://audio/sfx/bat.ogg")

func _ready():
	super._ready()
	states.init(self)

func _physics_process(delta):
	super._physics_process(delta)
	states.physics_update(delta)
	
	move_and_slide()
