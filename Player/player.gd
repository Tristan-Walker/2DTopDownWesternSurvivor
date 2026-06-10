extends CharacterBody3D

@onready var sprite = $AnimatedSprite3D

# Misc stats
@export var i_frame_duration: float = 0.5        # Half a second of invincibility
@export var max_health: int = 100                # Maximum possible health of character.
var current_health := 100.0                      # The health that the player currently has.
@export var speed = 5.0                          # player speed
var is_invincible: bool = false                  # Is the character currently invincible?

# Inventory
@export var inventory_data: InventoryData        # Inventory data
@export var equip_inventory_data: InventoryDataEquip  # Equip inventory data
@onready var inventory_interface: Control = $"../UI/InventoryInterface"   


func _ready():
	await get_tree().process_frame
	PlayerManager.player = self                  # Player reference for use items

# Tracking key inputs
func _unhandled_input(_event: InputEvent) -> void:
	if PlayerManager.is_level_select_open:
		return   # If map is open do nothing
	if Input.is_action_just_pressed("inventory"):
		SignalBus.toggle_inventory.emit()

# Player movement
func _physics_process(_delta: float) -> void:
	if PlayerManager.is_level_select_open:
		return   # If map is open or just closed do nothing
		
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
		sprite.flip_h = input_dir.x < 0
	
	move_and_slide()
	_update_animation(input_dir)

func take_damage(amount: int):
	# Check for invincibility
	if is_invincible:
		return # Skip the rest of the function if we're invincible
	
	# If not invincibile, take damage.
	current_health -= amount
	SignalBus.player_health_changed.emit(current_health)
	
	# Did damage kill?
	if current_health <= 0.0:
		SignalBus.player_died.emit()
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

func heal(heal_value: int) -> void:
	if ((current_health + heal_value) <= max_health):
		current_health += heal_value
		SignalBus.player_health_changed.emit(current_health)
	else:
		current_health = max_health
		SignalBus.player_health_changed.emit(current_health)

func _update_animation(input_dir: Vector2) -> void:
	if input_dir == Vector2.ZERO:
		_play_animation("idle")
		return

	# Right or down = walk_forward, Left or up = walk_backward
	var is_forward = input_dir.x > 0 or input_dir.y > 0
	_play_animation("walk_forward" if is_forward else "walk_backward")

func _play_animation(anim_name: String) -> void:
	if sprite.animation == anim_name:
		return  # Already playing, don't restart it
	sprite.play(anim_name)
