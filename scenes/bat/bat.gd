class_name Bat

extends CharacterBody2D

const FRICTION: int = 400
const MOVE: int = 150


func _physics_process(delta: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area is SwordHitBox:
		velocity = area.knock_back_vector * MOVE
