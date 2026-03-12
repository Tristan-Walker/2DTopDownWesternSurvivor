extends Node3D

# Slot for enemy scene
@export var enemy_scene: PackedScene 

func _on_timer_timeout() -> void:
	
	# Height at which to spawn the enemy
	var spawn_height = Vector3(0, 0.5, 0) 
	
	var enemy = enemy_scene.instantiate()
	
	# Spawn them at a random position away from the center
	var spawn_pos = Vector3(randf_range(-10, 10), 0, randf_range(-10, 10))
	enemy.position = spawn_pos + spawn_height
	
	add_child(enemy)
