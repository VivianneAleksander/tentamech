extends Node3D
class_name BulletBase

@onready var player_hitbox := get_node("PlayerHitbox") as DamageCollision3D
@onready var enemy_hitbox := get_node("EnemyHitbox") as DamageCollision3D

var align_speed : float = 5.0
var velocity : Vector3 = Vector3.RIGHT
var forces : Array[Vector3] = []

enum ALLIANCE {
	PLAYER,
	ENEMY,
	NEUTRAL
}

class BulletArgs :
	var transform : Transform3D = Transform3D()
	#TODO: Scale
	var direction : Vector3 = Vector3.RIGHT
	var velocity : float = 1.0
	## Use a low number for bullets that will collide with the player. Use a higher number for bullets
	## that collide with enemies.
	var damage : int = 1
	var damage_type : DamageType.TYPE = DamageType.TYPE.NEUTRAL
	## Bitmask. Sets collision layer and mask. Use 0b1 for player, 0b10 for enemies.
	var alliance : BulletBase.ALLIANCE = BulletBase.ALLIANCE.NEUTRAL

signal bullet_destroyed

func prepare(args : BulletArgs) -> void:
	var fwd := args.transform.basis.y
	fwd.z = 0

	var dir := fwd.normalized()
	var pos := args.transform.origin

	global_position = pos
	look_at(pos+dir)
	
	velocity = dir * args.velocity
	
	player_hitbox.damage_value = args.damage
	player_hitbox.damage_type = args.damage_type
	enemy_hitbox.damage_value = args.damage
	enemy_hitbox.damage_type = args.damage_type

	set_alliance(args.alliance)

func _physics_process(delta):
	# If the bullet is not aligned with the global plane XY normal ZERO, this will move it to that plane.
	if abs(global_position.z) <= align_speed * delta:
		global_position.z = 0
	else:
		global_position.z -= sign(global_position.z) * align_speed * delta
	
	for force in forces:
		velocity += force
	forces.clear()
	global_position += velocity * delta

func _exit_tree() -> void:
	bullet_destroyed.emit()

func add_force(force: Vector3):
	forces.append(force)

func set_alliance(new_alliance : ALLIANCE):
	match new_alliance:
		ALLIANCE.PLAYER:
			player_hitbox.monitorable = false
			player_hitbox.monitoring = false
			enemy_hitbox.monitorable = true
			enemy_hitbox.monitoring = true
		ALLIANCE.ENEMY:
			enemy_hitbox.monitorable = false
			enemy_hitbox.monitoring = false
			player_hitbox.monitorable = true
			player_hitbox.monitoring = true
		ALLIANCE.NEUTRAL:
			enemy_hitbox.monitorable = true
			enemy_hitbox.monitoring = true
			player_hitbox.monitorable = true
			player_hitbox.monitoring = true
