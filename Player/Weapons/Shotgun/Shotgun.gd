extends BaseWeapon

@export var bullet_amount: int = 8
@export var spread: float = 0.1
@export var bullet_scene: PackedScene

func fire():
	for i in range(bullet_amount):
		var bullet = bullet_scene.instantiate()
		get_tree().root.add_child(bullet)
		bullet.global_position = global_position
		var random_spread = Vector3(randf_range(-spread, spread), randf_range(-spread, spread), 0)
		bullet.velocity = (global_transform.basis.z + random_spread).normalized() * 50
