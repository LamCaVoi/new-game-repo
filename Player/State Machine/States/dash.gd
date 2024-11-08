extends State

var dir : Vector2 = Vector2.ZERO
var dash_timer: float= 0.0

func handle_input(_event: InputEvent) -> void:
	pass

func update(delta: float) -> void:
	dash_timer -= delta

func physics_update(delta: float) -> void:
	if dash_timer <=0:
		finished.emit("Fall")
		return
	print(parent.velocity)
	parent.move_and_slide()

func get_dir():
	dir = movement_component.get_8_directional_input()
	if dir == Vector2.ZERO:
		if parent.animated_sprite.flip_h:
			dir.x = -1
		else:
			dir.x = 1
	print(dir)

func enter(previous_state_path: String) -> void:
	parent.can_dash = false
	get_dir()
	parent.velocity = dir * movement_data.dash_speed
	dash_timer = movement_data.dash_time

func exit() -> void:
	parent.velocity.y = -50
	
