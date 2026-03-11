extends CanvasLayer

@onready var ammo_label = $MarginContainer/HBoxContainer/Label
@onready var bullet_grid = $MarginContainer/HBoxContainer/GridContainer

var bullet_icons = []

func _ready():
	SignalBus.ammo_updated.connect(_on_ammo_updated)
	SignalBus.ammo_setup.connect(_setup_icons)

# Sets up initial ammo icons
func _setup_icons(max_ammo):
	# Clear any existing ammo portraits
	for child in bullet_grid.get_children():
		child.queue_free()
	
	# Create new ammo portraits
	var icon_scene = load("res://UI/PlayerUI/AmmoUI/AmmoIcon_Default.tscn")
	for i in range(max_ammo):
		var icon = icon_scene.instantiate()
		bullet_grid.add_child(icon)
		bullet_icons.append(icon)

func _on_ammo_updated(current_ammo):
	ammo_label.text = str(current_ammo)
	
	for i in range(bullet_icons.size()):
		var icon = bullet_icons[i]
		
		if i < current_ammo:
			_animate_icon(icon, 1.0) # Change alpha to 100%
			icon.modulate = Color(1, 1, 0.5) # Golden yellow
		else:
			_animate_icon(icon, 0.2) # Change alpha to 20%
			icon.modulate = Color(0.2, 0.2, 0.2) # Dark empty grey

func _animate_icon(icon: Control, target_alpha: float):
	var tween = create_tween()
	tween.tween_property(icon, "modulate:a", target_alpha, 0.2).set_trans(Tween.TRANS_SINE)
