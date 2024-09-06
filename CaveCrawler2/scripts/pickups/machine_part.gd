extends Pickup

var part_number := 0
var speed := 50.0

var sfx_picked = preload("res://audio/sfx/health_pickup.ogg")

@onready var particles_picked = load("res://scenes/particles/health_picked.tscn")

func _ready() -> void:
	$Sprite.frame = part_number
	
	$Animator.play("bob")

func picked(body):
	super.picked(body)
	
	AudioHandler.play_sfx(sfx_picked)
	
	$Animator.play("picked")
	
	var p = particles_picked.instantiate()
	get_parent().add_child(p)
	p.global_position = global_position

func _physics_process(delta: float) -> void:
	global_position.y += speed * delta


func _on_body_entered(body: Node2D) -> void:
	super._on_area_body_entered(body)
	if body is TileMap:
		speed = 0


func _on_animator_animation_finished(anim_name: StringName) -> void:
	if anim_name == "picked":
		call_deferred("queue_free")
