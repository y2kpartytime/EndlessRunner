extends CharacterBody3D

@export var score = 0
@export var speed:float = 10
@export var rot_speed = 1000
@export var can_move:bool = true
@export var gravity: float = -24.8
@export var jump_force: float = 10.0

var controlling = true

var relative:Vector2 = Vector2.ZERO

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
	pass 

func _physics_process(delta: float) -> void:
	rotate(Vector3.DOWN, deg_to_rad(relative.x * deg_to_rad(rot_speed) * delta))
	rotate(transform.basis.x,deg_to_rad(- relative.y * deg_to_rad(rot_speed) * delta))
	relative = Vector2.ZERO
	velocity.y += gravity * delta
	
	if can_move:
		var v = Vector3.ZERO
		var mult = 1
		if Input.is_key_pressed(KEY_SHIFT):
			mult = 3

		var turn = Input.get_axis("Left", "Right") - v.x    
		if abs(turn) > 0:   
			position = position + global_transform.basis.x * speed * turn * mult * delta
			global_translate(global_transform.basis.x * speed * turn * mult * delta)

		var movef = Input.get_axis("Forward", "Back")
		if abs(movef) > 0:     
			global_translate(global_transform.basis.z * speed * movef * mult * delta)

		var upanddown = Input.get_axis("ui_up", "ui_down")
		if abs(upanddown) > 0:     
			global_translate(- global_transform.basis.y * speed * upanddown * mult * delta)

	move_and_slide()
	
	# velocity.z = speed //Turns into endless runner game//
	
	
	if is_on_floor() and Input.is_action_just_pressed("ui_select"):
		velocity.y = jump_force
