extends CharacterBody3D
@export var bullet_scene: PackedScene
var fire_rate := 0.3
var fire_timer := 0.0
var last_shoot_dir: Vector3 = Vector3.RIGHT   # Default direction

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
	
	#Shooting 
	fire_timer -= _delta
	var shoot_dir = Vector3.ZERO
	
	if Input.is_action_pressed("shoot_right"):
		shoot_dir = Vector3.RIGHT
	elif Input.is_action_pressed("shoot_left"):
		shoot_dir = Vector3.LEFT
	elif Input.is_action_pressed("shoot_up"):
		shoot_dir = Vector3(0, 0, -1)
	elif Input.is_action_pressed("shoot_down"):
		shoot_dir = Vector3(0, 0, 1)

	if shoot_dir != Vector3.ZERO:
		last_shoot_dir = shoot_dir

	if shoot_dir != Vector3.ZERO and fire_timer <= 0:
		shoot(last_shoot_dir)
		fire_timer = fire_rate

func shoot(dir: Vector3) -> void:

	var bullet = bullet_scene.instantiate()
	get_tree().root.add_child(bullet)

	bullet.global_position = global_position + Vector3(0, 0.5, 0)
	bullet.direction = dir
