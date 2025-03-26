extends Node

@export var player = CharacterBody3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		Global.current_score += 1
		queue_free()

func _ready() -> void:
	animation_player.play("CoinSpin")
