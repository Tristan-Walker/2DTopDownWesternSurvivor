extends CanvasLayer

func _ready() -> void:
	SignalBus.player_died.connect(_on_player_health_depleted)
	self.hide()                          # Ensure it's hidden at start

func _on_player_health_depleted() -> void:
	PlayerManager.is_game_over = true    # Tells PlayerManager that player is dead
	self.show()                          # Show game over screen
	get_tree().paused = true             # Pause game

# Restart level
func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

# Go back to Town or Main 
func _on_home_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main.tscn")

# Go to Main Menu
func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")
