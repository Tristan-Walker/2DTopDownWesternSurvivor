extends Control
class_name LevelSelect

@onready var current_level = $Town
var move_tween: Tween
var icon_offset := Vector2(0, -24)

func _ready() -> void:
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
		print(current_level)
	
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://main.tscn")

func update_player_position():
	move_tween = get_tree().create_tween()
	move_tween.tween_property($PlayerIcon, "global_position", \
		current_level.global_position \
		+ (current_level.size / 2) \
		- ($PlayerIcon.size / 2) \
		+ icon_offset, 0.5).set_trans(Tween.TRANS_SINE)
