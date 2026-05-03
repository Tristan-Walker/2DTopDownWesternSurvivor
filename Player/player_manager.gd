extends Node

var player

var is_inventory_open := false
var is_chest_open := false
var is_level_select_open := false
var is_game_over := false

func _ready() -> void:
	player = get_tree().root.find_child("Player", true, false)

func use_slot_data(slot_data: SlotData) -> void:
	slot_data.item_data.use(player)

func get_global_position() -> Vector3:
	return player.global_position

# Check if any UI is open (for handling esc pressed)
func is_any_ui_open() -> bool:
	return is_inventory_open or is_chest_open or is_level_select_open
