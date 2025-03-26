extends Node

@onready var label: Label = $Label
var default_text = "CURRENT SCORE: "

func _process(delta: float) -> void:
	label.text = str(default_text, str(Global.current_score))
