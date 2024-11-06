extends PlayerState

func handle_input(_event: InputEvent) -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	pass

func enter(previous_state_path: String, data := {}) -> void:
	player.velocity.y = player.high_jump_velocity
	finished.emit("Fall")

func exit() -> void:
	pass
