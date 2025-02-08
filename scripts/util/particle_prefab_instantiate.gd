extends Node3D
class_name ParticlePrefabInstantiate

@export var particle_prefab : PackedScene
## If this value isn't set, default to the scene root.
@export var particle_parent : Node

func spawn_particles() -> void:
	var parent = particle_parent if particle_parent else get_tree().root
	var new_particle_system := particle_prefab.instantiate() as GPUParticles3D
	parent.add_child(new_particle_system)
	new_particle_system.global_position = global_position
	
