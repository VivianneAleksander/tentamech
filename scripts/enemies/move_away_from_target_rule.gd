extends AIRule
class_name MoveAwayFromTargetRule

@export var acceleration : float = 1.0
@export var min_distance : float = 2.0


func _check_rule() -> bool:
	if (target.global_position - primary.global_position).length() <= min_distance:
		return true
	return false

func _apply_rule(_delta : float) -> void:
	var direction := (primary.global_position - target.global_position).normalized()
	var force := direction * acceleration * _delta
	primary.add_force(force)
