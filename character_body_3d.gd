extends CharacterBody3D
@export var bullet_scene: PackedScene

const SPEED = 5.0

func _physics_process(_delta: float) -> void:
	
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	var direction := Vector3(input_dir.x, 0, input_dir.y)
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	if input_dir.x != 0:
		$Sprite3D.flip_h = input_dir.x < 0
	
	move_and_slide()
	
	if Input.is_action_just_pressed("ui_accept"):
		shoot()

func shoot():
	
	# Height at which to spawn the bullet
	var spawn_height = Vector3(0, 0.5, 0) 
	
	# Initialize bullet & give it a position
	var bullet = bullet_scene.instantiate()
	get_tree().root.add_child(bullet)
	bullet.global_position = global_position + spawn_height
	
	# Get the movement input to decide bullet direction
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Default direction (if standing still, shoot the way the sprite faces)
	var shoot_dir = Vector3.LEFT if $Sprite3D.flip_h else Vector3.RIGHT
	
	# If moving, shoot in the direction of movement
	if input_dir.length() > 0:
		shoot_dir = Vector3(input_dir.x, 0, input_dir.y).normalized()
	bullet.direction = shoot_dir
	
