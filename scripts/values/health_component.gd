@icon("res://assets/icons/health.svg")
extends Node
class_name HealthComponent

@export var max_health : int = 5
@onready var health : int = max_health

var invincible : bool
var invincible_timer : float = 0.0

signal health_value_changed (health : int)
signal health_lost
signal health_gained
signal death

func _ready():
	health = max_health
	health_value_changed.emit(health)

func _process(delta):
	if invincible_timer <= 0:
		invincible = false
	else:
		invincible_timer -= delta

func adjust_health(value : int):
	if value == 0: return
	if value < 0 and invincible: return

	health = clampi(health + value, 0, max_health)
	health_value_changed.emit(health)

	if value > 0:
		health_gained.emit()
	else:
		health_lost.emit()
	
	if health <= 0:
		death.emit()

func set_invincible(time : float) -> void:
	if time < 0 or time < invincible_timer: return

	invincible_timer = time
	invincible = true
