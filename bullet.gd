extends Area3D

@export var speed: float = 10.0
var direction: Vector3 = Vector3.ZERO

func _physics_process(delta: float) -> void:
	# Move the bullet in the direction it was fired
	global_position += direction * speed * delta

func _on_body_entered(body: Node3D) -> void:
	# If it hits an enemy, kill the enemy and the bullet
	if body.is_in_group("enemy"):
		body.queue_free() # Deletes the enemy
		queue_free()      # Deletes the bullet

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()
