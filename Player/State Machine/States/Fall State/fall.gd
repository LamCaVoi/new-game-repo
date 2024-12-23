extends Player_State

var coyote_timer: float = 0
var buffer_jump_timer: float = 0

func handle_input(_event: InputEvent) -> void:
	if movement_input.released_jump() and parent.velocity.y < -100:
		parent.velocity.y *= movement_data.short_jump_cut
	elif movement_input.wants_climb():
		wall_dir = movement.find_wall(1)
		if wall_dir:
			finished.emit("Climb")
	elif movement_input.wants_jump():
		wall_dir = movement.find_wall()
		if wall_dir != 0:
			finished.emit("Wall Jump")
		elif not is_colliding_y == 1:
			if coyote_timer >= 0:
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

func physics_update(delta: float) -> void:
	timer_update(delta)
	var direction = movement_input.get_horizontal_input_pressed()
	run(direction)
	apply_gravity(delta, 0.8 if abs(parent.velocity.y) < movement_data.hang_threshold else 1.0)
	parent.velocity.x = lerp(parent.velocity.x, direction * movement_data.max_air_x_speed, 1 - (1 - movement_data.velocity_x_lerp_speed) * delta)
	movement.move_x(parent.velocity.x * delta, true)
	movement.move_y(parent.velocity.y *delta,parent.velocity.y < 0)
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
	elif (parent.velocity.y > -100):
		if(direction != 0 and direction == is_colliding_x):
			wall_dir = direction
			finished.emit("Wall Slide")

func enter(previous_state_path: String) -> void:
	super(previous_state_path)
	if (previous_state_path != "Jump") and (previous_state_path != "Wall Jump"):
		coyote_timer = movement_data.coyote_time
	else: 
		coyote_timer = -1
