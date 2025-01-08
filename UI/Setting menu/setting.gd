extends Control

@onready var close_button = $PanelContainer/MarginContainer/VBoxContainer/Close

signal close_option_menu

func  _ready():
	close_button.button_down.connect(_on_close_pressed)
	set_process(false)

func _on_volumn_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)

func _on_mute_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_volume_db(0, toggled_on)
	
func _on_resolution_item_selected(index: int) -> void:
	var window_size: Vector2i
	match index:
		0:
			window_size = Vector2i(320,180)
		1:
			window_size = Vector2i(960,540)
		2:
			window_size = Vector2i(1280,720)
		3:
			window_size = Vector2i(1920,1080)
	var screen_size : Vector2i = DisplayServer.screen_get_size()
	var window :Window= get_window()
	window.size = window_size
	window.position = Vector2i((screen_size - window_size) * 0.5)

func _on_close_pressed() -> void:
	close_option_menu.emit()
	set_process(false)
