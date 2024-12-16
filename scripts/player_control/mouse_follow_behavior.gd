extends Node
class_name MouseFollowControl

@onready var viewport := get_viewport()
@onready var camera := viewport.get_camera_3d()
## If this value is null, use parent.
@export var target : Node3D


func _physics_process(delta):
	var mouse_position := viewport.get_mouse_position()
	var world_position := camera.project_position(mouse_position, camera.global_position.z)
	target.global_position = world_position


