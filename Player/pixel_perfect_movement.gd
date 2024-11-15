extends Node
class_name Movement

var remainder: Vector2 = Vector2.ZERO
var parent: CharacterBody2D
var hitbox: HitBox

func init(parent: CharacterBody2D, hitbox: HitBox) -> void:
	self.parent = parent
	self.hitbox = hitbox

func move_x(amount: float):
	remainder.x += amount
	amount = round(remainder.x)
	
	if(amount != 0):
		remainder.x -= amount
		move_x_exact(amount)

func move_x_exact(move: int):
	var step : int = sign(move)
	
	while (move):
		if Game.is_colliding(hitbox, Vector2(step, 0)):
			print("helolo")
			zero_remainder_x()
			Events.player_colliding_x.emit(true)
			return
		parent.global_position.x += step
		move-=step
	Events.player_colliding_x.emit(false)
		
func move_y(amount: float):
	remainder.y += amount
	amount = round(remainder.y)
	
	if(amount != 0):
		remainder.y -= amount
		move_y_exact(amount)

func move_y_exact(move: int):
	var step : int = sign(move)
	
	while (move):
		if Game.is_colliding(hitbox, Vector2(0, step)):
			zero_remainder_y()
			Events.player_colliding_y.emit(true)
			return
		parent.global_position.y += step
		move-=step
	Events.player_colliding_y.emit(false)

func zero_remainder_x():
	remainder.x = 0

func zero_remainder_y():
	remainder.y = 0
	
