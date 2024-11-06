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
	elif Input.is_action_just_pressed("jump"):
		finished.emit("Jump")
	#Dash
	elif Input.is_action_just_pressed("dash"):
		finished.emit("Dash")
	#Run
	else:
		var direction = Input.get_axis("move_left", "move_right")
		if direction != 0:
			finished.emit("Run")

func enter(previous_state_path: String, data := {}) -> void:
	super(previous_state_path, data)
	parent.can_dash = true
	parent.velocity = Vector2.ZERO

func exit() -> void:
	pass
