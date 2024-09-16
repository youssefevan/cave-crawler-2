extends Node2D


func _on_child_exiting_tree(_node):
	if len(get_children()) < 1:
		call_deferred("queue_free")
