extends Area3D
class_name BulletBase

var align_speed : float = 5.0

var velocity : Vector3 = Vector3.RIGHT
var damage : int = 0
var forces : Array[Vector3] = []

signal bullet_destroyed

func prepare(args : BulletArgs) -> void:
	global_position = args.origin
	global_basis = args.basis
	global_scale(args.scale)
	velocity = args.velocity
	damage = args.damage
	collision_layer = args.alliance
	collision_mask = args.alliance

func _physics_process(delta):
	if abs(global_position.z) <= align_speed * delta:
		global_position.z = 0
	else:
		global_position += Vector3.FORWARD * sign(global_position.z) * align_speed * delta

	for force in forces:
		velocity += force
	forces.clear()
	global_position += velocity * delta


func _exit_tree() -> void:
	bullet_destroyed.emit()

func add_force(force: Vector3):
	forces.append(force)

class BulletArgs :
	var origin : Vector3 = Vector3.ZERO
	var basis : Basis = Basis()
	var scale : Vector3 = Vector3.ONE
	var velocity : Vector3 = Vector3.RIGHT
	## Use a low number for bullets that will collide with the player. Use a higher number for bullets
	## that collide with enemies.
	var damage : int = 1
	## Bitmask. Sets collision layer and mask. Use 0b1 for player, 0b10 for enemies.
	var alliance : int = 0b10
