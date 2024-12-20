extends AnimationValue

func get_value() -> Variant:
	return Input.is_action_pressed("fire")