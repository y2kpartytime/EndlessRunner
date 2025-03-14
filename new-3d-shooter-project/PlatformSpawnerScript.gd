extends Node3D

@export var platform_scene: PackedScene
@export var spawn_distance: float = 20.0
@export var platform_speed: float = 10.0

func _ready() -> void:
	spawn_platform()

func spawn_platform() -> void:
	var platform = platform_scene.instantiate()
	add_child(platform)
	platform.position.z = spawn_distance

func _process(delta: float) -> void:
	for platform in get_children():
		platform.position.z -= platform_speed * delta
		if platform.position.z < -10:
			platform.queue_free()
			spawn_platform()
