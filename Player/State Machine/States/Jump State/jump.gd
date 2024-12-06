extends Player_State

func enter(previous_state_path: String) -> void:
	parent.velocity.y = movement_data.high_jump_velocity
	finished.emit("Fall")
