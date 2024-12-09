extends Movement
class_name SolidMovement


func move_x(amount: float) -> void:
	remainder.x += amount
	amount = floor(remainder.x)
	
	if(amount != 0):
		remainder.x -= amount
		_move_x_exact(amount)

func _move_x_exact(move: float):
	var step : int = sign(move)
	while(move):
		parent.global_position.x += step
		move -= step
		

func move_y(amount: float):
	remainder.y += amount
	amount = floor(remainder.y)
	
	if(amount != 0):
		remainder.y -= amount
		_move_y_exact(amount)

func _move_y_exact(move: float):
	var step : int = sign(move)
	while(move):
		parent.global_position.y += step
		move -= step

func zero_remainder_x():
	remainder.x = 0

func zero_remainder_y():
	remainder.y = 0
