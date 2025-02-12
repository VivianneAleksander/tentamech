@tool
extends AudioStreamPlayer
class_name AudioFadeInOut

@export var fade_in_time := Vector2(0, 1)
@export var fade_in_dec := Vector2(-80, 0)

var started : bool = false
var fade_in_tween : Tween

func _ready() -> void:
	volume_db = fade_in_dec.x

func _process(delta: float) -> void:
	if not started and playing:
		started = true
		#TODO: Implement start time.
		if fade_in_tween:
			fade_in_tween.kill()
		volume_db = fade_in_dec.x
		fade_in_tween = get_tree().create_tween().bind_node(self)
		fade_in_tween.tween_property(self, "volume_db", fade_in_dec.y, fade_in_time.y)
	elif not playing:
		started = false
		volume_db = fade_in_dec.x
