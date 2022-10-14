extends Node2D

export(int) var wander_range = 32

onready var start_position := global_position
onready var target_position := global_position
onready var timer: Timer = $Timer

signal timer_zero


func _on_Timer_timeout() -> void:
	update_target_position()
	emit_signal("timer_zero")


func _ready() -> void:
	update_target_position()


func set_wander_time(duration: int) -> void:
	timer.start(duration)


func update_target_position() -> void:
	var target_vector = Vector2(
		rand_range(-wander_range, wander_range), rand_range(-wander_range, wander_range)
	)
	target_position = start_position + target_vector
