extends Enemy
class_name Boss3

@onready var animator = $Animator
@onready var states = $StateManager
@onready var idle = $StateManager/Idle
@onready var laser = $StateManager/Laser
@onready var spawn = $StateManager/Spawn
@onready var orbiting = $StateManager/Orbiting

@onready var laser_scene = preload("res://scenes/bullets/laser.tscn")
@onready var head_scene = preload("res://scenes/enemies/head.tscn")
@onready var knife_scene = preload("res://scenes/bullets/knife.tscn")

var speed := 50.0
var rotation_speed := 80.0

var start_height

func _ready():
	super._ready()
	
	states.init(self)
	
	$Animator.play("Idle")
	
	start_height = global_position.y
	#print(start_height)

func _physics_process(delta):
	super._physics_process(delta)
	states.physics_update(delta)
	face_player()
	
	$Orbit.rotation_degrees += rotation_speed * delta
	
	#move_and_slide()

func face_player():
	if (global_position.x - player.global_position.x) > 0:
		$Boss.flip_h = false
		$Sprite.scale.x = 1
		$Muzzle.position.x = -2
	else:
		$Boss.flip_h = true
		$Sprite.scale.x = -1
		$Muzzle.position.x = 2

func shoot_v():
	var l = laser_scene.instantiate()
	get_parent().add_child.call_deferred(l)
	l.global_position.x = player.global_position.x
	l.global_position.y = player.global_position.y - 128
	l.rotation_degrees = 90

func shoot_h():
	var l = laser_scene.instantiate()
	get_parent().add_child.call_deferred(l)
	l.global_position.y = player.global_position.y
	l.global_position.x = player.global_position.x - 256
	l.scale.x *= 2

func spawn_head():
	var h = head_scene.instantiate()
	get_parent().add_child.call_deferred(h)
	h.global_position = $HeadSpawn.global_position

func spawn_knives():
	for i in $Orbit.get_children():
		var k = knife_scene.instantiate()
		i.add_child(k)
		await get_tree().create_timer(0.3).timeout
		
	await get_tree().create_timer(1).timeout
	
	for i in $Orbit.get_children():
		i.get_child(0).player = player
		await get_tree().create_timer(0.3).timeout
	
	await get_tree().create_timer(1).timeout
	
	for i in $Orbit.get_children():
		i.get_child(0).call_deferred("queue_free")
		var k = knife_scene.instantiate()
		get_parent().get_parent().add_child(k)
		k.look_at(player.global_position)
		k.player = player
		k.global_position = i.global_position
		k.throw = true
		await get_tree().create_timer(0.5).timeout

func _on_hitbox_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	pass
	#if body is TileMap:
		#var cell_pos = body.get_coords_for_body_rid(body_rid)
		#var cell_data = body.get_cell_tile_data(0, cell_pos)
		#
		#if cell_data.get_custom_data("health") != 0:
			#body.erase_cell(0, cell_pos)
