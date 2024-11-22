extends State

var coyote_timer: float = 0
var buffer_jump_timer: float = 0
var start_fall_gravity = 0
var start_jump_gravity = 0
var start_velocity = 0

func handle_input(_event: InputEvent) -> void:
	if movement_input.released_jump() and parent.velocity.y < -100:
		parent.velocity.y *= movement_data.short_jump_cut

	elif movement_input.wants_jump():
		if movement_data.is_near_wall:
			finished.emit("WallJump")
		elif not movement_data.is_colliding_bottom:
			if coyote_timer >= 0:
				finished.emit("Jump")
			else:
				buffer_jump_timer = movement_data.buffer_jump_time
	elif movement_input.wants_dash() and movement_data.can_dash:
		movement_data.can_dash = false
		finished.emit("Dash")

func timer_update(delta):
	if coyote_timer > 0:
		coyote_timer -= delta
	if buffer_jump_timer > 0:
		buffer_jump_timer -= delta

func physics_update(delta: float) -> void:
	timer_update(delta)
	var direction = movement_input.get_horizontal_input()
	run(direction)
	apply_gravity(delta, abs(parent.velocity.y) < movement_data.hang_threshold)
	parent.velocity.x = lerp(parent.velocity.x, direction * movement_data.max_x_speed, movement_data.velocity_x_lerp_speed)
	movement.move_x(parent.velocity.x *delta)
	movement.move_y(parent.velocity.y *delta)

	if movement_data.is_colliding_top:
		movement_data.is_colliding_top = false
		parent.velocity.y = 0
	switch_state(direction)

func switch_state(direction):
	if movement_data.is_near_wall:
		if buffer_jump_timer > 0:
			buffer_jump_timer = -1
			finished.emit("WallJump")
	elif movement_data.is_colliding_bottom:
		movement_data.can_dash = true
		if buffer_jump_timer > 0:
			buffer_jump_timer = -1
			finished.emit("Jump")
		elif is_equal_approx(direction, 0.0):
			finished.emit("Idle")
		else:
			finished.emit("Run")
	

func enter(previous_state_path: String) -> void:
	super(previous_state_path)
	if (previous_state_path != "Jump") and (previous_state_path != "WallJump"):
		coyote_timer = movement_data.coyote_time
	else: 
		coyote_timer = -1
