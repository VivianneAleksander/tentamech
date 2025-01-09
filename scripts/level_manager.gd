@tool
extends Node3D
class_name LevelManager

@export var camera3D : Camera3D
@export_range(0.01, 1.0, 0.01) var level_margin_x : float = 1.0
@export_range(0.01, 1.0, 0.01) var level_margin_y : float = 1.0
@export var z_width : float = 1.0
var level_margin_calculated : Vector3
var level_margin_calculated_half : Vector3
@export var groups_to_monitor : Array[StringName]

var level_bounds : AABB = AABB()

func _ready():
	# This constrains the mouse to the viewport, but only in the release build, so I
	# can still do stuff outside the window in edit mode.
	if not OS.has_feature("editor"):
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED

func _physics_process(delta):

	calculate_level_bounds()

	if Engine.is_editor_hint(): return
	
	for g in groups_to_monitor:
		constrain_group(g)

func calculate_level_bounds():
	if not camera3D: 
		print_debug("NO CAMERA SET.")
		return

	var screen_size := get_viewport().get_visible_rect().size
	# The playspace will always be centered on Z zero.
	var z_depth := camera3D.global_position.z
	var projected_position := camera3D.project_position(screen_size * 2, z_depth)
	var z_width_vec = Vector3.BACK * z_width
	
	level_margin_calculated = (abs(projected_position) * Vector3(level_margin_x, level_margin_y, 0) + z_width_vec)
	level_margin_calculated_half = level_margin_calculated / 2.0

	level_bounds.position = -level_margin_calculated_half
	level_bounds.size = level_margin_calculated


func constrain_group(group_name : StringName):
	for node in get_tree().get_nodes_in_group(group_name):
		if not (node as Node3D):
			continue
		
		if not level_bounds.has_point(node.global_position):
			node.queue_free()
