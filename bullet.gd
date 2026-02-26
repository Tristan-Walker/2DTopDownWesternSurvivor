extends Area3D

@export var speed: float = 10.0
var direction: Vector3 = Vector3.ZERO

func _physics_process(delta: float) -> void:
	# Move the bullet in the direction it was fired
	global_position += direction * speed * delta

func _on_body_entered(body: Node3D) -> void:
	queue_free()      # Deletes the bullet when hitting another entity
	
	if body.has_method("take_damage"):
		body.take_damage()

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()
