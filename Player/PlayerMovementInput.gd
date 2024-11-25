class_name PlayerMovementInput
extends Node

func wants_jump()-> bool:
	return Input.is_action_just_pressed("jump")
func wants_climb()-> bool:
	return Input.is_action_just_pressed("climb")
func released_jump()-> bool:
	return Input.is_action_just_released("jump")

func released_climb()-> bool:
	return Input.is_action_just_released("climb")
	
func wants_dash()-> bool:
	return Input.is_action_just_pressed("dash")

func get_horizontal_input_pressed() -> float:
	return Input.get_axis("move_left","move_right")

func get_vertical_input_pressed() -> float:
	return Input.get_axis("move_up", "move_down")

func get_horizontal_input_released(dir : int) -> bool:
	if (dir < 0):
		return Input.is_action_just_released("move_left")
	elif (dir > 0):
		return Input.is_action_just_released("move_right")
	return false

func get_8_directional_input() -> Vector2:
	return Input.get_vector("move_left","move_right","move_up","move_down")
