extends CanvasLayer
class_name LevelUI

@export var health_pips : Array[Control]

@onready var game_over_timer = $GameOverTimer
@onready var face_cams = $Control/FaceCams

signal game_reset_checkpoint
signal game_quit

func update_health(val : int) -> void:
	for idx in health_pips.size():
		if idx < val:
			health_pips[idx].modulate.a = 1.0
		else:
			health_pips[idx].modulate.a = 0.0

func game_over() -> void:
	game_over_timer.start()
	face_cams.visible = false

func reset_checkpoint() -> void:
	game_reset_checkpoint.emit()

func quit_game() -> void:
	game_quit.emit()
