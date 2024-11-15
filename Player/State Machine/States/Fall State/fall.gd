extends State

var coyote_timer: float = 0
var buffer_jump_timer: float = 0
var start_fall_gravity = 0
var start_jump_gravity = 0
var start_velocity = 0
var was_jumping = false

func handle_input(_event: InputEvent) -> void:
	if movement_input.released_jump() and parent.velocity.y < -100:
		parent.velocity.y *= movement_data.short_jump_cut

	if movement_input.wants_jump():
		if parent.on_wall():
			finished.emit("WallJump")
		elif not parent.is_on_floor():
			if coyote_timer >= 0:
				finished.emit("Jump")
			else:
				buffer_jump_timer = movement_data.buffer_jump_time
	if movement_input.wants_dash() and parent.can_dash:
		finished.emit("Dash")

func timer_update(delta):
	if coyote_timer > 0:
		coyote_timer -= delta
	if buffer_jump_timer > 0:
		buffer_jump_timer -= delta

func hang_boost():
	if abs(parent.velocity.y) > movement_data.hang_threshold:
		if parent.velocity.y > 0:
			movement_data.max_x_speed = start_velocity
			movement_data.fall_gravity = start_fall_gravity
			movement_data.jump_gravity = start_jump_gravity
		return
	if parent.velocity.y < 0 and was_jumping:
		movement_data.jump_gravity *= 0.95
		movement_data.max_x_speed += 10
	elif parent.velocity.y > 0 and was_jumping: 
		movement_data.fall_gravity *= 0.95
		movement_data.max_x_speed += 10
	
func physics_update(delta: float) -> void:
	timer_update(delta)
	var direction = movement_input.get_horizontal_input()
	run(direction)
	apply_gravity(delta)
	#hang_boost()
	#parent.velocity = lerp(parent.velocity, Vector2(movement_data.max_x_speed * direction, movement_data.max_y_speed), 0.09)
	parent.velocity.x = lerp(parent.velocity.x, movement_data.max_x_speed * direction, movement_data.velocity_x_lerp_speed)
	#print("parent.max_x_speed: " + str(movement_data.max_x_speed) + " parent.velocity: " + str(parent.velocity) + " direction = " + str(direction))
	#parent.move_and_slide()
	movement.move_x(parent.velocity.x *delta)
	movement.move_y(parent.velocity.y *delta)
	switch_state(direction)

func switch_state(direction):
	if parent.on_wall():
		if buffer_jump_timer > 0:
			buffer_jump_timer = -1
			finished.emit("WallJump")
	elif parent.is_colliding_y:
		parent.can_dash = true
		if buffer_jump_timer > 0:
			buffer_jump_timer = -1
			finished.emit("Jump")
		elif is_equal_approx(direction, 0.0):
			finished.emit("Idle")
		else:
			finished.emit("Run")
	

func enter(previous_state_path: String) -> void:
	super(previous_state_path)
	start_fall_gravity = movement_data.fall_gravity
	start_jump_gravity = movement_data.jump_gravity
	start_velocity = movement_data.max_x_speed
	if (previous_state_path != "Jump") and (previous_state_path != "WallJump"):
		coyote_timer = movement_data.coyote_time
	else: 
		was_jumping = true
		coyote_timer = -1

func exit() -> void:
	movement_data.max_x_speed = start_velocity
	movement_data.fall_gravity = start_fall_gravity
	movement_data.jump_gravity = start_jump_gravity
