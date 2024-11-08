extends State

var wall_jump_gravity:float
var input_block_timer: float
var jump_dir: float

func physics_update(delta: float) -> void:
	input_block_timer -=delta
	if(input_block_timer < 0):
		finished.emit("Fall")
		return
	var dir = movement_component.get_horizontal_input()
	run(dir)
	if(dir != jump_dir):
		parent.velocity.y += wall_jump_gravity * delta
	else:
		apply_gravity(delta)
	parent.move_and_slide()
	switch_case(dir)

func switch_case(dir):
	if (parent.is_on_floor()):
		if dir != 0:
			finished.emit("Run")
		else:
			finished.emit("Idle")
	elif parent.on_wall() and movement_component.wants_jump():
		finished.emit("Wall Jump")

func enter(previous_state_path: String, data := {}) -> void:
	wall_jump_gravity = movement_data.jump_gravity * 1.8
	jump_dir = parent.get_wall_normal().x
	parent.velocity.x = 75 * jump_dir
	parent.velocity.y = movement_data.high_jump_velocity
	input_block_timer = 0.2
	
func exit():
	pass
