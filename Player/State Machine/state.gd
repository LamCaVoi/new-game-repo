## Virtual base class for all states.
## Extend this class and override its methods to implement a state.
class_name State
extends Node

@export var animation_name:String

var movement_data: PlayerMovementData
var movement_input: PlayerMovementInput
var movement: Movement
var parent:CharacterBody2D
var animated_sprite: AnimatedSprite2D
var ray_cast_2d: RayCast2D

var data: Dictionary = {
	"is_colliding_top": false,
	"is_colliding_bottom": false,
	"is_colliding_x": false,
	"can_dash": false
}

var is_colliding_top : bool 
var is_colliding_bottom : bool 
var is_colliding_x : bool 
var can_dash : bool 
var is_on_wall : bool 

## Emitted when the state finishes and wants to transition to another state.
signal finished(next_state_path: String, data : Dictionary)

## Called by the state machine when receiving unhandled input events.
func handle_input(_event: InputEvent) -> void:
	pass

## Called by the state machine on the engine's main loop tick.
func update(_delta: float) -> void:
	pass

## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
	pass

## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(previous_state_path: String) -> void:
	self.is_colliding_top = data.is_colliding_top
	self.is_colliding_bottom = data.is_colliding_bottom
	self.is_colliding_x = data.is_colliding_x
	self.can_dash = data.can_dash
	self.is_on_wall = data.is_on_wall
	animated_sprite.play(animation_name)
	

## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit(is_colliding_top: bool,is_colliding_bottom: bool,is_colliding_x: bool,can_dash: bool, is_on_wall: bool) -> Dictionary:
	data.is_collidingz_top = is_colliding_top
	data.is_colliding_bottom = is_colliding_bottom
	data.is_colliding_x = is_colliding_x
	data.can_dash = can_dash
	data.is_on_wall = is_on_wall
	return data

func get_fall_gravity():
	return movement_data.jump_gravity if parent.velocity.y < 0.0 else movement_data.fall_gravity

func apply_gravity(delta: float, is_at_apex : bool = false):
	if parent.velocity.y <= movement_data.max_y_speed:
		if (is_at_apex):
			parent.velocity.y += get_fall_gravity() * 0.5 * delta
		else:
			parent.velocity.y += get_fall_gravity() * delta
	else: parent.velocity.y = movement_data.max_y_speed


func run(direction):
	#velocity.x = max_x_speed * direction
	if not direction == 0:
		animated_sprite.flip_h = direction < 0
		ray_cast_2d.target_position = Vector2(-8,0) if animated_sprite.flip_h else Vector2(8,0)

#func set_colliding_x(val : bool) -> void:
	#is_colliding_x = val
#
#func set_colliding_top(val : bool) -> void:
	#is_colliding_y = val
#
#func is_on_floor() -> bool:
	#return is_colliding_y and (parent.velocity.y >=0)
#
#func is_on_wall() -> bool:
	#return is_colliding_x and not is_on_floor()
