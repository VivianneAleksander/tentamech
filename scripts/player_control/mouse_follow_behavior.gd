extends Node
class_name MouseFollowControl

@onready var viewport := get_viewport()
@onready var camera := viewport.get_camera_3d()
@export var target : CharacterBody3D
@export var acceleration : float = 1000


func _physics_process(delta):
	var mouse_position := viewport.get_mouse_position()
	var world_position := camera.project_position(mouse_position, camera.global_position.z)
	target.global_position = world_position
