class_name PlayerMovementInput
extends Node

func wants_jump()-> bool:
	return Input.is_action_just_pressed("jump")
	
func released_jump()-> bool:
	return Input.is_action_just_released("jump")
	
func wants_dash()-> bool:
	return Input.is_action_just_pressed("dash")

func get_horizontal_input() -> float:
	return Input.get_axis("move_left","move_right")

func get_8_directional_input() -> Vector2:
	return Input.get_vector("move_left","move_right","move_up","move_down")
