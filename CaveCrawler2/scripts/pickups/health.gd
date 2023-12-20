extends Pickup

func picked(body):
	super.picked(body)
	if body.health != body.max_health:
		body.health += 1
		call_deferred("queue_free")
