extends Enemy
class_name Slug

@onready var animator = $Animator
@onready var states = $StateManager

@onready var idle = $StateManager/Idle
@onready var move = $StateManager/Move
@onready var shield = $StateManager/Shield

@onready var shield_timer = $ShieldTimer

var speed := 100.0
var move_direction := -1
var inch_time := 0.4 # in seconds
var shield_time := 3.0 # in seconds

var bounce_force := 400.0
var deceleration := 8.0

var got_hit := false
@export var shield_state : State

func _ready():
	super._ready()
	shield_timer.wait_time = shield_time
	states.init(self)

func _physics_process(delta):
	super._physics_process(delta)
	states.physics_update(delta)
	apply_gravity(delta)
	
	if velocity.x > 0:
		$Sprite.flip_h = true
	if velocity.x < 0:
		$Sprite.flip_h = false 
	
	move_and_slide()

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * speed_modifier * delta
	
	if is_on_floor():
		velocity.y = 1
	
	velocity.y = clampf(velocity.y, -250.0 * speed_modifier, 250.0 * speed_modifier)

func apply_friction(delta):
	velocity.x = lerp(velocity.x, 0.0, deceleration * delta)

func _on_hurtbox_area_entered(area):
	super._on_hurtbox_area_entered(area)
	if area.is_in_group("Player"):
		got_hit = true

func _on_hitbox_area_entered(area):
	if area.is_in_group("Player"):
		if states.current_state == shield_state:
			area.get_parent().enter_bounce(bounce_force)

