extends Resource
class_name WeaponData

@export var name: String = ""
@export var damage: float = 10.0
@export var fire_rate: float = 0.5
@export var bullet_speed: float = 10
@export var ammo_capacity: int = 12
@export var bullet_range: float = 20
@export var bullet_amount: int = 1

# Bullet pooling
@export var pool_size: int = 18
@export var bullet_scene: PackedScene
