class_name PlayerMovement
extends Movement

var edge_detected : bool = false

func move_x(amount: float, edge_detection_enabled: bool = false) -> void:
	remainder.x += amount
	amount = round(remainder.x)
	
	if(amount != 0):
		remainder.x -= amount
		_move_x_exact(amount, edge_detection_enabled)

func _move_x_exact(move: float, edge_detection_enabled: bool = false):
	var step : int = sign(move)
	while (move):
		var offset : Vector2 = Vector2(step, 0)
		offset = Global.curr_level.check_intersection(offset, edge_detection_enabled) 
		if offset == Vector2.ZERO:
			edge_detected = false
			zero_remainder_x()
			Events.player_colliding_x.emit(step)
			return
		parent.global_position += offset
		move -= step
	Events.player_colliding_x.emit(0)

func move_y(amount: float, edge_detection_enabled: bool = false):
	remainder.y += amount
	amount = floor(remainder.y)
	
	if(amount != 0):
		remainder.y -= amount
		_move_y_exact(amount,edge_detection_enabled)

func _move_y_exact(move: float, edge_detection_enabled: bool = false):
	var step : int = sign(move)
	
	while (move):
		var offset: Vector2i = Vector2i(0,step)
		if Global.curr_level.check_intersection(Vector2i(0,step), edge_detection_enabled):
			if (not edge_detection_enabled) or edge_detected:
				edge_detected = false
				zero_remainder_y()
				Events.player_colliding_y.emit(step)
				return
			offset = Global.curr_level.find_edge_y(offset)
			if offset == Vector2.ZERO:
				zero_remainder_y()
				Events.player_colliding_y.emit(step)
				return
		parent.global_position += offset
		move -= step
	Events.player_colliding_y.emit(0)

func zero_remainder_x():
	remainder.x = 0

func zero_remainder_y():
	remainder.y = 0

func find_wall(x_offset_amount: int = 3) -> int:
	return Global.curr_level.find_wall(x_offset_amount)
