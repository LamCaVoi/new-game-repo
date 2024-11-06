class_name Player
extends CharacterBody2D

@export var max_x_speed: float = 130
@export var max_y_speed: float = 500
@export var jump_height: float = 60
@export var jump_time_to_peak:float = 0.4
@export var jump_time_to_descent:float = 0.3
@export var acceleration: float= 1200
@export var friction: float= 1200
@export var short_jump_cut: float= 0.6
@export var velocity_x_lerp_speed: float = 0.3
@export var velocity_y_lerp_speed: float = 0.8
@export var hang_threshold: float = 50.0
@export var dash_speed: float = 300.0
@export var dash_time: float = 0.2

@export var coyote_time: float = 0.2
@export var buffer_jump_time: float = 0.2

@onready var state_machine: StateMachine = $StateMachine
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var death_timer: Timer = $Timers/DeathTimer
@onready var high_jump_velocity:float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity:float =((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity:float =((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

var is_alive = true
var can_dash = true
var is_climbing = false

func _ready() -> void:
	Events.player_entered_kill_zone.connect(die)

func get_fall_gravity():
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func apply_gravity(delta: float):
	if is_climbing:
		velocity.y = 0
	elif velocity.y <= max_y_speed:
		velocity.y += get_fall_gravity() * delta
	else: velocity.y = max_y_speed

func _physics_process(delta: float) -> void:
	pass

func die():
	state_machine._transition_to_next_state("Die")

func _on_hurt_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy") and is_alive:
		die()
		is_alive = false

func run(direction):
	#velocity.x = max_x_speed * direction
	if not direction == 0:
		animated_sprite.flip_h = direction < 0
