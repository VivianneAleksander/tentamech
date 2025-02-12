@tool
extends Node3D
class_name LevelManager

#region Camera
@export var camera3D : Camera3D
@export_range(0.01, 2.0, 0.01) var level_margin_x : float = 0.85
@export_range(0.01, 2.0, 0.01) var level_margin_y : float = 1.0
@export var z_width : float = 5.0
var level_margin_calculated : Vector3
var level_margin_calculated_half : Vector3
@export var groups_to_monitor : Array[StringName]
#endregion

#region Levels
@onready var level_manager_prefab := preload("res://scenes/levels/level_manager.tscn")
@export var levels : Array[PackedScene]
@export var current_level_index : int = 0
var current_level : Level
var current_checkpoint : int = 0
#endregion

@onready var level_ui : LevelUI = $LevelUI
@onready var player := $Tentamech as AreaCharacter3D

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
	player.health_component.health_value_changed.connect(level_ui.update_health)
	
		
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

func reset_checkpoint() -> void:
	get_tree().call_group("Enemies", "queue_free")
	get_tree().call_group("Bullets", "queue_free")
	get_tree().call_group("Effects", "queue_free")
	var new_level_manager := level_manager_prefab.instantiate() as LevelManager
	new_level_manager.current_level_index = current_checkpoint
	get_tree().root.add_child(new_level_manager)
	queue_free()

func game_over() -> void:
	print_debug("Game Over")
	level_ui.game_over()
	game_is_over = true

func game_finished() -> void:
	print_debug("All Levels Cleared.")
	game_is_over = true


func _on_level_ui_game_quit() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit.call_deferred()
			
