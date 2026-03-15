extends Node3D

@export var terrain_scene: PackedScene
@export var spawn_count: int = 20
@export var spawn_area: Vector2 = Vector2(29.5, 29.5)
@export var spawn_height: float

func _ready():
	spawn_terrain()

func spawn_terrain():
	for i in range(spawn_count):
		var terrain = terrain_scene.instantiate()
		
		# Generate a random position within spawn area
		var x = randf_range(-spawn_area.x / 2, spawn_area.x / 2)
		var z = randf_range(-spawn_area.y / 2, spawn_area.y / 2)
		
		# Add the terrain as a child
		add_child(terrain)
		
		# Set the position (assuming Y=0 is your ground level)
		terrain.position = Vector3(x, spawn_height, z)
