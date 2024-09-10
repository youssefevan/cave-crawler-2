extends Node2D

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
	if $"../BGSprites/Rocket".frame == 4:
		power_up()

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
	pass
