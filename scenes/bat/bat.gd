class_name Bat

extends CharacterBody2D

const FRICTION: int = 400
const MOVE: int = 150

@onready var stats: Stats = $Stats
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var enemy_death_effect_scene: PackedScene = preload("res://scenes/effects/enemy_death/enemy_death_effect.tscn")


func _physics_process(delta: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide()


func spawn_enemy_death_effect() -> void:
	var enemy_death_effect: Effect = enemy_death_effect_scene.instantiate() as Effect
	get_parent().add_child(enemy_death_effect)
	enemy_death_effect.global_position = global_position


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area is SwordHitBox:
		stats.health -= area.damage
		velocity = area.knock_back_vector * MOVE


func _on_stats_no_health() -> void:
	spawn_enemy_death_effect()
	queue_free()
