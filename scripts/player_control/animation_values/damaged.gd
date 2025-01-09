extends AnimationValue

var _was_damaged : bool = false

func _get_value() -> Variant:
	var d = _was_damaged
	_was_damaged = false
	return d

func _on_health_component_health_lost() -> void:
	_was_damaged = true
