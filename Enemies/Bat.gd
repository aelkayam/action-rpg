extends KinematicBody2D

export var FRICTION = 200
export var KNOCKBACK_VELOCITY = 120
export var KNOCKBACK_ACCELERATION = 700

onready var stats: Node = $Stats

var knockback := Vector2.ZERO


func _physics_process(delta: float) -> void:
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)


func _on_area_entered(area: Hitbox) -> void:
	stats.health -= area.damage
	knockback = knockback.move_toward(
		area.knockback_vector * KNOCKBACK_VELOCITY, KNOCKBACK_ACCELERATION
	)


func _on_no_health() -> void:
	die()


func die() -> void:
	queue_free()
