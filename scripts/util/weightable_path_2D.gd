@tool
extends Path2D
class_name WeightablePath2D

@export var enabled : bool = false
@export var points : Array[Node2D]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not enabled: return
	for idx in curve.point_count:
		if idx >= points.size():
			break
		if not points[idx]: 
			continue
		
		curve.set_point_position(idx, to_local(points[idx].global_position))
