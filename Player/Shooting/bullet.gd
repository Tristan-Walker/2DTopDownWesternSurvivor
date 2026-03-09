extends Area3D

@export var speed: float = 10.0
@export var b_damage: float = 1.0
var direction: Vector3 = Vector3.ZERO

# Reactivate inactive bullet
func activate(pos: Vector3, dir: Vector3):
	global_position = pos
	direction = dir
	self.show()
	set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)

# Deactivates active bullet
func deactivate():
	self.hide()
	set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)

func _physics_process(delta: float) -> void:
	# Move the bullet in the direction it was fired
	global_position += direction * speed * delta

func _on_body_entered(body: Node3D) -> void:
	deactivate()
	
	if body.has_method("take_damage"):
		body.take_damage(b_damage)

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	deactivate()
