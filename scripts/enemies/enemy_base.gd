extends AreaCharacter3D
class_name EnemyBase

@onready var hitbox := get_node("Hitbox") as Area3D

func _ready():
	super()
	hitbox.area_entered.connect(_on_hitbox_entered)

func _physics_process(delta):
	move()

func _on_hitbox_entered(area : Area3D):
	pass

func _on_hurtbox_entered(area : Area3D):
	pass
