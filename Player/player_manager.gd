extends Node

var player

func _ready() -> void:
	player = get_tree().root.find_child("Player", true, false)

func use_slot_data(slot_data: SlotData) -> void:
	slot_data.item_data.use(player)

func get_global_position() -> Vector3:
	return player.global_position
