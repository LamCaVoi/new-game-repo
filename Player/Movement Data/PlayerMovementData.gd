class_name PlayerMovementData
extends Resource

@export var max_x_speed: float = 130
@export var max_y_speed: float = 250
@export var jump_height: float = 50
@export var jump_time_to_peak:float = 0.4
@export var jump_time_to_descent:float = 0.3
@export var acceleration: float= 1200
@export var friction: float= 1200
@export var short_jump_cut: float= 0.6
@export var velocity_x_lerp_speed: float = 0.3
@export var velocity_y_lerp_speed: float = 0.8
@export var hang_threshold: float = 50.0
@export var dash_speed: float = 175.0
@export var dash_time: float = 0.2


@export var coyote_time: float = 0.2
@export var buffer_jump_time: float = 0.2

var high_jump_velocity:float 
var jump_gravity:float
var fall_gravity:float 
var can_dash: bool = true
var is_colliding_top: bool
var is_colliding_bottom: bool = true
var is_colliding_x: bool
var is_near_wall: bool = false

func init() -> void:
	high_jump_velocity = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
	jump_gravity =((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
	fall_gravity =((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0
	print("high_jump_velocity: " + str(high_jump_velocity) + " jump_gravity: " + str(jump_gravity / 60) + " fall_gravity: " + str(fall_gravity / 60))
