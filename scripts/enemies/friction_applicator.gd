extends Node
class_name FrictionApplicator

@export var primary : AreaCharacter3D
@export var friction : float = 10

func _physics_process(delta):
	primary.velocity = lerp(primary.velocity, Vector3.ZERO, clampf(friction * delta, 0.0, 1.0))

