extends MarginContainer

@export var menu_screen: VBoxContainer
@export var settings_menu_screen: MarginContainer
@export var help_menu_screen: MarginContainer
@export var bestiary_menu_screen: MarginContainer


func _ready():
	menu_screen.visible = false
	help_menu_screen.visible = false
	settings_menu_screen.visible = false
	bestiary_menu_screen.visible = false

func _input(event):
	if event.is_action_pressed("pause"):
		handle_pause_pressed()

func handle_pause_pressed():
# If help menu open: close it
	if help_menu_screen.visible:
		help_menu_screen.visible = false
		menu_screen.visible = true
		return
# If settings open: close it
	if settings_menu_screen.visible:
		settings_menu_screen.visible = false
		menu_screen.visible = true
		return
# If bestiary open: close it
	if bestiary_menu_screen.visible:
		bestiary_menu_screen.visible = false
		menu_screen.visible = true
		return
# else toggle main pause menu
	menu_screen.visible = !menu_screen.visible
	get_tree().paused = menu_screen.visible

func toggle_visibility(object):
	object.visible = !object.visible

func _on_toggle_help_menu_button_pressed() -> void:
	toggle_visibility(help_menu_screen)
	toggle_visibility(menu_screen)

func _on_toggle_settings_menu_button_pressed() -> void:
	toggle_visibility(settings_menu_screen)
	toggle_visibility(menu_screen)

func _on_toggle_bestiary_menu_button_pressed() -> void:
	toggle_visibility(bestiary_menu_screen)
	toggle_visibility(menu_screen)
