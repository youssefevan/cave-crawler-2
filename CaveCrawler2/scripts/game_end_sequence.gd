extends Node2D

var done := false

func _ready():
	$"../BGSprites/Rocket".frame = 0
	$"../Pickups/Flagpole".visible = false
	$MachinePart1.visible = false
	$MachinePart2.visible = false
	$MachinePart3.visible = false

func add_new_part():
	$"../BGSprites/Rocket".frame += 1

func _on_game_end_body_entered(body):
	if body is Player and !done:
		done = true
		$Animator.play("GameEnd")
