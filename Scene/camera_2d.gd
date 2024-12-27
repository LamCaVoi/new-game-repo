extends Camera2D

var smoothing: float = 1.0
@export var follow_smoothing: float = 1
@export var zoom_view_size: Vector2
@onready var view_size: Vector2 = get_viewport_rect().size
@export var player : CharacterBody2D

var current_room_center: Vector2
var current_room_size: Vector2
var next_room_center: Vector2
var next_room_size: Vector2
var tween: Tween
var is_first_time: bool = true
var exit_room: bool = false
var left: float
var right: float
var top: float
var bottom: float

func _ready():
	Events.player_enter_room.connect(on_player_enter_new_room)
	Events.player_exit_room.connect(on_player_exit_room)
	position_smoothing_enabled = false
	smoothing = follow_smoothing
	zoom_view_size = view_size * zoom
	await get_tree().create_timer(0.1).timeout

func on_player_enter_new_room(room_rect: Rect2):
	next_room_center = room_rect.position
	next_room_size = room_rect.size
	if (exit_room or is_first_time):
		exit_room = false
		is_first_time = false
		change_room()

func on_player_exit_room(room_center: Vector2):
	if(room_center != current_room_center):
		return
	elif(next_room_center == current_room_center):
		exit_room = true
		return
	var target_position = change_room()
	start_camera_transition(target_position)

func change_room() -> Vector2:
	current_room_center = next_room_center
	current_room_size = next_room_size
	change_camera_margin(current_room_center,current_room_size)
	return calculate_target_position()

func _physics_process(delta: float) -> void:
	if(not tween or tween.is_running()):
		return
	var target_position = calculate_target_position()
	if target_position.distance_to(global_position) <=3:
		return
	global_position = global_position.lerp(target_position, 1 - pow(0.1,delta)).round()
	print(global_position)

func calculate_target_position():
	var target_position: Vector2 = Vector2.ZERO
	target_position.x = clampf(player.global_position.x,left,right)
	target_position.y = clampf(player.global_position.y,top,bottom)
	return target_position

func change_camera_margin(room_center: Vector2, room_size: Vector2):
	var x_margin = (room_size.x - zoom_view_size.x)/2
	var y_margin = (room_size.y - zoom_view_size.y)/2
	if(x_margin <= 0):
		left = room_center.x
		right = room_center.x
	else:
		left = room_center.x - x_margin
		right = room_center.x + x_margin
	if (y_margin <= 0):
		top = room_center.y
		bottom = room_center.y
	else: 
		top = room_center.y - y_margin
		bottom = room_center.y + y_margin

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
		0.8
	)
	await tween.finished
	get_tree().paused = false
