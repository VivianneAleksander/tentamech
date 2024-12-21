@tool
extends Node3D
class_name KeepAligned

@export var _align_location : bool = false
@export var _location : Vector3
@export var _align_rotation : bool = false
@export var _rotation : Vector3
@export var _align_scale : bool = false
@export var _scale : Vector3 = Vector3.ONE

func _process(delta):
	if _align_location:
		global_position = _location
	if _align_rotation:
		global_rotation = _rotation
	if _align_scale:
		scale = _scale