extends Player_State
var direction_block_time: float = 0.15
var buffer_jump_timer: float = -1
var initil_x_velocity: float = 100
#Cut the jump velocity in wall jump state plus buffing the lateral movement in this state
var jump_cut: float = 0.8
var direction_block_timer: float
var wall_jump_gravity: float
var jump_direction: float


func handle_input(_event: InputEvent) -> void:
	if movement_input.wants_dash() and can_dash:
		finished.emit("Dash")
		
func timer_update(delta):
	if(direction_block_timer > 0):
		direction_block_timer -=delta
	if(buffer_jump_timer > 0):
		buffer_jump_timer -= delta
		
func apply_wall_jump_speed(direction: int, delta: float):
	apply_gravity(delta)
	parent.velocity.x = lerp(parent.velocity.x, direction * (movement_data.max_air_x_speed + 30), 1 - exp(-movement_data.velocity_x_lerp_speed * delta))

func physics_update(delta: float) -> void:
	timer_update(delta)
	var direction = movement_input.get_horizontal_input_pressed()
	run(direction)
	if(direction_block_timer > 0):
		direction = jump_direction
	apply_wall_jump_speed(direction,delta)
	movement.move_x(parent.velocity.x * delta, true)
	movement.move_y(parent.velocity.y * delta, parent.velocity.y < 0)
	if (is_colliding_y == -1):
		is_colliding_y = 0
		parent.velocity.y = 0
	switch_case(direction)

func switch_case(direction):
	if (is_colliding_y == 1):
		if buffer_jump_timer > 0:
			buffer_jump_timer = -1 
			finished.emit("Jump")
		elif direction != 0:
			finished.emit("Run")
		else:
			finished.emit("Idle")
	elif movement_input.wants_climb():
		wall_direction = movement.find_wall(1)
		if(wall_direction):
			finished.emit("Climb")
	else:
		wall_direction = movement.find_wall(1)
		if(wall_direction and wall_direction == direction):
			finished.emit("Wall Slide")

func enter(_previous_state_path: String) -> void:
	animated_sprite.play("jump")
	jump_direction = wall_direction * -1
	parent.velocity.x = 50 * jump_direction
	parent.velocity.y = movement_data.high_jump_velocity * 0.8
	direction_block_timer = direction_block_time
