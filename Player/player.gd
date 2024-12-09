@tool
class_name Player
extends CharacterBody2D

@export_group("player's components")
@export var movement_data: PlayerMovementData
@onready var state_machine: StateMachine = $StateMachine
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var movement_input: PlayerMovementInput = $MovementInput
@onready var movement: PlayerMovement = $PixelPerfectMovement

@export_group("player's AABB")
@export var width : int = 10
@export var height : int = 20
@export var x : int = -5
@export var y : int = 0
@export var color : Color
@onready var rect2 : Rect2 = Rect2(x,y,width,height)

func _draw() -> void:
	draw_rect(rect2, color)

func _physics_process(delta: float) -> void:
	queue_redraw()

func _ready() -> void:
	Events.player_colliding_x.connect(state_machine.set_colliding_x)
	Events.player_colliding_y.connect(state_machine.set_colliding_y)
	Events.player_entered_kill_zone.connect(die)
	movement_data.init()
	movement.init(self)
	state_machine.init(self, animated_sprite, movement_data, movement_input, movement)

func die():
	state_machine._transition_to_next_state("Die")
