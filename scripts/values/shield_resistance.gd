extends ResistanceComponent
class_name ShieldResistance

@export var health : int = 10

@export_category("Resistances")
@export var resistance : float = 0.5
@export var resistance_types : Array[DamageType.TYPE] 

@export_category("Healing")
@export var heal_speed : float = 10.0
@export var heal_delay : float = 1.0
@export var restore_delay : float = 5.0

var shield_health : HealthComponent
var heal_delay_timer : Timer
var restore_delay_timer : Timer
var heal_tween : Tween

signal shield_damaged
signal shield_destroyed
signal shield_restored

func _ready() -> void:
	shield_health = HealthComponent.new()
	shield_health.max_health = health
	shield_health.death.connect(_on_shield_death)
	shield_health.health_lost.connect(_on_shield_damaged)
	add_child(shield_health)
	for type in resistance_types:
		var r = AttackResistance.new()
		r._type = type
		r.adjustment = resistance
		shield_health.add_child(r)
	
	heal_delay_timer = Timer.new()
	heal_delay_timer.one_shot = true
	heal_delay_timer.timeout.connect(_heal_shield)
	add_child(heal_delay_timer)
	
	restore_delay_timer = Timer.new()
	restore_delay_timer.one_shot = true
	restore_delay_timer.timeout.connect(_restore_shield)
	add_child(restore_delay_timer)

func apply_resistance(value : float, type : int = 0) -> float:
	var prior_health = shield_health.health
	shield_health.adjust_health(int(value))
	var new_health = shield_health.health
	var health_delta = abs(prior_health - new_health)
	
	value -= health_delta * sign(value)
	
	return value

func _on_shield_damaged() -> void:
	_halt_timers_and_tweeners()
	if shield_health.is_dead:
		restore_delay_timer.start(restore_delay)
	else:
		shield_damaged.emit()
		heal_delay_timer.start(heal_delay)

func _on_shield_death() -> void:
	shield_destroyed.emit()
	_halt_timers_and_tweeners()
	restore_delay_timer.start(restore_delay)

func _heal_shield() -> void:
	heal_tween = create_tween()
	var heal_speed_adjusted =  heal_speed * (1.0 - shield_health.get_health_percentage())
	heal_tween.tween_property(shield_health, "health", shield_health.max_health, heal_speed_adjusted)

func _restore_shield() -> void:
	shield_restored.emit()
	_heal_shield()

func _halt_timers_and_tweeners() -> void:
	if not heal_delay_timer.is_stopped():
		heal_delay_timer.stop()
	if not restore_delay_timer.is_stopped():
		restore_delay_timer.stop()
	if heal_tween and heal_tween.is_valid():
		heal_tween.kill()

func _on_death() -> void:
	_halt_timers_and_tweeners()

func _on_restore() -> void:
	_halt_timers_and_tweeners()
	restore_delay_timer.start(restore_delay)
