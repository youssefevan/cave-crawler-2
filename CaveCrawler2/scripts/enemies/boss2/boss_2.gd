extends Enemy
class_name Boss2

@onready var animator = $Animator
@onready var states = $StateManager
@onready var idle = $StateManager/Idle
@onready var chase = $StateManager/Chase
@onready var sleep = $StateManager/Sleep
@onready var wait = $StateManager/Wait
@onready var muzzle = $Muzzle

@onready var vines_particles = load("res://scenes/particles/boss_vines.tscn")
@onready var smoke_particles = load("res://scenes/particles/smoke.tscn")
@onready var smoke2_particles = load("res://scenes/particles/smoke2.tscn")

@onready var bullet = load("res://scenes/bullets/turret_bullet.tscn")

var sfx_phase = preload("res://audio/sfx/boss1_hurt.ogg")
var sfx_die = preload("res://audio/sfx/boss_death.ogg")

var fire_rate := 0.4
var can_fire := false

var speed := 140.0
var acceleration := 1.0

var move_direction := -1

func _ready():
	super._ready()
	states.init(self)

func _physics_process(delta):
	super._physics_process(delta)
	states.physics_update(delta)
	
	muzzle.look_at(player.global_position + Vector2(0, 4))
	
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
