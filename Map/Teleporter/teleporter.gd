extends Node3D

@export_file var desert: String # Holds the path to Desert scene
@onready var interaction_area: InteractionArea = $InteractionArea

func _ready():
	# Link our specific logic to the generic interaction "socket"
	interaction_area.interact = Callable(self, "teleport_player")
	interaction_area.player_left = Callable(self, "player_left")
	interaction_area.action_name = "go to Desert"

func teleport_player():
	var main_node = get_tree().root.find_child("Main", true, false)
	if main_node and main_node.has_method("change_level"):
		print("Has")
		main_node.change_level(desert)
	else:
		print("Could not find Main or method missing. Found: ", main_node.name if main_node else "null")

func player_left():
	pass
