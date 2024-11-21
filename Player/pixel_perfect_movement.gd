extends Node2D
class_name Movement

var remainder: Vector2 = Vector2.ZERO
var parent: CharacterBody2D

func init(parent: CharacterBody2D) -> void:
	self.parent = parent

func move_x(amount: float, wall_detection_enabled: bool = false):
	remainder.x += amount
	amount = round(remainder.x)
	
	if(amount != 0):
		remainder.x -= amount
		move_x_exact(amount, wall_detection_enabled)
		
	if(wall_detection_enabled):
		if Global.curr_level.find_wall():
			Events.player_near_wall.emit(true)
		else: 
			Events.player_near_wall.emit(false)

func move_x_exact(move: int, wall_detection_enabled: bool = false):
	var step : int = sign(move)

	while (move):
		if Global.curr_level.check_intersection(Vector2i(step,0)):
			Events.player_colliding_x.emit(true)
			return
		parent.global_position.x += step
		move -= step
	Events.player_colliding_x.emit(false)

func move_y(amount: float, wall_detection_enabled: bool = false):
	remainder.y += amount
	amount = floor(remainder.y)
	
	if(amount != 0):
		remainder.y -= amount
		move_y_exact(amount)
		
	if(wall_detection_enabled):
		if Global.curr_level.find_wall():
			Events.player_near_wall.emit(true)
		else: 
			Events.player_near_wall.emit(false)

func move_y_exact(move: int, wall_detection_enabled: bool = false):
	var step : int = sign(move)
	
	while (move):
		if Global.curr_level.check_intersection(Vector2i(0,step)):
			Events.player_colliding_bottom.emit(step > 0)
			Events.player_colliding_top.emit(not step > 0)
			return
		parent.global_position.y += step
		move -= step
	Events.player_colliding_bottom.emit(false)
	Events.player_colliding_top.emit(false)

func zero_remainder_x():
	remainder.x = 0

func zero_remainder_y():
	remainder.y = 0
