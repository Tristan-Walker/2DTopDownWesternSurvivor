extends BaseWeapon
class_name RifleGun

@export var bullet_scene: PackedScene

const BulletScene = preload("res://Player/Weapons/Rifle/rifle_bullet.tscn")

func fire(_start_pos: Vector3, _direction: Vector3) -> void:
	var bullet = BulletScene.instantiate()
	get_tree().current_scene.add_child(bullet)

func build_pool() -> void:
	pass
