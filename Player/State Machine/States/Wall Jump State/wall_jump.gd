extends State

var wall_jump_gravity:float
var input_block_timer: float
var jump_dir: float

func physics_update(delta: float) -> void:
	input_block_timer -=delta
	if(input_block_timer < 0):
		finished.emit("Fall")
		return
	var dir = movement_input.get_horizontal_input()
	run(dir)
	if(dir != jump_dir):
		parent.velocity.y += wall_jump_gravity * delta
	else:
		apply_gravity(delta)
	movement.move_x(parent.velocity.x * delta)
	movement.move_y(parent.velocity.y * delta)
	switch_case(dir)

func switch_case(dir):
	if (is_colliding_bottom):
		if dir != 0:
			finished.emit("Run")
		else:
			finished.emit("Idle")
	elif is_on_wall and movement_input.wants_jump():
		finished.emit("WallJump")

func enter(previous_state_path: String, data := {}) -> void:
	wall_jump_gravity = movement_data.jump_gravity * 1.8
	jump_dir = parent.get_wall_normal().x
	parent.velocity.x = 75 * jump_dir
	parent.velocity.y = movement_data.high_jump_velocity
	input_block_timer = 0.2
