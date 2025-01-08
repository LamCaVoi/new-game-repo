extends Node2D
class_name Solid

## the time it takes in second to reach the next keyframe
@export var advance_time: float= 1.0
@export var retract_time: float= 5.0
@export var target: Vector2 = Vector2.ZERO
@export var player_speed : Vector2 

@onready var movement: SolidMovement = $Movement
@onready var sprite: Sprite2D = $Sprite


enum STATE{YELLOW = -1, RED = 0, GREEN = 1}
signal player_collide
var origin : Vector2
var curr_state: STATE
var rect: Rect2
var green_velocity: Vector2
var yellow_velocity: Vector2
var is_momentum_given: bool = false
var player_is_colliding: bool = false

func _ready() -> void:
	origin = self.global_position
	if target == Vector2.ZERO:
		target = origin
	green_velocity.x = (target.x - origin.x) / advance_time
	green_velocity.y = (target.y - origin.y) / advance_time
	yellow_velocity.x = (origin.x - target.x) / retract_time
	yellow_velocity.y = (origin.y - target.y) / retract_time
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
	if curr_state != STATE.RED:
		if (Global.curr_level.intersect_with_player(get_extended_rect())):
			player_is_colliding = true
	match curr_state:
		STATE.RED:
			return
		STATE.GREEN:
			if(not is_momentum_given and player_is_colliding):
				Events.player_get_momentum.emit(player_speed * sign(green_velocity))
				is_momentum_given = true
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
			if (is_momentum_given and player_is_colliding):
				Events.player_get_momentum.emit(Vector2.ZERO)
				is_momentum_given = false
			movement.move_x(yellow_velocity.x * delta, origin.x)
			movement.move_y(yellow_velocity.y * delta, origin.y)
			if (self.global_position == origin):
				curr_state = STATE.RED

func get_rect():
	return sprite.get_rect()

func get_extended_rect()-> Rect2:
	var solid_rect = get_rect()
	solid_rect.position += Vector2(-1,-1)
	solid_rect.size += Vector2(2,1)
	solid_rect.position += global_position
	return solid_rect
