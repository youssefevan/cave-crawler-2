extends State

func enter():
	super.enter()
	entity.animator.play("Death")

func physics_update(delta):
	entity.velocity = Vector2.ZERO
