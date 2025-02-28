extends AIRule
class_name AvoidOtherEntitiesRule

@export var max_distance : float = 1.0
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

func _check_rule(primary : AreaCharacter3D, target : Node3D) -> bool:
	return true

func _apply_rule(primary : AreaCharacter3D, target : Node3D) -> Vector3:
	var vector = Vector3.ZERO
	for node in get_tree().get_nodes_in_group(type_str):
		if not (node as Node3D):
			continue
		var v : Vector3 = (node.global_position - primary.global_position).length()
		if v.length() <= max_distance:
			vector += v
	return Vector3.ZERO
