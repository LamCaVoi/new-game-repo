extends Node
class_name SolidMovement


var remainder: Vector2 = Vector2.ZERO
var parent: Node2D

func init(parent: Node2D) -> void:
	self.parent = parent

func move_x(amount: float, target_x: float) -> void:
	remainder.x += amount
	amount = int(remainder.x)
	
	if(amount != 0):
		remainder.x -= amount
		_move_x_exact(amount, target_x)

func _move_x_exact(move: float, target_x: float):
	var step : int = sign(move)
	var offset: Vector2 = Vector2(step,0)
	while(move and parent.global_position.x != target_x):
		Global.curr_level.solid_interact_player(parent, offset)
		parent.global_position.x += step
		move -= step

func move_y(amount: float, target_y: float):
	remainder.y += amount
	amount = int(remainder.y)
	
	if(amount != 0):
		remainder.y -= amount
		_move_y_exact(amount, target_y)

func _move_y_exact(move: float, target_y: float):
	var step : int = sign(move)
	var offset: Vector2 = Vector2(0,step)
	
	while(move and parent.global_position.y != target_y):
		Global.curr_level.solid_interact_player(parent, offset)
		parent.global_position.y += step
		move -= step

func zero_remainder_x():
	remainder.x = 0

func zero_remainder_y():
	remainder.y = 0
