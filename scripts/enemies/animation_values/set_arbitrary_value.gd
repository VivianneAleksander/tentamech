extends AnimationValue
class_name SetArbitraryValue

@export var value : bool = false

func set_value(new_value : bool) -> void:
	value = new_value

func _get_value() -> Variant:
	return value
