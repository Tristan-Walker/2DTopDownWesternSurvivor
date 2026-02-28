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
	
	# Player Movement
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
	
	# Player Shooting 
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
