@tool
extends Area3D
class_name FollowNode3D

@export var target : Node3D
@export var copy_location : bool = true
@export var run_in_editor : bool = false

func _physics_process(delta):
	if Engine.is_editor_hint() and not run_in_editor: return

	if not target: return
	
	if copy_location:
		global_position = target.global_position
	
	transform = transform.orthonormalized()