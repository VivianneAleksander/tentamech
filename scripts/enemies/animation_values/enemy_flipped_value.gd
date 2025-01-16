extends AnimationValue
class_name EnemyFlippedValue

@export var target : AreaCharacter3D

func _ready():
	if not target: 
		queue_free()
		return

func _get_value() -> Variant:
	var v := target.velocity
	var facing_right : bool = true if v.x > 0 else false

	return facing_right