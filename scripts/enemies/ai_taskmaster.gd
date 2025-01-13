extends AI
class_name AITaskmaster

@onready var rules : Array[AIRule]
@export var primary : AreaCharacter3D
@export var target : Node3D
@export var acceleration : float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rules.assign(get_children())
	if not target:
		target = get_tree().get_nodes_in_group("Player")[0]

func _physics_process(delta):
	var final_force : Vector3 = Vector3.ZERO
	var number_of_forces : int = 0

	for rule in rules:
		if not rule.apply_rule: continue
		if rule._check_rule(primary, target):
			var force = rule._apply_rule(primary, target)
			if force == Vector3.ZERO: continue

			number_of_forces += 1
			final_force += force
	
	if number_of_forces != 0:
		final_force = (final_force / number_of_forces).normalized()
	
	primary.add_force(final_force * acceleration * delta)
