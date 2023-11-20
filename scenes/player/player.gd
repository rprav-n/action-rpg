class_name Player

extends CharacterBody2D

enum State {MOVE, ROLL, ATTACK}

const SPEED: int = 80
const ACCELERATION: int = 800
const FRICTION: int = 800

var input_vector: Vector2 = Vector2.ZERO
var state: State = State.MOVE

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_state: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")


func _physics_process(_delta: float) -> void:
	match state:
		State.MOVE:
			process_move()
		State.ATTACK:
			process_attack()
		State.ROLL:
			process_roll()


func _process(_delta: float) -> void:
	if state == State.MOVE:
		set_input_vector()


func process_move() -> void:
	handle_movement()
	move_and_slide()
	update_animation()


func process_attack() -> void:
	velocity = Vector2.ZERO
	animation_state.travel("Attack")


func attack_animation_finished() -> void:
	state = State.MOVE


func process_roll() -> void:
	pass


func set_input_vector() -> void:
	input_vector.x = Input.get_axis("move_left", "move_right")
	input_vector.y = Input.get_axis("move_up", "move_down")
	input_vector = input_vector.normalized()
	if Input.is_action_just_pressed("attack"):
		state = State.ATTACK


func handle_movement() -> void:
	var delta: float = get_physics_process_delta_time()
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)


func update_animation() -> void:
	if input_vector != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_tree.set("parameters/Attack/blend_position", input_vector)
		animation_state.travel("Run")
	else:
		animation_state.travel("Idle")
