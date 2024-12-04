extends State

func handle_input(event: InputEvent) -> void:
	if movement_input.wants_jump():
		finished.emit("Jump")
		
	#Dash
	if movement_input.wants_dash() and can_dash:
		finished.emit("Dash")

func physics_update(delta: float) -> void:
	apply_gravity(delta)
	movement.move_y(parent.velocity.y * delta)
	if(is_colliding_y == 1):
		parent.velocity.y = 0
	switch_state()

func switch_state():
	#Fall
	if not is_colliding_y == 1: 
		finished.emit("Fall")
	#Run
	else:
		var direction = movement_input.get_horizontal_input_pressed()
		if direction != 0:
			finished.emit("Run")

func enter(previous_state_path: String) -> void:
	super(previous_state_path)
	can_dash = true
	parent.velocity = Vector2.ZERO
