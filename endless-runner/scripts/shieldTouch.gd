extends Node

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		body.shield_activate()
		self.queue_free()
