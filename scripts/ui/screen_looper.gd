@tool
extends Control
class_name ScreenLooper

@export var enabled : bool = true
@export var enabled_in_editor : bool = false
@export var ratio1 : Vector2 = Vector2.ZERO - (Vector2.ONE * 0.1)
@export var ratio2 : Vector2 = Vector2.ONE + (Vector2.ONE * 0.1)
@export var speed : float = 1.0
@export_range(0.0, 1.0, 0.01) var progress : float = 0.5
@export var parent_pos : Vector2 :
	get:
		return get_parent().position
@export var parent_size : Vector2 :
	get:
		return get_parent().size

func _process(delta: float) -> void:
	if not enabled or (Engine.is_editor_hint() and not enabled_in_editor): return
	progress += delta * speed
	progress -= floorf(progress)
	position = get_screen_pos(lerp(ratio1, ratio2, progress))

func get_screen_pos(ratio : Vector2) -> Vector2:
	return parent_size * ratio
