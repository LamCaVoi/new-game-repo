extends Player_State

var coyote_timer: float = 0
var buffer_jump_timer: float = 0
var direction_block_timer: float = -1
var prev_direction :float= 0

func handle_input(_event: InputEvent) -> void:
	if movement_input.released_jump() and parent.velocity.y < -100:
		parent.velocity.y *= movement_data.short_jump_cut
	elif movement_input.wants_jump():
		wall_direction = movement.find_wall()
		if wall_direction:
			finished.emit("Wall Jump")
		elif coyote_timer >= 0:
			finished.emit("Jump")
		else:
			buffer_jump_timer = movement_data.buffer_jump_time
	elif movement_input.wants_dash() and can_dash:
		can_dash = false
		finished.emit("Dash")

func timer_update(delta):
	if coyote_timer > 0:
		coyote_timer -= delta
	if buffer_jump_timer > 0:
		buffer_jump_timer -= delta
	if(direction_block_timer > 0):
		direction_block_timer -=delta

func physics_update(delta: float) -> void:
	timer_update(delta)
	var direction :float= movement_input.get_horizontal_input_pressed()
	run(direction)
	if(direction_block_timer > 0):
		direction = prev_direction
	else:
		extra_x_speed = 0
	parent.velocity.x = lerp(parent.velocity.x, direction * (movement_data.max_x_speed + abs(extra_x_speed)), 1 - exp(-movement_data.velocity_x_lerp_speed * delta))
	apply_gravity(delta, 0.8 if abs(parent.velocity.y) < movement_data.hang_threshold else 1.0)
	movement.move_x(parent.velocity.x * delta, true)
	movement.move_y(parent.velocity.y * delta,parent.velocity.y < 0)
	if is_colliding_y == -1:
		is_colliding_y = 0
		parent.velocity.y = 0
	switch_state(direction)

func switch_state(direction):
	if is_colliding_y == 1:
		can_dash = true
		if buffer_jump_timer > 0:
			buffer_jump_timer = -1
			finished.emit("Jump")
		elif is_equal_approx(direction, 0.0):
			finished.emit("Idle")
		else:
			finished.emit("Run")
	elif movement_input.wants_climb():
		wall_direction = movement.find_wall(2)
		if wall_direction and parent.velocity.y > -150:
			finished.emit("Climb")
	elif (parent.velocity.y > -100):
		wall_direction = movement.find_wall(2,1.0)
		if(wall_direction and wall_direction == direction):
			finished.emit("Wall Slide")

func exit():
	direction_block_time = -1
	extra_x_speed = 0
	momentum = Vector2.ZERO

func enter(previous_state_path: String) -> void:
	animated_sprite.play("jump")
	if(direction_block_time > 0):
		direction_block_timer = direction_block_time
		prev_direction = sign(parent.velocity.x)
	if (previous_state_path == "Idle") or (previous_state_path == "Run"):
		coyote_timer = movement_data.coyote_time
	else: 
		coyote_timer = -1
