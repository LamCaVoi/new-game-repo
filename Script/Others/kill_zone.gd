extends Area2D

func _on_body_entered(_body: Node2D) -> void:
	Events.emit_signal("player_entered_kill_zone")
