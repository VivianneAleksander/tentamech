extends AIRule
class_name MoveToTargetRule

@export var acceleration : float = 1.0
@export var max_distance : float = 2.0

func _check_rule() -> bool:
	if (target.global_position - primary.global_position).length() > max_distance:
		return true
	return false

func _apply_rule(_delta : float) -> void:
	var direction := (target.global_position - primary.global_position).normalized()
	var force := direction * acceleration * _delta
	primary.add_force(force)