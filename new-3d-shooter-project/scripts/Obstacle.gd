extends CharacterBody3D

func _process(delta: float) -> void:
	velocity.z -= 50 * delta
	move_and_slide()
