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
	if(dir != 0):
		animated_sprite.play("climb")
	else:
		animated_sprite.play("hold")
	parent.velocity.y = dir * movement_data.climb_speed
	movement.move_x(wall_direction)
	movement.move_y(parent.velocity.y * delta)
	switch_case(dir)

func exit():
	movement.move_x(2 * wall_direction)

func switch_case(dir: float):
	if is_colliding_y == 1:
		finished.emit("Idle")
	if is_colliding_x == 0:
		finished.emit("Fall")

func enter(previous_state_path: String) -> void:
	run(wall_direction)
	animated_sprite.play("hold")
