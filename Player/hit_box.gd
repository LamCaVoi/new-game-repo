@tool
extends Node2D
class_name HitBox

@export var width : float= 10.0
@export var height : float= 17
@export var x : int = 0
@export var y : int = 0
@export var color : Color

var rect

var left: 
	get:
		return global_position.x + x
var right: 
	get:
		return global_position.x + x + width
var top: 
	get:
		return global_position.y + y 
var bottom: 
	get:
		return global_position.y + y + height

func get_rect():
	return rect

func init():
	global_position.x = round(global_position.x)
	global_position.y = round(global_position.y)
	print(global_position)
	print(" self.left: " + str(self.left) + " self.right: " + str(self.right) + " self.top: " + str(self.top) +" self.bottom: " + str(self.bottom))
	
	rect = Rect2(x,y,width,height)

func _draw() -> void:
	rect = Rect2(x,y,width,height)
	draw_rect(rect, color)

func intersect(other: HitBox, offset: Vector2):
	print(" self.left: " + str(self.left) + " self.right: " + str(self.right) + " self.top: " + str(self.top) +" self.bottom: " + str(self.bottom))
	print(" other.left: " + str(other.left) + " other.right: " + str(other.right) + " other.top: " + str(other.top) +" other.bottom: " + str(other.bottom))
	var res = ((self.left + offset.x < other.right) and (self.right + offset.x > other.left) 
	and (self.top + offset.y < other.bottom) and (self.bottom + offset.y > other.top))
	return res
