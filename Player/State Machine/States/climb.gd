extends State


func handle_input(_event: InputEvent) -> void:
	pass
	
func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func enter(previous_state_path: String, data := {}) -> void:
	parent.is_climbing = true

func exit() -> void:
	pass
