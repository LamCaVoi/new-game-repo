extends Node
@onready var label_5: Label = $Label5

var score = 0

func add_score():
	score += 1
	label_5.text = "You've collected " + str(score) + " coins!!!"
	
