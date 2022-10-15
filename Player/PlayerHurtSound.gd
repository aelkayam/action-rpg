extends AudioStreamPlayer


func _ready() -> void:
# warning-ignore:return_value_discarded
	connect("finished", self, "queue_free")
