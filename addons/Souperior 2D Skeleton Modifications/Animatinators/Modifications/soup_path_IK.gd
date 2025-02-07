@tool
@icon("Icons/icon_two_bone_ik.png")
class_name SoupPathIK
extends SoupMod

@export var enabled : bool = false
@export var target_path : Path2D
@export var bone_nodes : Array[Bone2D]

func _process(delta: float) -> void:
	if !(
			enabled 
			and target_path 
			and bone_nodes.size() > 0
			and _parent_enable_check()
	) : 
		return
		
	bones_to_path_points()
		

func bones_to_path_points() -> void:
	var curve_length := target_path.curve.get_baked_length()
	var segment_length := curve_length / (bone_nodes.size() - 1)
	
	for idx in bone_nodes.size():
		var bone := bone_nodes[idx]
		var point := position_local_to_global(target_path.curve.sample_baked(segment_length * idx), target_path)
		_mod_stack.apply_bone_position_mod(bone, position_global_to_local(point, bone.get_parent()))
	
	
