extends Node3D
class_name MainMenuManager

@export var level_manager_prefab : PackedScene

func start_game() -> void:
	assert(level_manager_prefab, "ERROR: No level manager prefab assigned.")
	var level_manager : LevelManager = level_manager_prefab.instantiate()
	assert(level_manager, "ERROR: Level manager prefab isn't a valid level manager.")
	
	get_tree().root.add_child(level_manager)
	
	queue_free()

func quit_game() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
