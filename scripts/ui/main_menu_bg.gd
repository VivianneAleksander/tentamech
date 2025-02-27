extends Node3D
class_name MainMenuBG

@onready var camera : Camera3D = $Mesh/Camera
@onready var camera_starting_rotation = camera.global_rotation
var cam_range_x := Vector2(0.0, 0.05)
var cam_range_y := Vector2(-0.03, 0.03)

func _process(delta: float) -> void:
	var mouse_pos_ratio := get_viewport().get_mouse_position() / (get_viewport().size as Vector2)
	mouse_pos_ratio = clamp(mouse_pos_ratio, Vector2.ZERO, Vector2.ONE)
	mouse_pos_ratio -= Vector2(1.0, 1.0)
	var rotation_delta : Vector3
	rotation_delta.x = lerpf(cam_range_x.x, cam_range_x.y, -mouse_pos_ratio.y)
	rotation_delta.y = lerpf(cam_range_y.x, cam_range_y.y, -mouse_pos_ratio.x)
	camera.global_rotation = camera_starting_rotation + rotation_delta
