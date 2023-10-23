extends Node

@export var opening_scene : PackedScene

func _ready():
	var s = opening_scene.instantiate()
	get_tree().get_root().add_child.call_deferred(s)
