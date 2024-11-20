class_name StateMachine extends Node

@export var initial_state: State = null

@onready var state: State = (func get_initial_state() -> State:
	return initial_state if initial_state != null else get_child(0)
).call()

var data: Dictionary = {
	"is_colliding_top": false,
	"is_colliding_bottom": false,
	"is_colliding_x": false,
	"can_dash": false,
	"is_on_wall": false
}

func init(parent: CharacterBody2D, animated_sprite: AnimatedSprite2D, ray_cast_2d: RayCast2D, movement_data : PlayerMovementData, movement_input: PlayerMovementInput, movement: Movement) -> void:
	for state_node: State in find_children("*", "State"):
		state_node.data = self.data
		state_node.finished.connect(_transition_to_next_state)
		state_node.parent = parent
		state_node.animated_sprite = animated_sprite
		state_node.ray_cast_2d = ray_cast_2d
		state_node.movement_data = movement_data
		state_node.movement_input = movement_input
		state_node.movement = movement
		
	state.enter("")
	
func _transition_to_next_state(target_state_path: String) -> void:
	if not has_node(target_state_path):
		printerr(owner.name + ": Trying to transition to state " + target_state_path + " from " + state.name + " but it does not exist.")
		return
	var previous_state_path := state.name
	update_shared_data()
	state = get_node(target_state_path)
	state.data = self.data
	state.enter(previous_state_path)
	
func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)


func _process(delta: float) -> void:
	state.update(delta)


func _physics_process(delta: float) -> void:
	print(state.name)
	state.physics_update(delta)

func set_colliding_x(val : bool) -> void:
	state.is_colliding_x = val

func set_colliding_top(val : bool) -> void:
	state.is_colliding_top = val
	
func set_colliding_bottom(val : bool) -> void:
	state.is_colliding_bottom = val

func update_shared_data():
	data.is_colliding_top = state.is_colliding_top
	data.is_colliding_bottom = state.is_colliding_bottom
	data.is_colliding_x = state.is_colliding_x
	data.can_dash = state.can_dash
	data.is_on_wall = state.is_on_wall
