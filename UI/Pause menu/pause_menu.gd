extends Control

@export var main_menu : PackedScene

@onready var vbcontainer = $PanelContainer/VBoxContainer
@onready var option_menu = $PanelContainer/Setting

func resume():
	get_tree().paused = false
	hide()
	
func pause():
	get_tree().paused = true
	show()

func _on_resume_pressed():
	resume()

func _on_exit_pressed():
	resume()
	get_tree().change_scene_to_packed(main_menu)
	
func _on_option_pressed() -> void:	
	vbcontainer.hide()
	option_menu.set_process(true)
	pause()
	option_menu.show()
	
func _on_setting_close_option_menu() -> void:
	option_menu.hide()
	vbcontainer.show()
	
func _process(delta):
	if Input.is_action_just_pressed("pause") and !get_tree().paused:
		pause()
		option_menu.hide()
		vbcontainer.show()
	elif Input.is_action_just_pressed("pause") and get_tree().paused:
		resume()
