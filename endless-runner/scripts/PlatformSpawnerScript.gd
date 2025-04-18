extends Node3D

@export var platform_scene: PackedScene
@export var spawn_distance: float = 20.0
@export var platform_speed: float = 0.0
@export var player: CharacterBody3D

@onready var obstacle = preload("res://terrain_blocks/terrain_0.tscn")
var obstacle_timer: Timer

func _ready() -> void:
	spawn_platform()

func spawn_platform() -> void:
	var platform = platform_scene.instantiate()
	add_child(platform)
	platform.position.z = player.position.z + spawn_distance

func _process(delta: float) -> void:
	for platform in get_children():
		if platform is Node3D:
			platform.position.z -= platform_speed * delta
			if platform.position.z < player.position.z - 125:
				spawn_platform()
				platform.queue_free()
