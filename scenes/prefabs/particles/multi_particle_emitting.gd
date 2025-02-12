@tool
extends GPUParticles3D
@export var particle_systems : Array[GPUParticles3D]

func _process(delta: float) -> void:
	for ps in particle_systems:
		if not ps: continue
		ps.emitting = emitting
