extends Node3D

@onready var back_bar: ProgressBar = $SubViewport/MarginContainer/VBoxContainer/HealthControl/BackBar
@onready var front_bar: ProgressBar = $SubViewport/MarginContainer/VBoxContainer/HealthControl/FrontBar
@onready var reload_bar: TextureProgressBar = $SubViewport/MarginContainer/VBoxContainer2/ReloadControl/ReloadBar

func _ready():
	SignalBus.player_health_changed.connect(update_health)
	front_bar.value = 100
	back_bar.value = 100
	
	SignalBus.reload_started.connect(_on_reload_started)
	reload_bar.hide()

func update_health(new_health: int):
	var f_tween = get_tree().create_tween()
	f_tween.tween_property(front_bar, "value", new_health, 0.1).set_trans(Tween.TRANS_SINE)
	
	var b_tween = get_tree().create_tween()
	b_tween.tween_property(back_bar, "value", new_health, 0.6).set_trans(Tween.TRANS_SINE)

func _on_reload_started(duration: float):
	reload_bar.show()
	reload_bar.value = 0
	
	var tween = create_tween()
	tween.tween_property(reload_bar, "value", 100, duration)
	tween.finished.connect(func(): reload_bar.hide())
