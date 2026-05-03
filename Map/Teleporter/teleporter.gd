extends Node3D

@onready var interaction_area: InteractionArea = $InteractionArea
const map_scene = preload("res://Map/map.tscn")

func _ready():
	# Link to interaction area/manager logic
	interaction_area.interact = Callable(self, "open_map")
	interaction_area.player_left = Callable(self, "player_left")
	interaction_area.action_name = "teleport"

func open_map():
	if PlayerManager.is_level_select_open:
		return   #prevents reopening the map while its open
	var main_node = get_tree().root.find_child("Main", true, false)
	var map_instance = map_scene.instantiate()
	main_node.add_child(map_instance)

func player_left():
	pass
