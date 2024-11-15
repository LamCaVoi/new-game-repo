class_name Player
extends CharacterBody2D

@export var movement_data: PlayerMovementData

@onready var state_machine: StateMachine = $StateMachine
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var movement_input: PlayerMovementInput = $MovementInput
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var hit_box: HitBox = $HitBox
@onready var movement: Movement = $PixelPerfectMovement

var is_colliding_x = false
var is_colliding_y = false
var is_alive = true
var can_dash = true
var is_climbing = false

func _physics_process(delta: float) -> void:
	pass

func _ready() -> void:
	Events.player_entered_kill_zone.connect(die)
	Events.player_colliding_x.connect(set_colliding_x)
	Events.player_colliding_y.connect(set_colliding_y)
	movement_data._init()
	hit_box.init()
	movement.init(self,hit_box)
	state_machine.init(self, animated_sprite, ray_cast_2d, movement_data, movement_input, movement)

func die():
	state_machine._transition_to_next_state("Die")

func on_wall():
	return ray_cast_2d.is_colliding() and not is_on_floor()

func set_colliding_x(colliding: bool):
	is_colliding_x = colliding
	
func set_colliding_y(colliding: bool):
	is_colliding_y = colliding
