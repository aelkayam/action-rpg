extends Node2D

onready var animated_sprite: AnimatedSprite = $AnimatedSprite


func _ready() -> void:
	animated_sprite.play("animate")


func _on_animation_finished() -> void:
	queue_free()
