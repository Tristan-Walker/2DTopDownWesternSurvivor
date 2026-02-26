extends CharacterBody3D

@export var speed: float = 2.0
var player: CharacterBody3D = null
var health = 3

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

func take_damage():
	health -= 1
	
	if health == 0:
		queue_free()
