extends Enemy
class_name Boss3

@onready var animator = $Animator
@onready var states = $StateManager
@onready var idle = $StateManager/Idle

@onready var laser = preload("res://scenes/bullets/laser.tscn")

func _ready():
	super._ready()
	
	states.init(self)

func _physics_process(delta):
	super._physics_process(delta)
	states.physics_update(delta)
	
	move_and_slide()

func face_player():
	if (global_position.x - player.global_position.x) > 0:
		$Boss.flip_h = false
		$Sprite.scale.x = 1
	else:
		$Boss.flip_h = true
		$Sprite.scale.x = -1

func shoot():
	var l = laser.instantiate()
	get_parent().add_child.call_deferred(l)
	l.global_position = $Muzzle.global_position
	l.scale.x = -$Sprite.scale.x
