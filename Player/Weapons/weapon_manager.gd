extends Node3D

@export var available_weapons: Array[WeaponData] = []
var equipped_weapon_node: BaseWeapon

var current_index: int = 0
var current_weapon: WeaponData

func _ready():
	if available_weapons.size() > 0:
		equip_weapon(0)

# Catch player input
func _unhandled_input(event):
	if event.is_action_pressed("switch_weapon"):
		change_weapon(1)

# Parse array of weapons
func change_weapon(direction: int):
	current_index = posmod(current_index + direction, available_weapons.size())
	equip_weapon(current_index)

# Equip weapon
func equip_weapon(index: int):
	current_weapon = available_weapons[index]
	
	print("Equipped: ", current_weapon.name)

# Use the equipped weapon's fire function
func _input(event):
	if event.is_action_pressed("shoot") and equipped_weapon_node:
		equipped_weapon_node.fire()
