class_name Bat

extends CharacterBody2D

enum State {IDLE, WANDER, CHASE}

const KNOCK_BACK_SPEED: int = 50
const SPEED: int = 50
const ACCELERATION: int = 400
const FRICTION: int = 500
const enemy_death_effect_scene: PackedScene = preload("res://scenes/effects/enemy_death/enemy_death_effect.tscn")

@onready var stats: Stats = $Stats
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var detection_zone: DetectionZone = $DetectionZone

var state: State = State.IDLE

func _physics_process(delta: float) -> void:
	
	match state:
		State.IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		State.WANDER:
			pass
		State.CHASE:
			var player: Player = detection_zone.player
			if player != null:
				var direction: Vector2 = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * SPEED, ACCELERATION * delta)
			else:
				state = State.IDLE
	move_and_slide()
	update_animation()


func seek_player() -> void:
	if detection_zone.can_see_player():
		state = State.CHASE
		


func spawn_enemy_death_effect() -> void:
	var enemy_death_effect: Effect = enemy_death_effect_scene.instantiate() as Effect
	get_parent().add_child(enemy_death_effect)
	enemy_death_effect.global_position = global_position


func update_animation() -> void:
	if velocity.x != 0:
		animated_sprite_2d.flip_h = velocity.x < 0


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area is SwordHitBox:
		stats.health -= area.damage
		velocity = area.knock_back_vector * KNOCK_BACK_SPEED


func _on_stats_no_health() -> void:
	spawn_enemy_death_effect()
	queue_free()
