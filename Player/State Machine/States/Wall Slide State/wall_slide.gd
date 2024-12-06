extends Player_State

#The amount of gravity get decreased, ie: 0.5 make the gravity halved
@export_range(0,1) var gravity_decrease_by: float = 0.5
@export_range(0,1) var max_velocity_y_decrease_by: float = 0.5
@export_range(0,1) var wait_time: float = 0.1
var timer:float = -1

func handle_input(_event: InputEvent) -> void:
	if (movement_input.wants_climb()):
		wall_dir = movement.find_wall()
		if wall_dir != 0:
			finished.emit("Climb")
	elif (movement_input.wants_dash() and can_dash):
		finished.emit("Dash")
	elif (movement_input.wants_jump()):
		wall_dir = movement.find_wall()
		if wall_dir != 0:
			finished.emit("Wall Jump")
	elif (movement_input.get_horizontal_input_released(is_colliding_x)):
		timer = wait_time

func physics_update(delta: float) -> void:
	if(timer > 0):
		timer -= delta
		if timer <= 0:
			finished.emit("Fall")
	var dir = movement_input.get_horizontal_input_pressed()
	apply_gravity(delta, gravity_decrease_by)
	parent.velocity.y = clamp(parent.velocity.y, 0, movement_data.max_y_speed * max_velocity_y_decrease_by)
	movement.move_x(dir, true)
	movement.move_y(parent.velocity.y * delta)
	switch_case()

func switch_case():
	if (is_colliding_y == 1):
		finished.emit("Run")
	elif(is_colliding_x == 0):
		finished.emit("Fall")
