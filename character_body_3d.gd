extends CharacterBody3D
@export var bullet_scene: PackedScene
const SPEED = 5.0                #player speed

var health := 100.0              #max health
var damage_cooldown := 1.0       #i-frame time
var damage_timer := 0.0	
const damage_rate = 25.0         #damage delt by enemies
signal health_depleted

var fire_rate := 0.3             #bullet fire rate
var fire_timer := 0.0
var last_shoot_dir: Vector3 = Vector3.RIGHT   # Default direction

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
	
	#Player health
	damage_timer -= _delta
	%ProgressBar.step = damage_rate
	var overlapping_mobs = %Hurtbox.get_overlapping_bodies()
	
	if overlapping_mobs.size() > 0 and damage_timer <= 0:
		health -= damage_rate * overlapping_mobs.size()
		%ProgressBar.value = health
		damage_timer = damage_cooldown

		if health <= 0.0:
			health_depleted.emit()
	
	#Shooting 
	fire_timer -= _delta
	var shoot_dir = Vector3.ZERO
	
	if Input.is_action_pressed("shoot_right"):
		shoot_dir = Vector3.RIGHT
	elif Input.is_action_pressed("shoot_left"):
		shoot_dir = Vector3.LEFT
	elif Input.is_action_pressed("shoot_up"):
		shoot_dir = Vector3.FORWARD
	elif Input.is_action_pressed("shoot_down"):
		shoot_dir = Vector3.BACK

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
