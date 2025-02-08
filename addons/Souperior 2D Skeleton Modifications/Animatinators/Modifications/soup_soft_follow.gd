@tool
@icon("res://addons/Souperior 2D Skeleton Modifications/Animatinators/Modifications/Icons/icon_stay_at.png")
extends SoupMod
class_name SoupSoftFollow

## Target node for the modification;
## The bone tries to stay at the global position of this node;
## To avoid unintended behaviour, make sure this node is NOT a child of the to-be-modified bone.
@export var target_node: Node2D

## If true, the modifications are applied.
@export var enabled: bool = false

@export_category("Bones")
## The to-be-modified bone node.
@export var bone_node: Bone2D

@export_range(0, 1, 0.01) var position_hardness : float = 0.0
var last_target_position : Vector2
var last_bone_position : Vector2
@export_range(0, 1, 0.01) var rotation_hardness : float = 0.0
var last_target_rotation : float
var last_bone_rotation : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_last_transform()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_update_bone_transform()
	
	_update_last_transform()

func _update_bone_transform() -> void:
	if !(
			enabled 
			and target_node 
			and bone_node
			and _parent_enable_check() 
		):
		return
	
	var bone_position_delta := last_bone_position - bone_node.global_position
	var target_position_delta := target_node.global_position - last_target_position
	var position_delta := bone_position_delta + target_position_delta
	var new_position := bone_node.global_position + (position_delta * position_hardness)
	_mod_stack.apply_bone_position_mod(bone_node, position_global_to_local(new_position, bone_node.get_parent()))
	
	var bone_rotation_delta := last_bone_rotation - bone_node.global_rotation
	var target_rotation_delta := target_node.global_rotation - last_target_rotation
	var rotation_delta := bone_rotation_delta + target_rotation_delta
	var new_rotation := bone_node.global_rotation + (rotation_delta * rotation_hardness)
	_mod_stack.apply_bone_rotation_mod(bone_node, rotation_global_to_local(new_rotation, bone_node.get_parent()))

func _update_last_transform() -> void:
	if not (target_node and bone_node): return
	last_target_position = target_node.global_position
	last_target_rotation = target_node.global_rotation
	
	last_bone_position = bone_node.global_position
	last_bone_rotation = bone_node.global_rotation
