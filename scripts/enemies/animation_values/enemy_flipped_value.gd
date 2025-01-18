extends AnimationValue
class_name EnemyFlippedValue

@export var primary : AreaCharacter3D
@export var target : AreaCharacter3D

func _ready():
	if not primary: 
		queue_free()
		return
	
	if not target:
		target = get_tree().get_nodes_in_group("Player")[0] as AreaCharacter3D

func _get_value() -> Variant:
	var v := primary.global_position.x - target.global_position.x
	var facing_right : bool = true if v < 0 else false

	return facing_right