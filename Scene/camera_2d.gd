extends Camera2D

var smoothing: float = 1.0
@export var follow_smoothing: float = 1
var current_room_center: Vector2
var current_room_size: Vector2
@export var zoom_view_size: Vector2
@onready var view_size: Vector2 = get_viewport_rect().size
@export var player : CharacterBody2D
var target_position
var left
var right 
var top 
var bottom

func change_room(room_rect: Rect2):
	current_room_center = room_rect.position
	current_room_size = room_rect.size
	target_position = calculate_target_position(current_room_center, current_room_size)
	get_tree().paused = true
	start_camera_transition(target_position)

func _ready():
	Events.player_enter_room.connect(change_room)
	position_smoothing_enabled = false
	smoothing = follow_smoothing
	zoom_view_size = view_size * zoom
	await get_tree().create_timer(0.1).timeout

func start_camera_transition(target_position: Vector2):
	var tween = self.create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN_OUT).set_parallel(true)
	tween.tween_property(
		self,
		"limit_left",
		left,
		smoothing
	)
	tween.tween_property(
		self,
		"limit_right",
		right,
		smoothing
	)
	tween.tween_property(
		self,
		"limit_top",
		top,
		smoothing
	)
	tween.tween_property(
		self,
		"limit_bottom",
		bottom,
		smoothing
	)
	await tween.finished
	get_tree().paused = false

func calculate_target_position(room_center: Vector2, room_size: Vector2) -> Vector2:
	left = room_center.x - room_size.x/2
	right = room_center.x + room_size.x/2
	top = room_center.y - room_size.y/2
	bottom = room_center.y + room_size.y/2
	return Vector2.ZERO
