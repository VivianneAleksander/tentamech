extends Node
class_name AnimationValue

@export var value_name : StringName = ""
@export var value_inverse_prefix : StringName = "not_"
var value_name_inverse : StringName :
	get:
		return value_inverse_prefix + value_name

@export var also_set_inverse : bool = false

func get_value() -> Variant:
	return false