extends Button
class_name ToolButton

@export_enum("Terrain", "Enemy", "Hazard", "Pickup", "Essential") var tool_type : int
@export var tile_coordinate_x : int

var tile_coordinate : Vector2

signal tool_selected(tile_coordinate, tool_type)

func _ready():
	tile_coordinate = Vector2(tile_coordinate_x, tool_type)

func _on_pressed():
	emit_signal("tool_selected", tile_coordinate, tool_type)
