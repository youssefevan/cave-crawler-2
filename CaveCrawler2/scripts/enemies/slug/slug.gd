extends Enemy

@onready var animator = $Animator
@onready var states = $StateManager

@onready var idle = $StateManager/Idle
@onready var move = $StateManager/Move
@onready var shield = $StateManager/Shield

@export var print_states := false

var speed := 40.0
var move_direction := -1
var shield_time := 3.0 # in seconds

var got_hit := false

func _ready():
	super._ready()
	states.init(self)

func _physics_process(delta):
	states.physics_update(delta)
	
	if velocity.x > 0:
		$Sprite.flip_h = true
	if velocity.x < 0:
		$Sprite.flip_h = false 
	
	move_and_slide()

func _on_hurtbox_area_entered(area):
	if area.is_in_group("Player"):
		got_hit = true
