extends Player_State

func handle_input(_event: InputEvent) -> void:
	if movement_input.released_climb():
		if is_colliding_y == 1:
			finished.emit("Idle")
		else:
			finished.emit("Fall")
	elif movement_input.wants_jump():
		finished.emit("Wall Jump")

func physics_update(delta: float):
	var dir = movement_input.get_vertical_input_pressed()
	parent.velocity.y = dir * movement_data.climb_speed
	parent.velocity.x = wall_direction * movement_data.max_x_speed
	movement.move_x(parent.velocity.x * delta)
	movement.move_y(parent.velocity.y * delta)
	switch_case(dir)

func switch_case(dir: float):
	if is_colliding_y == 1:
		finished.emit("Idle")
	if is_colliding_x == 0:
		if dir > 0:
			finished.emit("Run")
		else:
			finished.emit("Fall")
func enter(previous_state_path: String) -> void:
	pass
