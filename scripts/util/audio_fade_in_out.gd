@tool
extends Node
class_name AudioFadeInOut

@onready var audio_player := get_parent() as AudioStreamPlayer

@export var auto_fade : bool = true

## X value is the time to wait before starting the fade in, Y value is how long to fade in for.
@export var fade_in_time := Vector2(0, 1)
## X value is the time to wait before starting the fade out, Y value is how long to fade out for.
@export var fade_out_time := Vector2(0, 1)
## X value is the minimum decibel value, Y value is the maximum decibel value.
@export var fade_dec := Vector2(-80, 0)

var fade_tween : Tween
enum PLAYBACK_STATE {
	IDLE,
	STARTED,
	ENDED
}

var playback_state : PLAYBACK_STATE = PLAYBACK_STATE.IDLE

var current_position : float = 0.0

func _ready() -> void:
	while not audio_player:
		await get_tree().process_frame
		audio_player = get_parent() as AudioStreamPlayer
		
	audio_player.volume_db = fade_dec.x

func _process(delta: float) -> void:
	if not audio_player: return
	if not auto_fade: return
	
	match playback_state:
		PLAYBACK_STATE.IDLE:
			if audio_player.playing:
				playback_state = PLAYBACK_STATE.STARTED
				fade_audio(fade_dec.y, fade_in_time.y, fade_in_time.x)
		PLAYBACK_STATE.STARTED:
			if not audio_player.playing:
				playback_state = PLAYBACK_STATE.ENDED
				audio_player.play(current_position)
				fade_audio(fade_dec.x, fade_in_time.y, fade_in_time.x)
		PLAYBACK_STATE.ENDED:
			if not audio_player.playing:
				playback_state = PLAYBACK_STATE.IDLE
		_:
			pass
		
	current_position = audio_player.get_playback_position() + AudioServer.get_time_since_last_mix()

func fade_audio(end_dec : float, time : float, wait : float = 0.0) -> void:
	if fade_tween:
		fade_tween.kill()
	
	if wait != 0.0:
		await get_tree().create_timer(abs(wait)).timeout
	
	fade_tween = get_tree().create_tween().bind_node(audio_player)
	fade_tween.tween_property(audio_player, "volume_db", end_dec, time)
