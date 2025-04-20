extends Area3D

@export var boost_force := 75.0
@export var boost_duration := 2

var boost_timer: Timer

func _ready() -> void:
	pass

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		if body.has_method("apply_boost"):
			body.apply_boost(boost_force, boost_duration)

func _on_boost_timeout() -> void:
	pass


func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("Obstacle"):
		queue_free()
		
