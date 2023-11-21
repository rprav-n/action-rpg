class_name Hurtbox

extends Area2D

@export var show_hit: bool = true

const hit_effect_scene: PackedScene = preload("res://scenes/effects/hit_effect/hit_effect.tscn")

func spawn_hit_effect() -> void:
	var hit_effect: Effect = hit_effect_scene.instantiate() as Effect
	get_tree().current_scene.add_child(hit_effect)
	hit_effect.global_position = global_position


func _on_area_entered(_area: Area2D) -> void:
	if show_hit:
		spawn_hit_effect()
