extends StaticBody3D

signal toggle_inventory(external_inventory_owner)

@onready var interaction_area: InteractionArea = $InteractionArea
@export var inventory_data: InventoryData

func _ready():
	interaction_area.interact = Callable(self, "player_interact")

func player_interact() -> void:
	toggle_inventory.emit(self)

	print("chest opened")
	
