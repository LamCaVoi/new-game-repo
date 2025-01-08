extends Control 

const CHAPTER_1 = "res://Chapters/Chapter 1/chapter_1.tscn"


@onready var vbcontainer = $VBoxContainer
@onready var option_menu = $Setting
@onready var chapter_menu = $"Select Chapter"
@onready var resume_button: Button = $"VBoxContainer/Resume button"

func _ready() -> void:
	if (not FileAccess.file_exists(Global.DATA_FILE)):
		resume_button.visible = false

func _on_new_game_button_pressed() -> void:
	Global.curr_spawn_point = Vector2.ZERO
	DirAccess.remove_absolute(Global.DATA_FILE)
	get_tree().change_scene_to_file(CHAPTER_1)

func _on_exit_button_4_pressed() -> void:
	get_tree().quit() 

func _on_option_button_3_pressed() -> void:
	vbcontainer.hide()
	option_menu.set_process(true)
	option_menu.show()

func _on_setting_close_option_menu() -> void:
	option_menu.hide()
	vbcontainer.show()

func _on_select_chapter_pressed() -> void:
	Global.curr_spawn_point = Vector2.ZERO
	DirAccess.remove_absolute(Global.DATA_FILE)
	vbcontainer.hide()
	chapter_menu.set_process(true)
	chapter_menu.show()

func _on_select_chapter_back_option_menu() -> void:
	chapter_menu.hide()
	vbcontainer.show()


func _on_resume_button_pressed() -> void:
	if (not FileAccess.file_exists(Global.DATA_FILE)):
		resume_button.visible = false
		return
	get_tree().change_scene_to_packed(ResourceLoader.load(Global.DATA_FILE))
