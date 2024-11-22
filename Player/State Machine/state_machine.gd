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
	state.exit()
	var previous_state_path := state.name
	state = get_node(target_state_path)
	state.enter(previous_state_path)
	
func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)


func _process(delta: float) -> void:
	state.update(delta)


func _physics_process(delta: float) -> void:
	print(int(Global.curr_level.find_wall()))
	state.physics_update(delta)
