extends Area2D

var areas := []
var push_vector := Vector2.ZERO


func is_Colliding() -> bool:
	areas = get_overlapping_areas()
	return areas.size() > 0


func get_push_vector() -> Vector2:
	if is_Colliding():
		var overlapping_area = areas[0]
		push_vector = overlapping_area.global_position.direction_to(global_position)
		push_vector = push_vector.normalized()
	else:
		push_vector = Vector2.ZERO

	return push_vector
