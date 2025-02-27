extends Node
class_name ScoreManager

## How quickly the score multiplier bar decays to zero, in seconds.
@export var score_multiplier_decay_speed : float = 0.25
## How long the bar should wait each time the player gains score before beginning to decay, in seconds.
@export var score_multiplier_decay_delay : float = 1.0

var score : int = 0 :
	get:
		return score
	set(value):
		if value < score:
			score_lost.emit()
		elif value > score:
			score_gained.emit()
		score = clampi(value, 0, score_max)
		score_value_changed.emit(score)

var score_max : int = int(9.9999 * pow(10, 9))

var score_multiplier_idx : int = 0 :
	get:
		return score_multiplier_idx
	set(value):
		if value > score_multiplier_idx:
			score_multiplier_reduced.emit()
		elif value < score_multiplier_idx:
			score_multiplier_increased.emit()
		score_multiplier_idx = clampi(value, 0, score_multiplier_table.size() - 1)
		score_multiplier_changed.emit(score_multiplier)

var score_multiplier_table : Array[int] = [
	1,
	2,
	3,
	5,
	7,
	10
]

var score_multiplier : int :
	get:
		return score_multiplier_table[score_multiplier_idx]

var score_multiplier_progress : float = 0.0 :
	get:
		return score_multiplier_progress
	set(value):
		if value < score_multiplier_progress:
			score_multiplier_progress_reduced.emit()
		elif value > score_multiplier_progress:
			score_multiplier_progress_increased.emit()
		
		score_multiplier_progress = clampf(value, 0, score_multiplier_max)
		score_multiplier_idx = floori(score_multiplier_progress / 100.0)
		
		if score_multiplier_progress >= score_multiplier_max:
			score_multiplier_progress_changed.emit(100)
		else:
			score_multiplier_progress_changed.emit(fmod(score_multiplier_progress, 100) - 0.01)

var score_multiplier_max : float :
	get:
		return 100 * (score_multiplier_table.size() - 1)

var score_multiplier_decay_delay_timer : SceneTreeTimer
var score_multiplier_decay_tween : Tween

signal score_value_changed(score : int)
signal score_lost
signal score_gained

signal score_multiplier_changed(score_multiplier : int)
signal score_multiplier_reduced
signal score_multiplier_increased

signal score_multiplier_progress_changed(score_multiplier_progress : float)
signal score_multiplier_progress_reduced()
signal score_multiplier_progress_increased()

func _ready() -> void:
	await get_tree().physics_frame
	score = 0
	score_multiplier_progress = 0.0

func add_score(add : int, mult : float = 0.0) -> void:
	score += add * score_multiplier
	
	add_score_multiplier(mult)

func add_score_multiplier(val : float) -> void:
	score_multiplier_progress += val
	
	stop_timers_and_tweeners()
	
	score_multiplier_decay_delay_timer = get_tree().create_timer(score_multiplier_decay_delay, false)
	score_multiplier_decay_delay_timer.timeout.connect(start_score_multiplier_decay)

func start_score_multiplier_decay() -> void:
	stop_timers_and_tweeners()
	
	score_multiplier_decay_tween = create_tween()
	var speed : float = score_multiplier_decay_speed * (score_multiplier_progress / score_multiplier_max)
	score_multiplier_decay_tween.tween_property(self, "score_multiplier_progress", 0, speed)

func stop_timers_and_tweeners() -> void:
	if score_multiplier_decay_tween and score_multiplier_decay_tween.is_valid():
		score_multiplier_decay_tween.kill()
	
	score_multiplier_decay_delay_timer = null
