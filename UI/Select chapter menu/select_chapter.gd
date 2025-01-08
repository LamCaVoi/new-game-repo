extends Control

const CHAPTER_1 = "res://Chapters/Chapter 1/chapter_1.tscn"
const CHAPTER_2 = "res://Chapters/Chapter 2/chapter_2.tscn"
const CHAPTER_3 = "res://Chapters/Chapter 3/chapter_3.tscn"

@onready var back_button = $PanelContainer/VBoxContainer/Back

signal back_option_menu

func  _ready():
	back_button.button_down.connect(_on_back_pressed)
	set_process(false)

func _on_back_pressed() -> void:
	back_option_menu.emit()
	set_process(false)

func _on_c_1_pressed() -> void:
	get_tree().change_scene_to_file(CHAPTER_1)


func _on_c_2_pressed() -> void:
	get_tree().change_scene_to_file(CHAPTER_2)


func _on_c_3_pressed() -> void:
	get_tree().change_scene_to_file(CHAPTER_3)
