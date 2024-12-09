extends Node2D
class_name Solid

@export var color :Color
@export var speed: Vector2 
@export var keyframes: Array[Vector2]

@onready var sprite: Sprite2D = $Sprite2D
@onready var movement: SolidMovement = $PixelPerfectMovement

var rect: Rect2
var next_keyframe_idx : int
var curr_keyframe_idx : int

func _ready() -> void:
	rect = sprite.get_rect()
	curr_keyframe_idx = 0
	self.global_position = keyframes[curr_keyframe_idx]
	movement.init(self)
	

func _draw() -> void:
	draw_rect(rect,color)

func _physics_process(delta: float) -> void:
	print(global_position)
	queue_redraw()
	next_keyframe_idx = curr_keyframe_idx + 1
	next_keyframe_idx %= keyframes.size()
	var dir = sign(keyframes[next_keyframe_idx] - global_position)
	movement.move_x(delta * speed.x * dir.x)
	movement.move_y(delta * speed.y * dir.y)
	print(dir)
	if(dir == Vector2.ZERO):
		curr_keyframe_idx = next_keyframe_idx
