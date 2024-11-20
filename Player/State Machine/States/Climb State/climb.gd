extends State

func enter(previous_state_path: String, data := {}) -> void:
	parent.is_climbing = true
