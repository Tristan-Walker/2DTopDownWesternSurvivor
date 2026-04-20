extends Node3D

@onready var interaction_area: InteractionArea = $InteractionArea
var map = preload("res://Map/map.tscn").instantiate()

func _ready():
	# Link to interaction area/manager logic
	interaction_area.interact = Callable(self, "open_map")
	interaction_area.player_left = Callable(self, "player_left")
	interaction_area.action_name = "teleport"

func open_map():
	var main_node = get_tree().root.find_child("Main", true, false)
	main_node.add_child(map)
	#get_tree().paused = true
	
func player_left():
	pass
