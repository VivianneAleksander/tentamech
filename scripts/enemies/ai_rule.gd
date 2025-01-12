extends Node
class_name AIRule

@export var apply_rule : bool = true
@export var primary : AreaCharacter3D
@export var target : Node3D

func _ready():
	if not target:
		target = get_tree().get_nodes_in_group("Player")[0]

func _physics_process(delta):
	if not apply_rule: return
	if _check_rule():
		_apply_rule(delta)

func _check_rule() -> bool:
	return false

func _apply_rule(_delta : float) -> void:
	pass
