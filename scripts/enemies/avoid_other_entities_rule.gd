extends AIRule
class_name AvoidOtherEntitiesRule

@export var max_distance : float = 1.0
@export var acceleration : float = 1.0
@export_enum("Bullets", "Enemies", "Player") var type : int = 0
var type_str : StringName : 
	get:
		match type:
			0:
				return "Bullets"
			1:
				return "Enemies"
			2:
				return "Player"
		return ""

var valid_nodes : Array[Node3D]

func _check_rule(primary : AreaCharacter3D, target : Node3D) -> bool:
	valid_nodes.assign(get_tree().get_nodes_in_group(type_str))
	return valid_nodes.any(func(node : Node3D) -> bool: return (node.global_position - primary.global_position).length() < max_distance)

func _apply_rule(primary : AreaCharacter3D, target : Node3D) -> Vector3:
	var vector = Vector3.ZERO
	for node in valid_nodes:
		if not node:
			continue
		var v : Vector3 = (primary.global_position - node.global_position)
		if v.length() <= max_distance:
			vector += v
	return vector * acceleration
