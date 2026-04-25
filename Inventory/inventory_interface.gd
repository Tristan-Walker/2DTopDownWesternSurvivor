extends Control

#signal force_close

const PickUp = preload("res://Inventory/PickUps/pick_up.tscn")

var grabbed_slot_data: SlotData
var external_inventory_owner
var is_inventory_open: bool = false

@onready var player_inventory: PanelContainer = $PlayerInventory
@onready var grabbed_slot: PanelContainer = $GrabbedSlot
@onready var external_inventory: PanelContainer = $ExternalInventory
@onready var player: CharacterBody3D = $"../../Player"
@onready var hot_bar_inventory: PanelContainer = $"../HotBarInventory"
@onready var inventory_interface: Control = $"."
@onready var equip_inventory: PanelContainer = $EquipInventory

func _ready():
	SignalBus.close_chest.connect(clear_external_inventory)
	SignalBus.open_chest.connect(open_external_inventory)
	SignalBus.toggle_inventory.connect(toggle_inventory_interface)
	SignalBus.drop_slot_data.connect(drop_item_to_world)
	SignalBus.close_inventory.connect(close_inventory_interface)
	SignalBus.open_inventory.connect(open_inventory_interface)

	# Giving player inventory data
	self.set_player_inventory_data(player.inventory_data)
	self.set_equip_inventory_data(player.equip_inventory_data)

func _physics_process(_delta: float) -> void:
	if grabbed_slot.visible:
		grabbed_slot.global_position = get_global_mouse_position() + Vector2(5, 5)

func toggle_inventory_interface() -> void:
	self.visible = !self.visible
	is_inventory_open = self.visible
	
	#Toggle hotbar visibility when player inventory is open
	if inventory_interface.visible:
		hot_bar_inventory.hide()
	else:
		hot_bar_inventory.show()

func close_inventory_interface():
	self.visible = false
	hot_bar_inventory.show()
	is_inventory_open = false

func open_inventory_interface():
	self.visible = true
	hot_bar_inventory.hide()
	is_inventory_open = true

func open_external_inventory(this_external_inventory_owner):
	if self.visible == false:
		self.visible = true
	set_external_inventory(this_external_inventory_owner)
	
	is_inventory_open = true
	SignalBus.isOpen.emit(true)
	
	if inventory_interface.visible:
		hot_bar_inventory.hide()
	else:
		hot_bar_inventory.show()
		
func set_player_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)
	player_inventory.set_inventory_data(inventory_data)

func set_equip_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)
	equip_inventory.set_inventory_data(inventory_data)

func set_external_inventory(_external_inventory_owner) -> void:
	external_inventory_owner = _external_inventory_owner
	var inventory_data = external_inventory_owner.inventory_data
	
	inventory_data.inventory_interact.connect(on_inventory_interact)
	external_inventory.set_inventory_data(inventory_data)
	
	external_inventory.show()

func clear_external_inventory() -> void:
	if external_inventory_owner:
		var inventory_data = external_inventory_owner.inventory_data
		
		inventory_data.inventory_interact.disconnect(on_inventory_interact)
		external_inventory.clear_inventory_data(inventory_data)
		
		#Close external inventory and player inventory when walking away
		external_inventory.hide()
		external_inventory_owner = null
		
		is_inventory_open = self.visible    #Sync bool with player inventory visibility

func on_inventory_interact(inventory_data: InventoryData, 
		index: int, button: int) -> void:
	
	match [grabbed_slot_data, button]:
		[null, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.grab_slot_data(index)
		[_, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.drop_slot_data(grabbed_slot_data, index)
		[null, MOUSE_BUTTON_RIGHT]:
			inventory_data.use_slot_data(index)
		[_, MOUSE_BUTTON_RIGHT]:
			grabbed_slot_data = inventory_data.drop_single_slot_data(grabbed_slot_data, index)

	update_grabbed_slot()

func update_grabbed_slot() -> void:
	if grabbed_slot_data:
		grabbed_slot.show()
		grabbed_slot.set_slot_data(grabbed_slot_data)
	else:
		grabbed_slot.hide()

func drop_item_to_world(slot_data: SlotData):
	var pick_up = PickUp.instantiate()
	pick_up.slot_data = slot_data
	
	var forward = player.global_transform.basis.z
	var drop_position = player.global_position + forward * 0.75 + Vector3.UP
	
	get_tree().current_scene.add_child(pick_up)
	pick_up.global_position = drop_position
	
	# throw force (forward: distance, Vector3.UP: hight)
	pick_up.apply_impulse(forward * 2.5 + Vector3.UP * 2.0)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
			and event.is_pressed() \
			and grabbed_slot_data:
			
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				SignalBus.drop_slot_data.emit(grabbed_slot_data)
				grabbed_slot_data = null
			MOUSE_BUTTON_RIGHT:
				SignalBus.drop_slot_data.emit(grabbed_slot_data.create_single_slot_data())
				
				if grabbed_slot_data.quantity <= 0:
					grabbed_slot_data = null
					
	update_grabbed_slot()

func _on_visibility_changed() -> void:
	if not visible and grabbed_slot_data:
		SignalBus.drop_slot_data.emit(grabbed_slot_data)
		grabbed_slot_data = null
		update_grabbed_slot()
