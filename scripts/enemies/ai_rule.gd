@icon("res://assets/icons/ai_rule.svg")
extends AI
class_name AIRule

@export var apply_rule : bool = true

func _check_rule(primary : AreaCharacter3D, target : AreaCharacter3D) -> bool:
	return false

func _apply_rule(primary : AreaCharacter3D, target : AreaCharacter3D) -> Vector3:
	return Vector3.ZERO
