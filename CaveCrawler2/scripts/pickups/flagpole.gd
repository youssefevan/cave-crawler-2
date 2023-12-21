extends Pickup

func picked(body):
	super.picked(body)
	$Sprite.frame = 1
	body.end_level()
