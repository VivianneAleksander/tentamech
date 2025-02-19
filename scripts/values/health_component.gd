@icon("res://assets/icons/health.svg")
extends Node
class_name HealthComponent

@export var max_health : int = 5
var health : int

var invincible : bool
var invincible_timer : float = 0.0

var resistances : Array[ResistanceComponent]

var is_dead : bool = false

signal health_value_changed (health : int)
signal health_lost
signal health_gained
signal death
signal restored

func _ready():
	resistances.assign(get_children())
	for r in resistances:
		death.connect(r._on_death)
		restored.connect(r._on_restore)
	
	health = max_health
	await get_tree().process_frame
	health_value_changed.emit(health)
	
func _process(delta):
	if invincible_timer <= 0:
		invincible = false
	else:
		invincible_timer -= delta
	
	if health > 0 and is_dead:
		is_dead = false
		restored.emit()

func adjust_health(value : int, type : DamageType.TYPE = DamageType.TYPE.NEUTRAL):
	if value == 0: return
	if value < 0 and invincible: return
	
	var valuef := float(value)
	for r in resistances:
		if not r: continue
		valuef = r.apply_resistance(valuef, type)
	
	value = floori(valuef)
	
	health = clampi(health + value, 0, max_health)
	health_value_changed.emit(health)

	if value > 0:
		health_gained.emit()
	elif value < 0:
		health_lost.emit()
		
	if health <= 0 and not is_dead:
		death.emit()
		is_dead = true

func set_invincible(time : float) -> void:
	if time < 0 or time < invincible_timer: return

	invincible_timer = time
	invincible = true

func get_health_percentage() -> float:
	return float(health) / float(max_health)
