extends AnimationValue

enum FIRE_MODE {
	SPREAD = 0,
	FOCUSED = 1,
	MELEE = 2
}

@export var firing_mode : FIRE_MODE
static var current_firing_mode : FIRE_MODE = FIRE_MODE.SPREAD

func _process(delta):
	if Input.is_action_just_pressed("change"):
		var new_mode := ((current_firing_mode + 1) % FIRE_MODE.size()) as FIRE_MODE
		(func(): current_firing_mode = new_mode).call_deferred()

func _get_value() -> Variant:
	return  current_firing_mode == firing_mode and Input.is_action_pressed("fire")