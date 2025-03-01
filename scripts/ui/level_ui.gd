extends CanvasLayer
class_name LevelUI

@export var health_pips : Array[Control]

@onready var energy_bar := $Control/Power/PowerMargin/PowerContainer/HBoxContainer/ProgressBar as ProgressBar
@onready var game_over_timer := $GameOverTimer as Timer
@onready var face_cams := $Control/FaceCams as Control

@onready var score_display := $Control/ScoreDisplay/ScoreLabel as Label
@onready var score_multiplier := $Control/ScoreMultiplierDisplay/ScoreMultiplierLabel as Label
@onready var score_multiplier_bar := $Control/ScoreDisplay/ScoreMultiplierBar as ProgressBar

@onready var level_progress_bar := $Control/LevelProgressBar/HSlider as HSlider

@onready var multiplier_bar_mat : Material = preload("res://assets/materials/ui/rainbow_scroll.tres")

signal game_reset_checkpoint
signal game_quit

func update_health(val : int) -> void:
	for idx in health_pips.size():
		if idx < val:
			health_pips[idx].modulate.a = 1.0
		else:
			health_pips[idx].modulate.a = 0.0

func update_engergy(val : float) -> void:
	energy_bar.value = val * energy_bar.max_value

func update_score(val : int) -> void:
	score_display.text = "Score: " + str(val).lpad(11, "0")

func update_score_multiplier(val : int) -> void:
	score_multiplier.text = "x" + str(val)

func update_score_multiplier_bar(val : float) -> void:
	score_multiplier_bar.value = val
	if score_multiplier_bar.value >= 100.0:
		score_multiplier_bar.material = multiplier_bar_mat
	else:
		score_multiplier_bar.material = null

func update_level_count(val : int) -> void:
	level_progress_bar.tick_count = val + 2

func update_level_progress(val : float) -> void:
	level_progress_bar.value = level_progress_bar.max_value * val

func game_over() -> void:
	game_over_timer.start()
	face_cams.visible = false

func reset_checkpoint() -> void:
	game_reset_checkpoint.emit()

func quit_game() -> void:
	game_quit.emit()
