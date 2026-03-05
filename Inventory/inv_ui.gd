extends MarginContainer

@onready var inv: Inv = preload("res://Inventory/playerinv.tres")
@onready var slots: Array = $NinePatchRect/MarginContainer/GridContainer.get_children()

var is_open = false

func _ready():
	update_slots()
	toggle_visibility()

func update_slots():
	for i in range(min(inv.items.size(), slots.size())):
		slots[i].update(inv.items[i])

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		toggle_visibility()

func toggle_visibility():
		visible = !visible
