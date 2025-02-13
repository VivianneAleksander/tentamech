@tool
extends AudioStreamPlayer
class_name AudioStreamLooper

@export var audio : Array[AudioStream]
@export var audio_loopback_idx : int = 1
@export var audio_start_idx : int = 0

@export var audio_idx : int = 0

@export var was_playing : bool = false

func _ready() -> void:
	finished.connect(_on_finished)
	audio_idx = audio_start_idx
	update_audio(audio_start_idx)
	if autoplay and not Engine.is_editor_hint(): play(0)

func _process(delta: float) -> void:
	if playing and not was_playing:
		was_playing = true
	elif not playing and was_playing:
		print_debug("eh")
		audio_idx = audio_start_idx
		update_audio(audio_idx)
		was_playing = false
		

func _on_finished() -> void:
	audio_idx += 1
	update_audio(audio_idx)
	play(0)

func update_audio(idx : int) -> void:
	if idx < 0 : return
	if idx >= audio.size():
		audio_idx = idx % (audio.size() - audio_loopback_idx) + audio_loopback_idx
	
	var new_audio = audio[audio_idx]
	stream = new_audio
