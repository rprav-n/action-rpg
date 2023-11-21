class_name Stats

extends Node

signal no_health

@export var max_health: int = 1
var health: int = 0 : set = set_health

func _ready() -> void:
	health = max_health


func set_health(value: int) -> void:
	health = value
	if health <= 0:
		no_health.emit()
