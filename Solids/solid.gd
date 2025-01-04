extends Node2D
class_name Solid

## the time it takes in second to reach the next keyframe
@export var green_time: float= 1.0
@export var yellow_time: float= 5.0
@export var target: Vector2 = Vector2.ZERO
@onready var movement: SolidMovement = $Movement
@onready var solid: Sprite2D = $Solid

enum STATE{YELLOW = -1, RED = 0, GREEN = 1}
signal player_collide
var origin : Vector2
var curr_state: STATE
var rect: Rect2
var green_velocity: Vector2
var yellow_velocity: Vector2

func _ready() -> void:
	origin = self.global_position
	if target == Vector2.ZERO:
		target = origin
	green_velocity.x = (target.x - origin.x) / green_time
	green_velocity.y = (target.y - origin.y) / green_time
	yellow_velocity.x = (origin.x - target.x) / yellow_time
	yellow_velocity.y = (origin.y - target.y) / yellow_time
	rect = get_rect()
	movement.init(self)
	player_collide.connect(on_player_collide)
	curr_state = STATE.RED

func on_player_collide():
	if curr_state == STATE.RED:
		var timer :Timer = Timer.new()
		timer.one_shot = true
		add_child(timer)
		timer.start(0.3)
		await timer.timeout
		curr_state = STATE.GREEN

func _physics_process(delta: float) -> void:
	if (target == origin):
		return
	match curr_state:
		STATE.RED:
			return
		STATE.GREEN:
			movement.move_x(green_velocity.x * delta, target.x)
			movement.move_y(green_velocity.y * delta, target.y)
			if (self.global_position == target):
				var timer :Timer = Timer.new()
				timer.one_shot = true
				add_child(timer)
				timer.start(0.3)
				await timer.timeout
				curr_state = STATE.YELLOW
		STATE.YELLOW:
			movement.move_x(yellow_velocity.x * delta, origin.x)
			movement.move_y(yellow_velocity.y * delta, origin.y)
			if (self.global_position == origin):
				curr_state = STATE.RED

func get_rect():
	return solid.get_rect()
