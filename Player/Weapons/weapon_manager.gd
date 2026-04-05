extends Node3D

# Weapon data + inventory
@export var loadout: Array[WeaponData] = []
var equipped_weapon_node: BaseWeapon
var current_index: int = 0
var current_weapon: WeaponData
var pools = {}

func _ready():
	# Build pools for all weapons in the loadout at start
	for data in loadout:
		_build_pool(data)
	
	# Equip the first one
	if loadout.size() > 0:
		current_weapon = loadout[0]

# Catch player input
func _unhandled_input(event):
	if event.is_action_pressed("switch_weapon"):
		change_weapon(1)

# Parse array of weapons
func change_weapon(direction: int):
	current_index = posmod(current_index + direction, loadout.size())
	equip_weapon(current_index)

# Equip weapon
func equip_weapon(index: int):
	current_weapon = loadout[index]
	
	print("Equipped: ", current_weapon.name)

# Use the equipped weapon's fire function
func _input(event):
	if event.is_action_pressed("shoot"):
		shoot()

func shoot():
	var current_pool = pools[current_weapon.name]
	
	# Look for a bullet that isn't busy
	for bullet in current_pool:
		if not bullet.is_active:
			# Found one! Launch it.
			var dir = -global_transform.basis.z # Forward
			bullet.fire(global_position, dir)
			return # Stop looking once we fired

func _build_pool(data: WeaponData):
	var pool_array = []
	var pool_container = Node3D.new()
	pool_container.name = data.name + "_Pool"
	add_child(pool_container)
	
	for i in range(data.pool_size):
		var b = data.bullet_scene.instantiate()
		pool_container.add_child(b)
		pool_array.append(b)
	
	pools[data.name] = pool_array

func get_mouse_world_position() -> Vector3:
	var mouse_pos = get_viewport().get_mouse_position()
	var camera = get_viewport().get_camera_3d()
	
	# Create a ray from the camera through the mouse position
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_direction = camera.project_ray_normal(mouse_pos)
	
	# Find where that ray hits the horizontal plane (Y=0, where your floor is)
	# This math finds the intersection point on the flat 3D floor
	var plane = Plane(Vector3.UP, 0) 
	var intersection = plane.intersects_ray(ray_origin, ray_direction)
	
	if intersection:
		return intersection
	return global_position # Fallback if mouse is off-screen
