@icon("res://assets/icons/bean_counter.svg")
extends Node
class_name BeanCounter

@export var max_count : int = 3
@export var starting_count : int = 0
@onready var count : int = starting_count

signal count_reached

func increment() -> void:
	count = clamp(count + 1, 0, max_count)
	if count == max_count:
		count_reached.emit()
		count = 0
