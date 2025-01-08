extends Control 

@onready var vbcontainer = $VBoxContainer
@onready var option_menu = $Setting
@onready var chapter_menu = $"Select Chapter"

func _on_new_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Chapters/Chapter 1/chapter_1.tscn")

func _on_exit_button_4_pressed() -> void:
	get_tree().quit() # Replace with function body.

func _on_option_button_3_pressed() -> void:
	vbcontainer.hide()
	option_menu.set_process(true)
	option_menu.show()

func _on_setting_close_option_menu() -> void:
	option_menu.hide()
	vbcontainer.show()

func _on_select_chapter_pressed() -> void:
	vbcontainer.hide()
	chapter_menu.set_process(true)
	chapter_menu.show()

func _on_select_chapter_back_option_menu() -> void:
	chapter_menu.hide()
	vbcontainer.show()
