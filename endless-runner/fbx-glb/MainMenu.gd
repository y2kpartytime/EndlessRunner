extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ship: CollisionShape3D = $CollisionShape3D
var speed = 1.5
var xs = .25

func _ready() -> void:
	pass

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Main_Scene.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://OptionsMenu.tscn")

func _on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://MainMenu.tscn")

func _process(delta: float) -> void:
	ship.rotate_y(speed*delta)
	ship.rotate_x(xs * delta)
	ship.rotate_z(xs * delta)
	ship.rotate_z(-xs*delta)
