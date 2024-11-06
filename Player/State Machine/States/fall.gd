extends PlayerState

var coyote_timer: float = 0
var buffer_jump_timer: float = 0
var start_fall_gravity = 0
var start_jump_gravity = 0
var start_velocity = 0
var was_jumping = false

func handle_input(_event: InputEvent) -> void:
	if Input.is_action_just_released("jump") and player.velocity.y < -100:
		print("Low jump")
		player.velocity.y *= player.short_jump_cut
	if Input.is_action_just_pressed("jump") and not player.is_on_floor():
		if coyote_timer >= 0:
			finished.emit("Jump")
		else:
			buffer_jump_timer = player.buffer_jump_time
	if Input.is_action_just_pressed("dash") and player.can_dash:
		finished.emit("Dash")

func update(delta: float) -> void:
	pass
	
func timer_update(delta):
	if coyote_timer > 0:
		coyote_timer -= delta
	if buffer_jump_timer > 0:
		buffer_jump_timer -= delta

func hang_boost():
	if abs(player.velocity.y) > player.hang_threshold:
		if player.velocity.y > 0:
			player.max_x_speed = start_velocity
			player.fall_gravity = start_fall_gravity
			player.jump_gravity = start_jump_gravity
		return
	if player.velocity.y < 0 and was_jumping:
		player.jump_gravity *= 0.95
		player.max_x_speed += 10
	elif player.velocity.y > 0 and was_jumping: 
		player.fall_gravity *= 0.95
		player.max_x_speed += 10
	
func physics_update(delta: float) -> void:
	timer_update(delta)
	var direction = Input.get_axis("move_left", "move_right")
	player.run(direction)
	player.apply_gravity(delta)
	hang_boost()
	player.velocity.x = lerp(player.velocity.x, player.max_x_speed * direction, player.velocity_x_lerp_speed)
	print("player.max_x_speed: " + str(player.max_x_speed) + " player.velocity: " + str(player.velocity) + " direction = " + str(direction))
	player.move_and_slide()
	switch_state(direction)

func switch_state(direction):
	if player.is_on_floor():
		player.can_dash = true
		if buffer_jump_timer > 0:
			buffer_jump_timer = -1
			finished.emit("Jump")
		elif is_equal_approx(direction, 0.0):
			finished.emit("Idle")
		else:
			finished.emit("Run")
	

func enter(previous_state_path: String, data := {}) -> void:
	start_fall_gravity = player.fall_gravity
	start_jump_gravity = player.jump_gravity
	start_velocity = player.max_x_speed
	player.animated_sprite.play("fall")
	if(previous_state_path != "Jump"):
		coyote_timer = player.coyote_time
	else: 
		was_jumping = true
		coyote_timer = -1

func exit() -> void:
	player.max_x_speed = start_velocity
	player.fall_gravity = start_fall_gravity
	player.jump_gravity = start_jump_gravity
