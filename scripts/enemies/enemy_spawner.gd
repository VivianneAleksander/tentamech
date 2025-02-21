extends Node
class_name EnemySpawner

@export var prefab : PackedScene
@export var target : Node3D
@export var max_enemies : int = -1

var active_enemies : Array[EnemyBase]

var spawning_is_valid : bool : 
	get:
		return max_enemies < 0 or active_enemies.size() < max_enemies

func spawn_character(force : bool = false) -> EnemyBase:
	if not force and not spawning_is_valid:
		return null
	
	var new_obj = prefab.instantiate()
	var new_enemy := new_obj as EnemyBase
	if not new_enemy: 
		new_obj.queue_free()
		return null
	
	get_tree().root.add_child(new_enemy)
	active_enemies.append(new_enemy)
	
	new_enemy.character_died.connect(trim_enemy.bind(new_enemy))
	
	if not target: return new_enemy
	
	new_enemy.global_position = target.global_position
	new_enemy.ai_taskmaster.target = target
	
	return new_enemy

func clear_enemies() -> void:
	for enemy in active_enemies:
		if not enemy: continue
		enemy.health_component.kill()
	active_enemies.clear()

func trim_enemy(enemy : EnemyBase) -> void:
	enemy.character_died.disconnect(trim_enemy)
	active_enemies.erase(enemy)
