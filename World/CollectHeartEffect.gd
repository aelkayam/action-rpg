extends AudioStreamPlayer


func _on_finished() -> void:
	queue_free()
