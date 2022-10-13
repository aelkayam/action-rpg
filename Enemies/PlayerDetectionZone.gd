extends Area2D

var player: KinematicBody2D = null


func can_see_player() -> bool:
	return player != null


func _on_body_entered(body: KinematicBody2D) -> void:
	player = body


func _on_body_exited(_body: KinematicBody2D) -> void:
	player = null
