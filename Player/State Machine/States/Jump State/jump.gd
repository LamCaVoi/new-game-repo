extends Player_State

func enter(previous_state_path: String) -> void:
	parent.velocity.y = movement_data.high_jump_velocity
	if (momentum != Vector2.ZERO):
		parent.velocity += momentum
	finished.emit("Fall")
