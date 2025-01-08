class_name Player
extends CharacterBody2D

@export_group("player's components")
@export var movement_data: PlayerMovementData
@export var state_machine: StateMachine
@export var animated_sprite: AnimatedSprite2D
@export var movement_input: PlayerMovementInput
@export var movement: PlayerMovement

@export_group("player's AABB")
@export var width : int = 10
@export var height : int = 20
@export var x : int = -5
@export var y : int = 0
@export var color : Color
@onready var rect2 : Rect2 = Rect2(x,y,width,height)
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

const STATE_MACHINE = preload("res://Player/State Machine/state_machine.tscn")
#
#func _draw() -> void:
	#draw_rect(rect2,color)
#
#func _physics_process(delta: float) -> void:
	#queue_redraw()

func _ready() -> void:
	Events.player_colliding_x.connect(state_machine.set_colliding_x)
	Events.player_colliding_y.connect(state_machine.set_colliding_y)
	Events.player_get_momentum.connect(state_machine.give_momentum)
	movement_data.init()
	movement.init(self)
	state_machine.init(self, animated_sprite, movement_data, movement_input, movement)

func die():
	velocity = Vector2.ZERO
	await state_machine._transition_to_next_state("Die")
	if not Global.curr_spawn_point:
		get_tree().call_deferred("reload_current_scene")
		return
	state_machine._transition_to_next_state(state_machine.initial_state.name)

func get_current_climb_direction():
	if(state_machine.state.name == "Climb" or state_machine.state.name == "Wall Slide"):
		return state_machine.state.wall_direction
	return 0

func is_climbing():
	return state_machine.state.name == "Climb"
	
func get_facing_direction() -> int:
	return -1 if animated_sprite.flip_h else 1

func is_grounded()->bool:
	return state_machine.state.is_colliding_y == 1
