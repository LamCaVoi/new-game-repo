extends State

var prev_velocity: Vector2= Vector2.ZERO
var start_accel: float = 0.0

func handle_input(_event: InputEvent) -> void:
	if movement_component.wants_jump():
		finished.emit("Jump")
	if movement_component.wants_dash():
		finished.emit("Dash")

func physics_update(delta: float) -> void:
	var direction = movement_component.get_horizontal_input()
	if direction != 0:
		if direction != sign(parent.velocity.x) and parent.velocity.x != 0:
			parent.velocity.x = move_toward(parent.velocity.x, direction * movement_data.max_x_speed, movement_data.acceleration * delta * 2)
		else:
			parent.velocity.x = move_toward(parent.velocity.x, direction * movement_data.max_x_speed, movement_data.acceleration * delta)
		run(direction)
	else:
		parent.velocity.x = move_toward(parent.velocity.x, 0.0, movement_data.friction * delta)
	apply_gravity(delta)
	parent.move_and_slide()
	switch_state(direction, delta)
	
func switch_state(direction, delta):
	if not parent.is_on_floor():
		finished.emit("Fall")
	elif abs(parent.velocity.x) < movement_data.friction * delta and direction == 0:
		finished.emit("Idle")

func enter(previous_state_path: String, data := {}) -> void:
	super(previous_state_path)
	parent.can_dash = true
	start_accel = movement_data.acceleration
