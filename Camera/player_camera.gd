extends Camera2D
class_name PlayerCamera

enum CAMERA_ANCHOR{LEFT = -1, CENTER, RIGHT}

@export var smoothing: float = 0.8
@export var zoom_view_size: Vector2
@onready var view_size: Vector2 = get_viewport_rect().size
@export var player : Player
@export var look_ahead_distance: float = 30.0
#The width and height of the death zone
@export var deathzone: Vector2 = Vector2(20,20)

@export var player_anchor: CAMERA_ANCHOR = CAMERA_ANCHOR.CENTER

var look_ahead_offset: float = 0
var current_room_rect: Rect2
var next_room_rect: Rect2
var tween: Tween
var is_first_time: bool = true
var left: float
var right: float
var top: float
var bottom: float

func set_camera_zoom(value: Vector2):
	if(value.x != round(value.x) or value.y != round(value.y)):
		printerr("Error: Can Only zoom by integer value")
		return
	zoom = value
	zoom_view_size = view_size * zoom

func _ready():
	Events.player_enter_room.connect(on_player_enter_new_room)
	Events.player_exit_room.connect(on_player_exit_room)
	zoom_view_size = view_size * zoom
	await get_tree().create_timer(0.1).timeout

func on_player_enter_new_room(room_rect: Rect2):
	next_room_rect = room_rect
	if (is_first_time):
		is_first_time = false
		var target_position = change_room()
		start_camera_transition(target_position)

func on_player_exit_room(room_top_left: Vector2 = current_room_rect.position):
	if(room_top_left != current_room_rect.position):
		return
	if(next_room_rect.position == current_room_rect.position):
		return
	var target_position = change_room()
	start_camera_transition(target_position)

func change_room() -> Vector2:
	current_room_rect = next_room_rect
	change_camera_margin(current_room_rect)
	return calculate_target_position()

func _physics_process(delta: float) -> void:
	if(tween and tween.is_running()):
		return
	var look_ahead_distance = (float(player_anchor) * zoom_view_size.x)/3
	look_ahead_offset = round_toward(lerp(look_ahead_offset, look_ahead_distance, 1 - pow(0.5,delta)), look_ahead_distance)
	var target_position = calculate_target_position(int(look_ahead_offset))
	if abs(target_position.x - global_position.x) <= deathzone.x:
		target_position.x = global_position.x
	if abs(target_position.y - global_position.y) <= deathzone.y:
		target_position.y = global_position.y
	if (not player.is_grounded()):
		if(not abs(target_position.y - global_position.y) > 50):
			target_position.y = global_position.y
	if(not target_position.x == global_position.x):
		global_position.x = round_toward(lerp(global_position.x,target_position.x, 1 - pow(0.1,delta)),target_position.x)
	if(not target_position.y == global_position.y):
		global_position.y = round_toward(lerp(global_position.y,target_position.y, 1 - pow(0.1,delta)),target_position.y)

func round_toward(value: float, target: float):
	if (value > target):
		value = floor(value)
	elif (value < target):
		value = ceilf(value)
	return value

func calculate_target_position(offset: int = 0):
	var target_position: Vector2 = Vector2.ZERO
	target_position.x = clampf(player.global_position.x + offset,left,right)
	target_position.y = clampf(player.global_position.y,top,bottom)
	return target_position

func change_camera_margin(room_rect: Rect2):
	var rect : Rect2 = change_rect_position_to_center(room_rect)
	var x_margin = (rect.size.x - zoom_view_size.x)/2
	var y_margin = (rect.size.y - zoom_view_size.y)/2
	if(x_margin <= 0):
		left = rect.position.x
		right = rect.position.x
	else:
		left = rect.position.x - x_margin
		right = rect.position.x + x_margin
	if (y_margin <= 0):
		top = rect.position.y
		bottom = rect.position.y
	else: 
		top = rect.position.y - y_margin
		bottom = rect.position.y + y_margin

func change_rect_position_to_center(rect: Rect2):
	rect.position += Vector2(rect.size.x * 0.5, rect.size.y * 0.5)
	return rect

func start_camera_transition(target_position: Vector2):
	if(tween):
		tween.kill()
	get_tree().paused = true
	tween = self.create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(
		self,
		"global_position",
		target_position,
		smoothing
	)
	await tween.finished
	get_tree().paused = false
