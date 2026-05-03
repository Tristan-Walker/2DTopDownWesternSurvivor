extends CanvasLayer
class_name LevelSelect

@export_file var desert: String # Holds the path to Desert scene
@export_file var town: String

@onready var map: LevelSelect = $"."
@onready var current_level = $Town

var move_tween: Tween
var icon_offset := Vector2(0, -24)

func _ready() -> void:
	PlayerManager.is_level_select_open = true
	update_player_position()

func _input(event):
	if move_tween.is_running():
		return
		
	if event.is_action_pressed("move_left") and current_level.next_level_left:
		current_level = current_level.next_level_left
		update_player_position()
	
	if event.is_action_pressed("move_right") and current_level.next_level_right:
		current_level = current_level.next_level_right
		update_player_position()
	
	if event.is_action_pressed("move_up") and current_level.next_level_up:
		current_level = current_level.next_level_up
		update_player_position()
	
	if event.is_action_pressed("move_down") and current_level.next_level_down:
		current_level = current_level.next_level_down
		update_player_position()
	
	if event.is_action_pressed("ui_accept"):
		PlayerManager.is_level_select_open = false
		teleport_player(name_converter(current_level.name))
		SignalBus.close_level_select.emit()
		map.queue_free()

	if event.is_action_pressed("ui_cancel"):
		PlayerManager.is_level_select_open = false
		SignalBus.close_level_select.emit()
		
		get_viewport().set_input_as_handled()   # Prevents pause menu from opening after
		
		map.queue_free()

func update_player_position():
	move_tween = get_tree().create_tween()
	move_tween.tween_property($PlayerIcon, "global_position", \
		current_level.global_position \
		+ (current_level.size / 2) \
		- ($PlayerIcon.size / 2) \
		+ icon_offset, 0.5).set_trans(Tween.TRANS_SINE)

func teleport_player(new_map: String):
	var main_node = get_tree().root.find_child("Main", true, false)
	if main_node and main_node.has_method("change_level"):
		main_node.change_level(new_map)
	else:
		print("Could not find Main or method missing. Found: ", \
		main_node.name if main_node else "null")

func name_converter(map_name: String):
	if map_name == "Desert":
		print(desert)
		return desert
	elif map_name == "Town":
		return town
