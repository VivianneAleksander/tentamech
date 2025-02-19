extends Area3D
class_name DamageCollision3D

@export var damage_value : int = -1
@export var damage_type : DamageType.TYPE = DamageType.TYPE.NEUTRAL

signal damage_dealt

func _ready():
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area3D):
	var health_component : HealthComponent
	if "health_component" in area:
		health_component = area.health_component
	elif "health_component" in area.get_parent():
		health_component = area.get_parent().health_component
	else:
		return

	health_component.adjust_health(damage_value, damage_type)
	damage_dealt.emit()
