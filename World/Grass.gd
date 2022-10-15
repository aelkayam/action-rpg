extends Node2D

const GrassEffect = preload("res://Effects/GrassEffect.tscn")
const Heart = preload("res://World/Heart.tscn")

export(float) var DROP_CHANCE = 0.1

onready var stats: Node = $Stats


func create_grass_effect():
	var grassEffect = GrassEffect.instance()
	get_parent().add_child(grassEffect)
	grassEffect.position = self.position


func _on_area_entered(area: Hitbox) -> void:
	create_grass_effect()
	stats.health -= area.damage


func _on_no_health() -> void:
	drop_heart()
	queue_free()
	# call_deferred("queue_free")


func drop_heart() -> void:
	var rand_num = rand_range(0, 1)
	if rand_num < DROP_CHANCE:
		var heart = Heart.instance()
		heart.global_position = global_position

		var parent = get_parent()
		parent.call_deferred("add_child", heart)
