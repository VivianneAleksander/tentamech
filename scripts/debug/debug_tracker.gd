@icon("res://assets/icons/debug_tracker_icon.svg")
extends Node3D
class_name DebugTracker

@export var should_follow_mouse : bool = false
@export var offset : Vector2
@export var label_settings : LabelSettings

var container : VBoxContainer
var ready_to_act : bool :
	get: return container != null

var children : Array[DebugLabel]

func _ready():
	children.assign(get_children().filter(func(x): return (x is DebugLabel)))

func _process(_delta):
	container_setup()
	if !ready_to_act: return

	if should_follow_mouse:
		follow_mouse()
	else:
		var cam = get_viewport().get_camera_3d()
		var screen_pos = cam.unproject_position(global_position)
		set_container_position(screen_pos)

	for i in children.size():
		set_label(i, children[i].get_value())

func container_setup():	
	if container: return
	var new_container = VBoxContainer.new()
	add_child(new_container)
	new_container.top_level = true
	container = new_container

func get_labels() -> Array[Label]:
	var nodes = container.get_children()
	var labels : Array[Label]
	for node in nodes:
		var label = node as Label
		label.label_settings = label_settings
		label.z_index = -100
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		labels.append(label)
	
	return labels

func get_label(index : int) -> Label:
	var labels = get_labels()

	if labels.size() <= index:
		for i in index - labels.size() + 1:
			add_label()
		labels = get_labels()
	
	return labels[index]

func set_label(index : int, text : String):
	var label = get_label(index)
	label.text = text

func add_label():
	var new_label = Label.new()
	container.add_child(new_label)

func remove_label(index : int):
	var labels = get_labels()
	labels[index].queue_free()

func set_container_position(pos : Vector2):
	var size = container.size
	container.position = pos + offset
	container.position.x -= size.x / 2
	container.position.y -= size.y

func follow_mouse():
	var mouse_pos = get_viewport().get_mouse_position()
	set_container_position(mouse_pos)
