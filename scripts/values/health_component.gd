@icon("res://assets/icons/health.svg")
extends Node
class_name HealthComponent

@export var max_health : int = 5
@onready var health : int = max_health

signal health_value_changed (health : int)
signal health_lost
signal health_gained
signal death

func _ready():
	health = max_health
	health_value_changed.emit(health)

func adjust_health(value : int):
	if value == 0: return

	health = clampi(health + value, 0, max_health)
	health_value_changed.emit(health)

	if value > 0:
		health_gained.emit()
	else:
		health_lost.emit()
	
	if health >= 0:
		death.emit()
