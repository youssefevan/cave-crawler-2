extends Enemy

@onready var animator = $Animator

@onready var states = $StateManager
@onready var idle = $StateManager/Idle
@onready var run = $StateManager/Run

@onready var muzzle = $Muzzle

var can_fire := true
var fire_rate := 0.25

var bullet = preload("res://scenes/bullets/turret_bullet.tscn")
var muzzle_flash = preload("res://scenes/particles/muzzle_flash.tscn")
var sfx_shoot = preload("res://audio/sfx/player/player_shoot.ogg")

func _ready():
	super._ready()
	states.init(self)

func _physics_process(delta):
	super._physics_process(delta)
	states.physics_update(delta)
	apply_gravity(delta)
	
	shoot()
	
	move_and_slide()

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func shoot():
	if can_fire == true:
		if OptionsHandler.particles_enabled == true:
			var mf = muzzle_flash.instantiate()
			muzzle.add_child(mf)
		
		var b = bullet.instantiate()
		get_tree().get_root().add_child(b)
		b.position = muzzle.global_position
		if muzzle.scale.x == 1:
			b.speed = -b.speed
		
		AudioHandler.play_sfx(sfx_shoot)
		
		can_fire = false
		await get_tree().create_timer(fire_rate).timeout
		can_fire = true
