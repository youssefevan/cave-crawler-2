extends State

var frame := 0

func enter():
	super.enter()
	frame = 0
	randomize()

func physics_update(delta):
	frame += 1
	if frame >= 60 * 3:
		return attack()
	
	var move_dir = Vector2(
			entity.player.position.x - entity.global_position.x,
			entity.reset_position.y - entity.global_position.y
		).normalized()
	
	if abs(entity.global_position.x - entity.player.position.x) < 24:
		entity.velocity = lerp(entity.velocity, Vector2.ZERO, 5 * delta)
	else:
		entity.velocity = lerp(entity.velocity, entity.speed * 0.3 * move_dir, 5 * delta)

func attack():
	var random = RandomNumberGenerator.new()
	random.randomize()
		
	var new_attack = random.randi_range(0, 1)
	#print("new: ", new_attack)
	#print("last: ", entity.last_attack)
	
	if entity.last_attack == new_attack:
		entity.same_attack += 1
		#print("same: ", entity.same_attack)
		if entity.same_attack >= 3:
			#print("--------loop---------")
			return attack()
	else:
		entity.same_attack = 0
		entity.last_attack = new_attack
		#print("same: ", entity.same_attack)
	
	if new_attack == 0:
		return entity.adjust
	else:
		return entity.chase
