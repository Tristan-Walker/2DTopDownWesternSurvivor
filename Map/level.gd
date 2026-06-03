#@tool
extends Control
class_name LevelIcon

@export var level_name := ""
@export var next_level_up: LevelIcon
@export var next_level_down: LevelIcon
@export var next_level_left: LevelIcon
@export var next_level_right: LevelIcon

func _ready() -> void:
	$LevelName.text = str(level_name)

#uncomment to see editor change live helps with direction mapping
#func _process(_delta: float) -> void:
	#if Engine.is_editor_hint():
			#$LevelName.text = str(level_name)
