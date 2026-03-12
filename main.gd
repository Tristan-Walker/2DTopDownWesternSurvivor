extends Node3D

@onready var player: CharacterBody3D = $Player
@onready var inventory_interface: Control = $UI/InventoryInterface

func _ready():
	# Giving plater inventory data
	inventory_interface.visible = false
	player.toggle_inventory.connect(toggle_inventory_interface)
	inventory_interface.set_player_inventory_data(player.inventory_data)
	
	for node in get_tree().get_nodes_in_group("external_inventory"):
		node.toggle_inventory.connect(toggle_inventory_interface)
	
	
	# Connect the signal from the bus to a local function
	SignalBus.player_died.connect(_on_player_health_depleted)
	%GameOverScreen.hide() # Ensure it's hidden at start

func toggle_inventory_interface(external_inventory_owner = null) -> void:
	inventory_interface.visible = !inventory_interface.visible
	
	if external_inventory_owner and inventory_interface.visible:
		inventory_interface.set_external_inventory(external_inventory_owner)
	else:
		inventory_interface.clear_external_inventory()

func _on_player_health_depleted() -> void:
	%GameOverScreen.visible = true
	get_tree().paused = true
