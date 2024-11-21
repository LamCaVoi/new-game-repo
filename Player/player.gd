@tool
class_name Player
extends CharacterBody2D

@export_group("player's components")
@export var movement_data: PlayerMovementData
@onready var state_machine: StateMachine = $StateMachine
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var movement_input: PlayerMovementInput = $MovementInput
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var movement: Movement = $PixelPerfectMovement

@export_group("player's AABB")
@export var width : int = 10
@export var height : int = 20
@export var x : int = -5
@export var y : int = 0
@export var color : Color
@onready var rect2 : Rect2 = Rect2(x,y,width,height)

func _physics_process(delta: float) -> void:
	queue_redraw()

func _ready() -> void:
	Events.player_entered_kill_zone.connect(die)
	Events.player_near_wall.connect(set_near_wall)
	Events.player_colliding_x.connect(set_colliding_x)
	Events.player_colliding_top.connect(set_colliding_top)
	Events.player_colliding_bottom.connect(set_colliding_bottom)
	movement_data.init()
	movement.init(self)
	state_machine.init(self, animated_sprite, ray_cast_2d, movement_data, movement_input, movement)

func set_colliding_x(val : bool):
	movement_data.is_colliding_x = val
func set_colliding_top(val : bool):
	movement_data.is_colliding_top = val
func set_colliding_bottom(val : bool):
	movement_data.is_colliding_bottom = val
func set_near_wall(val : bool):
	movement_data.is_near_wall = val

func die():
	state_machine._transition_to_next_state("Die")

func get_global_rect() -> Vector2:
	return to_global(rect2.position)

func get_left_rect():
	return get_global_rect().x
	
func get_right_rect():
	return get_global_rect().x + rect2.size.x
	
func get_top_rect():
	return get_global_rect().y
	
func get_bottom_rect():
	return get_global_rect().y + rect2.size.y
