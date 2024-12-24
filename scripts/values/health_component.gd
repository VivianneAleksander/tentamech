@icon("res://assets/icons/health.svg")
extends Node
class_name HealthComponent

@export var max_health : int = 5
@onready var health : int = max_health

func take_damage(damage : int):
	print("Damage: " + get_parent().name)