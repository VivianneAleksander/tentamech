@icon("res://assets/icons/energy_component.svg")
extends Node
class_name EnergyComponent

@export var fill_rate : float = 1.0
var current_fill : float = 0.0

signal energy_value_changed (health : int)
signal energy_lost
signal energy_gained

func _process(delta: float) -> void:
	current_fill = clampf(current_fill + (fill_rate * delta), 0.0, 1.0)
	energy_value_changed.emit(current_fill)

func adjust_energy(val : float) -> void:
	current_fill = clampf(current_fill + val, 0.0, 1.0)
	energy_value_changed.emit(current_fill)
	if val > 0:
		energy_gained.emit()
	elif val < 0:
		energy_lost.emit()
