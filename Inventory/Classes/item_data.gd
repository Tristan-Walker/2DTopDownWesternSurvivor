extends Resource

class_name ItemData

@export var name: String = ""
@export_multiline var description: String = ""
@export var stackable: bool = false
@export var texture: Texture2D
@export var effect: String = ""

#func does nothing but child classes will inherit from this class
func use(_target) -> void:
	pass
