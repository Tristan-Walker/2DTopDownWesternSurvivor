extends Node3D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var promptUI: Node3D = $InteractionPrompt
@onready var prompt = $InteractionPrompt/SubViewport/Label

const base_text = "[E] to "
var active_areas = []
var can_interact = true
var inUse: bool = false

func _ready():
	SignalBus.toggle_inventory.connect(player_closed_inventory)
	promptUI.hide()

func register_area(area: InteractionArea):
	prompt.text = base_text + String(area.action_name)
	active_areas.push_back(area)
	global_position = area.global_position + Vector3.UP * 2.0
	promptUI.show()

func unregister_area(area: InteractionArea):
	if area.player_left.is_valid:
		await area.player_left.call()
	
	inUse = false
	promptUI.hide()
	
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)

func _input(event):
	if event.is_action_pressed("interact") and can_interact:
		if active_areas.size() > 0:
			can_interact = false
			
			# Toggle label visibility
			if inUse == false:
				inUse = true
				promptUI.hide()
			else:
				inUse = false
				promptUI.show()
			
			# Call interact function
			await active_areas[0].interact.call()
			can_interact = true

func player_closed_inventory():
	if inUse == true:
		inUse = false
		promptUI.show()
