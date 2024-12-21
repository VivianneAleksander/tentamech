extends Node
class_name BulletSpawner

@export var _should_spawn : bool = true
@export var _bullet_prefab : PackedScene
## If this number is less than zero, the number of bullets will not be limited.
@export var _max_bullets : int = -1
@export var _spawn_at_all : bool = false
## If this value is set, it will be preferred over _location_explicit.
@export var _location_placeholders : Array[Node3D]
var current_location_placeholder : int = 0
## This value is only used if _location_placeholders is null.
@export var _location_explicit : Vector3
@export var _velocity : Vector3 = Vector3.RIGHT
@export var _scale : Vector3 = Vector3.ONE
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
		bullet_args.origin = new_location_placeholder.global_position
		bullet_args.basis = new_location_placeholder.global_basis
		bullet_args.velocity = new_location_placeholder.global_basis.y * _velocity


	var new_bullet := _bullet_prefab.instantiate() as BulletBase
	get_tree().root.add_child(new_bullet)
	new_bullet.prepare(args if args != null else bullet_args)
	bullet_list.append(new_bullet)
	new_bullet.bullet_destroyed.connect(forget_bullet.bind(new_bullet))

func spawn_at_all(args : BulletBase.BulletArgs = null):
	_spawn_at_all = false
	for i in _location_placeholders.size():
		spawn(args)
	_spawn_at_all = true

func spawn_explicit(location : Vector3, velocity : Vector3, scale : Vector3, damage : int, alliance : int):
	var new_args := BulletBase.BulletArgs.new()
	new_args.origin = location
	new_args.velocity = velocity
	new_args.scale = scale
	new_args.damage = damage
	new_args.alliance = alliance
	spawn(new_args)

func forget_bullet(bullet : BulletBase):
	bullet_list.erase(bullet)
	bullet.bullet_destroyed.disconnect(forget_bullet)

func clear_bullets():
	for bullet in bullet_list:
		bullet.queue_free()
	bullet_list.clear()

func update_bullet_args():
	bullet_args.origin = _location_explicit if _location_placeholders.size() == 0 else _location_placeholders[0].global_position
	bullet_args.velocity = _velocity
	bullet_args.scale = _scale
	bullet_args.damage = _damage
	bullet_args.alliance = _alliance

func set_bullet_prefab(new_prefab : PackedScene):
	_bullet_prefab = new_prefab

func set_bullet_velocity(new_velocity : Vector3):
	_velocity = new_velocity
	update_bullet_args()

func set_bullet_location_placeholders(new_placeholders : Array[Node3D]):
	_location_placeholders.assign(new_placeholders)
	update_bullet_args()

func set_bullet_location_explicit(new_location : Vector3):
	_location_explicit = new_location
	update_bullet_args()

func set_bullet_scale(new_scale : Vector3):
	_scale = new_scale
	update_bullet_args()

func set_bullet_damage(new_damage : int):
	_damage = new_damage
	update_bullet_args()

func set_bullet_alliance(new_alliance : int):
	_alliance = new_alliance
	update_bullet_args()
