extends Camera2D

var smoothing: float = 1.0
@export var follow_smoothing: float = 1
var current_room_center: Vector2
var current_room_size: Vector2
@export var zoom_view_size: Vector2
@onready var view_size: Vector2 = get_viewport_rect().size
@export var player : CharacterBody2D

var tween: Tween
var left: float
var right: float
var top: float
var bottom: float

func on_player_enter_new_room(room_rect: Rect2):
	current_room_center = room_rect.position
	current_room_size = room_rect.size
	var target_position = change_camera_margin(current_room_center, current_room_size)
	get_tree().paused = true
	start_camera_transition(target_position)


func _ready():
	Events.player_enter_room.connect(on_player_enter_new_room)
	position_smoothing_enabled = false
	smoothing = follow_smoothing
	zoom_view_size = view_size * zoom
	await get_tree().create_timer(0.1).timeout

func _physics_process(delta: float) -> void:
	if(not tween or tween.is_running()):
		return
	var target_position = calculate_target_position()
	if target_position.distance_to(global_position) <=3:
		return
	global_position = global_position.lerp(target_position, 1 - pow(0.1,delta)).round()
	print(global_position)
	
	
func my_lerp(from: float, to: float, delta: float):
	return from + (to - from) * delta
	
func calculate_target_position():
	var target_position: Vector2 = Vector2.ZERO
	target_position.x = clampf(player.global_position.x,left,right)
	target_position.y = clampf(player.global_position.y,top,bottom)
	return target_position

func start_camera_transition(target_position: Vector2):
	tween = self.create_tween().set_trans(Tween.TRANS_QUART)
	tween.tween_property(
		self,
		"global_position",
		target_position,
		smoothing
	)
	await tween.finished
	print("hey")
	get_tree().paused = false

func change_camera_margin(room_center: Vector2, room_size: Vector2) -> Vector2:
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
	return calculate_target_position()
