extends State

#The amount of gravity get decreased, ie: 0.5 make the gravity halved
@export_range(0,1) var gravity_decrease_by: float = 0.5
@export_range(0,1) var max_gravity_decrease_by: float = 0.5
@export_range(0,1) var wait_time: float = 0.1
var timer:float = -1

func handle_input(_event: InputEvent) -> void:
	if (movement_input.wants_climb()):
		movement_data.wall_dir = movement.find_wall()
		if movement_data.wall_dir != 0:
			finished.emit("Climb")
	elif (movement_input.wants_dash() and movement_data.can_dash):
		finished.emit("Dash")
	elif (movement_input.wants_jump() and movement_data.is_colliding_x != 0):
		movement_data.wall_dir = movement_data.is_colliding_x
		finished.emit("Wall Jump")
	elif (movement_input.get_horizontal_input_released(movement_data.is_colliding_x)):
		timer = wait_time

func physics_update(delta: float) -> void:
	if(timer > 0):
		timer -= delta
		if timer <= 0:
			finished.emit("Fall")
	var dir = movement_input.get_horizontal_input_pressed()
	apply_gravity(delta, gravity_decrease_by)
	movement.move_x(movement_data.max_x_speed * delta * movement_data.is_colliding_x, true)
	movement.move_y(parent.velocity.y * delta if parent.velocity.y < movement_data.max_y_speed * max_gravity_decrease_by else movement_data.max_y_speed * max_gravity_decrease_by * delta, true)
	switch_case(dir)

func switch_case(dir: int):
	if (movement_data.is_colliding_y == 1):
		finished.emit("Run")
	elif(movement_data.is_colliding_x == 0):
		finished.emit("Fall")

func enter(previous_state_path: String) -> void:
	parent.velocity = Vector2.ZERO
