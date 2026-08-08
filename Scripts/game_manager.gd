extends Node

var score = 0
@onready var score_label: Label = $"../CanvasLayer/ScoreLabel"

func update_score():
	score += 1
	score_label.text = "Score: " + str(score)
