extends Node

signal player_health_changed(new_health)
signal player_died()
signal ammo_updated(currrent_ammo)
signal ammo_setup(max_ammo)
signal reload_started(duration: float)

# Inventory Commands
signal close_chest()
signal open_chest(external_inventory_owner)
signal toggle_inventory()
# signal enemy_defeated(points)
