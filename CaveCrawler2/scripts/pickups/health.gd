extends Pickup

func picked(body):
	super.picked(body)
	body.health += 1
	call_deferred("queue_free")
