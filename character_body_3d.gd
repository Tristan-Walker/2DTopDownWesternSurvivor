extends CharacterBody3D
@export var bullet_scene: PackedScene

var speed = 5.0                  # player speed
@export var max_health: int = 100        # Maximum possible health of character.
var current_health := 100.0      # The health that the player currently has.
var is_invincible: bool = false  # Is the character currently invincible?
@export var i_frame_duration: float = 0.5 # Half a second of invincibility
signal health_depleted           # call game over screen
@onready var health_bar = $SubViewport/ProgressBar         # Load in health bar
var fire_rate := 0.3             # bullet fire rate
var fire_timer := 0.0            # 
var last_shoot_dir: Vector3 = Vector3.RIGHT   # Default direction

func _physics_process(_delta: float) -> void:
	
	# PLAYER MOVEMENT
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	var direction := Vector3(input_dir.x, 0, input_dir.y)
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		
	if input_dir.x != 0:
		$Sprite3D.flip_h = input_dir.x < 0
	
	move_and_slide()

	# PLAYER SHOOTING
	# Check for left-click 
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if $ShotTimer.is_stopped():
			# 1. Get where the mouse is on the floor
			var target_pos = get_mouse_world_position()
	
			# 2. Calculate direction (Target - Start)
			var shoot_dir = (target_pos - global_position).normalized()
			shoot_dir.y = 0             # We set Y to 0 so the bullet doesn't fly into the sky or floor
	
			# 3. Shoot in the direction
			shoot(shoot_dir)
	
			# 4. Restart timer
			$ShotTimer.start(fire_rate) 
	
			# 5. Flip the player sprite based on mouse position
			if target_pos.x < global_position.x:
				$Sprite3D.flip_h = true
			else:
				$Sprite3D.flip_h = false

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

# Spawning the bullets
func shoot(dir: Vector3) -> void:

	var bullet = bullet_scene.instantiate()
	get_tree().root.add_child(bullet)

	bullet.global_position = global_position + Vector3(0, 0.5, 0)
	bullet.direction = dir

# Player health
func take_damage(amount: int):
	# Check for invincibility
	if is_invincible:
		return # Skip the rest of the function if we're invincible
	
	# If not invincibile, take damage.
	current_health -= amount
	health_bar.value = current_health
	
	# Did damage kill?
	if current_health <= 0.0:
		health_depleted.emit()
	else:
		start_i_frames()

func start_i_frames():
	is_invincible = true
	
	# Flickering effect
	for i in range(5): # Flicker 5 times
		$Sprite3D.visible = false
		await get_tree().create_timer(0.05).timeout
		$Sprite3D.visible = true
		await get_tree().create_timer(0.05).timeout
	
	is_invincible = false
