extends Player_State

@export var jump_block_time: float = 0.1
var jump_block_timer: float


func handle_input(_event: InputEvent) -> void:
	if movement_input.released_climb():
		if is_colliding_y == 1:
			finished.emit("Idle")
		else:
			finished.emit("Fall")
	elif movement_input.wants_jump() and jump_block_timer <= 0:
		
		finished.emit("Wall Jump")
		
func timer_update(delta):
	if jump_block_timer > 0:
		jump_block_timer -= delta

func physics_update(delta: float):
	timer_update(delta)
	var dir = movement_input.get_vertical_input_pressed()
	if(dir != 0):
		animated_sprite.play("climb")
	else:
		animated_sprite.play("hold")
	parent.velocity.y = dir * movement_data.climb_speed
	movement.move_x(wall_direction * 2)
	movement.move_y(parent.velocity.y * delta)
	switch_case(dir)

func switch_case(dir: float):
	if is_colliding_y == 1:
		finished.emit("Idle")
	if is_colliding_x == 0:
		finished.emit("Fall")

func enter(previous_state_path: String) -> void:
	if(previous_state_path == "Wall Jump"):
		jump_block_timer = jump_block_time
	run(wall_direction)
	animated_sprite.play("hold")
