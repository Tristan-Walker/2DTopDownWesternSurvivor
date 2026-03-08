extends Node3D

@onready var player: CharacterBody3D = $Player
@onready var inventory_interface: Control = $UI/InventoryInterface

func _ready():
	# Giving plater inventory data
	player.toggle_inventory.connect(toggle_inventory_interface)
	inventory_interface.set_player_inventory_data(player.inventory_data)
	
	# Connect the signal from the bus to a local function
	SignalBus.player_died.connect(_on_player_health_depleted)
	%GameOverScreen.hide() # Ensure it's hidden at start

func toggle_inventory_interface() -> void:
	inventory_interface.visible = !inventory_interface.visible

func _on_player_health_depleted() -> void:
	%GameOverScreen.visible = true
	get_tree().paused = true
