extends State

func physics_update(delta: float) -> void:
	apply_gravity(delta)
	parent.move_and_slide()
	switch_state()

func switch_state():
	#Fall
	if parent.velocity.y > 0: 
		finished.emit("Fall")
	#Jump
	elif movement_component.wants_jump():
		finished.emit("Jump")
	#Dash
	elif movement_component.wants_dash():
		finished.emit("Dash")
	#Run
	else:
		var direction = movement_component.get_horizontal_input()
		if direction != 0:
			finished.emit("Run")

func enter(previous_state_path: String) -> void:
	super(previous_state_path)
	parent.can_dash = true
	parent.velocity = Vector2.ZERO

func exit() -> void:
	pass
