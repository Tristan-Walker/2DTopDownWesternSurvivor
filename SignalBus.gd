extends Node

# Player
signal player_health_changed(new_health)
signal player_died()
signal ammo_updated(currrent_ammo)
signal ammo_setup(max_ammo: int, layout: AmmoLayout)
signal reload_started(duration: float)

# Inventory Commands
signal close_chest()
signal open_chest(external_inventory_owner)
signal toggle_inventory()
signal drop_slot_data(slot_data: SlotData)
signal isOpen(isOpen: bool)
signal close_inventory()
signal open_inventory()

# Level Select
signal close_level_select()
# signal enemy_defeated(points)
