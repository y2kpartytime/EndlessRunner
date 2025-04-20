class_name WorldScript
extends Node

@onready var player: PlayerScript = $Player
@onready var pause_menu: Control = $Pause
var paused := false

func _process(_delta: float) -> void:
	if !player.dead and Input.is_action_just_pressed("Pause"):
		pauseMenu()

func pauseMenu():
	if player.dead:
		return
	paused = !paused
	if paused:
		pause_menu.show()
		Engine.time_scale = 0
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	else:
		pause_menu.hide()
		Engine.time_scale = 1
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
	player.count_score = not paused and not player.dead
