extends Area2D
class_name BossDoor

@export_enum("entrance", "exit") var type

var open

func _ready():
	if type == 0:
		open = true
	else:
		open = false

func _physics_process(delta):
	if open:
		$Wall/Collider.disabled = true
	else:
		$Wall/Collider.disabled = false

func _on_body_entered(body):
	if body is Player:
		if type == 0:
			if open == true:
				open = false
				animate(0)

func animate(dir):
	var sprite = $Sprite
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "position", Vector2(0, dir), .5).set_trans(Tween.TRANS_LINEAR)
