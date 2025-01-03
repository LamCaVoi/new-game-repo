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

const STATE_MACHINE = preload("res://Player/State Machine/state_machine.tscn")
#
#func _draw() -> void:
	#draw_rect(rect2,color)
##
##func _physics_process(delta: float) -> void:
	##queue_redraw()

func _ready() -> void:
	Events.player_colliding_x.connect(state_machine.set_colliding_x)
	Events.player_colliding_y.connect(state_machine.set_colliding_y)
	Events.player_entered_kill_zone.connect(die)
	movement_data.init()
	movement.init(self)
	state_machine.init(self, animated_sprite, movement_data, movement_input, movement)

func die():
	velocity = Vector2.ZERO
	state_machine._transition_to_next_state("Die")
	Engine.time_scale = 0.5
	await animated_sprite.animation_finished
	Engine.time_scale = 1
	if not Global.curr_spawn_point:
		get_tree().call_deferred("reload_current_scene")
		return
	remove_child(state_machine)
	#state_machine.queue_free()
	state_machine = STATE_MACHINE.instantiate()
	add_child(state_machine)
	state_machine.init(self, animated_sprite, movement_data, movement_input, movement)
	self.global_position = Global.curr_spawn_point.round()
	await Events.player_enter_room
	Events.player_respawned.emit()


func get_current_climb_direction():
	if(state_machine.state.name == "Climb"):
		return state_machine.state.wall_direction
	return 0
	
func get_facing_direction() -> int:
	return -1 if animated_sprite.flip_h else 1

func is_grounded()->bool:
	return state_machine.state.is_colliding_y == 1
