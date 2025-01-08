
extends Node2D



func _on_area_2d_body_entered(body: Node2D) -> void:
	Events.player_refill_dash.emit()
	self.visible = false
	await get_tree().create_timer(5).timeout
	self.visible = true
