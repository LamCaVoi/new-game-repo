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

var is_alive = true
var is_climbing = false

@onready var rect2 : Rect2 = Rect2(x,y,width,height)

func _draw() -> void:
	draw_rect(rect2, color)

func _physics_process(delta: float) -> void:
	queue_redraw()

func _ready() -> void:
	Events.player_entered_kill_zone.connect(die)
	Events.player_colliding_x.connect(state_machine.set_colliding_x)
	Events.player_colliding_y.connect(state_machine.set_colliding_y)
	movement_data._init()
	movement.init(self)
	state_machine.init(self, animated_sprite, ray_cast_2d, movement_data, movement_input, movement)

func die():
	state_machine._transition_to_next_state("Die")

func on_wall():
	return ray_cast_2d.is_colliding() and not is_on_floor()

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
