extends State

func physics_update(delta: float) -> void:
	apply_gravity(delta)
	movement.move_x(parent.velocity.x *delta)
	movement.move_y(parent.velocity.y *delta)
	switch_state()

func switch_state():
	#Fall
	if not parent.is_colliding_y: 
		finished.emit("Fall")
	#Jump
	elif movement_input.wants_jump():
		finished.emit("Jump")
	#Dash
	elif movement_input.wants_dash():
		finished.emit("Dash")
	#Run
	else:
		var direction = movement_input.get_horizontal_input()
		if direction != 0:
			finished.emit("Run")

func enter(previous_state_path: String) -> void:
	super(previous_state_path)
	parent.can_dash = true
	parent.velocity = Vector2.ZERO

func exit() -> void:
	pass
