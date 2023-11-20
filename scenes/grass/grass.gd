class_name Grass

extends Node2D

var grass_effect_scene: PackedScene = preload("res://scenes/grass_effect/grass_effect.tscn")


func spawn_grass_effect() -> void:
	var grass_effect: GrassEffect = grass_effect_scene.instantiate() as GrassEffect
	get_parent().add_child(grass_effect)
	grass_effect.global_position = global_position
	

func _on_hurtbox_area_entered(_area: Area2D) -> void:
	queue_free()
	spawn_grass_effect()
