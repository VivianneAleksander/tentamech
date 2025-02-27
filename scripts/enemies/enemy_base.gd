extends AreaCharacter3D
class_name EnemyBase

@onready var hitbox := get_node("Hitbox") as Area3D
@onready var ai_taskmaster := $AITaskmaster as AITaskmaster
@export var score_value : int = 1000

func _ready():
	super()
	hitbox.area_entered.connect(_on_hitbox_entered)

func _physics_process(delta):
	move()

func _on_hitbox_entered(area : Area3D):
	pass

func _on_hurtbox_entered(area : Area3D):
	pass

func perish():
	set_hitbox_monitoring(false)
	super()
	
func set_hitbox_monitoring(value : bool) -> void:
	if dead: return
	hitbox.set_deferred("monitoring", value)
	hitbox.set_deferred("monitorable", value)
