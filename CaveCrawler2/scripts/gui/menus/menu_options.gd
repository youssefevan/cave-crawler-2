extends Control

func _on_back_pressed():
	call_deferred("queue_free")
