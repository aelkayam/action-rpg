extends Node2D

var GrassEffect = preload("res://Effects/GrassEffect.tscn")


func create_grass_effect():
	var grassEffect = GrassEffect.instance()
	get_parent().add_child(grassEffect)
	grassEffect.position = self.position


func _on_area_entered(_area: Area2D) -> void:
	create_grass_effect()
	queue_free()
