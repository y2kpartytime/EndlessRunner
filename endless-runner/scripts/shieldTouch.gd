extends Node

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		body.shield_activate()
		self.queue_free()



func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("Obstacle"):
		queue_free()
