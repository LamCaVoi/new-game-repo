extends Camera2D

var smoothing: float 
@export var follow_smoothing: float = 1
var current_room_center: Vector2
var current_room_size: Vector2
@export var zoom_view_size: Vector2
@onready var view_size: Vector2 = get_viewport_rect().size
@export var player : CharacterBody2D
var tween : Tween
var is_transitioning: bool = false
var just_change_room = false

func change_room(room_rect: Rect2):
	current_room_center = room_rect.position + room_rect.size / 2
	current_room_size = room_rect.size
	just_change_room = true

func _ready():
	Events.player_enter_room.connect(change_room)
	position_smoothing_enabled = false
	smoothing = follow_smoothing
	zoom_view_size = view_size * zoom
	await get_tree().create_timer(0.1).timeout

func _process(delta: float) -> void:
	if(not player or current_room_size == Vector2.ZERO):
		return
	var target_position := calculate_target_position(current_room_center, current_room_size)
	if (target_position != position and not is_transitioning):
		start_camera_transition(target_position)


func start_camera_transition(target_position: Vector2):
	is_transitioning = true
	if(just_change_room):
		get_tree().paused = true
		just_change_room = false
	var tween = get_tree().create_tween()
	#tween.connect("finished", end_camera_transition)
	tween.tween_property(
		self,
		"position",
		target_position,
		smoothing
	).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(end_camera_transition)
	get_tree().paused = false


func end_camera_transition():
	is_transitioning = false
	print("Hey")

func calculate_target_position(room_center: Vector2, room_size: Vector2) -> Vector2:
	var x_margin: float = (room_size.x - zoom_view_size.x) / 2
	var y_margin: float = (room_size.y - zoom_view_size.y) / 2
	
	var return_position: Vector2 = Vector2.ZERO
	
	if x_margin <= 0:
		return_position.x = room_center.x
	else:
		var left_limit: float = room_center.x - x_margin
		var right_limit : float = room_center.x + x_margin
		return_position.x = clampf(player.position.x, left_limit, right_limit)
	
	if y_margin <= 0:
		return_position.y = room_center.y
	else:
		var top_limit: float = room_center.y - y_margin
		var bottom_limit: float = room_center.y + y_margin
		return_position.y = clampf(player.position.y, top_limit, bottom_limit)
	
	return return_position
