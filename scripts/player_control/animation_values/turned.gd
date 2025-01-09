extends AnimationValue

@export var follow_control : MouseFollowControl
var last_value : bool = false

func _get_value() -> Variant:
	if not follow_control: return false
	match follow_control.direction:
		1:
			last_value = false
		-1:
			last_value = true
			
	return last_value