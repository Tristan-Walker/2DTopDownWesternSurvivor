extends BaseWeapon
class_name PistolGun

var bullet_scene: PackedScene = preload("res://Player/Weapons/Pistol/pistol_bullet.tscn")

# Gun specs
@export var damage: int = 1
@export var fire_rate: float = 0.3
@export var bullet_speed: int = 50
@export var ammo_capacity: int = 6

# Bullet pool
@export var bullet_pool_size: int = 18
var bullet_pool: Array[Node3D] = []
var fire_cooldown: float = 0

# Reloading
var is_reloading: bool = false
var current_ammo: int = ammo_capacity
@export var reload_time: float = 1.5

# Initialize bullets
func _ready():
	for i in range(bullet_pool_size):
		var bullet = bullet_scene.instantiate()
		bullet.hide()
		bullet.process_mode = Node.PROCESS_MODE_DISABLED
		get_tree().root.call_deferred("add_child", bullet)
		bullet_pool.append(bullet)

# Fire rate cooldown
func _process(delta):
	if fire_cooldown > 0:
		fire_cooldown -= delta

# Find unused bullets
func get_bullet() -> Node3D:
	for bullet in bullet_pool:
		if not bullet.is_active:
			return bullet
	return null # If all bullets are in use

func start_reload():
	is_reloading = true
	SignalBus.reload_started.emit(reload_time)
	await get_tree().create_timer(reload_time).timeout # reload happens
	current_ammo = ammo_capacity
	SignalBus.ammo_updated.emit(current_ammo)
	is_reloading = false

func reload():
	if current_ammo != ammo_capacity:
		start_reload()

# Capture positions, find bullet, shoot bullet
func fire(_start_pos: Vector3, _direction: Vector3) -> void:
	if is_reloading or current_ammo <= 0 or fire_cooldown > 0:
		return
	var bullet = get_bullet()
	if bullet:
		bullet.fire(_start_pos, _direction, bullet_speed, damage)
		current_ammo -= 1
		SignalBus.ammo_updated.emit(current_ammo)
		fire_cooldown = fire_rate
		
		if current_ammo <= 0:
			start_reload()

func display_ammo() -> void:
	SignalBus.ammo_setup.emit.call_deferred(ammo_capacity)
	SignalBus.ammo_updated.emit.call_deferred(current_ammo)
