extends AnimatedSprite


func _ready() -> void:
# warning-ignore:return_value_discarded
	connect("animation_finished", self, "_on_animation_finished")
	frame = 0
	play("animate")


func _on_animation_finished() -> void:
	queue_free()
