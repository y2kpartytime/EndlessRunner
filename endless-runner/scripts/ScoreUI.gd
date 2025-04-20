extends Control

@onready var label: Label = $Label
var default_text = "CURRENT SCORE: "
@onready var player: PlayerScript = $"../Player"

func _process(_delta: float) -> void:
	label.text = str(default_text, str(Global.current_score))
	if player.count_score:
		Global.current_score +=1
	else:
		Global.current_score = Global.current_score
