extends Player_State

var wall_jump_gravity:float
var input_block_timer: float
var jump_dir: float

func physics_update(delta: float) -> void:
	input_block_timer -=delta
	if(input_block_timer < 0):
		finished.emit("Fall")
		return
	var dir = movement_input.get_horizontal_input_pressed()
	run(dir)
	if(dir != jump_dir):
		parent.velocity.y += wall_jump_gravity * delta
		parent.velocity.x = 75
	else:
		apply_gravity(delta)
		parent.velocity.x = lerp(parent.velocity.x, dir * movement_data.max_air_x_speed, movement_data.velocity_x_lerp_speed)
	
	movement.move_x(parent.velocity.x * delta, true)
	movement.move_y(parent.velocity.y * delta, true)
	if (is_colliding_y == -1):
		parent.velocity.y = 0
	switch_case(dir)

func switch_case(dir):
	if (is_colliding_y == 1):
		if dir != 0:
			finished.emit("Run")
		else:
			finished.emit("Idle")
	elif movement_input.wants_jump():
		wall_dir = movement.find_wall()
		if(wall_dir):
			finished.emit("Wall Jump")
	elif movement_input.wants_climb():
		wall_dir = movement.find_wall()
		if(wall_dir):
			finished.emit("Climb")

func enter(previous_state_path: String, data := {}) -> void:
	wall_jump_gravity = movement_data.jump_gravity * 1.5
	jump_dir = wall_dir * -1
	parent.velocity.x = movement_data.max_air_x_speed * jump_dir
	parent.velocity.y = movement_data.high_jump_velocity
	input_block_timer = 0.2
