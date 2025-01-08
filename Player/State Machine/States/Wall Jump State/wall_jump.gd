extends Player_State
@export var init_x_velocity: int = 120
#Cut the jump velocity in wall jump state plus buffing the lateral movement in this state
@export var jump_cut: float = 0.8
var jump_direction: float

func enter(_previous_state_path: String) -> void:
	jump_direction = wall_direction * -1
	parent.velocity.x = init_x_velocity * jump_direction
	parent.velocity.y = movement_data.high_jump_velocity
	run(jump_direction)
	if (momentum != Vector2.ZERO):
		parent.velocity += momentum
		direction_block_time = 0.2
		extra_x_speed = momentum.x
		momentum = Vector2.ZERO
	else:
		direction_block_time = 0.15
	finished.emit("Fall")
