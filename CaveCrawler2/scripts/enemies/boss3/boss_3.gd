extends Enemy
class_name Boss3

func _ready():
	super._ready()
	$Animator.play("Idle")
