extends Area2D

func _ready():
	$Animator.play("Laser")


func _on_animator_animation_finished(anim_name):
	call_deferred("queue_free")
