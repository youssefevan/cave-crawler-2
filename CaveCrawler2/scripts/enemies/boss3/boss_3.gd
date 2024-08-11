extends Enemy
class_name Boss3

@onready var animator = $Animator
@onready var states = $StateManager
@onready var idle = $StateManager/Idle
@onready var laser = $StateManager/Laser
@onready var spawn = $StateManager/Spawn
@onready var orbiting = $StateManager/Orbiting
@onready var death = $StateManager/Death

@onready var laser_scene = preload("res://scenes/bullets/laser.tscn")
@onready var head_scene = preload("res://scenes/enemies/head.tscn")
@onready var knife_scene = preload("res://scenes/bullets/knife.tscn")

@onready var smoke_particles = load("res://scenes/particles/smoke.tscn")
@onready var smoke2_particles = load("res://scenes/particles/smoke2.tscn")
@onready var death_particles = load("res://scenes/particles/boss_death.tscn")

var speed := 50.0
var rotation_speed := 80.0

var start_height

var sfx_phase = preload("res://audio/sfx/boss1_hurt.ogg")
var sfx_death_anim = preload("res://audio/sfx/boss_death.ogg")

#var max_shake_strength := 5.0
#var current_shake_strength : float
#var shake_fade := 2.0
#var random = RandomNumberGenerator.new()

func _ready():
	super._ready()
	
	states.init(self)
	
	$Animator.play("Idle")
	
	start_height = global_position.y
	#print(start_height)

func _physics_process(delta):
	super._physics_process(delta)
	states.physics_update(delta)
	face_player()
	
	$Orbit.rotation_degrees += rotation_speed * delta
	
	if current_shake_strength > 0:
		current_shake_strength = lerpf(current_shake_strength, 0, shake_fade * delta)
		$Boss.position = get_random_offset()
		$Sprite.position = $Boss.position
	
	#move_and_slide()

func face_player():
	if (global_position.x - player.global_position.x) > 0:
		$Boss.flip_h = false
		$Sprite.scale.x = 1
		$Muzzle.position.x = -2
	else:
		$Boss.flip_h = true
		$Sprite.scale.x = -1
		$Muzzle.position.x = 2

func shoot_v():
	if current_health > 0:
		var l = laser_scene.instantiate() 
		get_parent().add_child.call_deferred(l)
		l.global_position.x = player.global_position.x
		l.global_position.y = player.global_position.y - 128
		l.rotation_degrees = 90

func shoot_h():
	if current_health > 0:
		var l = laser_scene.instantiate()
		get_parent().add_child.call_deferred(l)
		l.global_position.y = player.global_position.y
		l.global_position.x = player.global_position.x - 256
		l.scale.x *= 2

func spawn_head():
	if current_health > 0:
		var h = head_scene.instantiate()
		get_parent().add_child.call_deferred(h)
		h.global_position = $HeadSpawn.global_position

func spawn_knives():
	if current_health > 0:
		for i in $Orbit.get_children():
			var k = knife_scene.instantiate()
			i.add_child(k)
			await get_tree().create_timer(0.3).timeout
			
		await get_tree().create_timer(1).timeout
		
		for i in $Orbit.get_children():
			i.get_child(0).player = player
			await get_tree().create_timer(0.3).timeout
		
		await get_tree().create_timer(1).timeout
		
		for i in $Orbit.get_children():
			i.get_child(0).call_deferred("queue_free")
			var k = knife_scene.instantiate()
			get_parent().get_parent().add_child(k)
			k.look_at(player.global_position)
			k.player = player
			k.global_position = i.global_position
			k.throw = true
			await get_tree().create_timer(0.5).timeout

func _on_hitbox_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	pass
	#if body is TileMap:
		#var cell_pos = body.get_coords_for_body_rid(body_rid)
		#var cell_data = body.get_cell_tile_data(0, cell_pos)
		#
		#if cell_data.get_custom_data("health") != 0:
			#body.erase_cell(0, cell_pos)

func get_hurt(hitstun_weight):
	super.get_hurt(hitstun_weight)
	
	if current_health == snapped(.66 * max_health, 1):
		#$Skull.frame = 1
		AudioHandler.play_sfx(sfx_phase)
		var s = smoke_particles.instantiate()
		add_child(s)
		s.position = Vector2(0, -16)
	elif current_health == snapped(.33 * max_health, 1):
		AudioHandler.play_sfx(sfx_phase)
		var s = smoke2_particles.instantiate()
		add_child(s)
		s.position = Vector2(0, -16)

func die():
	#AudioHandler.play_sfx(sfx_die)
	states.change_state(death)
	$Hitbox/Collider.disabled = true
	$Hurtbox/Collider.disabled = true
	AudioHandler.play_sfx(sfx_death_anim)
	
	max_shake_strength = 5.0
	shake_fade = 2.0
	
	apply_shake()
	await get_tree().create_timer(3).timeout
	
	var p = death_particles.instantiate()
	get_parent().add_child(p)
	p.global_position = global_position
	super.die()

func apply_shake():
	current_shake_strength = max_shake_strength

func get_random_offset():
	var shake = random.randf_range(-current_shake_strength, current_shake_strength)
	return Vector2(-shake, shake)
