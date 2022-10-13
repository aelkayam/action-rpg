extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

export var MAX_SPEED = 50
export var ACCELERATION = 300
export var FRICTION = 200
export var KNOCKBACK_VELOCITY = 120
export var KNOCKBACK_ACCELERATION = 700

enum states { IDLE, WANDER, CHASE }

onready var animated_sprite: AnimatedSprite = $AnimatedSprite
onready var stats: Node = $Stats
onready var player_detection_zone: Area2D = $PlayerDetectionZone
onready var hurt_box: Area2D = $HurtBox

var knockback := Vector2.ZERO
var velocity := Vector2.ZERO
var state = states.WANDER


func _ready() -> void:
	animated_sprite.playing = true


func _on_area_entered(area: Hitbox) -> void:
	take_damage(area)


func _on_no_health() -> void:
	die()


func _physics_process(delta: float) -> void:
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)

	match state:
		states.IDLE:
			stop_moving(delta)
			seek_player()

		states.WANDER:
			move_aimlessly(delta)
			seek_player()

		states.CHASE:
			move_toward_player(delta)

	animated_sprite.flip_h = velocity.x < 0
	velocity = move_and_slide(velocity)


func stop_moving(delta: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)


func move_aimlessly(delta: float) -> void:
	velocity = velocity.move_toward(
		Vector2(rand_range(-1, 1), rand_range(-1, 1)) * MAX_SPEED, ACCELERATION * delta
	)


func move_toward_player(delta: float) -> void:
	var player = player_detection_zone.player

	if player != null:
		var direction_to_player = position.direction_to(player.position)
		velocity = velocity.move_toward(direction_to_player * MAX_SPEED, ACCELERATION * delta)
	else:
		state = states.IDLE


func seek_player() -> void:
	if player_detection_zone.can_see_player():
		state = states.CHASE


func take_damage(area: Hitbox) -> void:
	stats.health -= area.damage
	hurt_box.create_hitEffect()
	hurt_box.start_invincibility(0.2)
	knockback = knockback.move_toward(
		area.knockback_vector * KNOCKBACK_VELOCITY, KNOCKBACK_ACCELERATION
	)

func die() -> void:
	var deathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(deathEffect)
	deathEffect.position = position
	deathEffect.offset = Vector2(0, -8)
	queue_free()
