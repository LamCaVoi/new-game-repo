extends Node
class_name SolidMovement


var remainder: Vector2 = Vector2.ZERO
var parent: Node2D

func init(parent: Node2D) -> void:
	self.parent = parent

func move_x(amount: float, x_key: float) -> void:
	remainder.x += amount
	amount = int(remainder.x)
	
	if(amount != 0):
		remainder.x -= amount
		_move_x_exact(amount, x_key)

func _move_x_exact(move: float, x_key: float):
	var step : int = sign(move)
	while(move and parent.global_position.x != x_key):
		parent.global_position.x += step
		move -= step
		

func move_y(amount: float, y_key: float):
	remainder.y += amount
	amount = int(remainder.y)
	
	if(amount != 0):
		remainder.y -= amount
		_move_y_exact(amount, y_key)

func _move_y_exact(move: float, y_key: float):
	var step : int = sign(move)
	while(move and parent.global_position.y != y_key):
		parent.global_position.y += step
		move -= step

func zero_remainder_x():
	remainder.x = 0

func zero_remainder_y():
	remainder.y = 0
