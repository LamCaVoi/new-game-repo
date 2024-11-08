class_name StateMachine extends Node

@export var initial_state: State = null

@onready var state: State = (func get_initial_state() -> State:
	return initial_state if initial_state != null else get_child(0)
).call()

func init(parent: CharacterBody2D, animated_sprite: AnimatedSprite2D, ray_cast_2d: RayCast2D, movement_data : PlayerMovementData, movement_component: PlayerMovementInput) -> void:
	for state_node: State in find_children("*", "State"):
		state_node.finished.connect(_transition_to_next_state)
		state_node.parent = parent
		state_node.animated_sprite = animated_sprite
		state_node.ray_cast_2d = ray_cast_2d
		state_node.movement_data = movement_data
		state_node.movement_component = movement_component
		
	state.enter("")
	
func _transition_to_next_state(target_state_path: String, data: Dictionary = {}) -> void:
	if not has_node(target_state_path):
		printerr(owner.name + ": Trying to transition to state " + target_state_path + " but it does not exist.")
		return

	var previous_state_path := state.name
	state.exit()
	state = get_node(target_state_path)
	state.enter(previous_state_path)
	
func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)


func _process(delta: float) -> void:
	state.update(delta)


func _physics_process(delta: float) -> void:
	state.physics_update(delta)
