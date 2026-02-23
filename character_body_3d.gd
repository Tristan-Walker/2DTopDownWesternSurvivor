extends CharacterBody3D

const SPEED = 5.0

func _physics_process(delta: float) -> void:
	
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	var direction := Vector3(input_dir.x, 0, input_dir.y)
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	if input_dir.x != 0:
		$Sprite3D.flip_h = input_dir.x < 0
	
	move_and_slide()
