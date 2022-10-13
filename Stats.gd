extends Node

export(int) var max_health = 1 setget set_max_health

var health = max_health setget set_health

signal no_health
signal health_change(value)
signal max_health_change(value)

func _ready() -> void:
	health = max_health

func set_max_health(value: int) -> void:
	max_health = max(value, 1)
	self.health = min(health, max_health)
	emit_signal("max_health_change", max_health)

func set_health(value: int) -> void:
	health = clamp(value, 0, max_health)
	emit_signal("health_change", health)
	
	if(health <= 0):
		emit_signal("no_health")

