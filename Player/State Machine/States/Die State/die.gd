extends Player_State

func enter(previous_state_path: String) -> void:
	animated_sprite.play("die")
	await animated_sprite.animation_finished
	reset()
