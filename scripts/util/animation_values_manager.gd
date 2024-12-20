extends Node
class_name AnimationValuesManager

@onready var values : Array[AnimationValue] = []
@onready var animation_tree : AnimationTree = get_parent() as AnimationTree
@export var parameter_path_base : String = "parameters/StateMachine/conditions/"

func _ready():
	values.assign(get_children())

func _process(delta):
	for v : AnimationValue in values:
		var value = v.get_value()
		animation_tree[parameter_path_base + v.value_name] = value
		if v.also_set_inverse:
			animation_tree[parameter_path_base + v.value_name_inverse] = not value
