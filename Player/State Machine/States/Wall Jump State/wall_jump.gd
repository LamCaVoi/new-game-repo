extends Player_State

var wall_jump_gravity:float
var input_block_timer: float
var jump_dir: float
var max_air_speed: float

func handle_input(event: InputEvent) -> void:
	if movement_input.wants_jump():
		wall_dir = movement.find_wall(4)
		if(wall_dir):
			finished.emit("Wall Jump")
	elif movement_input.wants_climb():
		wall_dir = movement.find_wall(1)
		if(wall_dir):
			finished.emit("Climb")
	elif movement_input.wants_dash() and can_dash:
		finished.emit("Dash")

func physics_update(delta: float) -> void:
	print(parent.velocity)
	input_block_timer -=delta
	var dir = movement_input.get_horizontal_input_pressed()
	if(input_block_timer > 0):
		dir = jump_dir
	run(dir)
	if(dir == jump_dir):
		apply_gravity(delta)
		if(input_block_timer > 0):
			parent.velocity.x = lerp(parent.velocity.x, dir * max_air_speed, movement_data.velocity_x_lerp_speed)
		else:
			parent.velocity.x = lerp(parent.velocity.x, dir * (max_air_speed + 20), movement_data.velocity_x_lerp_speed)
	else:
		parent.velocity.y = clamp(parent.velocity.y + wall_jump_gravity * delta,0,movement_data.max_y_speed)
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
	else:
		wall_dir = movement.find_wall(1)
		if(wall_dir and wall_dir == dir):
			finished.emit("Wall Slide")

func enter(previous_state_path: String, data := {}) -> void:
	wall_jump_gravity = movement_data.jump_gravity * 1.5
	jump_dir = wall_dir * -1
	max_air_speed = movement_data.max_air_x_speed * 1.3
	parent.velocity.x = 100 * jump_dir
	parent.velocity.y = movement_data.high_jump_velocity * 0.8
	input_block_timer = 0.15
