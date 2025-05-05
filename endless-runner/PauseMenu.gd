extends Node
@onready var pause: Control = $"."
@onready var player: PlayerScript = $"../Player"
@onready var label: Label = $"../ScoreUI/Label"

func _ready() -> void:
	pass

func _on_resume_pressed() -> void:
	Engine.time_scale = 1
	pause.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	var bus_idx = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(bus_idx, false)
	player.count_score = true




func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Main_Scene.tscn")
	Engine.time_scale = 1
	pause.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	var bus_idx = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(bus_idx, false)
	player.count_score = true
	Global.current_score = 0
