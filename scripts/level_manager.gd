@tool
extends Node3D
class_name LevelManager

@export var camera3D : Camera3D
@export var area3D : Area3D
@export var collision_shape3D : CollisionShape3D
@export var level_margin : Vector3

func _ready():
	if not OS.has_feature("editor"):
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED

	if not Engine.is_editor_hint():
		if not area3D: return
		area3D.area_entered.connect(_on_area_entered)
		area3D.area_exited.connect(_on_area_exited)

func _physics_process(delta):
	if not camera3D: return
	if not area3D: return
	if not collision_shape3D: return
	if not collision_shape3D.shape is BoxShape3D: return

	var screen_size : Vector2 = get_viewport().get_visible_rect().size
	var screen_extents : Vector3 = abs(camera3D.project_position(screen_size * 2, camera3D.global_position.z)) + level_margin + Vector3.BACK
	collision_shape3D.shape.size = screen_extents

	if Engine.is_editor_hint():
		pass
	else:
		pass

func _on_area_entered(area: Area3D):
	var parent = area.get_parent()
	parent.visible = true
	if parent.process_mode == PROCESS_MODE_DISABLED:
		area.get_parent().process_mode = Node.PROCESS_MODE_INHERIT

func _on_area_exited(area: Area3D):
	var parent = area.get_parent()
	if parent == get_tree().root: 
		area.queue_free()
		return
	area.get_parent().queue_free()