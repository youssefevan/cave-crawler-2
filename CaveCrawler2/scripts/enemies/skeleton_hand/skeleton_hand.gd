extends Enemy
class_name SkeletonHand

@export var print_states : bool

@onready var states = $StateManager
@onready var animator = $Animator
@onready var hitbox_collider = $Hitbox/Collider
@onready var hurtbox_collider = $Hurtbox/Collider

@onready var idle = $StateManager/Idle
@onready var jump = $StateManager/Jump


var grab := false
var jump_velocity := 150.0

var player_detected := false

func _ready():
	super._ready()
	states.init(self)

func _physics_process(delta):
	super._physics_process(delta)
	states.physics_update(delta)
	if not is_on_floor():
		velocity.y += gravity * speed_modifier * delta
	
	if abs(player.global_position.x - global_position.x) < 32:
		player_detected = true
	
	move_and_slide()

func _on_hitbox_area_entered(area):
	if area.is_in_group("Player"):
		grab = true
		await get_tree().create_timer(0.29).timeout
		grab = false
