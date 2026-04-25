extends ItemData
class_name ItemDataConsumable

@export var heal_value: int

func use(target) -> void:
	if not is_instance_valid(target) or heal_value == 0:
		return
	target.heal(heal_value)
