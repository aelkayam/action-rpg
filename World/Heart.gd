extends Area2D


func _on_body_entered(_body: Node) -> void:
	PlayerStats.health += 1
	queue_free()
