extends Node
class_name BulletSpawner

@export var _should_spawn : bool = true
@export var _bullet_prefab : PackedScene
## If this number is less than zero, the number of bullets will not be limited.
@export var _max_bullets : int = -1
@export var _spawn_at_all : bool = false
@export var _location_placeholders : Array[Node3D]
var current_location_placeholder : int = 0
@export var _direction : Vector3 = Vector3.RIGHT
@export var _velocity : float = 1.0
@export var _damage : int = 1
@export_flags_3d_physics var _alliance : int = 0b1

var bullet_args : BulletBase.BulletArgs
var bullet_list : Array[BulletBase]

func _ready():
	bullet_args = BulletBase.BulletArgs.new()
	update_bullet_args()

func spawn(args : BulletBase.BulletArgs = null):
	if not _should_spawn:
		return

	if _spawn_at_all:
		spawn_at_all(args)
		return

	if _max_bullets >= 0 and bullet_list.size() >= _max_bullets:
		return

	# Iterate over each of the provided location placeholders. This logic is here to support
	# characters with multiple guns. In this case, each gun will fire in sequence, in the
	# order they were placed in the list. Skip if args are provided, as they may contain 
	# new location data.
	if _location_placeholders.size() != 0 and args == null:
		current_location_placeholder += 1
		current_location_placeholder = current_location_placeholder % _location_placeholders.size()
		var new_location_placeholder = _location_placeholders[current_location_placeholder]
		update_bullet_args()
		bullet_args.transform = new_location_placeholder.global_transform.orthonormalized()

	var new_bullet := _bullet_prefab.instantiate() as BulletBase
	get_tree().root.add_child(new_bullet)
	new_bullet.prepare(args if args != null else bullet_args)
	bullet_list.append(new_bullet)
	new_bullet.bullet_destroyed.connect(forget_bullet.bind(new_bullet))

func spawn_at_all(args : BulletBase.BulletArgs = null):
	var last_spawn_at_all = _spawn_at_all
	_spawn_at_all = false
	for i in _location_placeholders.size():
		spawn(args)
	_spawn_at_all = last_spawn_at_all

func forget_bullet(bullet : BulletBase):
	bullet_list.erase(bullet)
	bullet.bullet_destroyed.disconnect(forget_bullet)

func clear_bullets():
	for bullet in bullet_list:
		bullet.queue_free()
	bullet_list.clear()

func update_bullet_args():
	bullet_args.transform = _location_placeholders[0].transform
	bullet_args.direction = _direction
	bullet_args.velocity = _velocity
	bullet_args.damage = _damage
	bullet_args.alliance = _alliance
