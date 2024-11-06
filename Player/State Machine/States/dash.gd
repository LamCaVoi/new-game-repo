extends State

var dir : Vector2 = Vector2.ZERO
var dash_timer: float= 0.0

func handle_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	dash_timer -= delta
	if dash_timer <=0:
		finished.emit("Fall")
		return
	print(parent.velocity)
	parent.move_and_slide()

func get_dir() -> Vector2:
	var dir : Vector2 = Vector2.ZERO
	dir.x = Input.get_axis("move_left","move_right")
	dir.y = Input.get_axis("move_up","move_down")
	
	if dir == Vector2.ZERO:
		if parent.animated_sprite.flip_h:
			dir.x = -1
		else:
			dir.x = 1
	print(dir)
	return dir

func enter(previous_state_path: String, data := {}) -> void:
	parent.can_dash = false
	dir = get_dir()
	parent.velocity = dir * movement_data.dash_speed
	dash_timer = movement_data.dash_time


func exit() -> void:
	parent.velocity = dir * 50
