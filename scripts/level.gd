extends Node3D
class_name Level

signal level_completed

func _physics_process(delta: float) -> void:
	if get_tree().get_node_count_in_group("Enemies") <= 0:
		level_completed.emit()
		queue_free()
