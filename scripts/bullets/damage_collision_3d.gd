extends Area3D
class_name DamageCollision3D

@export var damage_value : int = -1

func _ready():
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area3D):
	var health_component : HealthComponent
	health_component = area.health_component if "health_component" in area else area.get_parent().health_component

	health_component.adjust_health(damage_value)
