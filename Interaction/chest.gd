extends StaticBody3D

@onready var interaction_area: InteractionArea = $InteractionArea

func _ready():
	interaction_area.interact = Callable(self, "on_interact")
	
func on_interact():
	print("chest opened")
