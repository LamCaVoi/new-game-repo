extends Movement
class_name PlayerMovement

var edge_detected : bool = false

func init(parent: CharacterBody2D)-> void:
	self.parent = parent 

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
		if Global.curr_level.check_intersection(offset):
			if (not edge_detection_enabled):
				zero_remainder_x()
				Events.player_colliding_x.emit(step)
				return
			offset = Global.curr_level.find_edge_x(Vector2(step, 0))
			if offset != Vector2.ZERO:
				print("bro niceeeeeeeeeeeee!!!")
				edge_detected = true
			else:
				print("WTF man!!!")
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
		var offset: Vector2 = Vector2(0,step)
		if Global.curr_level.check_intersection(Vector2i(0,step)):
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
