class_name PlayerScript extends CharacterBody3D

var default_text = "CURRENT SCORE: "
@onready var audio_player: AudioStreamPlayer3D = $AudioStreamPlayer3D
@export var engineSound: AudioEffect
@onready var audio_player2: AudioStreamPlayer3D = $AudioStreamPlayer3D2
@onready var audio_player3: AudioStreamPlayer3D = $AudioStreamPlayer3D3
@onready var audio_stream_player_4: AudioStreamPlayer3D = $AudioStreamPlayer3D4

@onready var dead_label: Label = $"../ScoreUI/DeadLabel"
@onready var score_ui: Control = $"../ScoreUI"
@onready var label: Label = $"../ScoreUI/Label"

var count_score = true

@onready var ship_effect: Node3D = $CollisionShape3D/Cube_001/shipEffect
@onready var ship_effect_2: Node3D = $CollisionShape3D/Cube_001/shipEffect2

@export var speed:float = 10
@export var side_speed:float = 6
#@export var rot_speed = 1000
#@export var can_move:bool = true
@export var gravity: float = -10.8
@export var jump_force: float = 30.0
@onready var camera: Camera3D = $Camera3D
@onready var shield_timer: Timer = $ShieldTimer

@onready var ship_effect_shield_activated: Area3D = $shipEffectShieldACTIVATED
@onready var debris: GPUParticles3D = $Effect_Explosion/GPUParticles3D
@onready var fire: GPUParticles3D = $Effect_Explosion/GPUParticles3D2
@onready var smoke: GPUParticles3D = $Effect_Explosion/GPUParticles3D3

var shielded = false
var paused = false

var normal_camera_height := 9.643
var boost_camera_height := 10.0
var controlling = true
var relative:Vector2 = Vector2.ZERO

@onready var ship_model = $CollisionShape3D
var tilt_amount = 0.0
@export var max_tilt_angle: float = 10.0
@export var tilt_speed: float = 3.0
@export var tilt_return_speed: float = 2.0
var current_tilt: float = 0.0
var target_tilt = 0.0

@export var normal_fov := 60.0
@export var boost_fov := 80.0
@export var fov_change_speed := 1.0

var boosting = false
var boostpad = false
var boost_meter: float
var boost_timer = 3
var boost_force = 500.0
var mult = 1
var side_mult = .2

@export var jump_tilt_angle: float = -20.0
var current_pitch: float = 0.0
var dead = false


func _input(event):
	if event is InputEventMouseMotion and controlling:
		relative = event.relative
	if event.is_action_pressed("ui_cancel"):
		if controlling:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:            
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		controlling = ! controlling

func _ready():
	var score = 0
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera = $Camera3D
	camera.position.y = normal_camera_height
	if !dead:
		audio_player.play()
	if boostpad == true:
		audio_stream_player_4.play()


func _physics_process(delta: float) -> void:
	relative = Vector2.ZERO
	velocity.y += gravity * delta
	var target_height = boost_camera_height if boostpad else normal_camera_height
	camera.position.y = move_toward(camera.position.y, target_height, delta * 2.0)
	var target_fov = boost_fov if boostpad else normal_fov
	var current_fov_speed = fov_change_speed * (1.0 if boostpad else 1.0)
	camera.fov = lerp(camera.fov, target_fov, current_fov_speed * delta)
	
	if boostpad:
		boost_timer -= delta
		if boost_timer <= 0:
			boostpad = false
		else:
			velocity -= transform.basis.z * side_speed * boost_force * delta

	var _v = Vector3.ZERO
	var mult = 2
	var side_mult = 1.1
	var turn = Input.get_axis("Left", "Right")   
	var effective_speed = tilt_speed
	if abs(turn) > 0.1:   
		global_translate(global_transform.basis.x * side_speed * turn * delta)
		tilt_amount = turn * max_tilt_angle
	else:
		tilt_amount = 0.0
		effective_speed = tilt_return_speed
	current_tilt = lerp(current_tilt, tilt_amount, tilt_speed * delta)
	ship_model.rotation.z = deg_to_rad(current_tilt)
	ship_model.rotation.x = deg_to_rad(current_pitch)
	move_and_slide()

	if dead == false:
		velocity.z = speed * mult
	else:
		velocity.z = 0

	if Input.is_action_pressed("Pause") and dead == true:
		get_tree().change_scene_to_file("res://scenes/Main_Scene.tscn")
		Engine.time_scale = 1
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		var bus_idx = AudioServer.get_bus_index("Master")
		AudioServer.set_bus_mute(bus_idx, false)
		count_score = true
		Global.current_score = 0


func apply_boost(force: float, duration: float):
	boostpad = true
	boost_timer = duration
	boost_force = force
	audio_stream_player_4.play()

func shield_activate():
	var shieldDuration = 4.0
	ship_effect_shield_activated.visible = true
	shield_timer.start(shieldDuration)
	shielded = true
	audio_player3.play()

func _on_shield_timer_timeout() -> void:
	ship_effect_shield_activated.visible = false
	shielded = false



func explode():
	if shielded == true:
		pass
	else:
		dead = true
		speed = 0
		side_speed = 0
		tilt_amount = 0
		tilt_speed = 0
		#Show Loss Screen and points
		debris.emitting = true
		fire.emitting = true
		smoke.emitting = true
		ship_model.visible = false
		ship_effect_shield_activated.visible = false
		ship_effect.visible = false
		ship_effect_2.visible = false
		audio_player2.play()
		dead_label.show()
		audio_player.stop()
		count_score = false
		$AudioStreamPlayer3D5.stop()
