extends State

func enter(previous_state_path: String, data := {}) -> void:
	parent.velocity.y = movement_data.high_jump_velocity
	finished.emit("Fall")
