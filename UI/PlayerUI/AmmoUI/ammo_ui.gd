extends CanvasLayer

@onready var ammo_label = $MarginContainer/HBoxContainer/Label
@onready var bullet_grid = $MarginContainer/HBoxContainer/GridContainer

var bullet_icons = []
var current_layout: AmmoLayout

func _ready():
	SignalBus.ammo_updated.connect(_on_ammo_updated)
	SignalBus.ammo_setup.connect(_setup_icons)

# Sets up initial ammo icons
func _setup_icons(max_ammo: int, layout: AmmoLayout):
	current_layout = layout   # Save current layout to be used outside this function
	
	# Clear stale icon references FIRST
	bullet_icons.clear()
	
	# Clear any existing ammo portraits
	for child in bullet_grid.get_children():
		child.queue_free()
	
	
	# Use settings of the new layout
	bullet_grid.columns = layout.grid_columns     # Use new layouts number of columns
	var icon_size = layout.icon_size              # Use new layouts icon sizes
	bullet_grid.add_theme_constant_override("h_separation", int(layout.icon_separation.x))
	bullet_grid.add_theme_constant_override("v_separation", int(layout.icon_separation.y))
	
	# Create new ammo portraits
	for i in range(max_ammo):
		var icon = layout.icon_scene.instantiate()
		if icon is Control:
			icon.custom_minimum_size = icon_size
		bullet_grid.add_child(icon)
		bullet_icons.append(icon)

func _on_ammo_updated(current_ammo: int):
	ammo_label.text = str(current_ammo)
	
	for i in range(bullet_icons.size()):
		var icon = bullet_icons[i]
		
		if not is_instance_valid(icon):   # Don't use icons previously freed
			continue
		
		if i < current_ammo:
			_animate_icon(icon, 1.0) # Change alpha to 100%
			icon.modulate = current_layout.active_color
		else:
			_animate_icon(icon, 0.2) # Change alpha to 20%
			icon.modulate = current_layout.empty_color

func _animate_icon(icon: Control, target_alpha: float):
	var tween = create_tween()
	tween.tween_property(icon, "modulate:a", target_alpha, 0.2).set_trans(Tween.TRANS_SINE)
