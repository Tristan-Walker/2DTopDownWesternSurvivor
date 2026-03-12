extends Area3D
class_name InteractionArea

@export var action_name: String = "interact"

var interact: Callable

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		InteractionManager.register_area(self)

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		InteractionManager.unregister_area(self)
