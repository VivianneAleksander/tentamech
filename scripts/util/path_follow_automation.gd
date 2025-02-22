@tool
extends PathFollow3D
class_name PathFollowAutomation

@export var enabled : bool = true
@export var enabled_in_editor : bool = false

@export_category("Speed Settings")
@export var follow_speed : float = 1.0
@export_range(0, 1, 0.01) var starting_ratio : float = 0.0
@export_enum("PROCESS", "PHYSICS") var process_type : int = 0

func _ready() -> void:
	progress_ratio = starting_ratio

func _process(delta: float) -> void:
	if process_type == 0:
		_update_ratio(delta)

func _physics_process(delta: float) -> void:
	if process_type == 1:
		_update_ratio(delta)

func _update_ratio(delta: float) -> void:
	if not enabled or (Engine.is_editor_hint() and not enabled_in_editor):
		return
	var prog_delta = follow_speed * delta
	progress_ratio += prog_delta - floor(prog_delta)
