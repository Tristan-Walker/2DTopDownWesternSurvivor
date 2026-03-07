extends StaticBody3D

@export var item: InvItem
var player = null

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _on_interactable_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = body
		playercollect()
		await get_tree().create_timer(0.1).timeout
		self.queue_free()

func playercollect():
	player.collect(item)
