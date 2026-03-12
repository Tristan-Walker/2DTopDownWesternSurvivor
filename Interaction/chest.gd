extends StaticBody3D

@onready var interaction_area: InteractionArea = $InteractionArea
@export var inventory_data: InventoryData

var isOpen: bool = false

func _ready():
	interaction_area.interact = Callable(self, "player_interact")
	interaction_area.player_left = Callable(self, "player_left")

func player_interact() -> void:
	if isOpen == false:
		isOpen = true
		SignalBus.open_chest.emit(self)
	else:
		isOpen = false
		SignalBus.close_chest.emit()

func player_left() -> void:
	isOpen = false
	SignalBus.close_chest.emit()
