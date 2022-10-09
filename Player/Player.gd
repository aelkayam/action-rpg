extends KinematicBody2D

const MAX_SPEED = 100
const ACCELERATION = 500
const FRICTION = 450

enum PlayerState{
	MOVE,
	ROLL,
	ATTACK
}

var velocity: Vector2 = Vector2.ZERO
var state = PlayerState.MOVE

onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var anim_tree: AnimationTree = $AnimationTree
onready var anim_state = anim_tree.get("parameters/playback")


func _ready() -> void:
	anim_tree.active = true


func _physics_process(delta: float) -> void:
	match state:
		PlayerState.MOVE:
			move_state(delta)
		
		PlayerState.ROLL:
			pass
		
		PlayerState.ATTACK:
			attack_state(delta)
			


func move_state(delta: float) -> void:
	var input_vector := Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	
	
	if input_vector != Vector2.ZERO:
		anim_tree.set("parameters/Idle/blend_position", input_vector)
		anim_tree.set("parameters/Run/blend_position", input_vector)
		anim_tree.set("parameters/Attack/blend_position", input_vector)
		anim_state.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	
	else:
		anim_state.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("attack"):
		state = PlayerState.ATTACK


func attack_state(delta: float) -> void:
	anim_state.travel("Attack")
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	velocity = move_and_slide(velocity)


func attack_anim_finished() -> void:
	state = PlayerState.MOVE	
	


func roll_state(delta: float) -> void:
	pass




