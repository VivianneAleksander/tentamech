extends SpineSpriteControl
class_name  SpineSpriteControlMouthShapes

enum Shape {
	CLOSED,
	OH,
	OOO,
	EESH
}

@export var default_shape : Shape = Shape.CLOSED
var mouth_shape : Shape = -1
var animating : bool = false

func _ready() -> void:
	set_mouth_shape(mouth_shape)
	animation_completed.connect(set_animating_state.unbind(3))

func set_mouth_shape(new_shape : Shape) -> void:
	if animating or new_shape == mouth_shape: return
	
	var new_track : SpineTrackEntry
	match new_shape:
		Shape.CLOSED:
			new_track = set_animation_state("mouth_closed", false, 1)
		Shape.OH:
			new_track = set_animation_state("mouth_oh", false, 1)
		Shape.OOO:
			new_track = set_animation_state("mouth_ooo", false, 1)
		Shape.EESH:
			new_track = set_animation_state("mouth_eesh", false, 1)
		_:
			return
	
	mouth_shape = new_shape
	new_track.set_mix_blend(SpineConstant.MixBlend_Add)
	set_animating_state()

func set_animating_state() -> void:
	animating = not animating
