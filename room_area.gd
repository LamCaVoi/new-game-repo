extends Area2D

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	var local_shape_owner = shape_find_owner(local_shape_index)
	var local_shape_node: CollisionShape2D = shape_owner_get_owner(local_shape_owner)
	var rect = local_shape_node.shape.get_rect()
	rect.position = local_shape_node.global_position
	print(rect.position)
	
	Events.emit_signal("player_enter_room",rect)
	
