@tool
extends Node3D
class_name LevelManager

@export var camera3D : Camera3D
@export_range(0.01, 2.0, 0.01) var level_margin_x : float = 0.85
@export_range(0.01, 2.0, 0.01) var level_margin_y : float = 1.0
@export var z_width : float = 5.0
var level_margin_calculated : Vector3
var level_margin_calculated_half : Vector3
@export var groups_to_monitor : Array[StringName]
@export var levels : Array[PackedScene]

@onready var player := $Tentamech as AreaCharacter3D
var current_level : Level
@export var current_level_index : int = 0

var game_is_over : bool = false

static var level_bounds : AABB = AABB()

func _ready():
	# This constrains the mouse to the viewport, but only in the release build, so I
	# can still do stuff outside the window in edit mode.
	if not OS.has_feature("editor"):
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	
	if Engine.is_editor_hint(): return
	
	if levels.size() > 0:
		current_level = start_level(current_level_index)
	
	player.character_died.connect(game_over.unbind(1))
	
		
func _process(delta: float) -> void:
	pass

func _physics_process(delta) -> void:

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

func start_level(idx : int) -> Level:
		if idx >= levels.size() or idx < 0: 
			game_finished()
			return null
		var level : Level = levels[idx].instantiate() as Level
		add_child(level)
		level.level_completed.connect(next_level)
		return level as Level
	
func next_level() -> void:
	if game_is_over: return
	current_level_index += 1
	start_level(current_level_index)

func game_over() -> void:
	print_debug("Game Over")
	game_is_over = true

func game_finished() -> void:
	print_debug("All Levels Cleared.")
	game_is_over = true
