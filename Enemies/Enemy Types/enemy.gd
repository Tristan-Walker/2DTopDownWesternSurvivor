extends CharacterBody3D

@export var damage_amount: int = 20
@export var speed: float = 2.0
var player_in_range: CharacterBody3D = null
var player: CharacterBody3D = null
var health: float = 3

func _ready() -> void:
	# This finds the player node in the player group.
	# Faster than finding the child node.
	player = get_tree().get_first_node_in_group("player")

func _physics_process(_delta: float) -> void:
	if player:
		# Calculate direction (Target Position - My Position)
		var direction = (player.global_position - global_position).normalized()
		
		# Apply movement 
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		
		# Flip the sprite based on direction
		if direction.x != 0:
			$Sprite3D.flip_h = direction.x < 0
		
		move_and_slide()

func take_damage(damage: float):
	health -= damage
	
	if health == 0:
		queue_free()

func _on_attack_area_body_entered(body: Node3D) -> void:
	
	# 1. Deal first hit of damage & save player
	if body.is_in_group("player"):
		player_in_range = body
		if body.has_method("take_damage"):
			body.take_damage(damage_amount)
			
	# 2. Start the repeating clock for the next hits
	$DamageTimer.start()

func _on_timer_timeout() -> void:
	if player_in_range:
		player_in_range.take_damage(damage_amount)

func _on_attack_area_body_exited(body: Node3D) -> void:
	if body == player_in_range:
		player_in_range = null
		$DamageTimer.stop()
