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
	animated_sprite.play(animation_name)

## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit():
	pass

func get_fall_gravity():
	return movement_data.jump_gravity if parent.velocity.y < 0.0 else movement_data.fall_gravity

func apply_gravity(delta: float, decrease_by : float = 1.0):
	if parent.velocity.y <= movement_data.max_y_speed:
		parent.velocity.y += get_fall_gravity() * decrease_by * delta
	else: parent.velocity.y = movement_data.max_y_speed


func run(direction):
	if not direction == 0:
		animated_sprite.flip_h = direction < 0
		ray_cast_2d.target_position = Vector2(-8,0) if animated_sprite.flip_h else Vector2(8,0)
