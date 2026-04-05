extends Node3D

var velocity: Vector3 = Vector3.ZERO
var is_active: bool = false

func _ready():
	hide() # Start invisible
	set_process(false) # Start "sleeping"

func fire(start_pos: Vector3, direction: Vector3):
	global_position = start_pos
	velocity = direction * 50.0 # Speed
	is_active = true
	show()
	set_process(true)
	
	# After 2 seconds, "return" to pool automatically
	await get_tree().create_timer(2.0).timeout
	deactivate()

func _process(delta):
	global_position += velocity * delta

func deactivate():
	is_active = false
	hide()
	set_process(false)
