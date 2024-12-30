extends AnimationValue

enum FIRE_MODE {
	SPREAD = 0,
	FOCUSED = 1,
	MELEE = 2
}

@export var firing_mode : FIRE_MODE
var current_firing_mode : int = FIRE_MODE.SPREAD

func _process(delta):
	if Input.is_action_just_pressed("change"):
		firing_mode = ((firing_mode + 1) % FIRE_MODE.size()) as FIRE_MODE

func get_value() -> Variant:
	return  current_firing_mode == firing_mode and Input.is_action_pressed("fire")