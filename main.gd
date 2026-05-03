extends Node3D

@onready var player: CharacterBody3D = $Player
@onready var hot_bar_inventory: PanelContainer = $UI/HotBarInventory

func _ready():
	# Hotbar cant be in inventory interface as it is a sibling not a parent
	# Could make a script in UI but dont want to
	hot_bar_inventory.set_inventory_data(player.inventory_data)

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
