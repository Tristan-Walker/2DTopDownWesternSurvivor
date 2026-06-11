extends Node

enum WinConditionType {
	TIME,
	KILLS,
	BOSS
}

@export var win_condition: WinConditionType

# Time
@export var required_time: float = 60.0
var elapsed_time: float = 0.0

# Kills
@export var required_kills: int = 10
var current_kills: int = 0

# Boss
var boss_killed: bool = false

func _process(delta):
	match win_condition:
		WinConditionType.TIME:
			elapsed_time += delta
			if elapsed_time >= required_time:
				level_complete()

		WinConditionType.KILLS:
			if current_kills >= required_kills:
				level_complete()

		WinConditionType.BOSS:
			if boss_killed:
				level_complete()

func register_kill():
	current_kills += 1

func register_boss_kill():
	boss_killed = true

func level_complete():
	print("Level Complete")
