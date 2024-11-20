extends State

var dir : Vector2 = Vector2.ZERO
var dash_duration_timer: float= 0.0
@onready var ghost = preload("res://Player/State Machine/States/Dash State/ghost.tscn")
@onready var ghost_timer: Timer = $Timer

func physics_update(delta: float) -> void:
	dash_duration_timer -= delta
	if dash_duration_timer <=0:
		switch_state()
		return
	movement.move_x(parent.velocity.x *delta)
	movement.move_y(parent.velocity.y *delta)
	

func switch_state():
	if(is_colliding_bottom):
		can_dash = true
		if(movement_input.get_horizontal_input() != 0):
			finished.emit("Run")
		else:
			finished.emit("Idle")
	else:
		finished.emit("Fall")

func get_dir():
	dir = movement_input.get_8_directional_input()
	if dir == Vector2.ZERO:
		if parent.animated_sprite.flip_h:
			dir.x = -1
		else:
			dir.x = 1

func enter(previous_state_path: String) -> void:
	can_dash = false
	get_dir()
	parent.velocity = dir * movement_data.dash_speed
	dash_duration_timer = movement_data.dash_time
	ghost_timer.wait_time = movement_data.dash_time/4
	ghost_timer.start()

func add_ghost():
	var new_ghost = ghost.instantiate()
	new_ghost.set_property(parent.position, parent.scale)
	new_ghost.flip(parent.animated_sprite.flip_h)
	get_tree().current_scene.add_child(new_ghost)

func exit():
	ghost_timer.stop()
	return super()
	
	
