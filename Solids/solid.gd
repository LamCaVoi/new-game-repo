extends Sprite2D
class_name Solid

@export var color :Color
## the time it takes in second to reach the next keyframe
@export var time: Array[float] = [1]
@export var keyframes: Array[Vector2]
@onready var movement: SolidMovement = $PixelPerfectMovement


var rect: Rect2
var curr_keyframe : int
var next_keyframe : int
var speed: Vector2

func _ready() -> void:
	rect = get_rect()
	curr_keyframe = 0
	if(keyframes.size() <= 1):
		return
	next_keyframe = (curr_keyframe + 1)%keyframes.size()
	update_speed()
	self.global_position = keyframes[curr_keyframe]
	movement.init(self)

func update_speed():
	if time.size() <= next_keyframe - 1:
		printerr("Not enough time periods for the given keyframes")
		return
	speed = Vector2(abs(keyframes[curr_keyframe].x - keyframes[next_keyframe].x) / time[next_keyframe - 1],
				abs(keyframes[curr_keyframe].y - keyframes[next_keyframe].y) / time[next_keyframe - 1])

func _physics_process(delta: float) -> void:
	if(keyframes.size() <= 1):
		return
	var dir = sign(keyframes[next_keyframe] - global_position)
	movement.move_x(delta * speed.x * dir.x, keyframes[next_keyframe].x)
	movement.move_y(delta * speed.y * dir.y, keyframes[next_keyframe].y)
	if(dir == Vector2.ZERO):
		curr_keyframe = next_keyframe
		next_keyframe = (curr_keyframe + 1)%keyframes.size()
		update_speed()
