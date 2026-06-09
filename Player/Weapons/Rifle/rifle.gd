extends BaseWeapon
class_name RifleGun

const bullet_scene = preload("res://Player/Weapons/Rifle/rifle_bullet.tscn")
const ammo_layout: AmmoLayout = preload("res://UI/PlayerUI/AmmoUI/AmmoLayouts/ammo_layout_rifle.tres")

# Gun specs
@export var damage: int = 1
@export var fire_rate: float = 0.1
@export var bullet_speed: int = 50
@export var ammo_capacity: int = 24

# Bullet pool
@export var bullet_pool_size: int = 48
var bullet_pool: Array[Node3D] = []
var fire_cooldown: float = 0

# Reloading
var reload_tween: Tween = null   # Used for the timer till reload
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

# The actual reload mechanics
func start_reload():
	is_reloading = true
	SignalBus.reload_started.emit(reload_time)
	
	# Create and wait for tween to reload
	reload_tween = create_tween()
	reload_tween.tween_interval(reload_time)  
	await reload_tween.finished     # reload happens
	if not is_reloading:  # Guard in case cancel snuck in at the boundary
		return
	
	# Post reload stuff: reset ammo - send reset ammo signal
	current_ammo = ammo_capacity
	SignalBus.ammo_updated.emit(current_ammo)
	is_reloading = false
	reload_tween = null

# Block reload if ammo is full: Call reload otherwise
func reload():
	if current_ammo != ammo_capacity:
		start_reload()

# Cancels the tween of the reload. Will interupt reloads.
func cancel_reload():
	if not is_reloading: # If we aren't reloading, no need.
		return
	is_reloading = false
	if reload_tween:
		reload_tween.kill()
		reload_tween = null

# If weapon is swapped to but has no current ammo
func switch_reload():
	if not is_reloading: # If we aren't reloading, no need.
		return
	if reload_tween:
		reload_tween.kill()
		reload_tween = null
	is_reloading = false

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
	SignalBus.ammo_setup.emit.call_deferred(ammo_capacity , ammo_layout)
	SignalBus.ammo_updated.emit.call_deferred(current_ammo)
