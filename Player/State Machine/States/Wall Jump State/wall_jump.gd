extends Player_State
var input_block_time: float = 0.2
var buffer_jump_timer: float = -1
var initil_x_velocity: float = 100
#Cut the jump velocity in wall jump state plus buffing the lateral movement in this state
var jump_cut: float = 0.8
var input_block_timer: float
var wall_jump_gravity: float
var jump_dir: float


func handle_input(_event: InputEvent) -> void:
	if movement_input.wants_jump():
		wall_dir = movement.find_wall(3)
		if(wall_dir):
			finished.emit("Wall Jump")
		else:
			buffer_jump_timer = movement_data.buffer_jump_time
	elif movement_input.wants_climb():
		wall_dir = movement.find_wall(1)
		if(wall_dir):
			finished.emit("Climb")
	elif movement_input.wants_dash() and can_dash:
		finished.emit("Dash")
		
func timer_update(delta):
	if(input_block_timer > 0):
		input_block_timer -=delta
	if(buffer_jump_timer > 0):
		buffer_jump_timer -= delta
		
func apply_wall_jump_speed(dir: int, delta: float):
	apply_gravity(delta)
	parent.velocity.x = lerp(parent.velocity.x, dir * (movement_data.max_air_x_speed + (20 * int(parent.velocity.y < 0))), 1 - (1 - movement_data.velocity_x_lerp_speed) * delta)

func physics_update(delta: float) -> void:
	timer_update(delta)
	var dir = movement_input.get_horizontal_input_pressed()
	if(input_block_timer > 0):
		dir = jump_dir
	run(dir)
	apply_wall_jump_speed(dir,delta)
	movement.move_x(parent.velocity.x * delta, true)
	movement.move_y(parent.velocity.y * delta, parent.velocity.y < 0)
	if (is_colliding_y == -1):
		is_colliding_y = 0
		parent.velocity.y = 0
	switch_case(dir)

func switch_case(dir):
	if (is_colliding_y == 1):
		if buffer_jump_timer > 0:
			buffer_jump_timer = -1 
			finished.emit("Jump")
		elif dir != 0:
			finished.emit("Run")
		else:
			finished.emit("Idle")
	else:
		wall_dir = movement.find_wall(1)
		if(wall_dir and wall_dir == dir):
			finished.emit("Wall Slide")

func enter(_previous_state_path: String) -> void:
	jump_dir = wall_dir * -1
	parent.velocity.x = 30 * jump_dir
	parent.velocity.y = movement_data.high_jump_velocity * 0.8
	input_block_timer = input_block_time
