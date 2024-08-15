extends Enemy
class_name Slug

@onready var animator = $Animator
@onready var states = $StateManager

@onready var idle = $StateManager/Idle
@onready var move = $StateManager/Move
@onready var shield = $StateManager/Shield

@onready var shield_timer = $ShieldTimer

@onready var bounce_particles = preload("res://scenes/particles/bounce.tscn")

var speed := 80.0
var move_direction := -1
var inch_time := 0.4 # in seconds
var shield_time := 3.0 # in seconds

var bounce_force := 800.0
var deceleration := 8.0

var got_hit := false

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
		velocity.y += gravity * gravity_multiplier * delta
	
	velocity.y = clampf(velocity.y, -250.0, 250.0)

func apply_friction(delta):
	velocity.x = lerp(velocity.x, 0.0, deceleration * delta)

func get_hurt(hitstun_weight):
	super.get_hurt(hitstun_weight)
	got_hit = true

func apply_shake():
	pass

func enter_bounce(bounce_force):
	pass

func _on_hurtbox_area_entered(area):
	super._on_hurtbox_area_entered(area)
	if area.is_in_group("Player"):
		got_hit = true
	elif area.is_in_group("Enemy") and area != $Hitbox:
		if states.current_state == shield:
			got_hit = true

func _on_hitbox_area_entered(area):
	if area.is_in_group("Player") or area.is_in_group("Enemy"):
		#print(states.current_state)
		if states.current_state == shield:
			area.get_parent().enter_bounce(bounce_force)

func spawn_bounce_particles():
	var p = bounce_particles.instantiate()
	get_parent().add_child(p)
	p.global_position = global_position
