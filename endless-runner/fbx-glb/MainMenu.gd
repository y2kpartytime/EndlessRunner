extends Control

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Main_Scene.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://OptionsMenu.tscn")


func _on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://MainMenu.tscn")
