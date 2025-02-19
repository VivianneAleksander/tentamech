extends Node
class_name ResistanceComponent

func apply_resistance(value : float, type : int = 0) -> float:
	return value

func _on_death() -> void:
	pass

func _on_restore() -> void:
	pass
