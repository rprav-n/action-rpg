class_name Player

extends CharacterBody2D

const SPEED: int = 80
const ACCELERATION: int = 800
const FRICTION: int = 800

var input_vector: Vector2 = Vector2.ZERO

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_state: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")

func _physics_process(delta: float) -> void:
	set_input_vector()
	handle_movement(delta)
	move_and_slide()
	update_animation()


func set_input_vector() -> void:
	input_vector.x = Input.get_axis("move_left", "move_right")
	input_vector.y = Input.get_axis("move_up", "move_down")
	input_vector = input_vector.normalized()


func handle_movement(delta: float) -> void:
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)


func update_animation() -> void:
	if input_vector != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_state.travel("Run")
	else:
		animation_state.travel("Idle")
