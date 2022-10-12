extends Node2D

var GrassEffect = preload("res://Effects/GrassEffect.tscn")
onready var stats: Node = $Stats


func create_grass_effect():
	var grassEffect = GrassEffect.instance()
	get_parent().add_child(grassEffect)
	grassEffect.position = self.position


func _on_area_entered(area: Hitbox) -> void:
	create_grass_effect()
	stats.health -= area.damage
	

func _on_no_health() -> void:
	queue_free()
