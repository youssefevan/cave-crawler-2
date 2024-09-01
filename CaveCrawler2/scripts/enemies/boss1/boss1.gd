extends Enemy
class_name Boss1

var sfx_phase = preload("res://audio/sfx/boss1_hurt.ogg")
var sfx_chomp = preload("res://audio/sfx/boss1_chomp.ogg")
var sfx_slam = preload("res://audio/sfx/slam.ogg")
var sfx_hover = preload("res://audio/sfx/boss1_hover.ogg")
var sfx_drop = preload("res://audio/sfx/boss1_drop.ogg")
var sfx_swoop = preload("res://audio/sfx/boss1_swoop.ogg")
var sfx_death_anim = preload("res://audio/sfx/boss_death.ogg")

var speed := 200.0
var movement_direction : Vector2

@export var blood_particles1 : PackedScene
@export var blood_particles2 : PackedScene
@export var death_particles : PackedScene

@onready var animator = $Animator
@onready var jaw = $Jaw

@onready var states = $StateManager
@onready var idle = $StateManager/Idle
@onready var adjust = $StateManager/Adjust
@onready var slam = $StateManager/Slam
@onready var swoop = $StateManager/Swoop
@onready var chase = $StateManager/Chase
@onready var death = $StateManager/Death

var reset_position : Vector2
var phase := 0

var last_attack := -1
var same_attack := 0

var eye_offset : Vector2
var jaw_offset : Vector2
var outline_offset : Vector2

#var max_shake_strength := 5.0
#var current_shake_strength : float
#var shake_fade := 2.0
#var random = RandomNumberGenerator.new()

func _ready():
	super._ready()
	reset_position = global_position
	eye_offset = $Eye.position
	jaw_offset = $Jaw.position
	outline_offset = $Sprite.position
	$Skull.frame = 3
	$Jaw.frame = 0
	$Sprite.frame = 0
	phase = 0
	
	sfx_death = sfx_death_anim
	
	states.init(self)

func _physics_process(delta):
	super._physics_process(delta)
	
	states.physics_update(delta)
	
	if current_shake_strength > 0:
		current_shake_strength = lerpf(current_shake_strength, 0, shake_fade * delta)
		$Skull.position = get_random_offset()
		$Jaw.position = $Skull.position + jaw_offset
		$Eye.position = $Skull.position + eye_offset
		$Sprite.position = $Skull.position + outline_offset
		
	face_player()
	
	move_and_slide()

func face_player():
	if (global_position.x - player.global_position.x) > 0:
		$Hitbox.scale.x = 1
		$Hurtbox.scale.x = 1
		$Skull.flip_h = false
		$Jaw.flip_h = false
		$Eye.position.x = -16
		$Sprite.scale.x = 1
	else:
		$Hitbox.scale.x = -1
		$Hurtbox.scale.x = -1
		$Skull.flip_h = true
		$Jaw.flip_h = true
		$Eye.position.x = 16
		$Sprite.scale.x = -1

func get_hurt(hitstun_weight):
	super.get_hurt(hitstun_weight)
	
	if current_health == snapped(.66 * max_health, 1):
		$Skull.frame = 4
		AudioHandler.play_sfx(sfx_phase)
		var blood1 = blood_particles1.instantiate()
		add_child(blood1)
		blood1.position = $PartclesSpawnPosition.position
	elif current_health == snapped(.33 * max_health, 1):
		$Skull.frame = 5
		AudioHandler.play_sfx(sfx_phase)
		var blood2 = blood_particles2.instantiate()
		add_child(blood2)
		blood2.position = $PartclesSpawnPosition.position

func disable_hitboxes():
	$Hitbox/Collider.disabled = true
	$Hurtbox/Collider.disabled = true
	$Hurtbox/Collider2.disabled = true

func die():
	#AudioHandler.play_sfx(sfx_die)
	states.change_state(death)
	call_deferred("disable_hitboxes")
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

func play_sfx_chomp():
	AudioHandler.play_sfx(sfx_chomp)
