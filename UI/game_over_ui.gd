extends CanvasLayer



func _ready() -> void:
	SignalBus.player_died.connect(_on_player_health_depleted)
	self.hide()                          # Ensure it's hidden at start

func _on_player_health_depleted() -> void:
	PlayerManager.is_game_over = true    # Tells PlayerManager that player is dead
	self.show()                          # Show game over screen
	get_tree().paused = true             # Pause game
