extends Enemy
class_name Boss2

@onready var animator = $Animator
@onready var states = $StateManager
@onready var idle = $StateManager/Idle
@onready var chase = $StateManager/Chase
@onready var sleep = $StateManager/Sleep
@onready var wait = $StateManager/Wait
@onready var death = $StateManager/Death
@onready var muzzle = $Muzzle

@onready var vines_particles = load("res://scenes/particles/boss_vines.tscn")
@onready var smoke_particles = load("res://scenes/particles/smoke.tscn")
@onready var smoke2_particles = load("res://scenes/particles/smoke2.tscn")
@onready var death_particles = load("res://scenes/particles/boss_death.tscn")

@onready var bullet = load("res://scenes/bullets/turret_bullet.tscn")

var sfx_phase = preload("res://audio/sfx/boss1_hurt.ogg")
var sfx_death_anim = preload("res://audio/sfx/boss_death.ogg")
var sfx_shoot = preload("res://audio/sfx/enemy_shoot.ogg")
var sfx_chase = preload("res://audio/sfx/boss2/boss2_chase.ogg")
var sfx_transform = preload("res://audio/sfx/boss2/boss2_transform.ogg")

var music_theme = preload("res://audio/music/world1_boss.ogg")

var fire_rate := 0.4
var can_fire := false

var speed := 140.0
var acceleration := 1.0

var move_direction := -1

#var max_shake_strength := 5.0
#var current_shake_strength : float
#var shake_fade := 2.0
#var random = RandomNumberGenerator.new()

func _ready():
	super._ready()
	states.init(self)

func _physics_process(delta):
	super._physics_process(delta)
	states.physics_update(delta)
	
	velocity.y += gravity * delta
	velocity.y = clampf(velocity.y, -250.0, 250.0)
	
	muzzle.look_at(player.global_position - Vector2(0, 4))
	
	if current_shake_strength > 0:
		current_shake_strength = lerpf(current_shake_strength, 0, shake_fade * delta)
		$Tank.position = get_random_offset() + Vector2(0, -32)
		$Sprite.position = $Tank.position
		$Muzzle.visible = false
	else:
		$Muzzle.visible = false
	
	move_and_slide()

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

func vines():
	var v = vines_particles.instantiate()
	add_child(v)
	v.global_position = global_position + Vector2(0, -8)

func disabled_hitboxes():
	$Hitbox/Collider.disabled = true
	$Hurtbox/Collider.disabled = true

func die():
	#AudioHandler.play_sfx(sfx_die)
	states.change_state(death)
	call_deferred("disabled_hitboxes")
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
