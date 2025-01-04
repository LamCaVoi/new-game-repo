class_name Movement
extends Node

var remainder: Vector2 = Vector2.ZERO
var parent: Node2D

func init(parent: Node2D) -> void:
	self.parent = parent

func move_x(amount: float) -> void:
	remainder.x += amount
	amount = int(remainder.x)
	
	if(amount != 0):
		remainder.x -= amount
		_move_x_exact(amount)

func _move_x_exact(move: float):
	var step : int = sign(move)
	while(step):
		step-=1

func move_y(amount: float):
	remainder.y += amount
	amount = int(remainder.y)
	
	if(amount != 0):
		remainder.y -= amount
		_move_y_exact(amount)

func _move_y_exact(move: float):
	var step : int = sign(move)
	while(step):
		step-=1

func zero_remainder_x():
	remainder.x = 0

func zero_remainder_y():
	remainder.y = 0
