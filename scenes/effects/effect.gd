class_name Effect

extends Node2D


func _ready() -> void:
	connect("animation_finished", _on_animation_finished)


func _on_animation_finished() -> void:
	queue_free()
