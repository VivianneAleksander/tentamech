@icon("res://assets/icons/debug_label_icon.svg")
extends Node
class_name DebugLabel

@export var label_name : String
@export var item_to_check : Node
@export_multiline var value : String

var expression = Expression.new()

func get_value() -> String:
	if not item_to_check: return ""
	
	expression.parse(value)
	var output = expression.execute([], item_to_check)
	if expression.has_execute_failed(): return ""
	
	var string = ""
	if label_name != "": string += label_name + ": "
	string += str(output)
	return string
