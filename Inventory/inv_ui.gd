extends MarginContainer

var is_open = false

func _ready():
	toggle_visibility()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		toggle_visibility()

func toggle_visibility():
		visible = !visible
