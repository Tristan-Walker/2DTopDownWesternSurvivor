extends CharacterBody3D

@export var speed: float = 3.0
var player: CharacterBody3D = null

func _ready() -> void:
	# This finds the player node in your main scene. 
	# Ensure your player node is actually named "Player"!
	player = get_tree().root.find_child("Player", true, false)

func _physics_process(_delta: float) -> void:
	if player:
		# 1. Calculate direction (Target Position - My Position)
		var direction = (player.global_position - global_position).normalized()
		
		# 2. Apply movement (ignoring Y so they don't fly)
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		
		# 3. Flip the sprite based on direction
		if direction.x != 0:
			$Sprite3D.flip_h = direction.x < 0
		
		move_and_slide()
