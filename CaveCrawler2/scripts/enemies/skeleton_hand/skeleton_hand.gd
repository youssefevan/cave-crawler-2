extends Enemy
class_name SkeletonHand

@export var print_states : bool

@onready var states = $StateManager
@onready var animator = $Animator
@onready var hitbox_collider = $Hitbox/Collider
@onready var hurtbox_collider = $Hurtbox/Collider

@onready var idle = $StateManager/Idle
@onready var jump = $StateManager/Jump

@onready var particles_jump = preload("res://scenes/particles/skelton_hand_jump.tscn")
@onready var particles_telegraph = preload("res://scenes/particles/skelton_hand.tscn")

var sfx_telegraph = preload("res://audio/sfx/stalactite_anticipate.ogg")
var sfx_jump = preload("res://audio/sfx/stalactite_fall.ogg")

var grab := false
var jump_velocity := 180.0

var frame := 0

var player_detected := false

func _ready():
	super._ready()
	states.init(self)

func _physics_process(delta):
	super._physics_process(delta)
	states.physics_update(delta)
	if not is_on_floor():
		velocity.y += gravity * gravity_multiplier * delta
	
	if abs(player.global_position.x - global_position.x) < 96:
		frame += 1
		
	if frame == 1:
		telegraph()
	
	if abs(player.global_position.x - global_position.x) < 40:
		player_detected = true
	
	move_and_slide()

func _on_hitbox_area_entered(area):
	if area.is_in_group("Player"):
		grab = true
		await get_tree().create_timer(0.29).timeout
		grab = false

func telegraph():
	var p = particles_telegraph.instantiate()
	get_parent().add_child(p)
	p.global_position = global_position
	AudioHandler.play_sfx(sfx_telegraph)
