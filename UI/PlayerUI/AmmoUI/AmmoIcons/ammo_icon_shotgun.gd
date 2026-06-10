extends Control

@onready var border = $Border
@onready var body = $Body
@onready var tip = $Tip

const SHELL_COLOR = Color(0.75, 0.1, 0.1)
const TIP_COLOR = Color(0.85, 0.65, 0.1)      # Gold
const BORDER_COLOR = Color(0.35, 0.35, 0.35)
const BORDER_WIDTH = 1.0

func _ready():
	_build_shell()

func _build_shell():
	var w = custom_minimum_size.x
	var h = custom_minimum_size.y
	var half_w = w / 2.0
	var half_h = h / 2.0
	var r = 2.0
	var split = -half_w + (w * 0.25)  # gold takes left 1/4, in local space

	# --- Gold tip: left 1/4, no rounding, flat rectangle ---
	tip.polygon = PackedVector2Array([
		Vector2(-half_w, -half_h),
		Vector2(split,   -half_h),
		Vector2(split,    half_h),
		Vector2(-half_w,  half_h),
	])
	tip.color = TIP_COLOR
	tip.position = Vector2(half_w, half_h)

	# --- Red body: right 3/4, rounded on the right end ---
	body.polygon = _rounded_right_rect(split, -half_h, half_w, half_h, r)
	body.color = SHELL_COLOR
	body.position = Vector2(half_w, half_h)

	# --- Border: outlines the full shell shape ---
	border.polygon = _full_shell_border(-half_w, -half_h, half_w, half_h, r)
	border.color = BORDER_COLOR
	border.position = Vector2(half_w, half_h)
	border.z_index = -1  # Draw behind body and tip

func _rounded_right_rect(x: float, y: float, hw: float, hh: float, r: float, steps: int = 5) -> PackedVector2Array:
	var pts = PackedVector2Array()
	pts.append(Vector2(x, y))
	for s in range(steps + 1):
		var angle = -PI / 2.0 + (PI / 2.0) * (float(s) / steps)
		pts.append(Vector2(hw - r, y + r) + Vector2(cos(angle), sin(angle)) * r)
	for s in range(steps + 1):
		var angle = 0.0 + (PI / 2.0) * (float(s) / steps)
		pts.append(Vector2(hw - r, hh - r) + Vector2(cos(angle), sin(angle)) * r)
	pts.append(Vector2(x, hh))
	return pts

# Full outline of the shell: flat left edge, rounded right end, 1px larger on all sides
func _full_shell_border(x: float, y: float, hw: float, hh: float, r: float, steps: int = 5) -> PackedVector2Array:
	var b = BORDER_WIDTH
	var pts = PackedVector2Array()
	# Flat left edge (expanded outward)
	pts.append(Vector2(x - b, y - b))
	# Top edge across to rounded right corner
	var tr_cx = hw - r
	var tr_cy = y + r
	for s in range(steps + 1):
		var angle = -PI / 2.0 + (PI / 2.0) * (float(s) / steps)
		pts.append(Vector2(tr_cx, tr_cy) + Vector2(cos(angle), sin(angle)) * (r + b))
	# Bottom rounded right corner
	var br_cx = hw - r
	var br_cy = hh - r
	for s in range(steps + 1):
		var angle = 0.0 + (PI / 2.0) * (float(s) / steps)
		pts.append(Vector2(br_cx, br_cy) + Vector2(cos(angle), sin(angle)) * (r + b))
	# Flat left edge bottom
	pts.append(Vector2(x - b, hh + b))
	return pts
