class_name Bat

extends CharacterBody2D

const FRICTION: int = 400
const MOVE: int = 150

@onready var stats: Stats = $Stats


func _physics_process(delta: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area is SwordHitBox:
		stats.health -= area.damage
		velocity = area.knock_back_vector * MOVE


func _on_stats_no_health() -> void:
	queue_free()
