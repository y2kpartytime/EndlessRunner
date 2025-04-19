extends Node
@onready var pause: Control = $"."
@onready var death_timer: Timer = $"Death Timer"

func _ready() -> void:
	pass

func _on_resume_pressed() -> void:
	Engine.time_scale = 1
	pause.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_quit_pressed() -> void:
	get_tree().quit()

func
