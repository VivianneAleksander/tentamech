extends Node
class_name AnimationSMTraveler

@export var animation_tree : AnimationTree
@export var animation_sm_path : StringName = &"parameters/playback"
var state_machine : AnimationNodeStateMachinePlayback

func _ready() -> void:
	if animation_tree:
		state_machine = animation_tree[animation_sm_path]

func travel(state : StringName) -> void:
	if state_machine:
		state_machine.travel(state)
