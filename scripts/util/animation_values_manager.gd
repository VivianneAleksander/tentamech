extends AnimationValues
class_name AnimationValuesManager

@onready var values : Array[AnimationValue] = []
@export var parameter_path_base : String = "parameters/StateMachine/conditions/"
@export var animation_forest : Array[AnimationTree]

func _ready():
	values.assign(get_children())

func _process(delta):
	for v : AnimationValue in values:
		_update_animation_trees(v)
	

func _update_animation_trees(v : AnimationValue) -> void:
	for tree in animation_forest:
		var value = v._get_value()
		var parameter_path = parameter_path_base + v.value_name
		if not parameter_path in tree: return
		
		tree[parameter_path_base + v.value_name] = value
		if v.also_set_inverse:
			tree[parameter_path_base + v.value_name_inverse] = not value
		
