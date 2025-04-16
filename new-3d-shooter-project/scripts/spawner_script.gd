extends Node3D

@export var obstacle_scene: PackedScene
@export var ramp_scene: PackedScene
@export var boost_scene: PackedScene
@export var shield: PackedScene
@export var obstacle_scene2: PackedScene

@export var player: CharacterBody3D
@export var spawn_distance = 20.0
@export var spawn_interval = 2.0
@export var boost_spawn_interval = 8.0
@export var spawn_interval_pillar2 = 1.0

@export var shield_spawn = 5.0

var timer: Timer
var boost_timer: Timer
var shield_timer: Timer
var pillar2timer: Timer

var obstacles = []
var despawn_distance = -8.0

func _ready():
#pillar spawner
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_spawn_obstacle)
	timer.start(spawn_interval)
#pillar2
	pillar2timer = Timer.new()
	add_child(pillar2timer)
	pillar2timer.timeout.connect(_spawn_obstacle_2)
	pillar2timer.start(spawn_interval_pillar2)
#boost spawners
	boost_timer = Timer.new()
	add_child(boost_timer)
	boost_timer.timeout.connect(_spawn_boost)
	boost_timer.start(boost_spawn_interval)
#shield spawner
	shield_timer = Timer.new()
	add_child(shield_timer)
	shield_timer.timeout.connect(_spawn_shield)
	shield_timer.start(shield_spawn)

func _process(delta):
	if player:
		global_position = Vector3(global_position.x, player.position.y + 3, player.position.z + spawn_distance)

	for i in range(obstacles.size() - 1, -1, -1):
		var obstacle = obstacles[i]
		if obstacle and player:
			if obstacle.global_position.z < player.global_position.z + despawn_distance:
				obstacle.queue_free()
				obstacles.remove_at(i)


func _spawn_obstacle():
	if !obstacle_scene or !player:
		return
	var obstacle = obstacle_scene.instantiate()
	get_parent().add_child(obstacle)
	obstacle.global_position = Vector3(global_position.x + randf_range(-18.0, 18.0), global_position.y, global_position.z)
	obstacle.global_rotation = Vector3(global_rotation.x, global_rotation.y + randf_range(0, 360.0), global_rotation.z)
	obstacles.append(obstacle)

func _spawn_boost():
	if !boost_scene or !player:
		return
	var booster = boost_scene.instantiate()
	get_parent().add_child(booster)
	booster.global_position = Vector3(global_position.x + randf_range(-18.0, 18.0), global_position.y - 3, global_position.z)

func _spawn_shield():
	if !shield or !player:
		return
	var shield = shield.instantiate()
	get_parent().add_child(shield)
	shield.global_position = Vector3(global_position.x + randf_range(-18.0, 18.0), global_position.y + 1, global_position.z)

func _spawn_obstacle_2():
	if !obstacle_scene or !player:
		return
	var obstacle2 = obstacle_scene2.instantiate()
	get_parent().add_child(obstacle2)
	obstacle2.global_position = Vector3(global_position.x, global_position.y, global_position.z)
