class_name Player
extends CharacterBody2D

@onready var state_machine: StateMachine = $StateMachine
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var is_alive = true
var can_dash = true
var is_climbing = false

func _physics_process(delta: float) -> void:
	pass

func _ready() -> void:
	Events.player_entered_kill_zone.connect(die)
	state_machine.init(self, animated_sprite)

func die():
	state_machine._transition_to_next_state("Die")

func _on_hurt_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy") and is_alive:
		die()
		is_alive = false
