extends Node3D

# Base values
var velocity: Vector3 = Vector3.ZERO
var is_active: bool = false
var damage: float = 1

# Bullet lifetime values (How long bullet exists):
var lifetime: float = 0        # Current lifetime of a bullet
var max_lifetime: float = 0.5    # Maximum life until timeout

func _ready():
	hide() # Start invisible
	set_process(false) # Start "sleeping"

# Set parameters & turn on bullet
func fire(start_pos: Vector3, direction: Vector3, bullet_speed: int, bullet_damage: int):
	damage = bullet_damage
	global_position = start_pos
	velocity = direction * bullet_speed
	lifetime = 0
	activate()

# How the bullet functions while active
func _process(_delta):
	global_position += velocity * _delta
	lifetime += _delta
	if lifetime >= max_lifetime:
		deactivate()

# Turn on bullet
func activate():
	is_active = true
	set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
	set_process(true)
	show()

# Turn off bullet
func deactivate():
	is_active = false
	set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	set_process(false)
	hide()

# Disappear on-hit & Check for damage
func _on_body_entered(body: Node3D) -> void:
	deactivate()
	if body.has_method("take_damage"):
		body.take_damage(damage)
