extends CharacterBody3D

@export var score = 0
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

# Mouse settings
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
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera = $Camera3D
	camera.position.y = normal_camera_height

func _physics_process(delta: float) -> void:
	relative = Vector2.ZERO
	velocity.y += gravity * delta
	#rotate(Vector3.DOWN, deg_to_rad(relative.x * deg_to_rad(rot_speed*2) * delta)) #left/right rotation
	#rotate(transform.basis.x,deg_to_rad(- relative.y * deg_to_rad(rot_speed*2) * delta)) #Up/Down rotation
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
		#var movef = Input.get_axis("Forward", "Back")
		#if abs(movef) > 0:     
			#global_translate(global_transform.basis.z * speed * movef * mult * delta)
		#var upanddown = Input.get_axis("ui_up", "ui_down")
		#if abs(upanddown) > 0:     
			#global_translate(- global_transform.basis.y * speed * upanddown * mult * delta)
	move_and_slide()
	if dead == false:
		velocity.z = speed * mult  #//Turns into endless runner game//
	else:
		velocity.z = 0


	if is_on_floor() and Input.is_action_just_pressed("ui_select"):
		velocity.y = jump_force
		current_pitch = jump_tilt_angle
		
	if not is_on_floor():
		current_pitch = lerp(current_pitch, 0.0, tilt_return_speed * delta)
	else:
		current_pitch = 0
	if velocity.y > 0:  # Only while moving upward
		current_pitch = lerp(current_pitch, jump_tilt_angle * (velocity.y/jump_force), 5.0 * delta)

func apply_boost(force: float, duration: float):
	boostpad = true
	boost_timer = duration
	boost_force = force

func shield_activate():
	var shieldDuration = 4.0
	ship_effect_shield_activated.visible = true
	shield_timer.start(shieldDuration)
	shielded = true

func _on_shield_timer_timeout() -> void:
	ship_effect_shield_activated.visible = false
	shielded = false

func explode():
	if shielded == true:
		pass
	else:
		var dead = true
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
