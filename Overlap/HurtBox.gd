extends Area2D

const HitEffect = preload("res://Effects/HitEffect.tscn")

onready var timer: Timer = $Timer

var invincible := false setget set_invincle

signal invincibility_started
signal invincibility_ended


func _on_Timer_timeout() -> void:
	self.invincible = false


func _on_invincibility_started() -> void:
	set_deferred("monitoring", false)


func _on_invincibility_ended() -> void:
	set_deferred("monitoring", true)


func set_invincle(value) -> void:
	invincible = value
	if invincible:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")


func start_invincibility(duration: float) -> void:
	self.invincible = true
	timer.start(duration)


func create_hitEffect() -> void:
	var hitEffect = HitEffect.instance()
	hitEffect.position = position
	get_parent().add_child(hitEffect)
