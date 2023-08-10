extends Enemy

@onready var animator = $Animator
@onready var states = $StateManager

@onready var idle = $StateManager/Idle
@onready var move = $StateManager/Move
@onready var shield = $StateManager/Shield

var got_hit := false

func _ready():
	super._ready()
	states.init(self)

func _physics_process(delta):
	states.physics_update(delta)
	move_and_slide()

func _on_hurtbox_area_entered(area):
	got_hit == true
