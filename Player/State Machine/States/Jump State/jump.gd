extends Player_State

func enter(previous_state_path: String) -> void:
	parent.velocity.y = movement_data.high_jump_velocity
	var direction : float= movement_input.get_horizontal_input_pressed()
	if (direction != 0):
		parent.velocity.x += 40
	if (momentum != Vector2.ZERO):
		parent.velocity += momentum
		direction_block_time = 0.2
		extra_x_speed = momentum.x
		momentum = Vector2.ZERO
	else:
		direction_block_time = -1
	finished.emit("Fall")
