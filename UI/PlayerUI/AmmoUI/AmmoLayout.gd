# AmmoLayout.gd
class_name AmmoLayout
extends Resource

@export var icon_scene: PackedScene                       # Which icon shape to use
@export var grid_columns: int = 1                         # How many columns in the grid
@export var icon_size: Vector2 = Vector2(16, 16)          # Size of icons (X, Y)
@export var icon_separation: Vector2 = Vector2(2, 2)      # Separation between icons (X, Y)
@export var active_color: Color = Color(1, 1, 0.5)      # Golden yellow
@export var empty_color: Color = Color(0.2, 0.2, 0.2)   # Dark grey
