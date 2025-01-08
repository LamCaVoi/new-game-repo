class_name PlayerMovementData
extends Resource

@export_group("On Ground States") 
##The max x axis speed while on ground
@export var max_x_speed: float = 130
@export var acceleration: float= 1200
@export var friction: float= 1200
@export_group("On Air States") 
##The max y axis speed while on air
@export var max_y_speed: float = 250
@export var jump_height: float = 15.75
@export var jump_time_to_peak:float = 0.4
@export var jump_time_to_descent:float = 0.3
##Coyote time and buffer jump time to make the jump more responsive
@export var coyote_time: float = 0.2
@export var buffer_jump_time: float = 0.2
##Time the player upward speed when release the jump button mid air, cut the jump short
@export var short_jump_cut: float= 0.6
##Use this to lerp the speed of the character on air to stimulate air friction
@export var velocity_x_lerp_speed: float = 0.3
##Use this to half the player gravity around the apex of a jump, make it easier to land precisely
@export var hang_threshold: float = 50.0
@export_group("Dash State") 
@export var dash_speed: float = 175.0
@export var dash_time: float = 0.2
@export_group("Climb State") 
@export var climb_speed :float= 80

var high_jump_velocity:float 
var jump_gravity:float
var fall_gravity:float 

func init() -> void:
	high_jump_velocity = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
	jump_gravity =((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
	fall_gravity =((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0
	print("high_jump_velocity: " + str(high_jump_velocity) + " jump_gravity: " + str(jump_gravity / 60) + " fall_gravity: " + str(fall_gravity / 60))
