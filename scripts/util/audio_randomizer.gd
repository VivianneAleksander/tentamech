extends AudioStreamPlayer3D
class_name AudioRandomizer

@export var sounds : Array[AudioStreamOggVorbis]
@export_range(0.0, 1.0, 0.01) var pitch_range : float = 0.0

func play_from_list(idx : int):
	var pitch_min = clampf(1.0 - 1.0 * pitch_range, 0.01, 1.0)
	var pitch_max = 1.0 + (3.0 * pitch_range)
	var new_pitch := randf_range(pitch_min, pitch_max)
	pitch_scale = new_pitch
	stream = sounds[idx]
	play()

func play_random_from_list():
	var idx := randi_range(0, sounds.size() - 1)
	play_from_list(idx)
