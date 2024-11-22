extends State

var prev_velocity: Vector2= Vector2.ZERO
var start_accel: float = 0.0

func handle_input(_event: InputEvent) -> void:
	if movement_input.wants_jump():
		finished.emit("Jump")
	if movement_input.wants_dash():
		finished.emit("Dash")

func physics_update(delta: float) -> void:
	var direction = movement_input.get_horizontal_input()
	if direction != 0:
		if direction != sign(parent.velocity.x) and parent.velocity.x != 0:
			parent.velocity.x = move_toward(parent.velocity.x, direction * movement_data.max_x_speed, movement_data.acceleration * delta * 2)
		else:
			parent.velocity.x = move_toward(parent.velocity.x, direction * movement_data.max_x_speed, movement_data.acceleration * delta)
		run(direction)
	else:
		parent.velocity.x = move_toward(parent.velocity.x, 0.0, movement_data.friction * delta)
	apply_gravity(delta)
	movement.move_x(parent.velocity.x * delta)
	movement.move_y(parent.velocity.y * delta)
	if(movement_data.is_colliding_y == 1):
		parent.velocity.y = 0
	switch_state(direction, delta)
	
func switch_state(direction, delta):
	if not movement_data.is_colliding_y == 1:
		finished.emit("Fall")
	elif abs(parent.velocity.x) < movement_data.friction * delta and direction == 0:
		finished.emit("Idle")

func enter(previous_state_path: String) -> void:
	super(previous_state_path)
	start_accel = movement_data.acceleration
