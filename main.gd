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
