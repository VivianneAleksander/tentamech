extends Node
class_name EnemyAI

@export var target : EnemyBase
@export var enabled : bool = false

@onready var player := get_tree().get_nodes_in_group("Player")[0] as AreaCharacter3D