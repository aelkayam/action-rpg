extends Area2D

const CollectHeartEffect = preload("res://World/CollectHeartEffect.tscn")


func _on_body_entered(_body: Node) -> void:
	PlayerStats.health += 1
	var collectHeartEffect = CollectHeartEffect.instance()
	get_parent().add_child(collectHeartEffect)
	queue_free()
