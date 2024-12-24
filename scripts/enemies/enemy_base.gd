extends AreaCharacter3D
class_name EnemyBase

@export_range(0.0, 1.0, 0.001) var friction : float = 0.1

@onready var hitbox := get_node("Hitbox") as Area3D

func _ready():
	super()
	hitbox.area_entered.connect(_on_hitbox_entered)

func _physics_process(delta):
	move()

func _on_hitbox_entered(area : Area3D):
	pass

func _on_hurtbox_entered(area : Area3D):
	var damage : int = 0
	if "damage" in area:
		damage = area.damage
	elif "damage" in area.get_parent():
		damage = area.get_parent().damage

	health_component.take_damage(damage)
