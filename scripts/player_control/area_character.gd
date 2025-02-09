extends Node3D
class_name AreaCharacter3D

@onready var hurtbox := get_node("Hurtbox") as Area3D
@onready var health_component := get_node("HealthComponent") as HealthComponent

var velocity : Vector3 = Vector3.ZERO
var forces : Array[Vector3]

signal character_died(character : AreaCharacter3D)
var dead : bool = false

func _ready():
	process_physics_priority = 1
	hurtbox.area_entered.connect(_on_hurtbox_entered)
	health_component.death.connect(perish)

func _physics_process(delta):
	move()

func add_force(force : Vector3):
	forces.append(force)

func move():
	for force in forces:
		velocity += force
	
	forces.clear()
	global_position += velocity

func _on_hurtbox_entered(area : Area3D):
	pass

func perish():
	character_died.emit(self)
	set_hurtbox_monitoring(false)
	dead = true

func set_hurtbox_monitoring(value : bool) -> void:
	if dead: return
	hurtbox.set_deferred("monitoring", value)
	hurtbox.set_deferred("monitorable", value)
	
