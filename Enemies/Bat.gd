extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")
const SOFT_COLLISION_PUSH = 300

export var MAX_SPEED = 50
export var WANDER_SPEED = 25
export var ACCELERATION = 300
export var FRICTION = 200
export var WANDER_ACCELERATION = 100
export var WANDER_INTOLERANCE = 5
export var KNOCKBACK_VELOCITY = 120
export var KNOCKBACK_ACCELERATION = 700

enum states { IDLE, WANDER, CHASE }

onready var animated_sprite: AnimatedSprite = $AnimatedSprite
onready var stats: Node = $Stats
onready var player_detection_zone: Area2D = $PlayerDetectionZone
onready var hurt_box: Area2D = $HurtBox
onready var soft_collision: Area2D = $SoftCollision
onready var wander_controller: Node2D = $WanderController

var knockback := Vector2.ZERO
var velocity := Vector2.ZERO
var state = states.WANDER


func _ready() -> void:
	var num_of_frames = animated_sprite.frames.get_frame_count("fly")
	animated_sprite.frame = randi() % num_of_frames
	animated_sprite.playing = true
	state = pick_random_state([states.IDLE, states.WANDER])


func _on_area_entered(area: Hitbox) -> void:
	take_damage(area)


func _on_no_health() -> void:
	die()


func _on_WanderController_timer_zero() -> void:
	switch_between_states()


func _physics_process(delta: float) -> void:
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)

	match state:
		states.IDLE:
			seek_player()
			stop_moving(delta)

		states.WANDER:
			seek_player()
			move_aimlessly(delta)

		states.CHASE:
			move_toward_player(delta)

#	add push vector to avoid overlapping another bat
	velocity += soft_collision.get_push_vector() * delta * SOFT_COLLISION_PUSH
	velocity = move_and_slide(velocity)


func stop_moving(delta: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)


func move_aimlessly(delta: float) -> void:
	accelerate_towards(wander_controller.target_position, WANDER_SPEED, WANDER_ACCELERATION, delta)
	
	# to prevent the bat wiggle when it arrives the target:
	if global_position.distance_to(wander_controller.target_position) <= WANDER_INTOLERANCE:
		switch_between_states()


func move_toward_player(delta: float) -> void:
	var player = player_detection_zone.player

	if player != null:
		accelerate_towards(player.position, MAX_SPEED, ACCELERATION, delta)
	else:
		switch_between_states()


func switch_between_states() -> void:
	state = pick_random_state([states.IDLE, states.WANDER])
	wander_controller.set_wander_time(rand_range(1, 4))


func pick_random_state(states_list: Array) -> int:
	states_list.shuffle()
	return states_list.pop_front()


func seek_player() -> void:
	if player_detection_zone.can_see_player():
		state = states.CHASE


# damage effect and invincibility trigger
func take_damage(area: Hitbox) -> void:
	stats.health -= area.damage
	hurt_box.create_hitEffect()
	hurt_box.start_invincibility(0.2)
	knockback = knockback.move_toward(
		area.knockback_vector * KNOCKBACK_VELOCITY, KNOCKBACK_ACCELERATION
	)


# apply direction and velocity accordingly
func accelerate_towards(target: Vector2, speed: int, acceleration: int, delta: float) -> void:
	var direction_to_target = position.direction_to(target)
	velocity = velocity.move_toward(direction_to_target * speed, acceleration * delta)
	animated_sprite.flip_h = velocity.x < 0


# set death effect on the bat position
func die() -> void:
	var deathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(deathEffect)
	deathEffect.position = position
	deathEffect.offset = Vector2(0, -8)
	queue_free()
