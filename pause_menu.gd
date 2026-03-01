extends CanvasLayer

@onready var menu_screen = $InGameUI/PauseMenu

func _ready():
	menu_screen.visible = false

func _input(event):
	if event.is_action_pressed("pause"):
		toggle_visibility()

func toggle_visibility():
	menu_screen.visible = !menu_screen.visible
	get_tree().paused = menu_screen.visible
