extends AIRule
class_name AvoidLevelBoundsRule

@export var acceleration : float = 1.0
@export var min_distance : float = 1.0


var pos : Vector3
var bounds : AABB
var min_pos : Vector3
var max_pos : Vector3

var max_x_dist : float
var min_x_dist : float
var max_y_dist : float
var min_y_dist : float

func _check_rule(primary : AreaCharacter3D, target : AreaCharacter3D) -> bool:
	pos = primary.global_position
	bounds = LevelManager.level_bounds
	min_pos = bounds.position
	max_pos = bounds.position + bounds.size

	max_x_dist = -(pos.x - max_pos.x)
	min_x_dist = pos.x - min_pos.x
	max_y_dist = -(pos.y - max_pos.y)
	min_y_dist = pos.y - min_pos.y

	if max_x_dist < min_distance:
		return true
	if min_x_dist < min_distance:
		return true
	if max_y_dist < min_distance:
		return true
	if min_y_dist < min_distance:
		return true
	return false

func _apply_rule(primary : AreaCharacter3D, target : AreaCharacter3D) -> Vector3:
	if max_x_dist >= min_distance:
		max_x_dist = 0
	if min_x_dist >= min_distance:
		min_x_dist = 0
	if max_y_dist >= min_distance:
		max_y_dist = 0
	if min_y_dist >= min_distance:
		min_y_dist = 0

	var force := Vector3(-max_x_dist + min_x_dist, -max_y_dist + min_y_dist, 0)
	force *= acceleration
	return force
