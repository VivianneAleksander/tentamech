extends SpineSprite
class_name SpineSpriteControl


func set_animation_state(name : String, looping : bool = false, track : int = 0) -> void:
	var animation_state := get_animation_state()
	animation_state.set_animation(name, looping, track)

func queue_animation_state(name : String, delay : float = 0.5, looping : bool = false, track : int = 0) -> void:
	var animation_state := get_animation_state()
	animation_state.add_animation(name, delay, looping, track)
	
