extends Enemy
class_name Boss3

@onready var idle = $StateManager/Idle

func _ready():
	super._ready()
	$Animator.play("Idle")

func _physics_process(delta):
	pass
