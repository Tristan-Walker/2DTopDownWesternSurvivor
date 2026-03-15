extends Node3D

@export_file var desert: String # Holds the path to Desert scene
@onready var interaction_area: InteractionArea = $InteractionArea

func _ready():
	# Link to interaction area/manager logic
	interaction_area.interact = Callable(self, "open_map")
	interaction_area.player_left = Callable(self, "player_left")
	interaction_area.action_name = "teleport"

func open_map():
	teleport_player(desert)
	print("map opened")

func teleport_player(new_map: String):
	var main_node = get_tree().root.find_child("Main", true, false)
	if main_node and main_node.has_method("change_level"):
		main_node.change_level(new_map)
	else:
		print("Could not find Main or method missing. Found: ", main_node.name if main_node else "null")

func player_left():
	pass
