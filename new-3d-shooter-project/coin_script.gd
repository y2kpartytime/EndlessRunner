extends Node

@export var player = CharacterBody3D
var score = 0

func _ready() -> void:
	pass

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		score +=1
		queue_free()
