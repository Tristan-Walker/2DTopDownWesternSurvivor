extends Resource

class_name SlotData

const MaxStackSize: int = 99

@export var item_data: ItemData
@export_range(1, MaxStackSize) var quantity: int = 1: set = set_quantity

func can_fully_merge_with(other_slot_data: SlotData) -> bool:
	return item_data == other_slot_data.item_data \
			and item_data.stackable \
			and quantity + other_slot_data.quantity < MaxStackSize

func fully_merge_with(other_slot_data: SlotData) -> void:
	quantity += other_slot_data.quantity

func set_quantity(value: int) -> void:
	quantity = value
	if quantity > 1 and not item_data.stackable:
		quantity = 1
		push_error("%s is not stackable, setting quantity to 1" % item_data.name)
		
