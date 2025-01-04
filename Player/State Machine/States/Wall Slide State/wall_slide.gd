extends Player_State

#The amount of gravity get decreased, ie: 0.5 make the gravity halved
@export_range(0,1) var gravity_decrease_by: float = 0.5
@export_range(0,1) var max_velocity_y_decrease_by: float = 0.5
@export_range(0,1) var wait_time: float = 0.1
@export var jump_block_time: float = 0
var jump_block_timer: float
var timer:float = -1

func handle_input(_event: InputEvent) -> void:
	if (movement_input.wants_dash() and can_dash):
		finished.emit("Dash")
	elif (movement_input.wants_jump()):
		wall_direction = movement.find_wall(1)
		if wall_direction and jump_block_timer <= 0:
			jump_block_timer = -1
			finished.emit("Wall Jump")
	elif (movement_input.get_horizontal_input_released(is_colliding_x)):
		timer = wait_time

func timer_update(delta:float):
	if(timer > 0):
		timer -= delta
	if(jump_block_timer > 0):
		jump_block_timer -= delta

func physics_update(delta: float) -> void:
	timer_update(delta)
	if timer <= 0 and timer != -1:
		timer = -1
		finished.emit("Fall")
	var dir = movement_input.get_horizontal_input_pressed()
	apply_gravity(delta, gravity_decrease_by)
	parent.velocity.y = clamp(parent.velocity.y, 0, movement_data.max_y_speed * max_velocity_y_decrease_by)
	movement.move_x(dir * 3 , true)
	movement.move_y(parent.velocity.y * delta)
	switch_case()

func switch_case():
	if (movement_input.wants_climb()):
		wall_direction = movement.find_wall(2)
		if wall_direction:
			finished.emit("Climb")
	elif (is_colliding_y == 1):
		finished.emit("Run")
	elif(is_colliding_x == 0):
		finished.emit("Fall")

func enter(previous_state_path: String) -> void:
	animated_sprite.play("slide")
	if(previous_state_path == "Wall Jump"):
		jump_block_timer = jump_block_time
