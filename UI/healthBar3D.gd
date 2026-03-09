extends Node3D

@onready var back_bar = $SubViewport/BackBar
@onready var front_bar = $SubViewport/FrontBar

func _ready():
	SignalBus.player_health_changed.connect(update_health)
	front_bar.value = 100
	back_bar.value = 100

func update_health(new_health: int):
	var f_tween = get_tree().create_tween()
	f_tween.tween_property(front_bar, "value", new_health, 0.1).set_trans(Tween.TRANS_SINE)
	
	var b_tween = get_tree().create_tween()
	b_tween.tween_property(back_bar, "value", new_health, 0.6).set_trans(Tween.TRANS_SINE)
