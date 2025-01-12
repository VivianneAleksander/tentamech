extends AIRule
class_name AlignWithTargetAxisRule

@export var acceleration : float = 1.0
@export_enum("X_AXIS", "Y_AXIS") var axis : int = 0
@export var min_distance : float = 1.0
var axis_delta : float

func _check_rule() -> bool:
	match axis:
		0:
			axis_delta = target.global_position.y - primary.global_position.y
		1:
			axis_delta = target.global_position.x - primary.global_position.x
		_:
			return false
	
	if abs(axis_delta) > min_distance: return true
	return false

func _apply_rule(_delta : float) -> void:
	var force := Vector3.ZERO
	match axis:
		0:
			force = Vector3.UP * sign(axis_delta)
		1:
			force = Vector3.RIGHT * sign(axis_delta)
		_:
			return
	
	force = force.normalized()
	force *= (acceleration * _delta)
	primary.add_force(force)