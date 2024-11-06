extends PlayerState

func handle_input(_event: InputEvent) -> void:
	pass

func update(delta: float) -> void:
	pass
	
func physics_update(delta: float) -> void:
	pass

func enter(previous_state_path: String, data := {}) -> void:
	Engine.time_scale = 0.5
	player.animated_sprite.play("die")
	player.death_timer.start()

func exit() -> void:
	pass

func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()
