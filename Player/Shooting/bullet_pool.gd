extends Node3D

@export var bullet_scene: PackedScene
@export var pool_size: int = 18
var pool: Array[Node3D] = []

# Initialize bullets
func _ready():
	for i in range(pool_size):
		var bullet = bullet_scene.instantiate()
		bullet.hide()
		bullet.process_mode = Node.PROCESS_MODE_DISABLED
		add_child(bullet)
		pool.append(bullet)

func get_bullet() -> Node3D:
	for bullet in pool:
		if not bullet.visible:
			return bullet
	return null # If all bullets are on screen
