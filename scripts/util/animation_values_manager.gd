extends AnimationTree
class_name AnimationValuesManager

@onready var values : Array[AnimationValue] = []
@export var parameter_path_base : String = "parameters/StateMachine/conditions/"

func _ready():
	values.assign(get_children())

func _process(delta):
	for v : AnimationValue in values:
		var value = v._get_value()
		self[parameter_path_base + v.value_name] = value
		if v.also_set_inverse:
			self[parameter_path_base + v.value_name_inverse] = not value
