extends Node3D

func _on_player_health_depleted() -> void:
	%GameOverScreen.visible = true
	get_tree().paused = true
