extends Enemy
class_name Boss1

var speed := 200.0
var movement_direction : Vector2

@export var blood_particles1 : PackedScene
@export var blood_particles2 : PackedScene

@onready var animator = $Animator

@onready var states = $StateManager
@onready var idle = $StateManager/Idle
@onready var adjust = $StateManager/Adjust
@onready var slam = $StateManager/Slam
@onready var swoop = $StateManager/Swoop
@onready var chase = $StateManager/Chase

var reset_position : Vector2
var phase := 0

func _ready():
	super._ready()
	reset_position = global_position
	$Sprite.frame = 0
	phase = 0
	states.init(self)

func _physics_process(delta):
	super._physics_process(delta)
	states.physics_update(delta)
	face_player()
	
	move_and_slide()

func face_player():
	if (global_position.x - player.global_position.x) > 0:
		$Hitbox.scale.x = 1
		$Hurtbox.scale.x = 1
		$Sprite.flip_h = false
	else:
		$Hitbox.scale.x = -1
		$Hurtbox.scale.x = -1
		$Sprite.flip_h = true

func get_hurt(hitstun_weight):
	super.get_hurt(hitstun_weight)
	
	if current_health == snapped(.66 * max_health, 1):
		$Sprite.frame = 1
		var blood1 = blood_particles1.instantiate()
		add_child(blood1)
		blood1.position = $PartclesSpawnPosition.position
	elif current_health == snapped(.33 * max_health, 1):
		$Sprite.frame = 2
		var blood2 = blood_particles2.instantiate()
		add_child(blood2)
		blood2.position = $PartclesSpawnPosition.position
