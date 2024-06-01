extends Bullet

func _on_area_entered(area):
	if area.get_collision_layer_value(7):
		if area.get_parent().is_in_group("Player"):
			explode()

func damage_tile(body, cell_data, cell_pos):
	body.erase_cell(0, cell_pos)
