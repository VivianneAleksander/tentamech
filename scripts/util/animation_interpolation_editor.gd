@icon("res://assets/icons/animation_interpolation_editor.svg")
extends Node
class_name AnimationInterpolationEditor

@export_enum("NEAREST", "LINEAR", "CUBIC") var animation_interpolation_type = 0
@export var animation_blacklist : Array[String] = []
@export var use_blacklist_as_whitelist : bool = false

@onready var animation_player := get_parent() as AnimationPlayer

func _ready():
	await get_tree().physics_frame
	if not animation_player:
		queue_free()

	set_interpolation_type(animation_interpolation_type, animation_blacklist, use_blacklist_as_whitelist)

func set_interpolation_type(type : int, blacklist : Array[String], use_as_whitelist : bool = false):
	var animation_keys := animation_player.get_animation_list()
	for key in animation_keys:
		var list_contains := blacklist.has(key)
		if use_as_whitelist and not list_contains:
			return
		elif list_contains:
			return
		
		var animation := animation_player.get_animation(key)
		var count = animation.get_track_count()

		for i in count:
			animation.track_set_interpolation_type(i, type)
