extends KinematicBody2D

export var MAX_SPEED = 80
export var ROLL_SPEED = 100
export var ACCELERATION = 500
export var ROLL_ACCELERATION = 800
export var FRICTION = 500

enum PlayerState { MOVE, ROLL, ATTACK }

var velocity: Vector2 = Vector2.ZERO
var roll_vector = Vector2.RIGHT
var state = PlayerState.MOVE

onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var anim_tree: AnimationTree = $AnimationTree
onready var anim_state = anim_tree.get("parameters/playback")
onready var sword_hitbox: Area2D = $HitBoxPivot/SwordHitbox
onready var roll_hitbox: Area2D = $HitBoxPivot/RollHitBox


func _ready() -> void:
	anim_tree.active = true
	sword_hitbox.knockback_vector = roll_vector
	roll_hitbox.knockback_vector = roll_vector

func _physics_process(delta: float) -> void:
	match state:
		PlayerState.MOVE:
			move_state(delta)

		PlayerState.ROLL:
			roll_state(delta)

		PlayerState.ATTACK:
			attack_state(delta)


func move_state(delta: float) -> void:
	var input_vector := Vector2.ZERO
	input_vector.x = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	input_vector.y = (
		Input.get_action_strength("move_down") 
		- Input.get_action_strength("move_up")
	)

	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		anim_tree.set("parameters/Idle/blend_position", input_vector)
		anim_tree.set("parameters/Run/blend_position", input_vector)
		anim_tree.set("parameters/Attack/blend_position", input_vector)
		anim_tree.set("parameters/Roll/blend_position", input_vector)
		anim_state.travel("Run")
		roll_vector = input_vector
		sword_hitbox.knockback_vector = input_vector
		roll_hitbox.knockback_vector = input_vector
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)

	else:
		anim_state.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	move()

	if Input.is_action_just_pressed("attack"):
		state = PlayerState.ATTACK

	if Input.is_action_just_pressed("roll"):
		state = PlayerState.ROLL


func attack_state(delta: float) -> void:
	anim_state.travel("Attack")
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move()


func roll_state(delta: float) -> void:
	anim_state.travel("Roll")
	velocity = velocity.move_toward(roll_vector * ROLL_SPEED, ROLL_ACCELERATION * delta)
	move()


func attack_anim_finished() -> void:
	if Input.is_action_pressed("roll"):
		state = PlayerState.ROLL
	else:
		state = PlayerState.MOVE


func roll_anim_finished() -> void:
	if Input.is_action_pressed("attack"):
		state = PlayerState.ATTACK
	else:
		state = PlayerState.MOVE


func move() -> void:
	velocity = move_and_slide(velocity)
