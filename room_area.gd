extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _on_body_entered(body: Node2D) -> void:
	var rect : Rect2= collision_shape_2d.shape.get_rect()
	rect.position = to_global(rect.position)
	Events.player_enter_room.emit(rect)
