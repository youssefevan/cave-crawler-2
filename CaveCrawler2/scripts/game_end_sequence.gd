extends Node2D

@onready var particles_stage1 = load("res://scenes/particles/rocket_stage_1.tscn")
@onready var particles_stage2 = load("res://scenes/particles/rocket_stage_2.tscn")
@onready var particles_build = load("res://scenes/particles/rocket_build.tscn")

var sfx_charge = preload("res://audio/sfx/rocket_charge.ogg")
var sfx_takeoff = preload("res://audio/sfx/rocket_blast3.ogg")
var sfx_build = preload("res://audio/sfx/slam.ogg")

var done := false

var player

func _ready():
	$"../BGSprites/Rocket".frame = 0
	$"../Pickups/Flagpole".visible = false
	$MachinePart1.visible = false
	$MachinePart2.visible = false
	$MachinePart3.visible = false

func add_new_part():
	$"../BGSprites/Rocket".frame += 1
	
	if $"../BGSprites/Rocket".frame == 1:
		var b = particles_build.instantiate()
		get_parent().add_child(b)
		b.global_position = $"../BGSprites/Rocket/PartPos1".global_position
	
	if $"../BGSprites/Rocket".frame == 2:
		var b = particles_build.instantiate()
		get_parent().add_child(b)
		b.global_position = $"../BGSprites/Rocket/PartPos2".global_position
	
	if $"../BGSprites/Rocket".frame == 3:
		var b = particles_build.instantiate()
		get_parent().add_child(b)
		b.global_position = $"../BGSprites/Rocket/PartPos3".global_position
	
	if $"../BGSprites/Rocket".frame == 4:
		AudioHandler.play_sfx(sfx_charge)
	else:
		AudioHandler.play_sfx(sfx_build)

func _on_game_end_body_entered(body):
	if body is Player and !done:
		done = true
		body.game_end_start()
		player = body
		await get_tree().create_timer(1).timeout
		$Animator.play("GameEnd")

func move_player():
	player.movement_input = 1

func power_up():
	var s1_1 = particles_stage1.instantiate()
	get_parent().add_child(s1_1)
	s1_1.global_position = $"../BGSprites/Rocket/SmokePos".global_position
	
	var s1_2 = particles_stage1.instantiate()
	get_parent().add_child(s1_2)
	s1_2.global_position = $"../BGSprites/Rocket/SmokePos".global_position
	s1_2.scale.x = -1
	
	AudioHandler.play_sfx(sfx_takeoff)

func take_off():
	var s2 = particles_stage2.instantiate()
	$"../BGSprites/Rocket/SmokePos".add_child(s2)
