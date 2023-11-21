class_name Player

extends CharacterBody2D

enum State {MOVE, ROLL, ATTACK}

const SPEED: int = 80
const ACCELERATION: int = 800
const FRICTION: int = 800
const ROLL_SPEED: int = 100

var input_vector: Vector2 = Vector2.ZERO
var roll_vector: Vector2 = Vector2.DOWN

var state: State = State.MOVE

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_state: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
@onready var sword_hitbox: SwordHitBox = $HitboxPivot/SwordHitbox


func _ready() -> void:
	sword_hitbox.knock_back_vector = roll_vector


func _process(_delta: float) -> void:
	match state:
		State.MOVE:
			process_move()
		State.ATTACK:
			process_attack()
		State.ROLL:
			process_roll()
		

func process_move() -> void:
	set_input_vector()
	handle_movement()
	move_and_slide()
	update_animation()


func process_attack() -> void:
	velocity = Vector2.ZERO
	animation_state.travel("Attack")
	

func process_roll() -> void:
	velocity = roll_vector * ROLL_SPEED
	animation_state.travel("Roll")
	move_and_slide()


func attack_animation_finished() -> void:
	state = State.MOVE


func roll_animation_finished() -> void:
	velocity = Vector2.ZERO
	state = State.MOVE


func set_input_vector() -> void:
	input_vector.x = Input.get_axis("move_left", "move_right")
	input_vector.y = Input.get_axis("move_up", "move_down")
	input_vector = input_vector.normalized()
	if Input.is_action_just_pressed("attack"):
		state = State.ATTACK
	if Input.is_action_just_pressed("roll"):
		state = State.ROLL


func handle_movement() -> void:
	var delta: float = get_physics_process_delta_time()
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)


func update_animation() -> void:
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		sword_hitbox.knock_back_vector = roll_vector
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_tree.set("parameters/Attack/blend_position", input_vector)
		animation_tree.set("parameters/Roll/blend_position", input_vector)
		animation_state.travel("Run")
	else:
		animation_state.travel("Idle")
