extends CharacterBody3D

func _process(delta: float) -> void:
	velocity.z -= 75 * delta
	move_and_slide()
