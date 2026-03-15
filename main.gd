extends Node3D

@onready var player: CharacterBody3D = $Player
@onready var inventory_interface: Control = $UI/InventoryInterface

func _ready():
	# Connect the signal from the bus to a local function
	SignalBus.player_died.connect(_on_player_health_depleted)
	%GameOverScreen.hide() # Ensure it's hidden at start

func _on_player_health_depleted() -> void:
	%GameOverScreen.visible = true
	get_tree().paused = true

func change_level(new_scene_path: String):
	# Remove old map
	for level in get_tree().get_nodes_in_group("level"):
		level.queue_free()
	
	# Load new map
	var new_scene = load(new_scene_path)
	var new_instance = new_scene.instantiate()
	add_child(new_instance)
	
	# If the new map has a spawn point, spawn player there.
	if new_instance.has_node("SpawnPoint"):
		$Player.global_position = new_instance.get_node("SpawnPoint").global_position
