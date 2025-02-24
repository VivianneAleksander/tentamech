extends Control
class_name MainMenuUI

@onready var start_button : Button = $OverheadMenu/VBoxContainer/StartButtonControl/Button
@onready var options_button : Button = $OverheadMenu/VBoxContainer/OptionsButtonControl/Button
@onready var quit_button : Button = $OverheadMenu/VBoxContainer/QuitButtonControl/Button

@onready var overhead_menu : Control = $OverheadMenu

signal start_game
signal quit_game

func _ready() -> void:
	start_button.pressed.connect(start_game.emit)
	quit_button.pressed.connect(quit_game.emit)
