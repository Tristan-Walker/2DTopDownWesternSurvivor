extends Node3D

@export var weapons: Array[GDScript] = []
@export var bullet_height: float = 0.4

var _instances: Array[BaseWeapon] = []
var _current_index: int = 0
var current_weapon: BaseWeapon

func _ready():
	# Instantiate all weapons and add as children, but disable all first
	for script in weapons:
		var weapon: BaseWeapon = script.new()
		add_child(weapon)
		weapon.active = false # start inactive
		_instances.append(weapon)
	
	# Activate the first one
	if _instances.size() > 0:
		_instances[0].active = true
		current_weapon = _instances[0]

# Catch player input
func _unhandled_input(event):
	if event.is_action_pressed("switch_weapon"):
		change_weapon(1)

# Parse array of weapons
func change_weapon(direction: int):
	_current_index = posmod(_current_index + direction, _instances.size())
	equip_weapon(_current_index)

# Equip weapon
func equip_weapon(index: int):
	current_weapon = _instances[index]
	print("Equipped: ", current_weapon.name)

# Use the equipped weapon's fire function
func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("shoot"):
		shoot()

# Call the shoot function & tell it where to aim
func shoot():
	var target_pos = get_mouse_world_position()
	var shoot_dir = (target_pos - global_position).normalized()
	shoot_dir.y = 0
	var shoot_start = (global_position + Vector3(0, bullet_height, 0))
	current_weapon.fire( shoot_start, shoot_dir)
	return

# Aiming based on mouse position
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
